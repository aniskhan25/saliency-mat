function estim_mvt_dominant(vpath,tpath)

cd mvt_dominant/prog

l_vpath = ['..\..\' vpath];
l_tpath = ['..\..\' tpath];

chaine=sprintf('Motion2D -m AC -p %s -f 0 -r %s -v',l_vpath,l_tpath);
dos(chaine);%AC ou QC et support -a ./support/support -c 255 -w erreur

cd ../..




