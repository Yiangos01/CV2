clear all
close all
run('/home/juan/Documents/vlfeat-0.9.21/toolbox/vl_setup')
vl_setup demo
image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');

[framesa, framesb, matches, scores] = keypoint_matching(image1,image2);

figure(1) ; clf ;
imshow(cat(2, image1, image2)) ;

xa = framesa(1,matches(1,:)) ;
xb = framesb(1,matches(2,:)) + size(image1,2) ;
ya = framesa(2,matches(1,:)) ;
yb = framesb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(framesa(:,matches(1,:))) ;
framesb(1,:) = framesb(1,:) + size(image1,2) ;
vl_plotframe(framesb(:,matches(2,:))) ;
axis image off ;


[W, T] = RANSAC(framesa, framesb, matches);
%the W, T are the :
%W = [m1 m2 ; m3 m4];
%T = [t1 ; t2];
output = transform(W,T,image2);


