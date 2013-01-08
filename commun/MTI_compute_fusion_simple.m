function imsdf = MTI_compute_fusion_simple(t1,t2,t3,cfaces)

a = max(t1(:));

mn = min(t1(:));
mx = max(t1(:));
t1 = (t1-mn) ./ (mx-mn);

b = MTI_skewness(t2);
if(b<0) b = 0; end;

mn = min(t2(:));
mx = max(t2(:));
t2 = (t2-mn) ./ (mx-mn);

if size(cfaces,1)==0,
    g = 0;
else
    g = mean(cfaces(:,5))*nthroot(size(cfaces,1),3);
    
    mn = min(t3(:));
    mx = max(t3(:));
    t3 = (t3-mn) ./ (mx-mn);    
end

imsdf = a .* t1 + b .*t2 + g.*t3 ...
    + a*b.*t1.*t2 + a*g.*t1.*t3 + b*g.*t2.*t3;

mn = min(imsdf(:));
mx = max(imsdf(:));
imsdf = (imsdf-mn) ./ (mx-mn);
