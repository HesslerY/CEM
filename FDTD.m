%%   ****  ����ʱ�����޲�ַ��ԶԳƴ�״�߼��ؾ��β���TMģ�о�   ****  %%
%%   ***************** ������Ф�� ******************       %%
%%
%����FDTD���ԶԳ����δ�״��TMģ�ļ������
clear all
clc

global N rho mue epsilon c b a h M
%NΪ������������rhoΪa/b��ֵ,mueΪ����еĴŵ��ʣ�epsiloonΪ����еĽ�糣����
%cΪ���٣�bΪ�߳���һ�룬aΪ΢�����ȵ�һ�룬hΪ������΢���ĺ�Ȳ���,MΪ΢����
%�߻���������
time = cputime;         %cpu����ʱ������
N = 30;%input('����������(��Ϊż�����Ҳ�С��4)=');
c = 3e8;
mue = pi*4e-7;
epsilon = 1/(pi*36e9);
b = 5e-3;
h = 2*b/N;
rho = 0.7;%input('����a/b��ֵ(0.3-0.7֮��)=');
a = rho*b;
M = round((b-a)/h);
%%
%....................................................................................
%�������
%����I����
I = eye(N-1);
%�����΢������A��i,j����Ӧ��ϵ������D,��Ҫ�������ԽǾ����
D(1:N-1,1:N-1) = 0;
for i = 1:N-2;
    D(i,i+1) = 1;
    D(i+1,i) = 1;
end
for i = 1:N-1
    D(i,i) = -4;
end

%����΢������stripline����Ϊ΢���Ĺ���
for i = 1:N-1
    stripline(i,i) = -4;
end
for i = 2:N-2
    stripline(i,i-1) = 1;
    stripline(i,i+1) = 1;
end
i = N/2-M-1;
stripline(i,i-1) = 1;
stripline(i,i+1) = 0;
i = N/2+M+1;
stripline(i,i-1) = 0;
stripline(i,i+1) = 1;
for i = (N/2-M):(N/2+M)
    stripline(i,i-1) = 0;
    stripline(i,i+1) = 0;
end
stripline(1,2) = 1;
stripline(N-1,N-2) = 1;
%����΢������������߽�������ϵ������up_down,��A(i,j+1),A(i,j-1)������ϵ��
for i = 1:N-1
    if i>=(N/2-M) && i<=(N/2+M)
        up_down(i,i) = 0;
    else
        up_down(i,i) = 1;
    end
end
%����K����
K(1:(N-1)*(N-1),1:(N-1)*(N-1)) = 0;
for i = 2:N-2
    if i == N/2-1
        K(((i-1)*(N-1)+1):(i*(N-1)),((i-2)*(N-1)+1):((i-1)*(N-1))) = I;
        K(((i-1)*(N-1)+1):(i*(N-1)),((i-1)*(N-1)+1):(i*(N-1))) = D;
        K(((i-1)*(N-1)+1):(i*(N-1)),(i*(N-1)+1):((i+1)*(N-1))) = up_down;
    elseif i == N/2;
             K(((i-1)*(N-1)+1):(i*(N-1)),((i-2)*(N-1)+1):((i-1)*(N-1))) = up_down;
             K(((i-1)*(N-1)+1):(i*(N-1)),((i-1)*(N-1)+1):(i*(N-1))) = stripline;
             K(((i-1)*(N-1)+1):(i*(N-1)),(i*(N-1)+1):((i+1)*(N-1))) = up_down;
    elseif i == N/2+1
                K(((i-1)*(N-1)+1):(i*(N-1)),((i-2)*(N-1)+1):((i-1)*(N-1))) = up_down;
                K(((i-1)*(N-1)+1):(i*(N-1)),((i-1)*(N-1)+1):(i*(N-1))) = D;
                K(((i-1)*(N-1)+1):(i*(N-1)),(i*(N-1)+1):((i+1)*(N-1))) = I;
    else
             K(((i-1)*(N-1)+1):(i*(N-1)),((i-2)*(N-1)+1):((i-1)*(N-1))) = I;
             K(((i-1)*(N-1)+1):(i*(N-1)),((i-1)*(N-1)+1):(i*(N-1))) = D;
             K(((i-1)*(N-1)+1):(i*(N-1)),(i*(N-1)+1):((i+1)*(N-1))) = I;  
    end
