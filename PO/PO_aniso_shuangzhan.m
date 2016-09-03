%-----------------PO�������Բ���˫վ����ʵ��-------------------%
%2016-4-18
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
x = AB./repmat(sqrt(sum(AB.^2,2)),1,3);
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
r = 2e3*lambda;       %�ռ䳡����루�������ã���Ҫ�㹻Զ��  
%%
%Ŀ�����������
afa = 0*pi/180;                   %�������Բ����������ƫ��
Zuu = 0;%(0.1-0.01j)*Z0;%(0.1133+0.0166j)*Z0;        %������ֵ����
Zvv = 0;%(0.1-0.01j)*Z0;%(0.1133+0.0166j)*Z0;        %������ֵ����
Zxx = (cos(afa))^2*Zuu+(sin(afa))^2*Zvv;           %�迹��������
Zxy = cos(afa)*sin(afa)*(Zuu-Zvv); 
Zyx = cos(afa)*sin(afa)*(Zuu-Zvv);
Zyy = (cos(afa))^2*Zvv+(sin(afa))^2*Zuu;
%%
%��ӳ�����
thta = 0;
de_thta = thta*pi/180;
phi = 0;
de_phi = phi*pi/180;
thta_s = 0:180;
AA = length(thta_s);
de_thta_s = thta_s'*pi/180;
phi_s = 0;
de_phi_s = phi_s*pi/180;
%���õ�ų��ļ�������Ͳ�������
k_i= -[sin(de_thta)*cos(de_phi) sin(de_thta)*sin(de_phi) cos(de_thta)];          %���䲨����
e_i_theta = [cos(de_phi)*cos(de_thta) cos(de_thta)*sin(de_phi) -sin(de_thta)];  %thta��������
e_i_phi = [-sin(de_phi) cos(de_phi) 0];                             %fire��������
h_i_phi = cross(k_i,e_i_theta);   %����ų��Ĵ�ֱ��������
h_i_theta = cross(k_i,e_i_phi);       %����ų���ˮƽ��������
k_s = [sin(de_thta_s)*cos(de_phi_s) sin(de_thta_s)*sin(de_phi_s) cos(de_thta_s)];%ɢ�䲨����ʸ��
e_r_thta_s = [cos(de_thta_s)*cos(de_phi_s) cos(de_thta_s)*sin(de_phi_s) -sin(de_thta_s)];%thta��������
e_r_fire_s = repmat([-sin(de_phi_s) cos(de_phi_s) 0],AA,1);  %fire��������
%���䳡����
H0 = 1;     %���䳡ѡΪ�ų�������ѡΪ1
E0 = Z0*H0;  %�糡��ֵ����
%%
%�������䳡�����ÿ����Ԫ�ķ���ϵ����������
%���뼫���Ǹ��������Ϊ�糡ʵ�ʼ�������ʸ��������ƽ��ļн�pol_j
pol_j = 0/180*pi;
E_thta = E0*cos(pol_j);   %����λ���޹ص�ˮƽ�����糡��ֵ���
E_phi = E0*sin(pol_j);    %����λ���޹صĴ�ֱ�����糡��ֵ���
H_thta = H0*sin(pol_j);   %����λ���޹ص�ˮƽ�����ų���ֵ���
H_phi = H0*cos(pol_j);    %����λ���޹صĴ�ֱ�����ų���ֵ���  
E_inc = E_thta*e_i_theta+E_thta*e_i_phi; %������ϵ�糡ʸ���������

