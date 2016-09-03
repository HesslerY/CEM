%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        װ��MOM-PO�������Ͼ���                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
load('MOM.mat');
load('PO.mat');
load('EH.mat');
%%
%װ��H_MOM_PO:��PO������MOM����(ɢ��糡)
%Ŀ����Ϊ�˻�õ�ѹ����det_V
Constant_part1 = -eta_/(4*pi);
Matrix_MOM_PO = zeros(Edg_MOM_Total,Edg_PO_Total);%M*K
%n_i_MOM_Plus = n_i_MOM(Tri_MOM_Plus,:);  %MOM��������Ƭ�ķ�����
%n_i_MOM_Minus = n_i_MOM(Tri_MOM_Minus,:);  %MOM��������Ƭ�ķ�����
%n_i_MOM_PM = (n_i_MOM_Plus+n_i_MOM_Minus)./repmat(sqrt(sum((n_i_MOM_Plus+n_i_MOM_Minus).^2,2)),1,3);  %��Ԫ�Եķ�����
tic;
for i = 1:Edg_PO_Total
    m_k =mn_PO(i,:)';   %PO�����i����ż����
    r_MOM_PO_r_n = repmat(dolp_PO_r0(i,:),Edg_MOM_Total,1); %PO�����ż���ص�λ�� M*3
    r_MOM_PO_r_n_i = dolp_MOM_r0-r_MOM_PO_r_n;   %PO�����i����ż������MOM�������е�ż���ص�λ�ù�ϵ M*3
    norm_r_MOM_PO_r_n_i = sqrt(sum(r_MOM_PO_r_n_i.^2,2)); %PO�����i��ż���ӵ�λ����MOM��������ż���ӵľ��� M*1
    r_PO = r_MOM_PO_r_n_i./repmat(norm_r_MOM_PO_r_n_i,1,3);     %���е�ż���ص���m����ż���صķ���ʸ�� R_M*3
    jk_r = exp(-1j*k*norm_r_MOM_PO_r_n_i);
    CC = 1./norm_r_MOM_PO_r_n_i.^2.*(1+1./(1j*k*norm_r_MOM_PO_r_n_i));
    Matrix_MOM_PO(:,i) = Constant_part1*jk_r.*((m_n*m_k).*(1j*k./norm_r_MOM_PO_r_n_i+CC)-...%M*1
                         sum(m_n.*r_PO,2).*(r_PO*m_k).*(1j*k./norm_r_MOM_PO_r_n_i+3*CC));
end
disp(['PO������MOM����ľ���װ��ʱ�䣺',num2str(toc),'s']);
FileName1 = 'Matrix_MOM_PO.mat';
save(FileName1,'Matrix_MOM_PO','-v7.3');