
function [ska,sa] = MTI_skewness(a)

a = a(:);
ma=mean(a);
sa=std(a);
ska = mean((a-ma).^3) / sa^3;
