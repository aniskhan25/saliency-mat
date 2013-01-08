function matrix = Interaction(theta, alpha, rho,ortho_coeff)

dimension = rho * 2 + 1;

sigma = 3;

matrix = zeros(dimension, dimension);

i = ceil(dimension/2);
while i <= dimension
    x = i - (dimension+1)/2;
    for j = 1:dimension
        y = j - (dimension+1)/2;
        [XX YY] = cart2pol(x,y);    %[Theta (en radian), Rho]
        XX=XX*180/pi;
        matrix(j,i)=b_ang(0,alpha,XX)*b_rad(YY,rho,sigma);
        matrix(j,dimension-i+1)=b_ang(0,alpha,XX)*b_rad(YY,rho,sigma);
    end
    i = i + 1;
end

matrix = imrotate(matrix, theta, 'bilinear', 'crop');
% matrix = normalize(matrix);

if ortho_coeff~=0
    dimension = rho * 2 + 1;
    sigma = 3;
    matrix_ort = zeros(dimension, dimension);


    i = ceil(dimension/2);
    while i <= dimension
        x = i - (dimension+1)/2;
        for j = 1:dimension
            y = j - (dimension+1)/2;
            [XX YY] = cart2pol(x,y);    %[Theta (en radian), Rho]
            XX=XX*180/pi;
            matrix_ort(j,i)=b_ang(0,(360-2*alpha)/2,XX)*b_rad(YY,rho/2,sigma);
            matrix_ort(j,dimension-i+1)=b_ang(0,(360-2*alpha)/2,XX)*b_rad(YY,rho/2,sigma);
        end
        i = i + 1;
    end
    matrix_ort = imrotate(matrix_ort, theta + 90, 'bilinear', 'crop');
    
    somme = ortho_coeff * sum(sum(matrix)); 
    matrix_ort = matrix_ort / sum(sum(matrix_ort)) * somme;
    matrix = matrix - matrix_ort;
    
%     matrix_ort = normalize(matrix_ort);
%     matrix = matrix - ortho_coeff * matrix_ort;
    
end

