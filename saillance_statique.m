function M = saillance_statique(im)

%parametres
% taille et ecart-type de la fonction gausienne de la retine
TAI = 0; % on ne met pas de non linearite
SIG = 12;


% nombre de frequences et d'orientations
BANDE = 4;
ORIENT = 6;

% pour avoir meme param que sur bande 3 en dynamique
STD_MAX = 0.25/0.125*1/(2*pi*3.9);
FREQ_MAX = 0.25;

SCALE = 2;
CONTOUR_LEVEL = 0.5;

I=im;

if length(size(I)) > 2
    I = rgb2gray(I);
end

%I = double(I);

[ROW COL] = size(I);

% FILTRE RETINIEN
% voie Parvo, sans d'affichage, sans miroir
I_r = retine(I,TAI,SIG,0,0,0); 
mu = 8;
[X,Y] = meshgrid(0:1:COL-1,0:1:ROW-1);
mask = (1-((X-floor(COL/2)).^mu)/floor(COL/2)^mu).*(1-((Y-floor(ROW/2)).^mu)/floor(ROW/2)^mu);

I_r = I_r .* mask;

% % % afficher l'image retinienne
% figure; imshow(I_r,[])
% set(gcf,'Name','Image retinienne');

%spectre de l'image retinienne
SI_r = fftshift(fft2(I_r));

% FILTRE DE GABOR
%calcul des angles
teta = [0:ORIENT - 1]*180/ORIENT;
%en frequence, teta = teta spatial + 90
teta = teta + 90;

%calcul des frequences
for i = 1 : BANDE
    f0(i) = FREQ_MAX /(SCALE^(i-1));
end
f0 = fliplr(f0);

%calculer les ecarte-types dans la direction u
sig_hor = zeros(1,BANDE);
for i = 1 : BANDE
    sig_hor(i) = STD_MAX /(SCALE^(i-1));
end
sig_hor = fliplr(sig_hor);

u = linspace(-0.5,0.5,COL+1);
v = linspace(0.5,-0.5,ROW+1); % comme les coordonnnees Descartiennes
[Fx Fy] = meshgrid(u,v);

% differentes bandes de frequences
scale = 0;
for j = 1 : ORIENT
    theta = teta(j)*pi/180;
    u2 = Fx*cos(theta) + Fy*sin(theta);
    v2 = Fy*cos(theta) - Fx*sin(theta);
    u1 = u2(1:ROW,1:COL);
    v1 = v2(1:ROW,1:COL);
    
    for i = 1 : BANDE
        sigu = sig_hor(i);
        %sigv = f0(i)*tan(pi/(2*ORIENT))/(2*sqrt(log(1/CONTOUR_LEVEL)/2));
        sigv = sigu;
        scale(j,i) = sigv/sigu;
        gabor = exp(-((u1-f0(i)).^2/(2*sigu^2)+(v1).^2/(2*sigv^2)));
        SI_g = SI_r .* gabor;
        I_g(j,i,:,:) = ifft2(ifftshift(SI_g));
        
        I_g(j,i,:,:) = abs(I_g(j,i,:,:)).^2;
    end
end


% % % % SHORT Interaction
I_temps = I_g;
for j = 1 : ORIENT
    for i = 1 : BANDE
        jp = j + 1;
        jm = j - 1;
        if (j==ORIENT) jp = 1; end
        if (j==1) jm = ORIENT; end

        if i == 1
            map = 1*I_temps(j,i,:,:) + 0.5*I_temps(j,i+1,:,:)...
                  - 0.25*I_temps(jp,i,:,:) - 0.25*I_temps(jm,i,:,:);
        elseif i == BANDE
            map = 0.5*I_temps(j,i-1,:,:) + 1*I_temps(j,i,:,:)...
                  - 0.25*I_temps(jp,i,:,:) - 0.25*I_temps(jm,i,:,:);
        else
            map = 0.5*I_temps(j,i-1,:,:) + 1*I_temps(j,i,:,:)...
                  + 0.5*I_temps(j,i+1,:,:) - 0.5*I_temps(jp,i,:,:)...
                  - 0.5*I_temps(jm,i,:,:);
        end
        %map(find(map<0)) = 0;
        I_g(j,i,:,:) = map;
    end
end
clear I_temps

% LONG Interaction:  butterfly: Hor - 0.2Vert
MaskSize = 1/min(f0);
% RAD_MAX = 35;
RAD_MAX = ceil(MaskSize/2);
OUVERTURE = 180/ORIENT;
COEFF_ORTHO = 0.2;

theta = [0:ORIENT - 1]*180/ORIENT;

for i = 1 : BANDE
    rayon(i) = ceil(RAD_MAX/SCALE^(i-1));
end



for j = 1 : ORIENT
    for i = 1 : BANDE 
        hansenr = my_butterfly(theta(j),OUVERTURE,rayon(i),COEFF_ORTHO);
        hansenr = hansenr/sum(sum(hansenr));
        map = conv2(squeeze(I_g(j,i,:,:)),hansenr,'same');           

        I_g(j,i,:,:) = map;
    end
end


% % NORMALISATION ITTI
b_inf = 0;
b_sup = 1;
for j = 1 : ORIENT
    for i = 1 : BANDE
        map = squeeze(I_g(j,i,:,:));
        map = Norm_NL(map,b_inf,b_sup);
        map = NormItti(map);
        
        I_g(j,i,:,:) = NormPc(map,0.2);
 

    end
end


% FUSION
M = squeeze(sum(I_g,1));
M = squeeze(sum(M,1));

% G = fspecial('gaussian',15,12);
% M = conv2(M,G,'same');
% mask
mu = 8;
[X,Y] = meshgrid(0:1:COL-1,0:1:ROW-1);
mask = (1-((X-floor(COL/2)).^mu)/floor(COL/2)^mu).*(1-((Y-floor(ROW/2)).^mu)/floor(ROW/2)^mu);
M = M .* mask;

%affichage
% figure; imshow(M,[])
% set(gcf,'Name','Carte de saillance');