end
K(1:N-1,1:N-1) = D;
K(1:N-1,N:2*(N-1)) = I;
K((N-2)*(N-1) + 1:(N-1)^2,(N-3)*(N-1) + 1:(N-2)*(N-1)) = I;
K((N-2)*(N-1) + 1:(N-1)^2,(N-2)*(N-1) + 1:(N-1)^2) = D;
%%
%.........................................................................................
%���ֵ����
[phi,value] = eig(K);%�������ֵ��������phi������ֵeigv
eig_freq = c*sqrt(-value)/(2*pi*h);%��������ֵ�������Ƶ��
fc = eig_freq;
fc(fc == 0) = inf;
fc_min1 = min(min(fc));
[x1,y1] = find(fc==min(min(fc)));
fc(:,y1) = inf;
fc_min2 = min(min(fc));
[x2,y2] = find(fc==min(min(fc)));
phi1 = phi(:,y1);
phi2 = phi(:,y2);
%.........................................................................................
%��ͼ
f = 30e9:0.25e9:40e9;
beta1 = real(2*pi*sqrt(mue*epsilon*(f.^2-fc_min1.^2)));
beta2 =real(2*pi*sqrt(mue*epsilon*(f.^2-fc_min2.^2)));
f = f/1e9;
plot(f,beta1,'rd--',f,beta2,'kp-')
axis normal
title('�Գ����δ�״�ߵ���λ����(a/b=0.5,N=30)');
xlabel('Ƶ�ʣ�Hz��');ylabel('��λ������rad/m��');
legend('���TMģ','�ε�TMģ');
%..........................................................................................
 %%   
%���ֲ�
kc1 = 2*pi*fc_min1/c;
kc2 = 2*pi*fc_min2/c;
w1 = 2*pi*fc_min1;
w2 = 2*pi*fc_min2;
Z0 = sqrt(mue/epsilon);
Ez1(1:N-1,1:N-1) = 0;
Ez2(1:N-1,1:N-1) = 0;
for n = 1:N-1
    Ez1(n,1:N-1) = phi1((n-1)*(N-1)+1:n*(N-1));
    Ez2(n,1:N-1) = phi2((n-1)*(N-1)+1:n*(N-1));
end
j = j;
for k = 1:N-1
    for i = 2:N-2
        Hy1(i,k) = (-j*w1*epsilon/(2*h*kc1^2))*(Ez1(i+1,k)-Ez1(i-1,k));
        Hy2(i,k) = (-j*w2*epsilon/(2*h*kc2^2))*(Ez2(i+1,k)-Ez2(i-1,k));
    end
    Hy1(1,k) = (-j*w1*epsilon/(2*h*kc1^2))*(Ez1(2,k));
    Hy2(1,k) = (-j*w2*epsilon/(2*h*kc2^2))*(Ez2(2,k));
    Hy1(N-1,k) = (j*w1*epsilon/(2*h*kc1^2))*(Ez1(N-2,k));
    Hy2(N-1,k) = (j*w2*epsilon/(2*h*kc2^2))*(Ez2(N-2,k));
end
for i = 1:N-1
    for k = 2:N-2
        Hx1(i,k) = (j*w1*epsilon/(2*h*kc1^2))*(Ez1(i,k+1)-Ez1(i,k-1));
        Hx2(i,k) = (j*w2*epsilon/(2*h*kc2^2))*(Ez2(i,k+1)-Ez2(i,k-1));
    end
    Hx1(i,1) = (j*w1*epsilon/(2*h*kc1^2))*(Ez1(i,2));
    Hx2(i,1) = (j*w2*epsilon/(2*h*kc2^2))*(Ez2(i,2));
    Hx1(i,N-1) = -(j*w1*epsilon/(2*h*kc1^2))*(Ez1(i,N-2));
    Hx2(i,N-1) = -(j*w2*epsilon/(2*h*kc2^2))*(Ez2(i,N-2));
end
Ex1 = Z0 * Hy1;
Ex2 = Z0 * Hy2;
Ey1 = -Z0 * Hx1;
Ey2 =  -Z0 * Hx2;
axis([0 40 0 40])
subplot(2,2,1);
Efield1 = quiver(imag(Ey1),imag(Ex1));%��һ��TMģ�ĺ����糡�ֲ�ͼ
title('��һ��TMģ�ĺ����糡�ֲ�ͼ')
subplot(2,2,2);
Hfield1 = quiver(imag(Hy1),imag(Hx1),'r');%��һ��TMģ�ĺ����ų��ֲ�ͼ
title('��һ��TMģ�ĺ����ų��ֲ�ͼ')
subplot(2,2,3);
Efield2 = quiver(imag(Ey2),imag(Ex2));%�ڶ���TMģ�ĺ����糡�ֲ�ͼ
axis([0 30 0 30])
title('�ڶ���TMģ�ĺ����糡�ֲ�ͼ')
subplot(2,2,4);
Hfield2 = quiver(imag(Hy2),imag(Hx2),'r');%�ڶ���TMģ�ĺ����ų��ֲ�ͼ
title('�ڶ���TMģ�ĺ����ų��ֲ�ͼ') 

