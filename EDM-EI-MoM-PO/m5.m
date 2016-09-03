%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        װ����Ͼ���Z_PO_MOM                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
load('MOM.mat');
load('PO.mat');
load('PO_I_s.mat');
load('EH.mat');
%%
%װ��H_PO_MOM:��MOM������PO����(ɢ��ų�)
%Ŀ����Ϊ�˻��MOM��PO��Ϲ��׵ĵ���I_1_PO
Constant1 = 1j*k/(4*pi);
Matrix_PO_MOM = zeros(Edg_PO_Total,Edg_MOM_Total); %�����洢����MOM������POʱ�ĵ���ϵ���ľ��� K*M
tic;
for i = 1:Edg_MOM_Total
    m_n_i =repmat(m_n(i,:),Edg_PO_Total,1);   %K*3  
    sita_k_n = sita_PO_MOM(i,:)';  %MOM�����i�������߶�PO����������Ƭ���ڱ�ϵ���ж� P*1
    sita_k_n_P = sita_k_n(Tri_PO_Plus,1);  %PO����Ƭ�ڱ�ϵ��    K*1
    sita_k_n_M = sita_k_n(Tri_PO_Minus,1); %PO����Ƭ�ڱ�ϵ��    K*1
    %ż����
    r_PO_MOM_r_n=repmat(dolp_MOM_r0(i,:),Edg_PO_Total,1); %ȡ��MOM�����i��ż���ӵ�λ��  K*3  
    r_PO_MOM_r_n_p = dolp_PO_r0-r_PO_MOM_r_n;             %MOM�����i��ż���ӵ�λ����PO��������ż���ӵ�λ�ù�ϵ  K*3
    norm_r_PO_MOM_r_n_p = sqrt(sum(r_PO_MOM_r_n_p.^2,2)); %MOM�����i��ż���ӵ�λ����PO��������ż���ӵľ���   K*1
    jk_r = exp(-1j*k*norm_r_PO_MOM_r_n_p);                %��λ��ϵ K*1
    CC = 1./norm_r_PO_MOM_r_n_p.^2.*(1+1./(1j*k*norm_r_PO_MOM_r_n_p));  %K*1
    M_part1 = 0.5*Constant1*(sita_k_n_P+sita_k_n_M).*CC.*jk_r;
    M_part2 = sum(tao_zf.*cross(n_i_PO_PM,cross(m_n_i,r_PO_MOM_r_n_p)),2);
    Matrix_PO_MOM(:,i) = M_part1.*M_part2;
end
disp(['MOM������PO����ľ���װ��ʱ�䣺',num2str(toc),'s']);
FileName1 = 'Matrix_PO_MOM.mat';
save(FileName1,'Matrix_PO_MOM','-v7.3');