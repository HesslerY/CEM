%---------------------------PO_PEC˫վʵ��-------------------------%
%2016-4-12
%
clear;
clc;
p = load('NODE.txt');
t = load('FACE.txt');
p(:,1)=[];   %ɾ����һ��
t(:,1)=[];   %ɾ����һ��
TrianglesTotal=length(t);          %�ܵ���������Ԫ����
%%
%ÿ����Ԫ����������ġ��ⷨʸ
A = p(t(:,1),:);                   %ÿ��������Ԫ�Ľڵ�����
B = p(t(:,2),:);
C = p(t(:,3),:);
AB = B-A;                          %������Ԫ��ʸ
BC = C-B;
CA = A-C;
ABxBC = cross(AB,BC);
Area = 0.5*sqrt(sum(ABxBC.^2,2));  %ÿ����Ԫ�����
Center = 1/3*(A+B+C);              %��m��������Ԫ�ļ�����������(ͼ��)
n_i = ABxBC./repmat(sqrt(sum(ABxBC.^2,2)),1,3);       %��Ԫ��ʸ
ToT_S_s = sum(Area);                                  %����������Ԫ���
r_n = [AB,BC,CA];                  %һ�о��е�����ʸ������      
r_c = [(A+B)/2,(B+C)/2,(A+C)/2];   %һ�о��е������е��������
clear ABxBC;
%%
%��Ų�������
f = 3e8;                %���䲨Ƶ������  
epsilon_ = 8.854e-012;  %���ɿռ��糣��
mu_ = 1.257e-006;       %���ɿռ�ŵ���
c_=1/sqrt(epsilon_*mu_);%���ɿռ����
lambda =c_/f;           %���䲨����
Z0=sqrt(mu_/epsilon_);  %�����迹
k0 = 2*pi/lambda;       %�ռ����ɲ���
r = 2e2*lambda;       %�ռ䳡����루�������ã���Ҫ�㹻Զ��    
%%
%��ӳ�����
thta = 35;
de_thta = thta*pi/180;
phi = 30;
de_phi = phi*pi/180;
thta_s = 0:360;
AA = length(thta_s);
de_thta_s = thta_s'*pi/180;
phi_s = 30;
de_phi_s = phi_s*pi/180;
%���õ�ų��ļ�������Ͳ�������
k_i= -[sin(de_thta)*cos(de_phi) sin(de_thta)*sin(de_phi) cos(de_thta)];          %���䲨����
e_i_theta = [cos(de_phi)*cos(de_thta) cos(de_thta)*sin(de_phi) -sin(de_thta)];  %thta��������
e_i_phi = [-sin(de_phi) cos(de_phi) 0];                             %fire��������
pol_e_i = e_i_theta;
h_i = cross(k_i,pol_e_i);   %����ų��ļ�������
k_s = [sin(de_thta_s)*cos(de_phi_s) sin(de_thta_s)*sin(de_phi_s) cos(de_thta_s)];%ɢ�䲨����ʸ��
e_r_thta_s = [cos(de_thta_s)*cos(de_phi_s) cos(de_thta_s)*sin(de_phi_s) -sin(de_thta_s)];%thta��������
e_r_fire_s = repmat([-sin(de_phi_s) cos(de_phi_s) 0],AA,1);  %fire��������
%���䳡����
H0 = 1/Z0;     %���䳡ѡΪ�ų�������ѡΪ1
%%
%����Ԫ�ڱ��жϣ�
%���ڱ��ж�
afa0 = n_i*k_i';              %�������䷽��ʸ������Ԫ��ʸ����(ÿһ�м��Ƕ�Ӧһ���Ƕ���ʱ��������Ƭ���ڱ��жϽ�)
sita = afa0<0;                %afa0<0��������Ԫ����Ϊ1��afa0>=0����Ԫ���������ڱΣ���Ϊ0
%���ڱ��ж�
%�˴�Ԥ���ٴ���
clear afa0
%%
%��������Զ���ռ䴦��ɢ�䳡
%����׼��
part1 = 1j*k0*Z0*H0*exp(-1j*k0*r)/(2*pi*r);
part3 = -1j/k0;
W = repmat(k_i,AA,1)-k_s;
E_n=zeros(TrianglesTotal,3);
E = zeros(AA,3);
deta = lambda*1e-5;
for i=1:AA
    k_s_n = repmat(k_s(i,:),TrianglesTotal,1);
    h_i_n = repmat(h_i,TrianglesTotal,1);
    W_n = repmat(W(i,:),TrianglesTotal,1);
    W_i = W(i,:)';
    cross_W_n=cross(W_n,n_i);
    part2 = repmat(sita,1,3).*cross(k_s_n,cross(k_s_n,cross(n_i,h_i_n)));
    you1 = part1*part2;
    part4_1=sum(r_n(:,1:3).*cross_W_n,2).*exp(-1j*k0*r_c(:,1:3)*W_i).*sinc(k0/2*r_n(:,1:3)*W_i);
    part4_2=sum(r_n(:,4:6).*cross_W_n,2).*exp(-1j*k0*r_c(:,4:6)*W_i).*sinc(k0/2*r_n(:,4:6)*W_i);
    part4_3=sum(r_n(:,7:9).*cross_W_n,2).*exp(-1j*k0*r_c(:,7:9)*W_i).*sinc(k0/2*r_n(:,7:9)*W_i);
    you2 = part4_1+part4_2+part4_3;
    you3 = Area.*exp(-1j*k0*A*W_i);
    T_2 = sum(cross_W_n.^2,2);
    for j=1:TrianglesTotal
        if T_2(j,1)<deta;
            E_n(j,:)=you1(j,:)*you3(j,1);
        else
            E_n(j,:)=you1(j,:)*you2(j,1)*part3/T_2(j,1);
        end
    end
    E(i,:)=sum(E_n);
end
%%
%����ɢ�䳡��ֵ����RCS
rcs_thta = 4*pi*r^2*(abs(sum(E.*e_r_thta_s,2).^2));
rcs_phi = 4*pi*r^2*(abs(sum(E.*e_r_fire_s,2).^2));
RCS_THTA = 10*log10(rcs_thta);
RCS_PHI = 10*log10(rcs_phi);
%%
%��ͼ
figure(1)
plot(thta_s,RCS_THTA)
hold on
figure(2)
plot(thta_s,RCS_PHI)