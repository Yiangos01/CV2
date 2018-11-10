function [source,target,index]  = rejecting_pairs(source,target,normal_source,normal_target, distance,method)

if method==1
	% Remove worst points
	[dist,index] = sort(distance);
	perc = round(9*(length(index)/10));
	index = index(perc:end);

	source(:,index) = [];
	target(:,index) = [];
elseif method == 2 

	% Remove distances bigger than a threshold
	index = find(distance > 0.3)

	source(:,index) = [];
	target(:,index) = [];

elseif method == 3

 	std_ = std(distance);
 	mean_ = mean(distance);
 	index = find(abs(distance - mean_) > std_ * 2.5);

 	source(:,index) = [];
	target(:,index) = [];

elseif method == 4
	index = [];
	for i = 1:size(normal_source,2)

		theta = acosd((normal_source(:,i)' * normal_target(:,i)) / (norm(normal_source(:,i)') * norm(normal_target(:,i)')));
		if isnan(theta)
			theta=0;
		end
		if theta > 45
			index = [index ; i];
		end
	end
	source(:,index) = [];
	target(:,index) = [];
end

end