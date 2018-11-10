source = load('..//Assignment 1 - v1.0.1/Assignment 1/Data/source.mat')
target = load('../Assignment 1 - v1.0.1/Assignment 1/Data/target.mat')

% source = readPcd('../Assignment 1 - v1.0.1/Assignment 1/Data/data/0000000019.pcd');
% target = readPcd('../Assignment 1 - v1.0.1/Assignment 1/Data/data/0000000021.pcd');
% R1 = load('../Assignment 1 - v1.0.1/Assignment 1/Data/Archive/rotatation_1.mat')
% R2 = load('../Assignment 1 - v1.0.1/Assignment 1/Data/Archive/rotatation_2.mat')

% R1.rotation
% R2.rotation

source = source.source;
target = target.target;
% load('/home/yiangos/UvA/CV2/assignment/Assignment 1 - v1.0.1/Assignment 1/Data/data/0000000000.mat')
% load('/home/yiangos/UvA/CV2/assignment/Assignment 1 - v1.0.1/Assignment 1/Data/data/')

% source = source(source(:,3) < 2, :)';
% target = target(target(:,3) < 2, :)';

[adjusted, R, t, RMS] = ICP(source,target,1,3,source,target,'all',2000);

figure
% scatter3(source(1,:),source(2,:),source(3,:),1,[1,0,0])
% hold on
scatter3(target(1,:),target(2,:),target(3,:),1,[0,1,0])
hold on
scatter3(adjusted(1,:),adjusted(2,:),adjusted(3,:),1,[0,0,1])
