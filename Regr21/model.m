% model 
function [F,Kmax,Tx] =model(x)
% Projektujemy i obliczamy wejscia uogolnione Fi
% np. for(k=1:r) F(:,k)=x.^k; end % pe³ny model wielomianowy
Ld=length(x(:,1)); Lx=length(x(1,:));
if(Lx==1)
    m=0;
    k=0; m=m+1; F(:,m)=ones(Ld,1); Tx(m).nf=''; % wej. sta³ej (obowi¹zkowe)
    k=1; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x');
    k=2; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^%d',k);
    k=3; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^%d',k);
    k=4; m=m+1; F(:,m)=x.^k; Tx(m).nf=sprintf('x^%d',k);
    k=5; m=m+1; F(:,m)=x.^k; Tx(m).nf=sprintf('x^%d',k);
    k=6; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^%d',k);
    k=7; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^%d',k);
    k=8; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^%d',k);
    k=9; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^%d',k);
    k=10; m=m+1; F(:,m)=x.^k;  Tx(m).nf=sprintf('x^{%d}',k);
          m=m+1; F(:,m)=sqrt(x); Tx(m).nf=sprintf('x^{1/2}');
    %m=m+1; F(:,m)=x.^(1/3); Tx(m).nf=sprintf('x^{1/3}');
else
    zn='1'; x1=x(:,1); 
    m=0;
    k=0; m=m+1; F(:,m)=ones(Ld,1); Tx(m).nf=''; % wej. sta³ej (obowi¹zkowe)
    
    k=1; m=m+1; F(:,m)=x1.^k;  Tx(m).nf=sprintf('x_%c',zn);
    k=2; m=m+1; F(:,m)=x1.^k;  Tx(m).nf=sprintf('x_%c^%d',zn,k);
    k=3; m=m+1; F(:,m)=x1.^k;  Tx(m).nf=sprintf('x_%c^%d',zn,k);
         m=m+1; F(:,m)=sqrt(x1); Tx(m).nf=sprintf('x_%c^{1/2}',zn);
    x2=x(:,2); zn='2';
    k=1; m=m+1; F(:,m)=x2.^k; Tx(m).nf=sprintf('x_2');
    k=2; m=m+1; F(:,m)=x2.^k; Tx(m).nf=sprintf('x_2^%d',k);
    k=3; m=m+1; F(:,m)=x2.^k;  Tx(m).nf=sprintf('x_2^%d',k);
    m=m+1; F(:,m)=sqrt(x2); Tx(m).nf=sprintf('x_2^{1/2}');
    
    k1=1; k2=1; m=m+1; F(:,m)=(x1.^k1).*(x2.^k2);  Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
    k1=2; k2=1; m=m+1; F(:,m)=(x1.^k1).*(x2.^k2);  Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
    k1=1; k2=2; m=m+1; F(:,m)=(x1.^k1).*(x2.^k2);  Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
    %k1=2; k2=2; m=m+1; F(:,m)=(x_1.^k1).*(x2.^k2);  Tx(m).nf=sprintf('x_1^%d*x_2^%d',k1,k2);
                m=m+1; F(:,m)=sqrt(x1.*x2); Tx(m).nf=sprintf('(x_1*x_2)^{1/2}');
end
Kmax=m; 
