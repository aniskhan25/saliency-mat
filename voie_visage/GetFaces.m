function oFaces = GetFaces(img)

oFaces = [];

faces = FaceDetectStrict('voie_visage/bin/haarcascades/haarcascade_frontalface_alt2.xml',img);

if faces~=-1,
       
    oFaces = ... % SET faces
        [oFaces; ...
        [faces(:,1),faces(:,2) ...
        ,faces(:,3),faces(:,4) ...
        ,faces(:,5),zeros(size(faces,1),1)]];
    
end

faces = FaceDetect('voie_visage/bin/haarcascades/haarcascade_mcs_upperbody.xml',img);

if faces~=-1,
        
    med = floor(median(unique(faces(:,5))));
    faces( faces(:,5)<med,:)=[];
    
    oFaces = ... % SET faces
        [oFaces; ...
        [faces(:,1),faces(:,2) ...
        ,faces(:,3),faces(:,4) ...
        ,faces(:,5),ones(size(faces,1),1)]];
    
end
