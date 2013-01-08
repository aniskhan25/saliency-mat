function[W]=mon_svdcmp(A)
% function [U,W,V]=mon_svdcmp(A)

% décompose A, A(n,m)=U(n,m)*W(n,n)*V(n,n)'
%avec U et V' orthogonales et W diagonale

M=A'*A;
[P,Dl,P1]=svd(M);
% U=A*P*Dl.^(-1/2);
W=sqrt(Dl);
% V=P1;




