function [PVM] = chaining

	% imagefiles = dir('/home/juan/Documents/Uva/CV2/git/CV2/Assignment2/Data/House/House/*.png');  
	imagefiles = dir('Data/House/House/*.png');
	
	PVM = [];
	
	for i = 1:length(imagefiles)
		i
		% image1_path = strcat(imagefiles(1).folder,'/',imagefiles(i).name);
		image_number1 = i;
		if i ~= length(imagefiles)
			% image2_path = strcat(imagefiles(1).folder,'/',imagefiles(i+1).name);
			image_number2 = i+1;
		else
			% image2_path = strcat(imagefiles(1).folder,'/',imagefiles(1).name);
			image_number2 = 1;
		end

		
		[F,first_image_points,second_image_points] = generate_F(3,0,image_number1,image_number2);

		x_first = first_image_points(1,:);
		y_first = first_image_points(2,:);

		x_second = second_image_points(1,:);
		y_second = second_image_points(2,:);



		if isempty(PVM)
			PVM = [x_first; y_first; x_second ; y_second];
		else
			last_image_point = PVM(end-1:end,:);
			% [~,indexes] = ismembertol([x_first; y_first]',last_image_point','ByRows',true);

			[~,indexes] = ismembertol([x_first; y_first]',last_image_point',0.01,'ByRows',true);	
			% indexes			
			PVM(end+1:end+2,:) = zeros(2,size(PVM,2));

			for j = 1:length(indexes)
				% last_column_index = size(PVM,2);
				if (indexes(j) ~= 0)
					PVM(end-1:end,indexes(j)) = [x_second(j) ; y_second(j)];
					% y_second(indexes(j))
			% 	% If new point appears
				else
					PVM(:,end+1) = zeros(size(PVM,1),1);
					PVM(end-3,end) = x_first(j);
					PVM(end-2,end) = y_first(j);
					PVM(end-1:end,end) = [x_second(j) ; y_second(j)];
				end
			end
		end
	end
end
