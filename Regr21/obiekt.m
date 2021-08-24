function [Yemp,x,Ld,xmin,xmax,Lx,Yteor,wspZ,Af,F]=obiekt(x,wspZ)
% Af=[99,-0.8 0 1.2 0.3 0 0 0 0 0 0 0]; kf=length(Af); 
% ld=length(x); Yteor=zeros(ld,1);
% for k=1:kf-2
%    Yteor=Yteor+Af(k)*x.^(k-1); 
% end
% Yteor=Yteor+Af(kf-1)*sqrt
if(nargin==0 || isempty(x))
    Ld=30;
    xmin=0.62; xmax=4.1; dx=(xmax-xmin)/(Ld-1);
    x=[xmin:dx:xmax]';
    if(Lx==2)
        wx2=dx/3;
        x=[x x+wx2*(rand(Ld,1)-0.5)]; % drugie wejœcie jest zradomizowane wzgl. 1szego
    end
else xmin=min(x(:,1)'); xmax=max(x(:,1)');
end
Ld=length(x(:,1)); Lx=length(x(1,:)); 
xmin=min(x(:,1)'); xmax=max(x(:,1)'); 
if(Lx==1)
    m=0;
    k=0; m=m+1;  F(:,m)=ones(Ld,1); Af(m,1)=99; %Tx(m).nf=''; % wej. sta³ej (obowi¹zkowe)
    
    k=1; m=m+1;  F(:,m)=x.^k;  Af(m,1)=96.8; %-0.8;  %Tx(m).nf=sprintf('x_1');
    k=2; m=m+1;  F(:,m)=x.^k;  Af(m,1)=0.;    %Tx(m).nf=sprintf('x_1^%d',k);
    k=3; m=m+1;  F(:,m)=x.^k;  Af(m,1)=-85; %-100.;  %-90.;  %-70.;  %-11.2;  %Tx(m).nf=sprintf('x_1^%d',k);
    k=4; m=m+1;  F(:,m)=x.^k;  Af(m,1)=16.03; %6.03; %0.3;   %Tx(m).nf=sprintf('x_2^%d',k);
    k=5; m=m+1;  F(:,m)=x.^k;  Af(m,1)=  0;  %-2.3;  %Tx(m).nf=sprintf('x_2^%d',k);
    k=6; m=m+1;  F(:,m)=x.^k;  Af(m,1)=  0;  %-0.3;  % 0;   %Tx(m).nf=sprintf('x_2^%d',k);
    k=7; m=m+1;  F(:,m)=x.^k;  Af(m,1)=  0;   %Tx(m).nf=sprintf('x^%d',k);
    k=8; m=m+1;  F(:,m)=x.^k;  Af(m,1)=  0;   %Tx(m).nf=sprintf('x^%d',k);
    k=9; m=m+1;  F(:,m)=x.^k;  Af(m,1)=  0;   %Tx(m).nf=sprintf('x^%d',k);
    k=10; m=m+1; F(:,m)=x.^k;  Af(m,1)=  0;   %Tx(m).nf=sprintf('x^{%d}',k);
    m=m+1; F(:,m)=sqrt(x); Af(m,1)=811.2; %511.2; %1.2; %-1.2; %Tx(m).nf=sprintf('x^{1/2}');
    %m=m+1; F(:,m)=x.^(1/3);Af(m,1)=  0;  %Tx(m).nf=sprintf('x^{1/3}');
else
    x1=x(:,1); 
    m=0; 
    k=0; m=m+1; F(:,m)=ones(Ld,1); Af(m,1)=99; %Tx(m).nf=''; % wej. sta³ej (obowi¹zkowe)

    k=1; m=m+1; F(:,m)=x1.^k;    Af(m,1)=-90; %-0.8;  %Tx(m).nf=sprintf('x_1'); 
    k=2; m=m+1; F(:,m)=x1.^k;    Af(m,1)=0.;  %Tx(m).nf=sprintf('x_1^%d',k); 
    k=3; m=m+1; F(:,m)=x1.^k;    Af(m,1)=0.; %71.2; %1.2;   %Tx(m).nf=sprintf('x_1^%d',k); 
         m=m+1; F(:,m)=sqrt(x1); Af(m,1)=25.0; %0.1;  %Tx(m).nf=sprintf('x_1^{1/2}'); 
    x2=x(:,2);
    k=1; m=m+1; F(:,m)=x2.^k;    Af(m,1)=0.; %81.2;  %1.2;  %Tx(m).nf=sprintf('x_2^%d',k);
    k=2; m=m+1; F(:,m)=x2.^k;    Af(m,1)=0.; %-32.3; %-2.3; %Tx(m).nf=sprintf('x_2^%d',k);
    k=3; m=m+1; F(:,m)=x2.^k;    Af(m,1)=-10;   %-1.0; %Tx(m).nf=sprintf('x_2^%d',k);
         m=m+1; F(:,m)=sqrt(x2); Af(m,1)=0;    %Tx(m).nf=sprintf('x_2^{1/2}');
    
    k1=1; k2=1; m=m+1; F(:,m)=(x1.^k1).*(x2.^k2);  Af(m,1)=0;   %Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
    k1=2; k2=1; m=m+1; F(:,m)=(x1.^k1).*(x2.^k2);  Af(m,1)=0,; %-92; %-10; %Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
    k1=1; k2=2; m=m+1; F(:,m)=(x1.^k1).*(x2.^k2);  Af(m,1)=62.3; %12;  %Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
                m=m+1; F(:,m)=sqrt(x1.*x2);        Af(m,1)=85.; %5;  %Tx(m).nf=sprintf('(x_1*x_2)^{1/2}');
end
Km=m;
Yteor=F*Af; 
if wspZ<0
    wspZ=-wspZ;
    Dy=max(Yteor)-min(Yteor);
    wspZ=Dy*wspZ;
end
% ...............................
Yemp=Yteor+wspZ*randn(Ld,1);
