%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         �����������˫վɢ�䳡                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
%�������ݣ�
load('EH.mat');
load('E_i.mat');
load('MOM.mat');
load('PO.mat');
load('MOMandPO_i.mat');
%��ʼ���ݸ�ֵ
rr = 2e3*lambda;  %Զ������
th = 0:360;
AA = length(th);
E_s = zeros(AA,3);  %����װ������Ƕȵ�ɢ����ճ�
EE =zeros(AA,1);
Etotal=zeros(AA,1);
ths = th'*pi/180;                                     %AA��ɢ����ս�     AA*1
ks = [sin(ths)*cos(phs) sin(ths)*sin(phs) cos(ths)];  %ɢ�䳡��λʸ��     AA*3
RR = rr*ks;                                           %Զ��λ��ʸ��       AA*3
er0 = [cos(ths)*cos(phs) cos(ths)*sin(phs) -sin(ths)];%theta��������
er1 = repmat([-sin(phs) cos(phs) 0],AA,1);            %phi����           AA*3
er =er0;                                              %thta��������
mm_MOM = repmat(I_MOM,1,3).*m_n;           %��Чż����
mm_PO = repmat(I_PO,1,3).*mn_PO;
Constant1 = eta_/(4*pi);
for i=1:AA                  %����ɢ����ս�
    %PO����
    RR_n = repmat(RR(i,:),Edg_PO_Total,1)-dolp_PO_r0;    %��ɢ����ս�ȷ����ÿ��ż���ص�ɢ��Դ�㵽�����ʸ��λ��
    norm_RR_n = sqrt(sum(RR_n.^2,2));                    %����
    CC = 1./norm_RR_n.^2.*(1+1./(1j*k*norm_RR_n));
    MM = repmat(sum(RR_n.*mm_PO,2)./norm_RR_n.^2,1,3).*RR_n;
    E = Constant1*((MM-mm_PO).*repmat(1j*k./norm_RR_n+CC,1,3)+2*MM.*repmat(CC,1,3)).*repmat(exp(-1j*k*norm_RR_n),1,3);
    E_s(i,:) = sum(  );                                    %ͬһɢ����ս��µ�������Ƭ��ɢ�䳡����
    %MOM����
    RR_n = repmat(RR(i,:),Edg_MOM_Total,1)-dolp_MOM_r0;  %��ɢ����ս�ȷ����ÿ��ż���ص�ɢ��Դ�㵽�����ʸ��λ��
    norm_RR_n = sqrt(sum(RR_n.^2,2));                    %����
    CC = 1./norm_RR_n.^2.*(1+1./(1j*k*norm_RR_n));
    MM = repmat(sum(RR_n.*mm_MOM,2)./norm_RR_n.^2,1,3).*RR_n;
    E = Constant1*((MM-mm_MOM).*repmat(1j*k./norm_RR_n+CC,1,3)+2*MM.*repmat(CC,1,3)).*repmat(exp(-1j*k*norm_RR_n),1,3);
    E_s(i,:) = E_s(i,:)+sum(E);                                    %ͬһɢ����ս��µ�������Ƭ��ɢ�䳡����
end
RCS = 4*pi*rr^2*abs(sum(E_s.*er,2).^2);
dB_RCS = 10*log10(RCS);
plot(th,dB_RCS)