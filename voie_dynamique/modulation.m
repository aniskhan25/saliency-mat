function res=modulation(im,Nf,mod)

tx=size(mod,2);
ty=size(mod,1);
res=[];

for k=1:2*Nf
    res(:,:,k)=mod(:,:,k).*im(1:ty,1:tx);
end

