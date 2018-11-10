function [best_fit, first_image_points, ransac_points] = RANSAC(Im1,Im2,P,plot_)


	[f1,f2,matches,scores] = keypoint_matching(Im1,Im2);
	
	
	
	A = zeros(2*P,6);
        b = zeros(2*P,1);
	N = round(log(1-0.95)/log(1-(1-0.5)^P));
	best_in = 0;
	for n=1:N	
	inlier_count=0;
	selected_points=randperm(size(matches,2),P);
	x_first_set=f1(1:2,matches(1,selected_points));
	x_second_set=f2(1:2,matches(2,selected_points));
	for p=1:2:2*P
		index_=ceil(p/2);
		A(p:p+1,:) = [x_first_set(1,index_) x_first_set(2,index_) 0 0 1 0 ; 0 0 x_first_set(1,index_) x_first_set(2,index_) 0 1];
		b(p:p+1,:)= [x_second_set(1,index_) ; x_second_set(2,index_)];
	end
	
	x = (pinv(A) * b);
	
	first_image_points = f1(:,matches(1,:));
	second_image_points = f2(:,matches(2,:));
	interesting_points_count =size(f1(:,matches(1,:)),2);
	ransac_points_test = zeros(2,interesting_points_count);
	for point=1:interesting_points_count
		A =  [first_image_points(1,point) first_image_points(2,point) 0 0 1 0 ; 0 0 first_image_points(1,point) first_image_points(2,point) 0 1];
		
		b_point = A * x;
		ransac_points_test(:,point) = b_point;
		error_ = sqrt((b_point(1) - second_image_points(1,point))^2 + (b_point(2) - second_image_points(2,point))^2); 
		if error_ <= 10
			inlier_count = inlier_count+1;
		end
	end
	
	if inlier_count > best_in
		best_in = inlier_count;
		best_fit= x;
		ransac_points = ransac_points_test;
	end
    end
    
    if plot_
	% Plot images
	figure;
	imshow([imread(Im1) imread(Im2)]);
	hold on;
	ransac_points = ransac_points + [size(imread(Im1),2);0];
	sample=randperm(size(ransac_points,2),50);
	plot([first_image_points(1,sample) ; ransac_points(1,sample)], [first_image_points(2,sample) ; ransac_points(2,sample)], 'y-');
	hold off;
    end
end
