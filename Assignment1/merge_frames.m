function [merged_frames] = merge_frames(method,number_of_points,step,merging_strategy)

Pcd_path = '../Assignment 1 - v1.0.1/Assignment 1/Data/data/';
% Pcd_name1 = '0000000000.pcd';
% Pcd_name2 = '0000000002.pcd';

%cd '/home/yiangos/UvA/CV2/assignment/Assignment 1 - v1.0.1/Assignment 1/Data/data/';
%dir *.pcd;
%cd '/home/yiangos/UvA/CV2/assignment/CV2';

listing = dir('../Assignment 1 - v1.0.1/Assignment 1/Data/data/');
files={};
normal_files = {};
xml_files = {};
for i = 3 : length(listing)
	if contains(listing(i).name,'.pcd') && contains(listing(i).name,'normal')
 		normal_files{end+1} = listing(i).name;
 	elseif contains(listing(i).name,'.pcd')
 		files{end+1} = listing(i).name;
 	elseif contains(listing(i).name,'.xml')
 		xml_files{end+1} = listing(i).name;
 	end
end

pcd_merged = zeros(3,0);

%s = xml2struct( '../Assignment 1 - v1.0.1/Assignment 1/Data/data/0000000000_camera.xml');
%Intristic = double(str2num(s.Children(2).Children(8).Children.Data))
%R = reshape(double(str2num(strrep(s.Children(4).Children(8).Children.Data,sprintf('\n'),''))),3,[]);
%t = reshape(double(str2num(s.Children(6).Children(8).Children.Data)),3,[]);

%cloud_point_source = readPcd(strcat(Pcd_path,Pcd_name1));
%cloud_point_source = remove_background(cloud_point_source,R,t);
%cloud_point_source = cloud_point_source(:,1:3);

