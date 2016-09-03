%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           װ�����迹����                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
%��������
load('MOM.mat');
%%
%��Ż�����������
f = 6e8;                %��ӵ�Ų�Ƶ��
epsilon_ = 8.854e-012;  
mu_ = 1.257e-006;
c_=1/sqrt(epsilon_*mu_);
eta_=sqrt(mu_/epsilon_);   %���ɿռ��糣��
%ͬ�ڱ��������ڼ����迹����
omega       =2*pi*f;                                           
k           =omega/c_; 
K           =1j*k;
lambda = c_/f;  %����
%%
deta = 0.15*c_/f;            %�����ж��Ƿ�ʹ�õ�Чż���ط�����ѡȡ���볬��0.15��������
Constant_part1 = -1j*omega*mu_/(144*pi);
Constant_part2 = -4/(k^2);
%װ��Z_MOM_1
Z_MOM_1 = zeros(Edg_MOM_Total,Edg_MOM_Total)+1j*zeros(Edg_MOM_Total,Edg_MOM_Total);
tic;
for m=1:Edg_MOM_Total
    rho_m_P = RHO_MOM_Plus(m,:);           %rho_m+      ��m������Ƭ��rho_m+ 3*1
    rho_m_M = RHO_MOM_Minus(m,:);          %rho_m-      ��m������Ƭ��rho_m-
    lm = Ed_MOM_Length(m,1);               %lm          ��m��ż���ض�Ӧ�Ĺ����ߵĳ���
    %�ŵ㷨׼��
    r_m_Plus_n =repmat(Center_MOM_Plus(m,:),Edg_MOM_Total,9);     %r_m+  Edg_MOM_Total*27
    r_m_Minus_n = repmat(Center_MOM_Minus(m,:),Edg_MOM_Total,9);  %r_m-  Edg_MOM_Total*27
    r_mn_PP= r_m_Plus_n-Center__Plus_n;    %r_m+-r_k+   ������������Ƭ�ľŸ�ͼ�ĵ���m�������߶�Ӧ������Ƭ��ͼ�ĵ�ʸ�� Edg_MOM_Total*27
    r_mn_PM = r_m_Plus_n-Center__Minus_n;  %r_m+-r_k-   ������������Ƭ�ľŸ�ͼ�ĵ���m�������߶�Ӧ������Ƭ��ͼ�ĵ�ʸ�� Edg_MOM_Total*27
    r_mn_MP = r_m_Minus_n-Center__Plus_n;  %r_m--r_k+   ������������Ƭ�ľŸ�ͼ�ĵ���m�������߶�Ӧ�ĸ���Ƭ��ͼ�ĵ�ʸ�� Edg_MOM_Total*27
    r_mn_MM = r_m_Minus_n-Center__Minus_n; %r_m--r_k-   ������������Ƭ�ľŸ�ͼ�ĵ���m�������߶�Ӧ������Ƭ��ͼ�ĵ�ʸ�� Edg_MOM_Total*27
   %��Ե�m�������߶����и������ߵ����ý��б�����
   for n=1:Edg_MOM_Total  
       ln = Ed_MOM_Length(n,1);                %ln  
       r_mk_PP = reshape(r_mn_PP(n,:),3,9)';   %9*3 ���������εĹ�ϵ ȡ����n�������߶�Ӧ������Ƭ�ŵ�͵�m�������߶�Ӧ������Ƭ��������ϵ
       r_mk_PM = reshape(r_mn_PM(n,:),3,9)';   %9*3
       r_mk_MP = reshape(r_mn_MP(n,:),3,9)';   %9*3
       r_mk_MM = reshape(r_mn_MM(n,:),3,9)';   %9*3
       norm_r_mk_PP = sqrt(sum(r_mk_PP.^2,2)); %9*1  ������õ�������ȡģ �õ������ϵ  
       norm_r_mk_PM = sqrt(sum(r_mk_PM.^2,2)); %9*1  
       norm_r_mk_MP = sqrt(sum(r_mk_MP.^2,2)); %9*1
       norm_r_mk_MM = sqrt(sum(r_mk_MM.^2,2)); %9*1
       g_PP = exp(-1j*k*norm_r_mk_PP)./norm_r_mk_PP;  %9*1 �õ���λ��ϵ
       g_PM = exp(-1j*k*norm_r_mk_PM)./norm_r_mk_PM;  %9*1
       g_MP = exp(-1j*k*norm_r_mk_MP)./norm_r_mk_MP;  %9*1
       g_MM = exp(-1j*k*norm_r_mk_MM)./norm_r_mk_MM;  %9*1
       rho_k_P = reshape(RHO_MOM__Plus_n(n,:),3,9)';  %rho_k+ = 9*3  ��n�������߶�Ӧ������Ƭ��rho_k+ 
       rho_k_M = reshape(RHO_MOM__Minus_n(n,:),3,9)'; %rho_k- = 9*3  ��n�������߶�Ӧ�ĸ���Ƭ��rho_k-
       rho_g_PP_rhom_z = sum((rho_k_P*rho_m_P').*g_PP);     %1*3
       rho_g_PM_rhom_z = sum((rho_k_M*rho_m_P').*g_PM);     %1*3
       rho_g_MP_rhom_f = sum((rho_k_P*rho_m_M').*g_MP);     %1*3
       rho_g_MM_rhom_f = sum((rho_k_M*rho_m_M').*g_MM);     %1*3

       Z_MOM_1(m,n)=Constant_part1*lm*ln*((rho_g_PP_rhom_z+rho_g_PM_rhom_z)+(rho_g_MP_rhom_f+rho_g_MM_rhom_f)+...
                    ((sum(g_PP)-sum(g_PM))-(sum(g_MP)-sum(g_MM)))*Constant_part2); %ʹ�ô�ͳ�ľŵ㷨����װ��
   end
end
disp(['�迹����Z_MOMװ��ʱ���ǣ�',num2str(toc)]);
%%
FileName1='Z_MOM_1.mat';
save(FileName1,'Z_MOM_1');
FileName2='EH.mat';
save(FileName2,'f','omega','mu_','epsilon_','c_', 'k','eta_','lambda');