
function[num_matches,A_total,best_model, best_model_score, best_im1_cords, best_im2_cords] = ransac(f1, f2, matches,n_samples, n_iter)

radius = 10;

num_matches = size(matches, 2);

A_total = [];
b_total = [];
im1_cords = [];
im2_cords = [];
for i = 1:num_matches
    match_indexes = matches(:, i);
       
    % features vecs for both points
    im1_feat = f1(:, match_indexes(1));
    im2_feat = f2(:, match_indexes(2));

    % coordinates
    im1_x_coord = im1_feat(1);
    im1_y_coord = im1_feat(2);

    im2_x_coord = im2_feat(1);
    im2_y_coord = im2_feat(2);

    A = [im1_x_coord im1_y_coord 0 0 1 0; 0 0 im1_x_coord im1_y_coord 0 1];

    A_total = cat(1, A_total, A);
    b_total = cat(1, b_total, [im2_x_coord im2_y_coord]);
    im1_cords = cat(1,im1_cords, [im1_x_coord, im1_y_coord]);
    im2_cords = cat(1,im2_cords, [im2_x_coord, im2_y_coord]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
best_model_score = 0;
best_model = zeros(1,6);

for iter = 1:n_iter
    
    rand_indexes = randperm(num_matches, n_samples);
    A_sample = [];
    b_sample = [];
    im1_cords_sample = [];
    im2_cords_sample = [];

    for rand_i = rand_indexes
        A_sample = cat(1, A_sample, A_total([rand_i*2-1,rand_i*2] , :));
        b_sample = cat(1, b_sample, b_total(rand_i, :)');
        im1_cords_sample = cat(1, im1_cords_sample, im1_cords(rand_i, :));
        im2_cords_sample = cat(1, im2_cords_sample, im2_cords(rand_i, :));
    end
    
    X = pinv(A_sample) * b_sample;
    preds = A_total * X;
    
    n_inliers = 0;
    for i = 1:num_matches
        match = matches(:, i);
    
        % features vecs for both points
        x_coord = f2(1, match(2));
        y_coord = f2(2, match(2));
        
        offset = floor(radius / 2);
        
        for x = -offset:offset
            for y = -offset:offset
                if round([preds(i*2-1); preds(i*2)]) == round([x_coord + x; y_coord + y])
                    n_inliers = n_inliers + 1;
                    break
                end
            end
        end
    end
    disp(n_inliers)
    if n_inliers > best_model_score
        best_model = X;
        best_model_score = n_inliers;
        best_im1_cords = im1_cords_sample;
        best_im2_cords = im2_cords_sample;
    end
    
end

end