function [mod]=mat_mod(im,Nf,f)

t_x=size(im,2);
t_y=size(im,1);

mod=zeros(t_y,t_x,2*Nf);

I1=(1:t_y);
O1=ones(1,t_x);
I=I1'*O1;
J1=(1:t_x);
O2=ones(t_y,1);
J=O2*J1;

for k=1:Nf
    mc=I.*cos(k*pi/Nf)+J.*sin(k*pi/Nf);
    mod(:,:,k)=cos(mc.*(2*pi*f));
    mod(:,:,k+Nf)=sin(mc.*(2*pi*f));
end

% programme équivalent mais plus couteux en temps de calcul
% for k=1:Nf
%     for i=1:t_y
%         for j=1:t_x
%             mod(i,j,k)=cos(2*pi*f*(i*cos(k*pi/Nf)+j*sin(k*pi/Nf)));
%             mod(i,j,k+Nf)=sin(2*pi*f*(i*cos(k*pi/Nf)+j*sin(k*pi/Nf)));
%         end
%     end
% end

