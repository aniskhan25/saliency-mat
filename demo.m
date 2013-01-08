clc;

clear all;

%% SET paths

path = fileparts(mfilename('fullpath'));

addpath(fullfile(path, 'voie_statique'));

addpath(fullfile(path, 'voie_dynamique'));
addpath(fullfile(path, 'mvt_dominant'));

addpath(fullfile(path, 'voie_visage'));
addpath(fullfile(path, 'voie_visage', 'bin'));

addpath(fullfile(path, 'commun'));

addpath(path);

%% COMPILE mex functions

mex voie_visage/src/FaceDetect.cpp -Ivoie_visage/inc/ voie_visage/lib/*.lib -outdir voie_visage/bin/
mex voie_visage/src/FaceDetectStrict.cpp -Ivoie_visage/inc/ voie_visage/lib/*.lib -outdir voie_visage/bin/

%% SET IO variables

ipath = 'data/input/clp01018.mpg';
opath = 'data/output';

[pathstr, name, ext] = fileparts(ipath);
comppath = [fullfile(pathstr,name) '.txt'];

%% GET video file

video = mmreader(ipath);

nframes = video.NumberOfFrames;

%% GET camera motion compensation

estim_mvt_dominant(ipath,comppath);

%% LOOP thru each frame

for i=1:nframes-1,
    
    %% READ frames
    
    im1 = rgb2gray(im2double(read(video,i)));
    im2 = rgb2gray(im2double(read(video,i+1)));
    
    %% COMPUTE dynamic saliency map
    
    [D,D_brut] = saillance_dynamique( ...
        im1, im2 ...
        , 0, comppath, 0, 1 );
    
    %% COMPUTE static saliency map
    
    S = saillance_statique(im2);
    
    %% COMPUTE face saliency map
    
    [F,faces] = saillance_visage(im2);
    
    %% COMPUTE master/fused saliency map
    
    M = MTI_compute_fusion_simple(S,D_brut,F,faces);
    
    %% WRITE saliency maps
    
    imwrite(S,[fullfile(opath,'static',name)  '_' num2str(i) '_sta.png'],'png');
    imwrite(D,[fullfile(opath,'dynamic',name) '_' num2str(i) '_dyn.png'],'png');
    imwrite(F,[fullfile(opath,'face',name)    '_' num2str(i) '_fac.png'],'png');
    imwrite(M,[fullfile(opath,'fusion',name)  '_' num2str(i) '_fus.png'],'png');
    
end
