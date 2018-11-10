function [source,R,t,RMS]  = ICP(source, target,rejecting,weighting_tech,normal_source,normal_target, varargin)
original_normal_source = normal_source;
original_normal_target = normal_target;
original_target = target ;
if nargin == 2
    type = 'all';
end
predicted = source;
switch(varargin{1})
    case 'all'
        %Nothing
    case 'uniform'
        reducedby = length(source)/varargin{2};
        predicted = source(:,1:reducedby:end);
        normal_source = normal_source(:,1:reducedby:end);


        reducedby = length(target)/varargin{2};
        target = target(:,1:reducedby:end);
        reducedby = length(target)/varargin{2};
        normal_target = normal_target(:,1:reducedby:end);
    case 'random'
        % indexes = randperm(length(source)-1,varargin{2});
        % predicted = source(:,indexes);
        % indexes = randperm(length(target)-1,varargin{2});
        % target = target(:,indexes);
        original_normal_source = normal_source;
        original_normal_target = normal_target;
        original_target = target ;
    case 'informative'
        %% using normal space sampling.
        predicted = get_normal_space_sample(source,normal_source,varargin{2})';
        target = get_normal_space_sample(target,normal_target,varargin{2})';
    otherwise
        %Nothing
end


R = {};
t = {};
RMSold = 0;
RMS = 1;
max_iter=0;
weight_vector=0;
predicted_new = predicted;

while RMS ~= RMSold
    max_iter=max_iter+1;
    fprintf('RMS %d and RMSold %d\n', RMS, RMSold);

    if strcmp(varargin{1},'random')

        indexes = randperm(length(source)-1,varargin{2});
        predicted = source(:,indexes);
        normal_source = original_normal_source(:,indexes);

        indexes = randperm(length(original_target)-1,varargin{2});
        target = original_target(:,indexes);
        normal_target = original_normal_target(:,indexes);
        predicted_new = R{end} * predicted + t{end};
    end

    [match,dist,RMSold] = getMatchesAndRMS(predicted_new,target);
    target_RT = target(:, match);
    if length(target) == length(normal_target)
    normal_target = normal_target(:, match);

    end


    % Rejecting pair mathods
    if rejecting ~= 0
        [predicted_RT,target_RT,index]  = rejecting_pairs(predicted,target_RT,normal_source,normal_target,dist,rejecting);
        dist(index)=[];
        normal_target_RT = normal_target;
        normal_source_RT = normal_source;
        if weighting_tech == 2
        
        normal_target_RT(:,index)=[];
        
        normal_source_RT(:,index)=[];
        end
    else
        predicted_RT = predicted;
        % target_RT = target;
    end


    % Weighting pair methods
    if weighting_tech == 1
        weight_vector = weighting_of_pairs(dist,'max', predicted_RT, normal_source_RT,normal_target_RT);
    elseif weighting_tech == 2
        weight_vector = weighting_of_pairs(dist,'comp', predicted_RT, normal_source_RT,normal_target_RT);
    elseif weighting_tech == 3
        weight_vector = weighting_of_pairs(dist,'own', predicted_RT, normal_source_RT,normal_target_RT);
    end

    [R{end+1},t{end+1}] = getRAndT(predicted_RT,target_RT,weight_vector);

    predicted_new = R{end} * predicted + t{end};
    %predicted_RT = R{end} * predicted_RT + t{end};

    [match,dist,RMS] = getMatchesAndRMS(predicted_new,target);
    % sandom sampling 
    
    if max_iter==100
        break
    end
end

R = R{end};
t = t{end};
source =  R * source + t;

end

