function [match,dist,RMS] = getMatchesAndRMS(source,target)
noOfPoints = size(source,2);
dimensions = size(source,1);
match = zeros(1,noOfPoints);
minimumDist = zeros(1,noOfPoints);
% for x = 1:noOfPoints
%     dist = zeros(1,noOfPoints);
%     for n = 1:dimensions
%     	for j = 1:noOfPoints
%     		dist(1,j) = sqrt( (source(1,x) - target(1,j)).^2 +(source(2,x) - target(2,j)).^2+(source(3,x) - target(3,j)).^2);
%    		end
%     end
%     % size(dist)
%     [value,index] = min(dist);
%     match(x) = index;
%     minimumDist(x) = value;
% end

point_distance = pdist2(source', target');

[dist,match] = min(point_distance, [], 2);
RMS = sqrt((1/noOfPoints) * sum(dist));
end

