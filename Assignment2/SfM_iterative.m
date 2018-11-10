function [Final_View] = SfM_iterative(num_of_images,method,dense_flag)

    if dense_flag
          PVM = dlmread('dense_PVM.txt',' ');
%            PVM = dlmread('PointViewMatrix.txt',' ');
    else
        PVM = dlmread('PVM.txt',' ');
    end

    Final_S = {};
    pointCloud_points = {};
    for i = 1:2:(size(PVM,1)- ((num_of_images*2)+1))
        [~,S,columns] = SfM(i,i+((num_of_images*2)+1),1,PVM);
        Final_S{end+1} = S;
        pointCloud_points{end+1} = columns;
    end
    Final_View=[];
    Final_View_points = [];
    for i = 1:length(Final_S)-2

        if method==1
            if i == 1
            % remove_list = [];
            
            
                target_pcd = Final_S{i};
                target_pcd_columns = pointCloud_points{i};

                new_pcd = Final_S{i+1};
                new_pcd_columns = pointCloud_points{i+1};

                % Remove Outliers
                outliers_high = find(target_pcd(3,:)>10);
                outliers_low = find(target_pcd(3,:)<-10);
                target_pcd(:,[outliers_high outliers_low]) = [];
                target_pcd_columns([outliers_high outliers_low]) = [];

                outliers_high = find(new_pcd(3,:)>10);
                outliers_low = find(new_pcd(3,:)<-10);
                new_pcd(:,[outliers_high outliers_low]) = [];
                new_pcd_columns([outliers_high outliers_low]) = [];
                % Final_View_points=target_pcd_columns
            
                [shared_points, target_pcd_pos, new_pcd_pos] = intersect(target_pcd_columns, new_pcd_columns);
                % overlapping_target_points = target_pcd(:,target_pcd_pos);
                target_pcd = target_pcd(:,target_pcd_pos);
                overlapping_points = new_pcd(:,new_pcd_pos);



                [~,Z,transform] = procrustes(target_pcd',overlapping_points');
                transformed_pcd = (transform.b*new_pcd'*transform.T + transform.c(1,:))'; 
                transformed_pcd_columns = new_pcd_columns;
                Final_View = target_pcd

                % [shared_points, target_pcd_pos, new_pcd_pos] = intersect(Final_View_points, new_pcd_columns);
                % new = setdiff(1:size(new_pcd,2),new_pcd_pos)';

                % new_point_idexes = new_pcd_columns(new);
                % new_3D_points = new_pcd(:,new);
                % Final_View_points = [Final_View_points; new_point_idexes];
            % new_point_idexes = new_pcd_columns(new);
            % new_3D_points = Z(:,new)
            % Final_View_points = [Final_View_points; new_point_idexes];
            
        else

            
            new_pcd = Final_S{i+1};
            new_pcd_columns = pointCloud_points{i+1};

            % Remove Outliers
            outliers_high = find(new_pcd(3,:)>10);
            outliers_low = find(new_pcd(3,:)<-10);
            new_pcd(:,[outliers_high outliers_low]) = [];
            new_pcd_columns([outliers_high outliers_low]) = [];


            [shared_points, target_pcd_pos, new_pcd_pos] = intersect(transformed_pcd_columns, new_pcd_columns);
            length(shared_points)
            overlapping_points = new_pcd(:,new_pcd_pos);
            % new_pcd = new_pcd(:,new_pc_pos)
            target_pcd = transformed_pcd(:,target_pcd_pos);

            [~,Z,transform] = procrustes(target_pcd',overlapping_points');
            transformed_pcd = (transform.b*new_pcd'*transform.T + transform.c(1,:))'; 
            transformed_pcd_columns = new_pcd_columns;

            % [shared_points, target_pcd_pos, new_pcd_pos] = intersect(Final_View_points, new_pcd_columns);
            % new = setdiff(1:size(new_pcd,2),new_pcd_pos)';

            % new_point_idexes = new_pcd_columns(new);
            % new_3D_points = new_pcd(:,new);
            % Final_View_points = [Final_View_points; new_point_idexes];

        end
        Final_View = [Final_View transformed_pcd];
    else
        if i == 1
            % remove_list = [];
            
            
            target_pcd = Final_S{i};
            target_pcd_columns = pointCloud_points{i};

            new_pcd = Final_S{i+1};
            new_pcd_columns = pointCloud_points{i+1};

                % Remove Outliers
            outliers_high = find(target_pcd(3,:)>10);
            outliers_low = find(target_pcd(3,:)<-10);
            target_pcd(:,[outliers_high outliers_low]) = [];
            target_pcd_columns([outliers_high outliers_low]) = [];

            outliers_high = find(new_pcd(3,:)>10);
            outliers_low = find(new_pcd(3,:)<-10);
            new_pcd(:,[outliers_high outliers_low]) = [];
            new_pcd_columns([outliers_high outliers_low]) = [];

            Final_View = target_pcd;
            Final_View_points = target_pcd_columns;
            [shared_points, target_pcd_pos, new_pcd_pos] = intersect(target_pcd_columns, new_pcd_columns);
                % overlapping_target_points = target_pcd(:,target_pcd_pos);
            target_pcd = target_pcd(:,target_pcd_pos);
            overlapping_points = new_pcd(:,new_pcd_pos);



            [~,Z,transform] = procrustes(overlapping_points',target_pcd');
            Final_View = (transform.b*Final_View'*transform.T + transform.c(1,:))'; 

            new = setdiff(1:size(new_pcd,2),new_pcd_pos)';
            new_point_idexes = new_pcd_columns(new);
            new_3D_points = new_pcd(:,new);
            Final_View_points = [Final_View_points; new_point_idexes];
        else

            
            new_pcd = Final_S{i+1};
            new_pcd_columns = pointCloud_points{i+1};

            % Remove Outliers
            outliers_high = find(new_pcd(3,:)>10);
            outliers_low = find(new_pcd(3,:)<-10);
            new_pcd(:,[outliers_high outliers_low]) = [];
            new_pcd_columns([outliers_high outliers_low]) = [];


            [shared_points, target_pcd_pos, new_pcd_pos] = intersect(Final_View_points, new_pcd_columns);
            
            overlapping_points = new_pcd(:,new_pcd_pos);
            % new_pcd = new_pcd(:,new_pc_pos)
            target_pcd = Final_View(:,target_pcd_pos);
            new = setdiff(1:size(new_pcd,2),new_pcd_pos)';
            length(shared_points)
            if length(new)~=0

            [~,Z,transform] = procrustes(overlapping_points',target_pcd');
            Final_View = (transform.b*Final_View'*transform.T + transform.c(1,:))'; 
        
            
            new_point_idexes = new_pcd_columns(new);
            new_3D_points = new_pcd(:,new);
            Final_View_points = [Final_View_points; new_point_idexes];
            end
        end
        Final_View = [Final_View new_3D_points];
    end
        % Final_View = [Z new_3D_points];
          
%     figure;         %
       % scatter3(Final_View(1,:),Final_View(2,:),Final_View(3,:),5,'filled');
%         hold on
         % scatter3(Z(1,:),Z(2,:),Z(3,:),5,'filled');
        %hold on
%         scatter3(transformed_pcd(1,:),transformed_pcd(2,:),transformed_pcd(3,:),5,'filled');
        %hold on
        %hold on
        % scatter3(Final_View(1,end-300:end),Final_View(2,end-300:end),Final_View(3,end-300:end),5,'filled');
        %% 
%           drawnow;
        
    end
%     Final_View = Final_View(:,~(Final_View(3,:) > 10));
%     Final_View = Final_View(:,~(Final_View(3,:) < -10));
%     %scatter3(Final(1,:),Final(2,:),Final(3,:),5,'filled');
    scatter3(Final_View(1,:),Final_View(2,:),Final_View(3,:),4,'filled');

end