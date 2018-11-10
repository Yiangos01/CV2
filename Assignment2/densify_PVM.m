function PVM = densify_PVM(PVM)
    
    count =0
    % For each column
	for i = 1:size(PVM,2)
    	% count amount of appearances for each point
        
    	if sum(PVM(:,i)~=0) < 10
            count = count+1
    		columns = [columns, i];
    	end

    	% Create improved PVM with cols which have min amount of appearances t
    end
    all_index = 1:size(PVM,2);
    dense_columns = setdiff(all_index,columns)';
    PVM = PVM(:,dense_columns);
	end