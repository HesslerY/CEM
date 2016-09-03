%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          �������ݴ���                                   %                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
p0 = load('NODE.txt');
t0 = load('FACE.txt');
p0(:,1)=[];   %ɾ����һ��
t0(:,1)=[];   %ɾ����һ��
t = t0;
p = p0;
TrianglesTotal=length(t);  %�ܵ���������Ԫ����
clear p0 t0
t_MOM = t; %MOM������Ԫ���
p_MOM = p; %MOM����ڵ���
P_NUM_MOM = length(p_MOM(:,1));  %MOM����ڵ���
T_NUM_MOM = length(t_MOM(:,1));  %MOM������Ԫ��
%%
tic;
%MOM����ÿ����Ԫ�������ͼ�ġ��ⷨʸ
A_MOM = p_MOM(t_MOM(:,1),:);                   %ÿ��������Ԫ�Ľڵ�����
B_MOM = p_MOM(t_MOM(:,2),:);
C_MOM = p_MOM(t_MOM(:,3),:);
AB_MOM= B_MOM-A_MOM;                           %������Ԫ��ʸ
BC_MOM = C_MOM-B_MOM;
CA_MOM = A_MOM-C_MOM;
ABxBC = cross(AB_MOM,BC_MOM);
Area_MOM = 0.5*sqrt(sum(ABxBC.^2,2));          %ÿ����Ԫ�����
Center_MOM = 1/3*(A_MOM+B_MOM+C_MOM);                         %��m��������Ԫ�ļ�����������(ͼ��)
n_i_MOM = ABxBC./repmat(sqrt(sum(ABxBC.^2,2)),1,3);           %��Ԫ��ʸ
ToT_S_s_MOM = sum(Area_MOM);                                  %����������Ԫ���
clear ABxBC;
%%
%�ҵ�MOM���еĹ�����Ԫ������������Ԫ��
n=0;
Edge_MOM = [];
for m=1:T_NUM_MOM                                 %��������������Ԫ
   N=t_MOM(m,:)';
   for k=m+1:T_NUM_MOM 
       M=t_MOM(k,:)';
       a=1-all([N-M(1) N-M(2) N-M(3)]);
       if(sum(a)==2)
           n=n+1;
           Edge_MOM=[Edge_MOM M(find(a))];
           Tri_MOM_Plus(n,1)=m;
           Tri_MOM_Minus(n,1)=k;
       end
           
   end
end
Edg_MOM_Total = length(Edge_MOM);                  %��ù�����Ԫ��Ŀ
Edge_MOM= Edge_MOM';
%MOM���򹫹��߶�Ӧ���ɽڵ�Ͷ�Ӧ����Ԫ
A0 = t_MOM(Tri_MOM_Plus,:);
A1 = (A0 - repmat(Edge_MOM(:,1),1,3)==0);
A2 = (A0 - repmat(Edge_MOM(:,2),1,3)==0);
A3 = (A1+A2==0);
A4 = (A0.*A3)';
A4(A4==0)=[];
fr_N_MOM_Plus = A4';
A0 = t_MOM(Tri_MOM_Minus,:);
A1 = (A0 - repmat(Edge_MOM(:,1),1,3)==0);
A2 = (A0 - repmat(Edge_MOM(:,2),1,3)==0);
A3 = (A1+A2==0);
A4 = (A0.*A3)';
A4(A4==0)=[];
fr_N_MOM_Minus= A4';
%MOM���򹫹��߳���������Ƭ��ͼ��
RHO_MOM_Plus = Center_MOM(Tri_MOM_Plus,:)-p_MOM(fr_N_MOM_Plus,:);
RHO_MOM_Minus = -Center_MOM(Tri_MOM_Minus,:)+p_MOM(fr_N_MOM_Minus,:);
PO_Ln = p_MOM(Edge_MOM(:,1),:)-p_MOM(Edge_MOM(:,2),:);   %MOM���򹫹��ߵ������ڵ�����
dolp_MOM_r0 = (Center_MOM(Tri_MOM_Plus,:)+Center_MOM(Tri_MOM_Minus,:))/2;  %��Чż�������ĵ�λ��
Ed_MOM_Length = sqrt(sum(PO_Ln.^2,2));                       %�����߳���
m_n = repmat(Ed_MOM_Length/2,1,3).*(RHO_MOM_Plus+RHO_MOM_Minus);         %MOM�������е�ż����
Center_MOM_Plus = Center_MOM(Tri_MOM_Plus,:);            %����Ƭͼ��λ��
Center_MOM_Minus = Center_MOM(Tri_MOM_Minus,:);          %����Ƭͼ��λ��
%%
%���þŵ㷨
%�ҵ��Ÿ�С�����ε�ͼ�ģ�
C1=A_MOM+(1/3)*AB_MOM;      %��m��������Ԫ��9���������ε�λ��ʸ��
C2=A_MOM+(2/3)*AB_MOM;
C3=B_MOM+(1/3)*BC_MOM;
C4=B_MOM+(2/3)*BC_MOM;
C5=A_MOM-(1/3)*CA_MOM;
C6=A_MOM-(2/3)*CA_MOM;
a1=1/3*(C1+C5+A_MOM);
a2=1/3*(C1+C2+Center_MOM);
a3=1/3*(C2+C3+B_MOM);
a4=1/3*(C2+C3+Center_MOM);
a5=1/3*(C3+C4+Center_MOM);
a6=1/3*(C1+C5+Center_MOM);
a7=1/3*(C5+C6+Center_MOM);
a8=1/3*(C4+C6+Center_MOM);
a9=1/3*(C4+C6+C_MOM);
Center_=[a1 a2 a3 a4 a5 a6 a7 a8 a9];   %T_NUM_MOM*27
Center__Plus_n = Center_(Tri_MOM_Plus,:);      %��������Ƭ�ľŸ�ͼ��
Center__Minus_n = Center_(Tri_MOM_Minus,:);    %���и���Ƭ�ľŸ�ͼ��
RHO_MOM__Plus_n= Center__Plus_n-repmat(p_MOM(fr_N_MOM_Plus,:),1,9);       %��������Ƭ�ϾŸ�rho+
RHO_MOM__Minus_n=-Center__Minus_n+repmat(p_MOM(fr_N_MOM_Minus,:),1,9);    %���и���Ƭ�ϾŸ�rho-
disp(['MOM�����������ݴ���ʱ�䣺',num2str(toc),'s']);
%%
%MOM���������ܽ᣺
FileName1 = 'MOM.mat';
save(FileName1,'t_MOM','p_MOM','A_MOM','B_MOM','C_MOM','AB_MOM','BC_MOM','CA_MOM',...
     'Area_MOM','Center_MOM','n_i_MOM','ToT_S_s_MOM','Tri_MOM_Plus','Tri_MOM_Minus',...
     'Edg_MOM_Total','Edge_MOM','fr_N_MOM_Plus','fr_N_MOM_Minus','dolp_MOM_r0',...
     'Ed_MOM_Length','RHO_MOM_Plus','RHO_MOM_Minus','Center_MOM_Plus','Center__Plus_n',...
     'Center_MOM_Minus','Center_','RHO_MOM__Plus_n','RHO_MOM__Minus_n','Center__Minus_n',...
     'T_NUM_MOM','P_NUM_MOM','m_n');