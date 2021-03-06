function [outx, outy]=gradient_m(im)

outx=zeros(size(im,1),size(im,2),size(im,3));
outy=zeros(size(im,1),size(im,2),size(im,3));

outx(3:size(im,1)-2,3:size(im,2)-2,:)=( ...
    - im(3:size(im,1)-2,1:size(im,2)-4,:) ...
    + 8*im(3:size(im,1)-2,2:size(im,2)-3,:) ...
    - 8*im(3:size(im,1)-2,4:size(im,2)-1,:) ...
    + im(3:size(im,1)-2,5:size(im,2),:) ...
    )/12;

outy(3:size(im,1)-2,3:size(im,2)-2,:)=( ...
    - im(1:size(im,1)-4,3:size(im,2)-2,:) ...
    + 8*im(2:size(im,1)-3,3:size(im,2)-2,:) ...
    - 8*im(4:size(im,1)-1,3:size(im,2)-2,:) ...
    + im(5:size(im,1),3:size(im,2)-2,:) ...
    )/12;
