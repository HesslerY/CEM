%%   ****  ����Ƶ�����޲�ַ��ԶԳƴ�״�߼��ؾ��β���TMģ�о�   ****  %%
%%   ***************** ������Ф�� ******************       %%
%%   *************  ѧ�ţ�201421040239  *************     %%
%%ģ��ʾ��ͼ����
%         *****************************       ����
%         *                           *
%         *                           *        ��
%         *     |    ������w   |      *        by
%         *     ************** |���a|*  ����  
%         *                           *   ��     
%         *                           *   h
%         *****************************  ����  ����                      
%         |          ������bx          |
%% �������ݴ���
clc;clear;close all;
b=input('�����벨�����һ��b��ֵ(��λ��mm)��'); 
b=b*1e-3; % b=5mm  ���һ��
by=2*b;  %%�����Ŀ� 
bx=by;  %%�����ĳ�,����1�����
rou=input('������a/b��ֵ(0.3��0.7֮��)��'); 
a=b*rou;%��rou=a/b,����aֵ
w=bx-2*a;%��״�ߵĸ߶ȼ����
h=1/2*by;    %������          
epsilon = 8.85e-12; %����еĽ�糣��
mu=4*pi*(1e-7); %����еĴŵ���
epsilonxyz=1;%��Խ�糣������
c=3e8;%����й���
jim=sqrt(-1);%����i��jim��j-image)��ʾ
%% ��������x����nx����y����ny��
nx=input('������x���򻮷ֵ���������');nx=ceil(nx);
ny=input('������y���򻮷ֵ���������');ny=ceil(ny);disp(sprintf('������������x���� %g ����y���� %g ��',nx,ny))
tic;  %%��ʼ��ʱ
ni=nx+1;nj=ny+1;%x��y��������Ŀ
dx=bx/nx;dy=by/ny;%x������y�������񲽳�
s1=ceil(a/dx)+1;
s2=floor((a+w)/dx)+1;
sy=round(h/dy)+1;   %���㵼��λ�ýڵ���
%% ��ȡϵ������
%%�ĸ�ϵ�����Ϊ toeplitz ����
B1(ni*ny,ni*nj)=0;%%EZ ����HX����HX,EZ�������д�С
B2(nx*nj,ni*nj)=0;%%EZ ����Hy����HY,EZ�������д�С
B3(ni*nj,ni*ny)=0;%%HX ��������EZ����EZ,HX�������д�С
B4(ni*nj,nx*nj)=0;%%HY ��������EZ����EZ,HY�������д�С
B(ni*ny+nx*nj+ni*nj,ni*ny+nx*nj+ni*nj)=0;%%B1+B2+B3�кͣ�B3+B4+B1�к�
%% hx ni*ny�� hy nx*nj �� EZ ni*nj��
c1(ny)=0;c1(1)=-1;        %����TOEPLITZ����B1_sub������
r1(nj)=0;r1(1)=-1;r1(2)=1; %����TOEPLITZ����B1_sub������
B1_sub=toeplitz(c1,r1);   %B1
for i=1:ni
    B1((i-1)*ny+(1:ny),(i-1)*nj+(1:nj))=B1_sub(1:ny,1:nj);
end
B1=jim/dy*B1;
c2(nx*nj)=0;c2(1)=-1;        %����TOEPLITZ����B2������
r2(ni*nj)=0;r2(1)=-1;r2(1+nj)=1; %����TOEPLITZ����B2������
B2=-jim/dx*toeplitz(c2,r2);   %B2
c3(nj)=0;c3(1)=1;c3(2)=-1;        %����TOEPLITZ����B3_sub������
r3(ny)=0;r3(1)=1; %����TOEPLITZ����B3_sub������
B3_sub=toeplitz(c3,r3); 
for i=1:ni
    B3((i-1)*nj+(1:nj),(i-1)*ny+(1:ny))=B3_sub(1:nj,1:ny);