%����ϵ����������Ǻ���Ƭ��λ���йؼ��ɣ����䷽��ʸ������Ƭ����ʸ��ȷ����
e_ph = repmat(e_i_phi,TrianglesTotal,1);
e_tao = cross(n_i,cross(n_i,e_ph));
cos_i = -n_i*k_i';
sin_i = sqrt(1-cos_i.^2);
cos_X = sum(e_tao.*x,2);
sin_X = sqrt(1-cos_X.^2);
%������ⷴ��ϵ���Ĳ���
Aa = 1/Z0*(Zxx*sin_X.^2+Zyy*cos_X.^2-Zxy*(sin_X.*cos_X)-Zyx*(sin_X.*cos_X));
Bb = 1/Z0*(Zxy*sin_X.^2+Zyx*cos_X.^2+Zxx*(sin_X.*cos_X)-Zyy*(sin_X.*cos_X));
Cc = 1/Z0*(Zxy*sin_X.^2-Zyx*cos_X.^2+Zxx*(sin_X.*cos_X)-Zyy*(sin_X.*cos_X));
Dd = -1/Z0*(Zyy*sin_X.^2+Zxx*cos_X.^2+Zxy*(sin_X.*cos_X)+Zyx*(sin_X.*cos_X));
%����ϵ��
R11 = (Dd.*cos_i.^2-Aa.*Dd.*cos_i+Bb.*Cc.*cos_i-cos_i+Aa)./(Dd.*cos_i.^2+Aa.*Dd.*cos_i-Bb.*Cc.*cos_i-cos_i-Aa);
R12 = (-2*Bb.*cos_i)./(Dd.*cos_i.^2+Aa.*Dd.*cos_i-Bb.*Cc.*cos_i-cos_i-Aa);
R21 = (-2*Cc.*cos_i)./(Dd.*cos_i.^2+Aa.*Dd.*cos_i-Bb.*Cc.*cos_i-cos_i-Aa);
R22 = (Dd.*cos_i.^2+Aa.*Dd.*cos_i-Bb.*Cc.*cos_i+cos_i+Aa)./(Dd.*cos_i.^2+Aa.*Dd.*cos_i-Bb.*Cc.*cos_i-cos_i-Aa);
%%
%����Ԫ�ڱ��жϣ�
%���ڱ��ж�
afa0 = n_i*k_i';              %�������䷽��ʸ������Ԫ��ʸ����(ÿһ�м��Ƕ�Ӧһ���Ƕ���ʱ��������Ƭ���ڱ��жϽ�)
sita = afa0<0;                %afa0<0��������Ԫ����Ϊ1��afa0>=0����Ԫ���������ڱΣ���Ϊ0
%���ڱ��ж�
%�˴�Ԥ���ٴ���
clear afa0
%%
%ɢ��������Ӧ�����͸�Ӧ����
J_part1 = ((1-R11).*E_phi-R21.*E_thta).*cos_i;
J_part2 = (R12.*E_phi+(1+R11).*E_thta);
Js = 1/Z0*(repmat(sita,1,3).*(repmat(J_part1,1,3).*e_ph+repmat(J_part2,1,3).*cross(n_i,e_ph)));
Jm_part1 = ((1-R11).*E_thta-R12.*E_phi).*cos_i;
Jm_part2 = R21.*E_thta+(1+R22).*E_phi;
Jm = repmat(sita,1,3).*(repmat(Jm_part1,1,3).*e_ph-repmat(Jm_part2,1,3).*cross(n_i,e_ph));
%%
%��������Զ���ռ䴦��ɢ�䳡
%����׼��
part1 = 1j*k0*Z0*exp(-1j*k0*r)/(4*pi*r);
part3 = -1j/k0;
W = repmat(k_i,AA,1)-k_s;
E_n=zeros(TrianglesTotal,3);
E = zeros(AA,3);
deta = lambda*1e-5;
for i=1:AA
    k_s_n = repmat(k_s(i,:),TrianglesTotal,1);
    W_n = repmat(W(i,:),TrianglesTotal,1);
    W_i = W(i,:)';
    cross_W_n=cross(W_n,n_i);
    part2_1 = cross(k_s_n,cross(k_s_n,Js));
    part2_2 = 1/Z0*cross(k_s_n,Jm);
    you1 = part1*(part2_1+part2_2);
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
rcs_TH = 4*pi*r^2*(abs(sum(E.*e_r_thta_s,2).^2))/Z0^2;  %36*pi*
rcs_PH = 4*pi*r^2*(abs(sum(E.*e_r_fire_s,2).^2))/Z0^2;
RCS_TH = 10*log10(rcs_TH);
RCS_PH = 10*log10(rcs_PH);
%%
%��ͼ
figure(1)
plot(thta_s,RCS_TH)
hold on
figure(2)
plot(thta_s,RCS_PH)


