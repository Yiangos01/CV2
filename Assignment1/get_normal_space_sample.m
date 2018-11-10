function sample = get_normal_space_sample(source, normals, limit) 
    angels = [];
    source = source';
    
    for i = 1:size(normals,1)

         if (isnan(normals(i,1)))
             angels(i) = NaN;
         else             
             r = sqrt(normals(i,1)^2 + normals(i,2)^2 + normals(i,3)^2);
             teta = normals(i,3)/r;
             angels(i) = acos(teta);
         end
    end
    [N,edges,bin] = histcounts(angels);
    
    sample = [];
    i = 0;
    while size(sample,1) ~= limit
        bin_to_use = mod(i,89);
        index = floor(i/89) + 1 ;
        samples = source(bin == bin_to_use, :);
        if ~(index > size(samples,1))
            sample(end+1,:) = samples(index,:);
        end
        i = i+1;
    end

end