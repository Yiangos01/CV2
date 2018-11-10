function [best_F,best_first, best_second] = RANSAC_F(image1,image2)
    best_score = 0;
    best_F = [];


    for iter = 1:50
        [f1,f2,matches,scores] = keypoint_matching(image1,image2);

        % Best 200 image points
        first_points = f1(1:3,matches(1,:));
        second_points = f2(1:3,matches(2,:));
        first_points(3,:) = 1;
        second_points(3,:) = 1;

        %select 8 random
        index = randperm(size(matches,2),8);
        % index = randperm(size(first_image_points,2),8);
        first_image_points = f1(1:3,matches(1,index));
        second_image_points = f2(1:3,matches(2,index));
        first_image_points(3,:) = 1;
        second_image_points(3,:) = 1;

        [candidate_F,~,~] = eight_point(first_image_points, second_image_points,first_points,second_points,1,0);
        
        d = sampson_distance(first_points, second_points, candidate_F);
        
        inliers = sum(abs(d) <= 1.25);

        if best_score < inliers
        	best_F = candidate_F;
        	best_score = inliers
            index_inlier = abs(d) <= 1.25;
        	best_first = first_points(:,index_inlier);
        	best_second = second_points(:,index_inlier);
            if inliers == length(matches)
                break
            end
        end
        
    end
end

