function [F,first_image_points,second_image_points] = eight_point(first_image_points, second_image_points,first_points,second_points,norm,inliers)

    if (norm == 1)
       f1_ = first_image_points;
       f2_ = second_image_points;
       [T1, first_image_points] = get_normalise_matrix(first_image_points);
       [T2, second_image_points] = get_normalise_matrix(second_image_points);
    end

    A = zeros(size(first_image_points,2), 9);

    for i = 1:size(first_image_points,2)
        x1 = first_image_points(1,i);
        xd1 = second_image_points(1,i);
        y1 = first_image_points(2,i);
        yd1 = second_image_points(2,i);
        
        A(i,:) = [x1*xd1, x1*yd1, x1, y1*xd1, y1*yd1, y1, xd1, yd1, 1];    
    end

    [~,~,V] = svd(A);
    
    F = V(:,9);
    F = reshape(F,3,3);


    [Uf,Df,Vf] = svd(F);
    
    Df(3,3) = 0;
    
    F = Uf * Df * Vf';
    
    if (norm == 1)
        F = T2'*F*T1;
        if ~inliers
            first_image_points = f1_;
            second_image_points = f2_;
        end
    end

    if inliers == 1
        d = sampson_distance(first_points, second_points, F);
        index_inlier = abs(d) < 1.25;
        first_image_points = first_points(:,index_inlier);
        second_image_points = second_points(:,index_inlier);
    end

end


