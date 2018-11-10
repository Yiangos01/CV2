function [d] = sampson_distance(first_image_points,second_image_points, F)
    first_image_points = first_image_points(1:2,:);
    second_image_points = second_image_points(1:2,:);
    
    first_image_points(3,:) = 1;
    second_image_points(3,:) = 1;
    d = [];
    for i = 1:size(first_image_points,2)
        fpi = F*first_image_points(:,i);
        fpid = F'*second_image_points(:,i);

        numerator = (second_image_points(1:3,i)'*F*first_image_points(1:3,i))^2;
        denominator = (fpi(1))^2 + (fpi(2))^2 + (fpid(1))^2 + (fpid(2))^2;

        d(i) = numerator/denominator;
    end
end

