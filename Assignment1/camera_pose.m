Pcd_path = '/home/yiangos/UvA/CV2/assignment/Assignment 1 - v1.0.1/Assignment 1/Data/data/';
Pcd_name1 = '0000000001.pcd';
Pcd_name2 = '0000000067.pcd';

%cd '/home/yiangos/UvA/CV2/assignment/Assignment 1 - v1.0.1/Assignment 1/Data/data/';
%dir *.pcd;
%cd '/home/yiangos/UvA/CV2/assignment/CV2';

DOMnode = xmlread('/home/yiangos/UvA/CV2/assignment/Assignment 1 - v1.0.1/Assignment 1/Data/data/0000000001_camera.xml')
camera = ((-inv([1. 0. 0. ; 0. 1. 0. ; 0. 0. 1.])) * [6.26666665e-001 ; 6.26666665e-001 ; -1.25333369e-001] )


%X = u*Z/f;  
%Y = v*Z/f,  
%[525.  0. 320. ; 0. 525. 240. ; 0. 0. 1] *
camera;    
cloud_point1 = readPcd(strcat(Pcd_path,Pcd_name1));
size(cloud_point1)
%cloud_point2 = readPcd(strcat(Pcd_path,Pcd_name2));
%cloud_point_new=[]
%for row=1:size(cloud_point1,1)
%	sqrt((row(:,1)-camera(1)).^2+(row(:,2)-camera(2)).^2+(row(:,3)-camera(3)).^2)
%end
cloud_point1=cloud_point1(sqrt((cloud_point1(:,1)-camera(1)).^2+(cloud_point1(:,2)-camera(2)).^2+(cloud_point1(:,3)-camera(3)).^2) < 2, :);
size(cloud_point1)
%[adjusted, pose] = ICP(cloud_point1(:,1:3)',cloud_point1(:,1:3)','all');

%pose
scatter3(cloud_point1(:,1),cloud_point1(:,2),cloud_point1(:,3),1,[1,0,0]);
%adjusted = ICP(source,target,'all');

%data.unpackRGBFloat