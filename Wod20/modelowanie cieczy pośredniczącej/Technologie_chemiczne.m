clear all
temperatura=[0.00,0.01,1:1:60,62:2:120,125:5:190,200:10:370,374.12];
x=1./(temperatura+273.16);
%jednostka preznosci kPA
preznosc=[0.6108,0.6112,0.6566,0.7054,0.7575,0.8129,0.8719,0.9346,1.0012,1.0721,1.1473,1.2271,1.3118,1.4015,1.4967,1.5974,1.7041,1.8170,1.9364,2.063,2.196,2.337,2.485,2.642,2.808,2.982,3.166,3.360,3.654,3.778,4.004,4.242,4.491,4.754,5.029,5.318,5.622,5.940,6.274,6.624,6.991,7.375,7.777,8.198,8.639,9.100,9.582,10.085,10.612,11.161,11.735,12.335,12.960,13.612,14.292,15.001,15.740,16.510,17.312,18.146,19.015,19.919,21.837,23.910,26.148,28.561,31.161,33.957,36.963,40.190,43.650,47.395,51.328,55.572,60.107,64.974,70.108,75.607,81.460,87.695,94.301,101.32,108.78,116.68,125.04,133.90,143.26,153.16,163.61,174.64,186.28,198.54,232.09,270.12,313.06,361.36,415.5,475.97,543.31,618.04,700.75,792.02,892.46,1002.7,1123.4,1255.2,1555.1,1908.0,2320.1,2797.9,3348.0,3977.6,4694.0,5501.1,6419.1,7444.8,8592,9870,11290,12865,15608,16537,18674,21053,22115];
y=log(preznosc);
stopien_wielomianu=3;
Apr=polyfit(temperatura,preznosc,stopien_wielomianu);
Ltemp=200; dtm=(temperatura(end)-temperatura(1))/(Ltemp-1); 
tempx=[temperatura(1):dtm:temperatura(end)];
pvOblw=Apr(1)*tempx.^stopien_wielomianu+Apr(2)*tempx.^(stopien_wielomianu-1)+Apr(3)*tempx.^(stopien_wielomianu-2)+Apr(4)*tempx.^(stopien_wielomianu-3);
pvObx=Apr(1)*temperatura.^stopien_wielomianu+Apr(2)*temperatura.^(stopien_wielomianu-1)+Apr(3)*temperatura.^(stopien_wielomianu-2)+Apr(4)*temperatura.^(stopien_wielomianu-3);
Epv=preznosc-pvObx; 
Apr2=polyfit(x,y,stopien_wielomianu); 
yOb=Apr2(1)*x.^stopien_wielomianu+Apr2(2)*x.^(stopien_wielomianu-1)+Apr2(3)*x.^(stopien_wielomianu-2)+Apr2(4)*x.^(stopien_wielomianu-3);
Eypv=y-yOb; 
tx=1./(tempx+273.16);
pvOblex=Apr2(1)*tx.^stopien_wielomianu+Apr2(2)*tx.^(stopien_wielomianu-1)+Apr2(3)*tx.^(stopien_wielomianu-2)+Apr2(4)*tx.^(stopien_wielomianu-3);
pvObl2=exp(pvOblex); 
%interpolacja=interp1(temperatura,preznosc,aproksymacja,'pchip');
plot(tempx,pvOblw,'r',tempx,pvObl2,'b',temperatura,preznosc,'k.'); axis('tight');
maxEy=max(abs(Eypv)); nEy=find(abs(Eypv)==maxEy),;
maxE=max(abs(Epv)); nE=find(abs(Epv)==maxE);
fprintf(1,'\nmaxEy=%.2f pv(%d)=%.2f; maxE=%.2f pvy(%d)=%.2f;',maxEy,nEy,preznosc(nEy),maxE,nE,preznosc(nE));
%plot(temperatura,preznosc)
%pause
%plot(aproksymacja,interpolacja,'*b')