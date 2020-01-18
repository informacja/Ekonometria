% regr2; 
% Pobieramy dane empiryczne
clear all;  
xmin=0.2; xmax=1.1; 
Ldemp=100; wspZ=0.05; 
dx=(xmax-xmin)/(Ldemp-1); x=[xmin:dx:xmax]'; 
[Yemp,Yteor,wspZ,Af]=obiekt(x,-wspZ);
% Mamy gotowe dane Yemp i x - Rysujemy Y(x)
figure(1); 
plot(x,Yemp,'k.'); axis('tight'); input(' ?? '); 
% ---------- Budujemy arbitralnie wejscia uogolnione FI ---
Kd=4; % zadana liczba jednomianow (rzad wielom.=(Kd-1)
FI(:,1)=ones(Ldemp,1); 
for(k=2:Kd) FI(:,k)=x.^(k-1); end,
% ........... Liczymy wspolczynniki modelu .....
G=inv(FI'*FI); % macierz Gaussa 
Aob=G*FI'*Yemp; % mamy wspolczynniki
% ..... Policzymy wyjscia modelu dla obserwacji 
Yob=FI*Ad; 
% ----- Rysujemy wynik ----------
figure(1); 
plot(x,Yemp,'k.',x,Yteor,'c:',x,Yob,'r.'); axis('tight');
xlabel(sprintf('Regresja i dane dla Ldemp=%d wspZ=%.3f',Ldemp,wspZ)); 