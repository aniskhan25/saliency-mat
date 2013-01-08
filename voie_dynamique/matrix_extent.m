function Y = matrix_extent(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      mat1 mat2 mat3
% Y =  mat4 mat5 mat6      avec mat5=X
%      mat7 mat8 mat9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row col]=size(X);

mat1=zeros(row,col);
for i=1:row
    for j=1:col
        mat1(i,j)=X(row-i+1,col-j+1);
    end
end

mat2=zeros(row,col);
for i=1:row
    for j=1:col
        mat2(i,j)=X(row-i+1,j);
    end
end

mat3=mat1;

mat4=zeros(row,col);
for i=1:row
    for j=1:col
        mat4(i,j)=X(i,col-j+1);
    end
end

mat6=mat4;

mat7=mat1;

mat8=mat2;

mat9=mat1;

Y=[mat1 mat2 mat3;mat4 X mat6;mat7 mat8 mat9];