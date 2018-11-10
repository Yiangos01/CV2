function [F,first_image_points,second_image_points] = generate_F(F_method,plot,im_1,im_2)

%% Read images
<<<<<<< HEAD
% imagefiles = dir('/home/juan/Documents/Uva/CV2/git/CV2/Assignment2/Data/House/House/*.png');
imagefiles = dir('Data/House/House/*.png');  
  
image1_path = strcat(imagefiles(1).folder,'/',imagefiles(im_1).name);
image2_path = strcat(imagefiles(1).folder,'/',imagefiles(im_2).name);
image1 = imread(image1_path);
image2 = imread(image2_path);


if F_method == 1 | F_method == 2
	
	[best_fit first_image_points, second_image_points] = RANSAC(image1_path,image2_path,3,0);
	% [f1,f2,matches,scores] = keypoint_matching(image1_path,image2_path);
	first_image_points (3,:)=1;
	second_image_points (3,:)=1;
	first_points = first_image_points;
	second_points = second_image_points;

	% 8 Random Points
	index = randperm(size(first_image_points,2),8);

	first_image_points = first_image_points(1:3,index);
	second_image_points = second_image_points(1:3,index);
	% size(second_image_points);
	%% Eight Point Algorithm
	if F_method == 1
		[F,first_image_points,second_image_points] = eight_point(first_image_points,second_image_points,first_points,second_points , 0,0);
	else
		[F,first_image_points,second_image_points] = eight_point(first_image_points,second_image_points,first_points,second_points, 1,0);
	end

elseif F_method == 3
	[F,first_image_points, second_image_points] = RANSAC_F(image1_path,image2_path);
	
	% index = randperm(size(first_image_points,2),8);

	% first_image_points = first_image_points(1:3,index);
	% second_image_points = second_image_points(1:3,index);

end
		


% Compute epipolar line
e_line_image2 = F * first_image_points(1:3,:);
e_line_image1 = F' * second_image_points(1:3,:);

x_points = round(linspace(0,size(image1,2),10));
y_1 =   (e_line_image1(1,:)' .* x_points + e_line_image1(3,:)') ./ (-e_line_image1(2,:)');
y_2 =   (e_line_image2(1,:)' .* x_points + e_line_image2(3,:)') ./ (-e_line_image2(2,:)');

if plot == 1
	figure;
	imshow([image1 image2]);
	hold on;
	scatter(first_image_points(1,1:8),first_image_points(2,1:8),'filled');
	hold on;
	scatter(second_image_points(1,1:8)+size(image1,2),second_image_points(2,1:8),'filled');
	hold on;
	line(x_points,y_1','Color','y','LineWidth',1,'LineStyle','-')
	hold on;
	line(x_points+size(image1,2),y_2','Color','g','LineWidth',1,'LineStyle','-')
	hold off;
end
end
