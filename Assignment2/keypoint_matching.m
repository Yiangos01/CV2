function [framesa,framesb,matches,scores] = keypoint_matching(image1,image2)

if nargin == 2 
    showNumberOfPoints = 50;
end

image1 = imread(image1);
image2 = imread(image2);


image1 = remove_background(image1,1);
image2 = remove_background(image2,1);

[framesa, da] = vl_sift(single(image1)) ;
[framesb, db] = vl_sift(single(image2)) ;


[matches, scores] = vl_ubcmatch(da, db,1) ;
background_index = [];


for i = 1:size(matches,2)
	index1 = matches(:,i);
 	x_first_set=floor(framesa(1:2,index1(1)));
 	x_second_set=floor(framesb(1:2,index1(2)));

 	if image1(fix(x_first_set(2)),fix(x_first_set(1))) < 10 | image2(fix(x_second_set(2)),fix(x_second_set(1))) < 10
 		background_index = [background_index  i];
 	end
end

matches(:,background_index) = [];
scores(background_index) = [];

% matches
[~, perm] = sort(scores, 'descend');
matches = matches(:, perm);
scores  = scores(perm);

% matches = matches(:,1:200);
% scores = scores(1:200);

end

    