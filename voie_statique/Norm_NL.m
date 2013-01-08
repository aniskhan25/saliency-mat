function Y = Norm_NL(X,a,b)
% normalisation lineaire X dans [0,1]
% mettre a zeros toutes les valeurs inferieures a a
% mettre a uns toutes les valeurs supeieures a b

Y = normalize(X);
Y(find(Y<a)) = 0;
Y(find(Y>b)) = 1;
Y(find(0<Y & Y<1)) = (Y(find(0<Y & Y<1)) - a)/(b - a);