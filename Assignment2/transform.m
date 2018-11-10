% demo ransac transform
function transform(im1,im2)
close all;

[h,w] = size(im1);

[framesa, framesb, matches, scores] = keypoint_matching(im1,im2);

[~, ~, best_model, best_model_score] = ransac(framesa, framesb, matches, 10, 50);

top_left = round([1 1 0 0 1 0; 0 0 1 1 0 1] * best_model);
top_right = round([1 w 0 0 1 0; 0 0 1 w 0 1] * best_model);
bottom_left = round([h 1 0 0 1 0; 0 0 h 1 0 1] * best_model);
bottom_right = round([h w 0 0 1 0; 0 0 h w 0 1] * best_model);

leftmost_point = min(top_left(2), bottom_left(2));
highest_point = min(top_left(1), top_right(1));

width = max(top_right(2), bottom_right(2)) - leftmost_point;
height = max(bottom_left(1), bottom_right(1)) - highest_point;

w_offset = - leftmost_point + 1;   
h_offset = - highest_point + 1;

transformed_image = zeros(height, width);

for x = 1:h
    for y = 1:w
    
    A = [x y 0 0 1 0; 0 0 x y 0 1]; 
    new_coords = round(A * best_model);
    new_coords = new_coords + [h_offset; w_offset];
     
    transformed_image(new_coords(1), new_coords(2)) = im2(x,y) ;

    end
end



figure(3)
%imshow(uint8(transformed_image))
R = [best_model(1), best_model(2); best_model(3), best_model(4)];
T = maketform('affine',R);
I2 = imtransform(I,T);
imshow(I2)

end

    