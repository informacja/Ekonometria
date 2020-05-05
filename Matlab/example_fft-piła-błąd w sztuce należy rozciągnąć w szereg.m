
%filtacja cyfrowa szum cyfrowy
% dt=1.e-3; N=10006; t=[1:N]*dt; 
% T=N/5*dt; 
% Y=5*sin(2*pi*t/T)+3*sin(2*pi*t*10/T); 
% A=fft(Y); 
% Am=abs(A); 
% M=round(N/2); 
% Amp=sqrt(Am(M:end)*dt); 
% subplot(1,2,1); plot(t,Y); subplot(1,2,2); plot([M:N],Amp)

 % dt=1.e-3; N=1006; t=[1:N]*dt; T=N*dt; 
 % Y=5*sin(2*pi*t/T)+3*sin(2*pi*t*100/T); A=fft(Y); Am=abs(A); 
 % M=round(N/2); Amp=sqrt(Am(1:M)*dt); 
 % subplot(1,2,1); plot(t,Y); axis('tight'); 
 % subplot(1,2,2); plot([1:M],Amp,'k',-20,0,'w'); axis('tight')
 
%  dt=1.e-3; N=1006; t=[1:N]*dt; T=N*dt; 
% Y1=5*sin(2*pi*t/T); 
% Y2=3*sin(2*pi*t*5/T); 
% Y3=5*sin(2*pi*t*3/T); 
% Y4=3*sin(2*pi*t*2/T); 
% Y0=10/(N*dt)*t;
% Y=Y0+Y1+Y2+Y3+Y4;
% A=fft(Y); 
% Am=abs(A); M=round(N/2); Amp=sqrt(Am(1:M)*dt); 
% subplot(1,2,1); plot(t,Y,'k',t,Y1,'b',t,Y2,'r',t,Y3,'m',t,Y4,'g',t,Y0,'k--'); 
% axis('tight'); subplot(1,2,2); plot([1:50],Amp(1:50),'k',-0.20,0,'w'); axis('tight')
clear
% close
dt=1.e-3; 
N=1006; 
t=[1:N]*dt;
T=N*dt;
Y1=5*sin(2*pi*t/T);
Y2=3*sin(2*pi*t*5/T); 
Y3=5*sin(2*pi*t*3/T); 
Y4=3*sin(2*pi*t*2/T); 
Y0=10/(N*dt)*t;

Y=Y0+Y1+Y2+Y3+Y4;

A=fft(Y); 
Am=abs(A);
M=round(N/2);
Amp=sqrt(Am(1:M)*dt); 
subplot(1,2,1);
plot(t,Y,'k',t,Y1,'b',t,Y2,'r',t,Y3,'m',t,Y4,'g',t,Y0,'k--'); 
axis('tight'); subplot(1,2,2); 
plot([1:500],Amp(1:500),'k',-0.20,0,'w');
 axis('tight')

