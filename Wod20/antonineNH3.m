clear all;
A=+5.6460 ; 
B=+991.44 ; 
C=+247.05;
T0C=273.16;
% zak³adamy, ¿e woda op³ywa odbiornik ciep³a
% .300; % p [mmHg]
% 
% Ciep³o w³aœciwe w temp. 25°C: 2,39 J/(g K)
% Ciep³o parowania:
% - w temp. wrzenia: 841,5 J/g
% - w temp. 25°C: 920 J/g
Sch1= 100; Sch1= 50; % [m2]
Kch1 = 7500; %  [J/s/m2/K]TODO wsp wni. ciepla. 
Lambd=920.e3; %J/kg
Tw = [3:0.1:25]; T1 = 1; lTw=length(Tw); % [*C]


T=[-20:0.05:30]+T0C; lT=length(T); 
A=8.20417; B=1642.89; C=230
% og P = A - B/(T + C)
for(i=1:lT) lPv=A-B/(T(i)+C); Pv(i)=exp(lPv)/760; end
figure(2); plot(T-T0C,Pv); 
lPv=A-B/(T1+T0C+C); P1=exp(lPv)/760; 
for(k=1:lTw)
  q1=Sch1*Kch1*(Tw(k)-T1); Fv(k)=q1/Lambd; % ile trzeba pompowaæ by odebraæ ciep³o parowania
end
% rownanie wym. ciepla w kaloryferze 
figure(3); plot(Tw,Fv); ylabel('kg/s');xlabel('J/s/m2/K');

%czy to bêdzie proces izotermiczny ??? sprê¿arka t³okowa
% izentropowe - bez wymiany ciep³a

