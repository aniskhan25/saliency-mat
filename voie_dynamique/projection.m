function P = projection(im,tx,ty)
%projette le vecteur vitesse (ou matrice de singularité) trouvé au niveau n
%de la pyramide au niveau n-1

P=zeros(floor(ty*2),floor(tx*2));
temp=zeros(floor(ty*2), floor(tx*2));

for i=1:ty
    for j=1:tx
        P(i*2-1,j*2-1)=2*im(i,j);
    end
end

for i=2:(2*ty-1)
    temp(i,:)=0.5*P(i-1,:)+P(i,:)+0.5*P(i+1,:);
end

for j=2:(2*tx-1)
    P(:,j)=0.5*temp(:,j-1)+temp(:,j)+0.5*temp(:,j+1);
end
