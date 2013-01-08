
function res = MTI_MGaussFilterFace_v2(cfaces,ImgW,ImgH,scale,minimum,maximum)

mask = zeros(ImgH,ImgW);
res = zeros(ImgH,ImgW);

xc = double(round(cfaces(:,1)*scale));
yc = double(round(cfaces(:,2)*scale));

wc = double(round(cfaces(:,3)*scale));
hc = double(round(cfaces(:,4)*scale));

for i=1:size(cfaces,1),
    
    mask(:) = 0;
    
    mask = customgauss( ...
        size(mask) ...
        , hc(i), wc(i) ...
        , 0, 0, cfaces(i,5), ...
        [double(yc(i)+hc(i)/2-ImgH/2) double(xc(i)+wc(i)/2-ImgW/2)]);
           
    t = mask(yc(i)+ceil(hc(i)/2),xc(i));
    mask(mask<t) = 0.0;   
    
    index = (mask ~= 0);
    res(index) = res(index) + mask(index);
end
