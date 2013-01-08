function [Pyr] = pyramide (im, niv)
% construit la pyramide de niveau niv


taille_x=size(im,2);
t_x=taille_x;
taille_y=size(im,1);
t_y=taille_y;
pyr=zeros(taille_y, taille_x, niv);
pyr(:,:,1)=im;

for n=2:niv
    pyr(:,:,n-1)=filtre_gaussien_recursif(pyr(:,:,n-1),t_x,t_y,1.0); % param=1
    scal=2^(n-1);
    t_x=floor(taille_x/scal);
    t_y=floor(taille_y/scal);
    for i=1:t_y
        for j=1:t_x
            pyr(i,j,n)=pyr(2*i-1,2*j-1,n-1);
        end
    end
end

Pyr=pyr;
            