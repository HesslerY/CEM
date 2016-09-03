%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          ��ʼ��ѹ����V0                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
load('MOM.mat');
load('EH.mat');
load('Z_MOM_1.mat');
%%
%��ѹ�������ӳ��������й�
%������ӳ���
thi = 35;
phi = 0;
phi = phi*pi/180;
thi = thi*pi/180;
k_i = -[sin(thi)*cos(phi) sin(thi)*sin(phi) cos(thi)];        %���䲨����
e_i_theta = [cos(phi)*cos(thi) cos(thi)*sin(phi) -sin(thi)];  %thta��������
e_i_phi = [-sin(phi) cos(phi) 0];                             %fire��������
Pol = e_i_theta;                                              %��������ѡ��
kv=k*k_i;                                                     %���䲨ʸ
ph = 0;
phs = ph*pi/180;      %ph
%%
V0 = zeros(Edg_MOM_Total,1);                            
tic;
for m=1:Edg_MOM_Total  
    ScalarProduct=kv*Center_MOM_Plus(m,:)';             %��������������Ԫȡ�ñ�š�ȡ��������Ԫͼ��������Բ�ʸ����ͣ�����k*r�� 
    EmPlus =Pol*exp(-1j*ScalarProduct);                 %������λ��ʾ���õ����䳡���
    ScalarProduct=kv*Center_MOM_Minus(m,:)';   
    EmMinus=Pol*exp(-1j*ScalarProduct);     
    ScalarPlus =EmPlus* RHO_MOM_Plus(m,:)';             %E*rou     
    ScalarMinus=EmMinus*RHO_MOM_Minus(m,:)';  
    V0(m,1)=-Ed_MOM_Length(m,1)*(ScalarPlus/2+ScalarMinus/2);      
end
disp(['��ѹ����װ��ʱ�䣺',num2str(toc),'s']);
clear ScalarProduct EmPlus ScalarProduct EmMinus ScalarPlus ScalarMinus m
%%
tic;
%�����󷽳���
I0=Z_MOM_1\V0;                                                 %�õ������ı�ʾ���Թ�������Ŀװ��
disp(['��������ʱ�䣺',num2str(toc),'s']);
%%
FileName='V0_I0.mat';
save(FileName,'V0','I0');
FileName2='E_i.mat';
save(FileName2,'thi','phi','k_i','e_i_theta','e_i_phi','Pol','kv','ph','phs');