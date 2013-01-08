
function [imf,filtered_faces] = saillance_visage(img)

[ImgH,ImgW] = size(img);

res1 = retine(img,0,12,0,0,0);

res1 = (double(img) + res1);
res1 = res1 - min(res1(:));
res1 = res1 ./ max(res1(:)) .* 255;

res1(res1<0)=0;
res1(res1>255)=255;

faces = GetFaces(res1);

filtered_faces = FilterFaces(faces);

%%
if size(faces,1)==0,
    imf = zeros(ImgH,ImgW);
else
    imf = MTI_MGaussFilterFace_v2(filtered_faces,ImgW,ImgH,1.0,0.0,1.0);
end