R_cmb = eye(3);
t_cmb = zeros(3, 1);
change = 1;
indexes_plot = []
for i = 1:step:100-step	
	% if i == 10
	% 	break
	% % end
	% s=xml2struct(strcat(Pcd_path,xml_files{i}));
	% R_cam = reshape(double(str2num(strrep(s.Children(4).Children(8).Children.Data,sprintf('\n'),''))),3,[]);
	% t_cam = reshape(double(str2num(s.Children(6).Children(8).Children.Data)),3,[]);

	% Load target cloud point
	
	cloud_point_source = readPcd(strcat(Pcd_path,files{i+step}));
	[cloud_point_source,index] = remove_background(cloud_point_source);
	cloud_point_source = cloud_point_source(:,1:3);

	cloud_point_source_normal = readPcd(strcat(Pcd_path,normal_files{i+step}));
	cloud_point_source_normal = cloud_point_source_normal(index,1:3);
	
	% s=xml2struct(strcat(Pcd_path,xml_files{i}));
	% R_cam = reshape(double(str2num(strrep(s.Children(4).Children(8).Children.Data,sprintf('\n'),''))),3,[]);
	% t_cam = reshape(double(str2num(s.Children(6).Children(8).Children.Data)),3,[]);
	% % Load target cloud point
	
	cloud_point_target = readPcd(strcat(Pcd_path,files{i}));
	[cloud_point_target,index] = remove_background(cloud_point_target);
	cloud_point_target = cloud_point_target(:,1:3);

	cloud_point_target_normal = readPcd(strcat(Pcd_path,normal_files{i}));
	cloud_point_target_normal = cloud_point_target_normal(index,1:3);
	
	% size(cloud_point_source)
	% cloud_point_target = cloud_point_target(1:length(cloud_point_source))''
	if merging_strategy==1

		% if length(pcd_merged) == 0
		% 	pcd_merged = cloud_point_source';
		% end
		% Find camera pose
		% center = mean(cloud_point_source);
		% distanceMatrix = pdist2(cloud_point_source,center);
		
		% std_ = std(distanceMatrix);
 	% 	index = find(abs(distanceMatrix - mean(distanceMatrix)) > std_ * 2);
 	% 	cloud_point_source(index,:)=[];
 		
		[result, R, t,RMS] = ICP(transpose(cloud_point_source),transpose(cloud_point_target),3,1,transpose(cloud_point_source_normal),transpose(cloud_point_target_normal),method,number_of_points);

		t_cmb = R_cmb * t + t_cmb;
    	R_cmb = R_cmb * R;

		predicted =  R_cmb * transpose(cloud_point_source)  + t_cmb; 
    	% merge new point cloud 
    	pcd_merged = [pcd_merged  predicted];

		% end
		

	elseif merging_strategy==2

		if length(pcd_merged) == 0
			pcd_merged = cloud_point_target';
			pcd_merged_normal = cloud_point_target_normal';
		else
			pcd_merged_normal = cat(2, pcd_merged_normal, cloud_point_target_normal');
		end


		% Find camera pose
		% if i > 10
		% [result, R, t,RMS] = ICP(transpose(cloud_point_source),pcd_merged(:,0.8*size(pcd_merged,2):end),3,0,pcd_merged_normal,transpose(cloud_point_source),method,number_of_points);
		% else
		[result, R, t,RMS] = ICP(transpose(cloud_point_source),pcd_merged,3,1,pcd_merged_normal,transpose(cloud_point_source),method,number_of_points);
		% end
		% if RMS < 0.1
		% result = R * transpose(cloud_point_source) + t
		pcd_merged  =  (pcd_merged - t)' / R';
		
		%transform the merged pointclouds
		
		% if RMS < 0.05
    	pcd_merged = [pcd_merged' transpose(cloud_point_source)];
    	% pcd_merged = cat(2, pcd_merged,result);
		% end

	end

    %Plot the pointclouds before and after
    if mod(i-1,10)==0
    figure  
    scatter3(pcd_merged(1,:), pcd_merged(2,:), pcd_merged(3,:),1);
    hold on
    if merging_strategy == 1
    scatter3(predicted(1,:), predicted(2,:), predicted(3,:),1);
	else
	scatter3(cloud_point_source(:,1), cloud_point_source(:,2), cloud_point_source(:,3),1);
	end
	hold off
    drawnow;
	end

    if merging_strategy == 1
    	% size(predicted,2)
    	new_index = ones(size(predicted,2),1);
    	new_index = new_index .* i;
    	indexes_plot = [indexes_plot ; new_index ];
    else
    	new_index = ones(size(cloud_point_source,1),1);
    	new_index = new_index .* i;
    	indexes_plot = [indexes_plot ; new_index ];
    end
   
 %    cloud_point_source = cloud_point_target;
	% end

end
% figure;
% scatter3(pcd_merged(1,:), pcd_merged(2,:), pcd_merged(3,:),1);
%previous target is the new source
	
%X = u*Z/f;  
%Y = v*Z/f,  
%[525.  0. 320. ; 0. 525. 240. ; 0. 0. 1] *
%camera;    
%cloud_point1 = readPcd(strcat(Pcd_path,Pcd_name1));
%size(cloud_point1)
%cloud_point2 = readPcd(strcat(Pcd_path,Pcd_name2));
%cloud_point_new=[]
%R = {};
%t = {};
%for row=1:size(cloud_point1,1)
%	sqrt((row(:,1)-camera(1)).^2+(row(:,2)-camera(2)).^2+(row(:,3)-camera(3)).^2)
%end
%cloud_point1=cloud_point1(sqrt((cloud_point1(:,1)-camera(1)).^2+(cloud_point1(:,2)-camera(2)).^2+(cloud_point1(:,3)-camera(3)).^2) < 2, :);
%cloud_point2=cloud_point2(sqrt((cloud_point1(:,1)-camera(1)).^2+(cloud_point1(:,2)-camera(2)).^2+(cloud_point1(:,3)-camera(3)).^2) < 2, :);
%size(cloud_point1)
%[source R t]  = ICP(cloud_point1(:,1:3)',cloud_point2(:,1:3)','uniform',30000);

%pose
%scatter3(cloud_point1(:,1),cloud_point1(:,2),cloud_point1(:,3),1);
%adjusted = ICP(source,target,'all');

%data.unpackRGBFloat

figure;
fscatter3( pcd_merged(1,:), pcd_merged(2,:), pcd_merged(3,:),indexes_plot);
xlabel('X');
ylabel('Y');
zlabel('Z');

function [new_pointCloud,index] = remove_background(cloud_point)
	%find camera position in XYZ system
	%C = -(inv(R))*t;
	%remove all of the points that are in the background (2 meters away)
    % new_pointCloud = cloud_point(sqrt((cloud_point(:,1)-C(1)).^2+(cloud_point(:,2)-C(2)).^2+(cloud_point(:,3)-C(3)).^2) < 2, :);
    index = find(cloud_point(:,3) < 2);
    new_pointCloud = cloud_point(index,:);
end


end