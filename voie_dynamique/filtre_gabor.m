function res=filtre_gabor(im,sigma,mod,N)

tx=size(mod,2);
ty=size(mod,1);
G=modulation(im,N/2,mod);

for i=1:N
    G(:,:,i)=filtre_gaussien_recursif(G(:,:,i),tx,ty,sigma);
end
 
res=demodulation(G,N/2,mod);