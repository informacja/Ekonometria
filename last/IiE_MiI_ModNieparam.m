% Program do estymacji nieparametrycznej; 
% Obiekt; y(n)=f(V(k,n))+Z(n)
% Wspolczynniki A=[a0 av1 av2 av3 av12 av13 av23 av1_2 av2_2 av3_2]
%a0=1; av1=1.5; av11=0; av2=1.5; av3=1.5; av12=15; av13=15; av23=15; av1_2=12; av2_2=12; av3_2=20;
a0=1; av1=15; av11=-10; av2=1.5; av3=15; av12=1.5; av13=1.5; av23=1.5; av1_2=1.2; av2_2=-1.2; av3_2=2.0;
A=[a0 av1 av2 av3 av12 av13 av23 av1_2 av2_2 av3_2]; 
Ld=500; 
V=rand(3,Ld); 
Yf=a0+av1*V(1,:)+av11*V(1,:).^2+av2*V(2,:)+av3*V(3,:)+av12*V(1,:).*V(2,:)+av13*V(1,:).*V(3,:)+av23*V(2,:).*V(3,:)+av1_2*V(1,:).^2+ av2_2*V(2,:).^2+av3_2*V(3,:).^2;
sigZ=0.01;
DY=max(Yf)-min(Yf); Z=sigZ*DY*randn(1,Ld); 
Y=Yf+Z;
rKern=0.2; typK='c'; typK='p'; typK='t'; %typK='g';
r2Kern=rKern^2; wcKern=pi/(rKern/2); wtKern=1/(rKern); tsig=1.5; wgKern=tsig/(r2Kern)/2;
txK=''; if(typK=='g') txK='\sigma_g'; txK=[sprintf('=%.1f*',tsig) txK]; end 
Lobl=200; dv=1/(Lobl-1); v=[0:dv:1]; Lobl=length(v); dKvobl=Lobl/10; 
L3=0; 
for(k=1:dKvobl: Lobl)
    L3=L3+1; v3(L3)=v(k); L2=0;
    yfp=a0+av3*v3(L3)+av3_2*v3(L3).^2;
    for(m=1:dKvobl: Lobl) 
        L2=L2+1; v2(L2)=v(m); 
        yfp=yfp+av2*v2(L2)+av23*v2(L2)*v3(L3)+av2_2*v2(L2)^2;
        for(i=1:Lobl)
            Mod(L3).yf(L2,i)=yfp+av1*v(i)+av12*v(i)*v2(L2)+av13*v(i)*v3(L3)+av1_2*v(i)^2;
            lyS=0; Sy=0; 
            for(n=1:Ld) 
                dV3=(V(3,n)-v3(L3)); 
                if(abs(dV3)<=rKern) 
                    dV2=(V(2,n)-v2(L2)); 
                    if(abs(dV2)<=rKern) r2Dv=dV3^2+dV2^2;  
                        if(r2Dv<r2Kern)
                            r2Dv=r2Dv+(V(1,n)-v(i))^2; 
                            if(r2Dv<r2Kern) 
                                switch(typK)
                                    case 'c', wy=sqrt(r2Dv)*wrKern; lyS=lyS+wy; Sy=Sy+wy*Y(n); 
                                    case 'p', lyS=lyS+1; Sy=Sy+Y(n);  
                                    case 't', wy=1-sqrt(r2Dv)*wtKern; lyS=lyS+wy; Sy=Sy+wy*Y(n);
                                    case 'g', wy=exp(-r2Dv*wgKern); lyS=lyS+wy; Sy=Sy+wy*Y(n);
                                    otherwise, lyS=lyS+1; Sy=Sy+Y(n);   
                                end
                            end
                        end
                    end
                end
            end
            if(lyS==0) Mod(L3).ym(L2,i)=NaN; else Mod(L3).ym(L2,i)=Sy/lyS; end
        end
    end
end
figure(4)
for(k3=2:L3)
    subplot(3,3,k3-1); wybrv2=[1 2 4 5 7 9]; lw=length(wybrv2); kolV2='kbrmgc'; 
    txt=sprintf('Jadr0 %c, rKern=%.3f%s, v2=',typK,rKern,txK); for(i=1:lw) txt=[txt sprintf('%.2f %c, ',v2(wybrv2(i)),kolV2(i))]; end
    plot(v,Mod(k3).ym(1,:),'k',v,Mod(k3).ym(2,:),'b',v,Mod(k3).ym(4,:),'r',v,Mod(k3).ym(5,:),'m',v,Mod(k3).ym(7,:),'g',v,Mod(k3).ym(9,:),'c'); 
    hold on; 
    plot(v,Mod(k3).yf(1,:),'k:',v,Mod(k3).yf(2,:),'b:',v,Mod(k3).yf(4,:),'r:',v,Mod(k3).yf(5,:),'m:',v,Mod(k3).yf(7,:),'g:',v,Mod(k3).yf(9,:),'c:'); 
    hold off;
    xlabel(sprintf('v3=%.3f',v3(k3))); ylabel='y(v3,v2,v1)'; 
    axis('tight'); 
end
subplot(3,3,2); title(txt); 
figure(5)
for(k3=2:L3)
    subplot(3,3,k3-1); 
    mesh(Mod(k3).ym); %mesh([v2,v],Mod(k3).ym); %waterfall(Mod(k3).ym); 
    xlabel(sprintf('v3=%.3f',v3(k3))); ylabel='y(v3,v2,v1)'; 
    axis('tight'); 
end
subplot(3,3,2); title(txt); 
% figure(6)
% for(k3=2:L3)
%     subplot(3,3,k3-1); 
%     waterfall(Mod(k3).ym); 
%     xlabel(sprintf('v3=%.3f',v3(k3))); ylabel='y(v3,v2,v1)'; 
%     axis('tight'); 
% end
% subplot(3,3,2); title(txt); 

%waterfall(Mod(5).ym); mesh(Mod(5).ym)