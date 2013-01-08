function I_c_ng = compense_mvt_dominant(number,I2,file_resultat)

%function  [VVitX,VVitY,singu,P,singub]=motion_map_ret_v15(number,path_image,file_resultat,TAI)



% % calcul l'estimation de mouvement dominant
%ouvrir le fichier resultat
fid = fopen(file_resultat,'rt');
if fid==-1
    disp('erreur dans file_resultat');
    return;
end
%passer l'entete
chaine='#';
while(chaine(1)=='#')
    chaine=fgetl(fid);
end
id_model=chaine;

factor=fgetl(fid);

%=============================================================%
%Start to read the file containing affine motion model 
%and search the frame number
%=============================================================%
numero=-100;
indice = 1;
while(numero~=number)
    chaine=fgetl(fid);
    if chaine==-1
        break;
    end
    cha=str2num(chaine);
    numero=cha(1);
    indice = indice +1;
end

fclose(fid);

if (numero~=number)
    bw3a=[];
    return;
end

numero=cha(1);
pos_y=cha(2);
pos_x=cha(3);
c1=cha(4);
c2=cha(5);
a1=cha(6);
a2=cha(7);
a3=cha(8);
a4=cha(9);
q1=cha(10);
q2=cha(11);
q3=cha(12);
q4=cha(13);
q5=cha(14);
q6=cha(15);
illu=cha(16);
est=cha(17);
t_y=pos_y*2;
t_x=pos_x*2;
x=ones(t_y,1)*[1:t_x];
y=[1:t_y]'*ones(1,t_x);
vx=c1+a1*(x-pos_x)+a2*(y-pos_y)+q1*(x-pos_x).^2+q2*(y-pos_y).*(x-pos_x)+q3*(y-pos_y).^2;
vy=c2+a3*(x-pos_x)+a4*(y-pos_y)+q4*(x-pos_x).^2+q5*(y-pos_y).*(x-pos_x)+q6*(y-pos_y).^2;

%=============================================================%
%To achieve motion compensation 
%=============================================================%

I_c_ng=interp2(I2,x+vx,y+vy,'linear');
return;
