function [VitX,VitY] = contraste_mouvement(X1,X2)

%__________________________________________________________% 
% fonction qui calcule le contraste de mouvement qui donne %
% apres filtrage temporel la carte dynamique               %
% estime les mouvements dans une vidéo à l'aide de Gabor   %
% spatiaux du 3ème ordre à partir du fichier commande.c    %
% d'Eric Bruno                                             %

%                                                          %
% entree :                                                 %
% sortie :                                                 %
%                                                          %
% parametres :                                             %
% N = nombre orientation Gabors                            %
% niv = niveau de decomposition pyramidale (nbr bande freq)%
% s0 = ecart-type gabors niv 0                             %
% f0 = frequence centrale Gabors niv 0                     %
% seuilt et VP pour enlever pixels aberrants               %
%__________________________________________________________%


N = 6; % nombre d'orientation
N1 = 2*N;
niv = 3;
s0 = 3.9; % comme en statique
f0 = 0.125; % comme en statique
seuilt = 0.2;
VP=15; % niv dans prog eric mais cree effet de bord
% on a mis VP=15 pour que si pix non extimé à chacun des niveaux il ne soit
% pas pris en compte. mais si il ya a seulement des mauvaises estimations
% dans la boucle robuste ondépasse cette valeur.


% 
% % estime les mouvements dans une vidéo à l'aide de Gabor spatiaux du 3ème
% % ordre à partir du fichier commande.c d'Eric Bruno

taille_y=size(X1,1);
taille_x=size(X1,2);



% DECLARATION
seuil_temp=zeros(taille_y,taille_x);
P=zeros(taille_y,taille_x);
pyr1=zeros(taille_y,taille_x,niv);
pyr2=zeros(taille_y,taille_x,niv);
res1=zeros(taille_y,taille_x);
res2=zeros(taille_y,taille_x);
Vq=zeros(taille_y,taille_x,2);
aux=zeros(taille_y,taille_x);

    
%initialiser vpx et vpy a 0
tx=taille_x/(2^(niv-1));
ty=taille_y/(2^(niv-1));
txf=floor(tx);
tyf=floor(ty);
Vpx=zeros(tyf,txf);
Vpy=zeros(tyf,txf);
V=zeros(tyf,txf,2);
    
    
if size(X1,3)>1
    X1=rgb2gray(X1);
    X2=rgb2gray(X2);
    X1=double(X1);
    X2=double(X2);
end

X1(isnan(X1))=0;
X2(isnan(X2))=0;

    
% decomposition en pyramide pour avoir un system multi-resolution
%gaussien dans pyramide pour eviter contour de mouvement trop net
pyr1=pyramide(X1,niv);
pyr2=pyramide(X2,niv);

% prefiltrage par retine (equivalent filtre DOG) pour blanchiment de
% spectre
for n=niv:-1:1
    txf=floor(taille_x/(2^(n-1)));
    tyf=floor(taille_y/(2^(n-1)));

    res1(1:tyf,1:txf)=retine(pyr1(1:tyf,1:txf,n),0,12,2,0,0);
    res2(1:tyf,1:txf)=retine(pyr2(1:tyf,1:txf,n),0,12,2,0,0);

    pyr1(:,:,n)=res1;
    pyr2(:,:,n)=res2;
end
    

% mauvaise estimation sur zone uniforme on met vect mvt a 0
P=imabsdiff(pyr2(:,:,1),pyr1(:,:,1)); 
seuil_temp=(P<seuilt);
seuil_temp=100*seuil_temp;
seuil_temp=medfilt2(seuil_temp);


for nivp=niv:-1:1   % estimation de la vitesse à tous les niv de la pyramide
    tx=taille_x/(2^(nivp-1));
    ty=taille_y/(2^(nivp-1));
    txf=floor(tx);
    tyf=floor(ty);

    % declaration
    MOD=zeros(tyf,txf,N1);
    E1=zeros(tyf,txf,N1);
    E2=zeros(tyf,txf,N1);
    Dt0=zeros(tyf,txf,N1);
    gradx=zeros(tyf,txf,N1);
    grady=zeros(tyf,txf,N1);

    if (nivp==niv)
        singu=zeros(tyf,txf);
    end
    MOD=mat_mod(singu, N1/2,f0);
    E1=filtre_gabor(pyr1(:,:,nivp),s0,MOD,N1);

    if(nivp~=niv)
        % warping
        Imdep=zeros(tyf,txf);
        [Xw,Yw]=meshgrid(1:txf,1:tyf);
        Imdep=interp2(pyr2(:,:,nivp),Xw+Vpx,Yw+Vpy,'linear');
        Imdep(isnan(Imdep))=0;
        E2=filtre_gabor(Imdep,s0,MOD,N1);
    else
        E2=filtre_gabor(pyr2(:,:,nivp),s0,MOD,N1);
    end
    Dt0=E2-E1; %Dt0 =-dérivée temporelle
    [gradx,grady]=gradient_m(E2);

    %estimation de la vitesse

    [V,singu]=mon_rls7(singu,N1,gradx,grady,Dt0);

    if(nivp~=niv) % on met à jour le vecteur vitesse =vecteur estimé étage k + vecteur étage k-1
        V(:,:,1)=Vpx(:,:)+V(:,:,1);
        V(:,:,2)=Vpy(:,:)+V(:,:,2);
    end
    vxi=medfilt2(V(:,:,1));
    vyi=medfilt2(V(:,:,2));
    vxi=filtre_gaussien_recursif(vxi,txf,tyf,s0);
    vyi=filtre_gaussien_recursif(vyi,txf,tyf,s0);

    % projection à l'étage suivant de la pyramide
    if(nivp~=1)
        singu=projection(singu,tx,ty);
        Vpx=projection(vxi,tx,ty);
        Vpy=projection(vyi,tx,ty);
    else
        V(:,:,1)=vxi;
        V(:,:,2)=vyi;
    end

end

% % on met a 0 les pix jamais estime
% non_estime = (singu+seuil_temp)<=VP;
% VitX = V(:,:,1).*non_estime;
% VitY = V(:,:,2).*non_estime;

VitX = V(:,:,1);
VitY = V(:,:,2);