end
B3=jim/dy/epsilonxyz*B3;          %B3
c4(ni*nj)=0; c4(1)=1; c4(1+nj)=-1 ;     %����TOEPLITZ����B4������
r4(nx*nj)=0;r4(1)=1;  %����TOEPLITZ����B4������
B4=-jim/dx/epsilonxyz*toeplitz(c4,r4);   %B4
B(1:ni*ny,ni*ny+nx*nj+(1:ni*nj))=B1(1:ni*ny,1:ni*nj);
B(ni*ny+(1:nx*nj),ni*ny+nx*nj+(1:ni*nj))=B2(1:nx*nj,1:ni*nj);
B(ni*ny+nx*nj+(1:ni*nj),1:ni*ny)=B3(1:ni*nj,1:ni*ny);
B(ni*ny+nx*nj+(1:ni*nj),ni*ny+(1:nx*nj))=B4(1:ni*nj,1:nx*nj);
%�߽紦�� Ez=0
B(ni*ny+nx*nj+(1:nj),:)=0; %%��߽�
B(ni*ny+nx*nj+ni*nj-nj+(1:nj),:)=0; %%�ұ߽�
for i=1:ni
B(ni*ny+nx*nj+1+nj*(i-1),:)=0 ;  %%�±߽�
B(ni*ny+nx*nj+i*nj,:)=0 ;   %%�ϱ߽�
end
%%�����������
for i=s1:s2
    B(ni*ny+nx*nj+sy+nj*(s1-1:s2-1),:)=0;
end

%% ����ϵ����������ֵ����������
%mode=input('����Ҫ�õ���TMģʽ��ֹƵ������');
mode=5;
[EH, k0]=eig(B);
%% һ�������ֹƵ��
k0=real(k0);
f=k0*c/(2*pi);
f_sort=sort(f(:));
fc(1,1:mode)=0;
ii = 0;
%ɾ��α��
for i = 1:length(f_sort)
if f_sort(i) > 1e9
ii = ii+1;
fc(ii) = f_sort(i);
if mode== ii
break;
end
end
end
disp(['����ʱ�䣺',num2str(toc)]);
%�����ֹƵ��
disp('***********************************************');
disp('FDFD��������');
for i=1:mode
disp(sprintf('TM���� %g ��ģ��ֹƵ�ʣ�fc= %gGHz��',i,fc(i)/(1e9)));
end
%% �������㳡����
[x1, y1] = find(f == fc(1));%�õ���һ����ֹƵ������Ӧ�ĳ����� f�Ǿ���X1,Y1��FC(1)�����У��С�
[x2, y2] = find(f == fc(2));%�õ��ڶ�����ֹƵ������Ӧ�ĳ�����
% ��һ��ģʽ�ĳ�����
HX1=EH(1:ni*ny, y1);%��ȡHx����
HX1=reshape(HX1, ny, ni);%ת��Ϊ������ʽ
if  sum(sum(abs(real(HX1)))) > sum(sum(abs(imag(HX1))))  
    HX1 = real(HX1);
else
    HX1 = imag(HX1);
end
HY1 = EH(ni*ny+(1:nx*nj), y1);%��ȡHy����
HY1 = reshape(HY1,nj, nx);%ת��Ϊ������ʽ
if  sum(sum(abs(real(HY1)))) > sum(sum(abs(imag(HY1))))  
    HY1 = real(HY1);
else
    HY1 = imag(HY1);
end
EZ1 = EH(ni*ny+nx*nj+(1:ni*nj), y1);%��ȡEz����
EZ1 = reshape(EZ1,nj, ni);%ת��Ϊ������ʽ
if  sum(sum(abs(real(EZ1)))) > sum(sum(abs(imag(EZ1))))  
    EZ1 = real(EZ1);
else
    EZ1 = imag(EZ1);
end
% �ڶ���ģʽ�ĳ�����
HX2=EH(1:ni*ny, y2);%��ȡHx����
HX2=reshape(HX2, ny, ni);%ת��Ϊ������ʽ
if  sum(sum(abs(real(HX2)))) > sum(sum(abs(imag(HX2))))  
    HX2 = real(HX2);
else
    HX2 = imag(HX2);
end
HY2 = EH(ni*ny+(1:nx*nj), y2);%��ȡHy����
HY2 = reshape(HY2,nj, nx);%ת��Ϊ������ʽ
if  sum(sum(abs(real(HY2)))) > sum(sum(abs(imag(HY2))))  
    HY2 = real(HY2);
else
    HY2 = imag(HY2);
