function [T, points] = get_normalise_matrix(points)
    points = points(1:2,:);
    points(3,:) = 1;
    
    x = points(1,:);
    y = points(2,:);
    
    mx = sum(x) / size(x,2);
    my = sum(y) / size(y,2);
    d  = sum(sqrt(((x-mx).^2) + ((y-my).^2))) / size(x,2);
    T = [sqrt(2)/d, 0, -mx*(sqrt(2)/d); 0, sqrt(2)/d, -my*(sqrt(2)/d); 0, 0, 1];
    points = T*points;
end

