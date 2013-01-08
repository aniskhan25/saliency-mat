function res=demodulation(G,Nf,mod)


res=[];

for k=1:Nf
    norme=sqrt(G(:,:,k).^2+G(:,:,k+Nf).^2);
    res(:,:,k)=(mod(:,:,k).*G(:,:,k)+mod(:,:,k+Nf).*G(:,:,k+Nf))./norme;
    res(:,:,k+Nf)=(-mod(:,:,k+Nf).*G(:,:,k)+mod(:,:,k).*G(:,:,k+Nf))./norme;
end