end
EZ2 = EH(ni*ny+nx*nj+(1:ni*nj), y2);%��ȡEz����
EZ2 = reshape(EZ2,nj, ni);%ת��Ϊ������ʽ
if  sum(sum(abs(real(EZ2)))) > sum(sum(abs(imag(EZ2))))  
    EZ2 = real(EZ2);
else
    EZ2 = imag(EZ2);
end
%% ����������άͼ
figure
subplot(1,3,1)
surf(HX1);
title('TMģ1 Hx����X-Yƽ����ͼ')
%figure
subplot(1,3,2)
surf(HY1);
title('TMģ1 Hy����X-Yƽ����ͼ')
subplot(1,3,3)
%figure
surf(EZ1);
title('TMģ1 Ez����X-Yƽ����ͼ')
figure
subplot(1,3,1)
surf(HX2);
title('TMģ2 Hx����X-Yƽ����ͼ')
%figure
subplot(1,3,2)
surf(HY2);
title('TMģ2 Hy����X-Yƽ����ͼ')
%figure
subplot(1,3,3)
surf(EZ2);
title('TMģ2 Ez����X-Yƽ����ͼ')
%% ����ɫɢ��������
f1=fc(1):0.5e9:50e9;
f2=fc(2):0.5e9:50e9;
beta1 = 2*pi*sqrt(epsilon*mu)*sqrt(f1.^2 -(fc(1))^2);
beta2 = 2*pi*sqrt(epsilon*mu)*sqrt(f2.^2 -(fc(2))^2);
beta1=abs(beta1);beta2=abs(beta2);
f1=f1/(1e9);  %��λΪGHz
f2=f2/(1e9);  %��λΪGHz
figure
plot(f1,beta1,'-*r');  %��һ�ߴ�ģ
hold on;
plot(f2,beta2,'-pb');  %�ڶ��ߴ�ģ
hold off;
ylabel('rad/m');
xlabel('Ƶ��(GHz)');
ylabel('��λ������rad/m��')
title('�ǶԳ����δ�״�߾��β���TMģ��ɫɢ����')
legend('TM��һ�ߴ�ģ','TM�ڶ��ߴ�ģ','Location','NorthWest')
%% ������泡������ά�ֲ�ͼ
%%���ݺ��ݹ�ϵ����糡�������
f1_g =30e9;  %%����ģʽ1��һ������Ƶ��30GHZ
beta1_g=2*pi*sqrt(epsilon*mu)*sqrt(f1_g^2 -(fc(1))^2);
omiga1=2*pi*f1_g;
k1=2*pi*f1_g/c;
ZTM1=omiga1*mu*k1/beta1_g^2;
HX_1(1:ny, 1:nx) = (HX1(1:ny, 1:nx) + HX1(1:ny, 2:ni))/2;
HY_1(1:ny, 1:nx) = (HY1(1:ny, 1:nx) + HY1(2:nj, 1:nx))/2;
EX_1= ZTM1*HY_1;
EY_1= -ZTM1*HX_1;
%figure
subplot(2,2,1)
quiver(EX_1, EY_1);
title('TM��1ģʽ �����糡������άͼ')
subplot(2,2,2)
quiver(HX_1, HY_1,'r');
title('TM��1ģʽ �����ų�������άͼ')
f2_g = 40e9;  %%����ģʽ2��һ������Ƶ��40GHZ
beta2_g=2*pi*sqrt(epsilon*mu)*sqrt(f2_g^2 -(fc(2))^2);
omiga2=2*pi*f2_g;
k2=2*pi*f2_g/c;
ZTM2=omiga2*mu*k2/beta2_g^2;
HX_2(1:ny, 1:nx) = (HX2(1:ny, 1:nx) + HX2(1:ny, 2:ni))/2;
HY_2(1:ny, 1:nx) = (HY2(1:ny, 1:nx) + HY2(2:nj, 1:nx))/2;
EX_2= ZTM2*HY_2;
EY_2= -ZTM2*HX_2;
%Figure 
subplot(2,2,3)
quiver(EX_2, EY_2);
title('TM��2ģʽ �����糡������άͼ')
subplot(2,2,4)
quiver(HX_2, HY_2,'r');
title('TM��2ģʽ �����ų�������άͼ')

