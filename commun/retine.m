function out = retine(X,tai,sig,gang,display,n)
% Xi = image d'entree (2D)
% tai = taille du filtrage passe bas (gaussien)
% sig = sigma de la gaussienne
% gang : type de la sortie
%       gang = 0 : Parvo
%       gang = 1 : Magno X
%       gang = 2 : Magno Y
% display : afficher les resulats ou non
%       display = 1 : afficher
%       dispaly = 0 : pas d'affichage
% n: nombre de pixels etendus au bord


% HPT mis à jour 2007
% N.Guyader
% Fonction de Pascal Teissier (1999)
% repris et mis à jour le 22/02/2005


[Nrows Mcolumns] = size(X);
X = matrix_extent(X);
X = X(Nrows+1-n:2*Nrows+n,Mcolumns+1-n:2*Mcolumns+n);

    
% Photorécepteurs------------------------------------
% % Non linearite
% G = fspecial('gaussian',tai,sig);
% if display
%     figure;set(gcf,'Name','Retinal filter')
%     subplot(3,2,1);mesh(G);
%     xlabel('Gaussian filter')
% end
% H = filter2(G,X);
% % Xo=.1+410*H./(H+105); 
% Xo = eps + H;
% % 
% % % Moyennage local
% Y = (255+Xo).*X./(X+Xo);

Y=X;

% % Filtre passe-bas des photorecepteurs
tai_p = 15;
sig_p = 1/(2*pi*0.5);
Gp = fspecial('gaussian',tai_p,sig_p);  
Y = filter2(Gp,Y);
% % end - filtre passe-bas des photorecepteurs

if display
    Y_v = Y(n+1:n+Nrows,n+1:n+Mcolumns);
    subplot(3,2,2);imshow(Y_v,[]);
    xlabel('Photoreceptor')
end

% % Cellules Horizontales-------------------------------
% G = fspecial('gaussian',tai,sig);  
% H = filter2(G,Y);
% H = filter2(G,H);
xg1 = filtre_gaussien_recursif(Y,size(Y,2),size(Y,1),0.8);
xg2 = filtre_gaussien_recursif(xg1,size(Y,2),size(Y,1),0.94);

H = xg2;

if display
    H_v = H(n+1:n+Nrows,n+1:n+Mcolumns);
    subplot(3,2,3);imshow(H_v,[]);
    xlabel('Horizontal cellular')
end

% Cellules ON-----------------------------------------
beta=1; %on ne rajoute pas de BF
ON = Y - beta*H;
ON(find(ON<0)) = 0;
% % Compression
% ON = (255+Xo).*ON./(ON+Xo);

if display
    ON_v = ON(n+1:n+Nrows,n+1:n+Mcolumns);
    subplot(3,2,4);imshow(ON_v,[]);
    xlabel('Bipolar cellular ON')
end

% Cellules OFF
OFF = beta*H - Y;
OFF(find(OFF<0)) = 0;
% % Compression
% OFF = (255+Xo).*OFF./(OFF+Xo);

if display
    OFF_v = OFF(n+1:n+Nrows,n+1:n+Mcolumns);
    subplot(3,2,5);imshow(OFF_v,[]);
    xlabel('Bipolar cellular OFF')
end

out = ON - OFF;


% modulé par la composante BF de Horizontal
%on utilise le paramètre beta
% alpha = 0.6;
% out = alpha * out + (1 - alpha) * H; 

if gang == 0
    % Sortie Parvo
    out = out(n+1:n+Nrows,n+1:n+Mcolumns);
    
%     max_out=max(max(out));
%     min_out=min(min(out));
%     out=(out-min_out)*255/(max_out-min_out);

    if display
        subplot(3,2,6);imshow(out,[]);
        xlabel('Retinal output - Parvocellular')
    end
elseif gang == 1
    % Sorties MagnoX
    Mx = filter2(G,out);
    Mx = filter2(G,Mx);
    Mx = filter2(G,Mx);
    out = Mx;
    
    out = out(n+1:n+Nrows,n+1:n+Mcolumns);
    
%     max_out = max(max(out));
%     min_out = min(min(out));
%     out = (out-min_out)*255/(max_out-min_out);
    
    if display
        subplot(3,2,6);imshow(out,[]);
        xlabel('Retinal output - Magnocellular X')
    end
elseif gang == 2
    % Magno Y (celle qu'on utilise pour voie mouvement)

    A=Y-H;
    out=filtre_gaussien_recursif(A,size(A,2),size(A,1),0.8);

    
%     temp_y = abs(double(ON)+double(OFF));
%     My = filter2(G,temp_y);
%     out = My;
%     out = out(n+1:n+Nrows,n+1:n+Mcolumns);
    
%     max_out = max(max(out));
%     min_out = min(min(out));
%     out = (out-min_out)*255/(max_out-min_out);
    
    if display
        subplot(3,2,6);imshow(out,[]);
        xlabel('Retinal output - Magnocellular Y')
    end
end


