function [V,singu]=mon_rls7(singu,N,Gradx,Grady,Dt0)

% resolution des moindres carrées globales (sur toutes les orientation et
% toutes les echelles)

% retourne la vitesse V en résolvant l'ECMA avec les moindres carrées
% robustes
% Dt0 = dérivée temporelle
% singu est la matrice de singularité



V=zeros(size(singu,1),size(singu,2),2);

ty=size(singu,1);
tx=size(singu,2);

rob=2; %nombre d'itération pour l'estimation robuste
eps1=10^(-2);

% DECLARATION
U=zeros(N,2);
b=zeros(N,1);
A=zeros(N,2);
err=zeros(1,N);

for i=1:ty
    for j=1:tx
        if (singu(i,j)>99)
            singu(i,j)=singu(i,j)+1;
            V(i,j,:)=0;
        else
            U(:,1)=Gradx(i,j,:);
            U(:,2)=Grady(i,j,:);
            b(:,1)=Dt0(i,j,:);
            
            test=0;
            [D]=mon_svdcmp(U);
            %           test si la matrice U est inversible et si le pb est bien
            %           conditionné
            if(D(1,1)>D(2,2))
                wmax=D(1,1);
                wmin=wmax*eps1;
                if(D(2,2)<wmin)
                    test=1;
                end
            else
                wmax=D(2,2);
                wmin=wmax*eps1;
                if(D(1,1)<=wmin)  % + rajouté pour le cas part où W1=W2=0;
                    test=1;
                end
            end
            
            if (test~=1)
                %                 Xt=mon_svbksb(U2,D,Vs,b);
                %                 Xt=inv(U'*U)*U'*b;
                Xt=U\b;
                %              trace_courbe(U,b)
                V(i,j,1)=Xt(1);
                V(i,j,2)=Xt(2);
                
                %estimation robuste
                m=0;
                while(m<rob)
                    %                     var=0;
                    %                     moy=0;
                    %                     w=1;
                    err(1:N)=Gradx(i,j,1:N).*V(i,j,1)+Grady(i,j,1:N).*V(i,j,2)-Dt0(i,j,1:N);
                    trie=err;
                    trie=sort(trie);
                    med=trie(N/2);
                    trie=abs(err-med);
                    trie=sort(trie);
                    var=trie(N/2);
                    poids=0;
                    var=1.4826*var;
                    
                    %   estimation robuste
                    for n=1:N
                        
                        %biweight Tukey
                        C=2.795*var;
                        w=(err(n)^2-C^2)/(C^2);
                        if(w>0)
                            w=0;
                        else
                            w=w^2;
                        end
                        A(n,1)=w*Gradx(i,j,n);
                        A(n,2)=w*Grady(i,j,n);
                        b(n)=w*Dt0(i,j,n);
                        poids=poids+abs(A(n,1))+abs(A(n,2));
                        %                         We(n)=w;
                    end
                    %                     trace_courbe(A,b)
                    if(isfinite(poids)~=0 && var<1)
                        [D]=mon_svdcmp(A);
                        %                         test si la matrice A est inversible et si le pb
                        %                         est bien conditionné
                        if(D(1,1)>D(2,2))
                            wmax=D(1,1);
                            wmin=wmax*eps1;
                            if(D(2,2)<wmin)
                                test=1;
                            end
                        else
                            wmax=D(2,2);
                            wmin=wmax*eps1;
                            if(D(1,1)<=wmin)
                                test=1;
                            end
                        end
                        if(test~=1)
                            %                             Xt=mon_svbksb(A2,D,Vs,b);
                            %                             Xt=inv(A'*A)*A'*b;
                            Xt=A\b;
                            V(i,j,1)=Xt(1);
                            V(i,j,2)=Xt(2);
                        else
                            singu(i,j)=singu(i,j)+1;
                            V(i,j,:)=0;
                        end
                    else
                        singu(i,j)=singu(i,j)+1;
                        V(i,j,:)=0;
                    end
                    m=m+1;
                end
            else
                singu(i,j)=singu(i,j)+1;
                V(i,j,:)=0;
            end
            if(abs(V(i,j,1))>3 ||abs(V(i,j,2))>3)
                singu(i,j)=singu(i,j)+1;
                V(i,j,:)=0;
            end
        end
    end
end




