function [Yemp,Yteor,wspZ,Af]=obiekt(x,wspZ,alfa,v0)
%Af=[1,-0.8,1.2,0.3,0,0,0,0 0 0 0 0 0 0]; ld=length(x);
ld=length(x(:,1)); Lx=length(x(1,:));
if(nargin<3 || alfa<1.e-4) 
    Hammer=0; 
    if(Lx==1)
        %Af=[1, 150, 0.0, -15, -8.0, 0.0, 0.5e1, 0 0 0 0 0 0 0]; 
        Af=[1,-0.8,1.2,0.3,0,0,0,0 0 0 0 0 0 0]; ld=length(x);
        %Af=[1,-6.0,3.2,0.3,0,0,0,0 0 0 0 0 0 0]; 
        kf=length(Af); Kf=kf; 
        fi(1:ld,1)=1; 
        for(k=2:Kf) fi(:,k)=x.^(k-1); end
    else
        fi(1:ld,1)=1; k=1;
        for(i=1:2) k=k+1; fi(:,k)=x(:,i); end % czlony 1.go rzedu
        for(i=1:2) k=k+1; fi(:,k)=(x(:,i).^2); end % czl.2go rzedu
        for(i=1:2) k=k+1; fi(:,k)=(x(:,i).^3); end % czl.2go rzedu
        k=k+1; fi(:,k)=x(:,1).*x(:,2); 
        k=k+1; fi(:,k)=(x(:,1).^2).*x(:,2); 
        k=k+1; fi(:,k)=x(:,1).*x(:,2).^2; 
        Kf=k; Af=zeros(2*Kf,1); 
        Af(1)=1; Af(2)=-0.8; Af(3)=1.2; Af(4)=0.3; Af(6)=-0.2;        
    end   
else
    Hammer=1; 
    Af=[1, 15, alfa]; kf=length(Af); Kf=kf-1; 
end
Yteor=zeros(ld,1);
for k=1:Kf
   Yteor=Yteor+Af(k)*fi(:,k); 
end
if wspZ<0
    wspZ=-wspZ;
    Dy=max(Yteor)-min(Yteor);
    wspZ=Dy*wspZ;
end
% Obliczamy zaklocenia
if(Hammer) 
    K=wspZ*sqrt(1-alfa^2);
    if(nargin==3 || v0==0.) 
        v0=0; 
        for(n=1:100) v0=alfa*v0+K*randn; end, 
    end, % rozbiegowy
    for(n=1:ld) v0=alfa*v0+K*randn; v(n,1)=v0; end, 
else v=wspZ*randn(ld,1); 
end
Yemp=Yteor+v;