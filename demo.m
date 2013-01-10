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

if( ~exist('data/output/static','dir')), mkdir('data/output/static'); end;
if( ~exist('data/output/dynamic','dir')), mkdir('data/output/dynamic'); end;
if( ~exist('data/output/face','dir')), mkdir('data/output/face'); end;
if( ~exist('data/output/fusion','dir')), mkdir('data/output/fusion'); end;

%% COMPILE mex functions

disp('COMPILE mex functions.');

if( ~exist('voie_visage/bin/FaceDetect','file')),
    mex voie_visage/src/FaceDetect.cpp -Ivoie_visage/inc/ voie_visage/lib/*.lib -outdir voie_visage/bin/
end;
if( ~exist('voie_visage/bin/FaceDetectStrict','file')),
    mex voie_visage/src/FaceDetectStrict.cpp -Ivoie_visage/inc/ voie_visage/lib/*.lib -outdir voie_visage/bin/
end;

%% SET IO variables

ipath = 'data/input/clp01018.mpg';
opath = 'data/output';

[pathstr, name, ext] = fileparts(ipath);
comppath = [fullfile(pathstr,name) '.txt'];

%% GET video file

disp('READ input video.');

video = mmreader(ipath);

nframes = video.NumberOfFrames;

%% GET camera motion compensation

disp('COMPUTE camera motion variables.');
    
if( ~exist(comppath,'file')),
    estim_mvt_dominant(ipath,comppath);
end;

%% LOOP thru each frame

disp('COMPUTE saliency ...');

%for i=1:nframes-1,
for i=1:3, % first three frames

    disp(['Frame ' num2str(i+1) '...']);
    
    %% READ frames
    
    im1 = rgb2gray(im2double(read(video,i)));
    im2 = rgb2gray(im2double(read(video,i+1)));
    
    %% COMPUTE static saliency map
    
    disp('COMPUTE static saliency map.');
    
    S = saillance_statique(im2);
    
    %% COMPUTE dynamic saliency map
    
    disp('COMPUTE dynamic saliency map.');
    
    [D,D_brut] = saillance_dynamique( ...
        im1, im2 ...
        , 0, comppath, 0, 1 );
    
    %% COMPUTE face saliency map
    
    disp('COMPUTE face saliency map.');
    
    [F,faces] = saillance_visage(im2);
    
    %% COMPUTE master/fused saliency map
    
    disp('COMPUTE fusion/master saliency map.');
    
    M = MTI_compute_fusion_simple(S,D_brut,F,faces);
        
    %% WRITE saliency maps

    disp('SAVE saliency maps.');
    
    imwrite(S,[fullfile(opath,'static',name)  '_' num2str(i) '_sta.png'],'png');
    imwrite(D,[fullfile(opath,'dynamic',name) '_' num2str(i) '_dyn.png'],'png');
    imwrite(F,[fullfile(opath,'face',name)    '_' num2str(i) '_fac.png'],'png');
    imwrite(M,[fullfile(opath,'fusion',name)  '_' num2str(i) '_fus.png'],'png');
    
end

disp('COMPUTE saliency completed.');