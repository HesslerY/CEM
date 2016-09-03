%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            MOM_PO�������                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
load('Z_MOM_1.mat');
load('V0_I0.mat');
load('Matrix_PO_MOM.mat');
load('Matrix_MOM_PO.mat');
load('I_inc_k.mat');
%%
%���õ�����ֵ
afa = 1e-5;  %��ֵ
eff = 1;     %���������ó�ֵ
I_MOM_i1 = I0;   
n=0;         %��������
tic;
while(eff>afa)
    I_PO_i=Matrix_PO_MOM*I_MOM_i1+I_inc_k;     %��i�ε���PO����ĵ���
    detV_i = Matrix_MOM_PO*I_PO_i+V0;          %��i�ε���MOM��������ѹ
    I_MOM_i2=Z_MOM_1\detV_i;                       %��i�ε���MOM�ĵ���ϵ��
    det_I = I_MOM_i2-I_MOM_i1;                 %����ǰ�����ε�����
    eff = norm(det_I,2)/norm(I_MOM_i1,2);      %
    I_MOM_i1 = I_MOM_i2;
    n=n+1;
    emsno(n,1)=eff;
end
disp(['�������ʱ�䣺',num2str(toc),'s']);
I_MOM = I_MOM_i1;
I_PO = I_PO_i;
FileName='MOMandPO_i.mat';
save(FileName,'I_MOM','I_PO');