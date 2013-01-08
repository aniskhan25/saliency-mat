function [dyn,dyn_brut] = saillance_dynamique_vid_longue(X, X2, temp, file_resultat, nb_fr, ind)

Im_comp = compense_mvt_dominant(nb_fr,X2,file_resultat);
[VitX,VitY] = contraste_mouvement(X,Im_comp);
%[VitX,VitY] = contraste_mouvement(X,X2);
dyn_brut = sqrt(VitX.^2+VitY.^2);

if ind<size(temp,3)
    if ind==1 % 1er frame du snippet
        dyn = dyn_brut;
    else
        fen = [];
        for k=1:min(ind-1,size(temp,3)-1)
            fen(:,:,k) = temp(:,:,end-k);
        end   
        fen(:,:,k+1) = dyn_brut;
        
        milieu = ceil((size(fen,3)+1)/2);
        fen_med = medfilt1(fen,size(fen,3),[],3);
        dyn = fen_med(:,:,milieu);
    end
else
    fen = [];
    for k=1:size(temp,3)-1
        fen(:,:,k) = temp(:,:,k);
    end
    fen(:,:,size(temp,3)) = dyn_brut;
    milieu = floor((size(temp,3)+1)/2); %3 pour un med de 5
    fen_med = sort(fen,3);
    dyn = fen_med(:,:,milieu);
end
