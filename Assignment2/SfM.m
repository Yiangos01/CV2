function [M,S,indices_not_removed] = SfM(start,end_point,plot,PVM) 
    
	D=PVM(start:end_point,:);
    indices_removed = any(D'==0,2);
    indices_not_removed = find(~indices_removed);
    
    indices_removed = find(indices_removed);
    
	D(:,indices_removed) = [];
    %D(:,204:end) = [];
    
%     for i = 1:size(indices_removed,2)
% %         [rows, row_scores] = get_row_scores(PVM, end_point);
% %         [column, column_scores] = get_column_scores(PVM, indices_removed);
% %         [row_val, row_idx] = max(row_scores);
% %         [col_val, column_idx] = max(column_scores);
%     end
    
	mean_D = mean(D,2);
	D = D - mean_D;

	[U,S,V] = svd(D);
	U = U(:,1:3);
	S = S(1:3,1:3);
 	V = V';
	V = V(1:3,:);

	M = U * sqrt(S);
	S = sqrt(S) * V;

% end
	% eliminate_affine_ambiguity
	A = [];
	B = [];
	for i=1:2:size(M,1)
		x_i = M(i,:);
		y_i = M(i+1,:);
		Motion_matrix = [x_i ; y_i;];
		A = [A ; Motion_matrix];
		B = [B ; (pinv(Motion_matrix)')];
	end
	x = A \ B;

	[C,p] = chol(x);
	
	M = M * C;
    S  = C' \ S ;

    
	
 	%scatter3(S(1,:),S(2,:),S(3,:),'filled');
%     scatter3(M(:,1)',M(:,2)',M(:,3)');

% if eliminate_affine_ambiguity
	% A = []
	% B = []
	% for i=1:2:size(M,1)
	% 	x_i = M(i,:);
	% 	y_i = M(i+1,:);
	% 	Motion_matrix = [x_i.*x_i ; y_i.*y_i; x_i.*y_i];
	% 	A = [A ; Motion_matrix];
	% 	B = [B ; (inv(Motion_matrix)')];
	% end
	% x = Motion_matrix \ (inv(Motion_matrix)')

	% [C,p] = chol(x)
	
	% M = M * C;
 %    S  = C' \ S ;       
end


function [rows,row_score] = get_row_scores(current_PVM, end_point)
    rows = current_PVM(end_point:end,:);
    row_scores = [];
    for i = 1:size(rows,1)
        current_row = rows(i,:);
        row_scores(end+1) = sum(current_row(indices_not_removed) > 0);
    end
end


function [columns,column_scores] = get_column_scores(current_PVM, indices_removed)
    columns = current_PVM(:,indices_removed);
    colum_scores = [];
    for i = 1:size(columns,2)
       current_column = columns(:,i);
       colum_scores(end+1) =  sum(current_column(start:end_point) > 0);
    end
end
	