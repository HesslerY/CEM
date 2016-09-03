%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            �������ӻ�����                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�˳�����������֪MOM���������֪������½��е������ӻ�
%
clear;
clc;
%��������
load('MOM.mat');
load('V0_I0.mat');
%���ÿ��������Ԫ�ĵ����ܶ�
M =I0.*Ed_MOM_Length;     %�����˹�����  Edg_MOM_Total*1
rho_A_P = RHO_MOM_Plus./repmat(2*Area_MOM(Tri_MOM_Plus,1),1,3);  %rho+/2A+  Edg_MOM_Total*3
rho_A_M = RHO_MOM_Minus./repmat(2*Area_MOM(Tri_MOM_Minus,1),1,3);%rho-/2A-
for n=1:T_NUM_MOM              %��������Ƭ���б���
    i=[0 0 0];          
    for m=1:Edg_MOM_Total      
        IE=M(m,1);         
        if(Tri_MOM_Plus(m)==n)   %�ҵ���n����Ƭ����������Ƭ��Ӧ��λ��
            i=i+IE*rho_A_P(m,:); %��Ƭn���򱻵�������Ƭ���µĵ�������
        end
        if(Tri_MOM_Minus(m)==n)  %��Ƭn���򱻵�������Ƭ���µĵ�������
            i=i+IE*rho_A_M(m,:);
        end
    end
    CurrentNorm(n,1)=abs(norm(i)); %��Ƭn���۵ĵ����ۻ�����ģ
end
toll_J = sum(CurrentNorm);%������Ƭ�ĵ����ۻ�
average_J = toll_J/T_NUM_MOM;   %��������Ƭ�ĵ���ƽ��
Jmax=max(CurrentNorm);          %�ҵ�������Ƭ��ģֵ���ĵ�����ֵ
MaxCurrent=strcat(num2str(Jmax),'[A/m]');%ƴ���ַ���������ʾ��������ֵ
CurrentNorm1=CurrentNorm/max(CurrentNorm);%��һ��
for m=1:T_NUM_MOM               %��ͼ
    N = t_MOM(m,:)';            %ȡ����m��������Ƭ��Ӧ�������ڵ���
    X(1:3,m)=[p_MOM(N,1)];      %�����ڵ��x����
    Y(1:3,m)=[p_MOM(N,2)];      %y
    Q(1:3,m)=[p_MOM(N,3)];      %z
end
C=repmat(CurrentNorm1,1,3)';
h=fill3(X, Y, Q, C); %��ͼ
colormap gray;
axis('equal');
rotate3d
FileName='current_i.mat';
save(FileName, 'CurrentNorm')