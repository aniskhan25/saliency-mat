function [res] = filtre_gaussien_recursif (im,taille_x, taille_y,sigma)

% filtrage gaussien par filtre récursif

%definit les partamètres du filtrage à partir de sigma
q=sigma/2.1234+0.0467;

d1_r=(1.7387^(1/q))*cos(0.61861/q);
d1_i=(1.7387^(1/q))*sin(0.61861/q);
d3=1.8654^(1/q);
b=(d3*(d1_r^2+d1_i^2))^(-1);

b1=-b*(d1_r^2+d1_i^2+2*d3*d1_r);
b2=b*(2*d1_r+d3);
b3=-b;
B=1+b1+b2+b3;
b0=-1;


% paramètres article young 95
% q=sigma;
% if (sigma >=0.5 && sigma <2.5)
%     q=3.97156-4.14554*sqrt(1-0.26891*sigma);
% else
%     if (sigma >=2.5)
%         q=0.98711*sigma-0.096330;
%     end
% end
% b0=1.57825+2.44413*q+1.4281*q^2+0.422205*q^3;
% b1=2.44413*q+2.85619*q^2+1.26661*q^3;
% b2=-(1.4281*q^2+1.26661*q^3);
% b3=0.4222205*q^3;
% B=1-((b1+b2+b3)/b0);

tampon=zeros(10,1);
out=zeros(taille_y,taille_x);
res=im;


% filtrage causal en x %

for i=1:taille_y
    tampon(1)=B*res(i,1);
    tampon(2)=B*res(i,2)+(b1/b0)*tampon(1);
    tampon(3)=B*res(i,3)+(b1*tampon(2)+b2*tampon(1))/b0;
    
    for k=4:10
        tampon(k)=B*res(i,k)+(b1*tampon(k-1)+b2*tampon(k-2)+b3*tampon(k-3))/b0;
    end
    
    out(i,1)=B*res(i,1)+(b1*tampon(10)+b2*tampon(9)+b3*tampon(8))/b0;
    out(i,2)=B*res(i,2)+(b1*out(i,1)+b2*tampon(10)+b3*tampon(9))/b0;
    out(i,3)=B*res(i,3)+(b1*out(i,2)+b2*out(i,1)+b3*tampon(10))/b0;

    for j=4:taille_x
        out(i,j)=B*res(i,j)+(b1*out(i,j-1)+b2*out(i,j-2)+b3*out(i,j-3))/b0;
    end
        
end


% filtrage anticausale en x %

for i=1:taille_y
    tampon(10)=B*out(i,taille_x);
    tampon(9)=B*out(i,taille_x-1)+(b1/b0)*tampon(10);
    tampon(8)=B*out(i,taille_x-2)+(b1*tampon(9)+b2*tampon(10))/b0;
    
    for k=3:9
        tampon(10-k)=B*out(i,taille_x-k)+(b1*tampon(11-k)+b2*tampon(12-k)+b3*tampon(13-k))/b0;
    end
    
    res(i,taille_x)=B*out(i,taille_x)+(b1*tampon(1)+b2*tampon(2)+b3*tampon(3))/b0; 
    res(i,taille_x-1)=B*out(i,taille_x-1)+(b1*res(i,taille_x)+b2*tampon(1)+b3*tampon(2))/b0;
    res(i,taille_x-2)=B*out(i,taille_x-2)+(b1*res(i,taille_x-1)+b2*res(i,taille_x)+b3*tampon(1))/b0;
     
    for j=taille_x-3:-1:1
        res(i,j)=B*out(i,j)+(b1*res(i,j+1)+b2*res(i,j+2)+b3*res(i,j+3))/b0;
    end
end


% filtrage causal en y

for j=1:taille_x
    tampon(1)=B*res(1,j);
    tampon(2)=B*res(2,j)+(b1/b0)*tampon(1);
    tampon(3)=B*res(3,j)+(b1*tampon(2)+b2*tampon(1))/b0;
    
    for k=4:10
        tampon(k)=B*res(k,j)+(b1*tampon(k-1)+b2*tampon(k-2)+b3*tampon(k-3))/b0;
    end
    
    out(1,j)=B*res(1,j)+(b1*tampon(10)+b2*tampon(9)+b3*tampon(8))/b0;
    out(2,j)=B*res(2,j)+(b1*out(1,j)+b2*tampon(10)+b3*tampon(9))/b0;
    out(3,j)=B*res(3,j)+(b1*out(2,j)+b2*out(1,j)+b3*tampon(10))/b0;
    
    for i=4:taille_y
        out(i,j)=B*res(i,j)+(b1*out(i-1,j)+b2*out(i-2,j)+b3*out(i-3,j))/b0;
    end
end


% filtrage anticausal en y %

for j=1:taille_x
    tampon(10)=B*out(taille_y,j);
    tampon(9)=B*out(taille_y-1,j)+(b1/b0)*tampon(10);
    tampon(8)=B*out(taille_y-2,j)+(b1*tampon(9)+b2*tampon(10))/b0;
    
    for k=3:9
        tampon(10-k)=B*out(taille_y-k,j)+(b1*tampon(11-k)+b2*tampon(12-k)+b3*tampon(13-k))/b0;
    end
    
    res(taille_y,j)=B*out(taille_y,j)+(b1*tampon(1)+b2*tampon(2)+b3*tampon(3))/b0;
    res(taille_y-1,j)=B*out(taille_y-1,j)+(b1*res(taille_y,j)+b2*tampon(1)+b3*tampon(2))/b0;
    res(taille_y-2,j)=B*out(taille_y-2,j)+(b1*res(taille_y-1,j)+b2*res(taille_y,j)+b3*tampon(1))/b0;
    
    for i=taille_y-3:-1:1
        res(i,j)=B*out(i,j)+(b1*res(i+1,j)+b2*res(i+2,j)+b3*res(i+3,j))/b0;
    end
end

