function [rTemp,Temp,nTim,czas,lTim,lrT]=dane()


% if (verLessThan('matlab', '8.4')) % for MATLAB 2010
% %     filename = '2018_space.csv'; delimiterIn = ',';
% %     data = importdata(filename, delimiterIn)'; % wektor pionowy (szafa)
%     load('time_data.mat')
%     x = datenum(time'); tR = [1:max(x) - min(x) + 2]; % time Real
%     L = length(x);
%     T = max(x) - min(x) + 1;
%     L = length(data); x = [1:L]; tR = x; % generowanie numeru pr�bki dla MatLab 2010
% %     time = x;
% 
% else % for MATLAB 2020
%     [time, data] = loadEmp(2013, 2019, 'Raport_Pomiarow_anonim.xls'); % lata od 2013 do 2019
%     x = datenum(time'); tR = [1:max(x) - min(x) + 2]; % time Real
% 
%     if (length(x) == length(unique(x))) fprintf(1, 'ok - 1 pomiar dziennie')% To do
%     else length(unique(x)); error ('kilka pomiar�w jednego dnia lub inny pow�d powt�rze� w wektorze [time]');  end
% end
%----------------------------------------------------------------------


% startYear = 2013;
% numdays = datenum({'06/01/13'},'dd/mm/yy') - datenum({'31/12/19'},'dd/mm/yy')
% data(-numdays-26) % 29 lutego 2016 % 4,2 *C

data=[3.8 6.5 6.6 6.2 6.2 6.6 6.3 6.2 5.9 5.5 5.4 5.9 2.9 6.7 6.2 2.5 5.8 6 5.1 5 4.8 4.3 5.4 5.6 6.2 6.3 4.2 5.2 3.5 6.6 4.2 6.6 3.8 3.8 6.9 5.2 5.7 5.6 6.4 6 5.1 7.5 9.4 6 3.6 3.1 3.95 4.5 5.6 5.8 6 6.6 5.8 5.6 4.9 4.1 4.2 6 6.2 7.3 3.3 6.1 6.9 7 5.4 5.2 3.9 4.9 4.7 4.5 4.9 6.7 6.6 5.9 7 6.7 5 4.9 6.8 6.7 7.2 7.6 6.9 7.2 7.3 7.2 7.6 6.5 6.5 7.2 7.3 8.3 7.6 8 10.3 10.3 7 7.2 10 10.3 10.5 11.2 10.2 11.2 11 11.6 11.9 12.6 12.5 14 13.5 13.6 14.3 14.3 14.9 14.6 14.5 14.6 14 15 15.2 16.8 15.1 14.8 15.3 15.1 15.6 15 16 18.4 18.7 18.7 17.7 18.5 18.2 17.5 17.8 15.5 17.8 17.7 16.2 17.3 17.1 16.9 17.2 18.2 16 16.2 18.2 16.5 16.8 16.8 17.8 18.2 18.2 18.6 19 19.1 19.6 19.3 19.4 19.9 22.1 21.5 19.3 19.2 19.6 20.1 19.6 19.9 20 19.8 19 19.3 20.05 19.8 20.1 20.6 20.4 20.5 21.3 21 20.4 20.8 19.5 20.6 18.9 20.4 19.7 20.6 19.2 19 20.1 20.4 20.9 20.6 21.5 22.2 22.9 23 23.2 22.6 22.5 22.9 23 23.2 22.9 22.9 23.1 23 23.2 22.7 22.7 22.6 22.6 22.6 21.1 21.8 21.1 24.1 22.6 23.5 21.2 21.6 22 20.9 20.9 21.3 20.3 20.1 19.9 20.3 17.8 19.4 19.6 20.3 19.7 19.8 19.2 19.6 19.2 17.1 18.5 18.6 19.8 19.2 17.9 18.7 19.1 19.6 17.6 18.3 16.9 17.8 17.7 16.8 16.2 17.1 16.1 16.3 14.8 14.5 14.1 13.9 14.2 12.2 12.5 13 14.3 12.6 14.3 14.6 14.1 14.3 14 13.9 14.6 13.6 13.2 13 12.7 14.6 12.9 13 13.1 13 13.7 13.6 13.9 13.8 13.9 13.8 12.6 12.6 12.9 13.6 12.4 11.9 11.8 11.8 10.3 11.2 11 10.6 7.7 7.5 7.4 10.2 10.4 9.6 10.2 10.2 10.6 10.6 10.2 10.2 10.9 9.2 10 7.7 8 9.2 6.2 7.3 7.2 9.9 6.8 6.6 6.7 6.4 6.2 6.8 6.6 6.3 6.4 7.9 5.6 4.6 7.4 4.2 4.9 3.9 10.2 7.3 5.3 6.8 7 7.2 8.1 9.6 6.6 4.2 4.9 4.4 4.6 4.9 5.6 6.1 6.3 6.1 6.3 5.7 6.4 4.6 5.3 4.8 4.5 9.5 7.1 4.5 5.3 5.4 5.2 4.7 4.4 5.2 4.3 2.5 2.7 2.8 2.7 6.4 4.1 4.3 6.1 4.6 4.7 4.8 5.8 4.6 4.6 6.3 4.6 4.9 5.6 5.7 4.2 5.9 9.2 5.7 6.2 8.3 7.2 4.9 4.6 4.3 5 4.8 4.9 4.8 7.8 7.7 7.8 6.8 6.3 5.9 6.9 7.1 7.1 4.8 8.2 10.2 7.2 7 10 10.2 9.1 10 10.5 8.1 10.5 9 9.1 10 9.9 9.7 11.4 11.2 11.4 11.1 11.6 11.4 12.4 12.3 12.5 13.2 12.1 12.2 12 12.1 12.4 14.1 14.4 12.6 12.5 14.2 14.6 14.1 14.1 14 14.2 14.6 13.6 13.3 13.6 13.4 134 13.9 12.8 13 14.8 15.6 15.7 15.2 14.7 14.6 15.5 16.1 15.2 13.3 14.5 12.6 13.6 13.5 14.4 14.3 14.9 14.9 14.6 14.3 14.2 15.5 16.6 16.2 16 16.8 17.4 14.5 16.2 16.4 17 16.8 15.9 19.5 19.3 19.9 18.9 18.8 18.5 17.9 17.7 17.8 18.5 18.8 18.9 18.8 18.9 19.3 19.2 19.8 18.8 19.7 19.5 206 20.5 20.4 21.3 21.5 20.8 20.2 22.5 22.6 22.6 22.1 19.9 22 21.8 19.8 19.4 19 19.5 19.3 19.2 19.4 19.3 19.6 19.8 19.9 18.8 20 19.2 28.5 25.1 21.4 21.3 21.1 21.3 21.7 22.1 21 20 21 21.2 20 21 21.5 20.1 20.7 20.6 20.1 20.4 20 19.9 19.4 19.4 20 18.9 18.8 17.2 16.6 16.3 18.6 17.4 17.3 17.5 17.9 17.6 17.3 17.1 18.2 18.6 17.9 19.7 18.5 17.2 17.5 18.6 18.1 17.6 19.3 19.4 18.5 18.6 19.6 19.2 19.2 18.2 17.2 17 16.8 16.2 16.2 15.2 17.2 15.6 17.2 16.7 15.7 14.9 14.9 15 14.9 15.4 16.8 14.9 14.8 14.5 14.8 16.9 17.5 17.9 14 17.1 16.8 14 14.2 13.8 14.1 14.1 11.9 11.6 12 11.8 11 10.4 11.2 11.2 17 10.6 11.4 11.5 12.1 11.8 12.1 12.1 12.1 12.6 12 11.8 11.6 11.2 11 10.6 11.1 11 13.4 12 11.5 11.3 11 8.2 8.1 8.2 7.9 7.2 8.2 5.2 5.3 07.04 8.1 7.2 8 7.9 7.9 11.6 7.6 7.4 7.1 7.9 8 7.6 7.4 7.5 7.6 5.4 5.5 5.3 7.6 5.8 5.9 5.1 4.1 4 3.1 3.1 3.3 5 4.8 4 4.6 3.2 3.6 3.3 3.3 3.9 4.2 4.1 4.4 4.3 3.9 3.9 4.5 3.1 4.5 4.6 4.3 4.1 3.4 3.8 3.1 3.9 4.8 3.1 3.5 3.2 3.7 10.7 10 9.9 9.8 8.9 8.7 2.1 3.1 3.2 3 3.6 2.3 3.1 3.3 3.6 3.3 3.6 5.2 5.1 5.3 6 6.5 5.9 5.9 6.9 7.2 7.4 7.2 6.6 6.2 8.1 8.4 8.4 8.2 8.2 8 8.6 6.8 8.1 8 7.9 7.2 7.81 7 7.6 11.3 10.9 12.3 10.8 11.2 8.9 8.9 8.4 8.2 10.2 11.1 8.6 10.3 10.1 10.1 9.9 9.2 10.8 9.8 7.9 7.8 8.4 8.2 10.3 9.5 10.2 10.5 10.2 10.2 10.6 10.4 10.3 10.8 11.4 11.1 9.6 9.2 10.9 7.7 11 12.3 12.1 12.4 14.2 10.4 13.1 11.1 11 10.9 13.4 15 14.6 14.7 14.8 14.9 14.3 14.2 14 15.1 13.2 12.9 13 11.7 14.8 15.2 17.5 13 12.9 13 12.9 12.8 14.01 14.6 14.5 14.6 14.6 14.7 14.3 14.6 14.9 13.9 15.3 15.7 15.1 18 18.4 19.1 19.1 19.9 19.2 21.6 19.8 17.8 18 18.4 18.6 18 18.3 18.6 19.1 18.9 19.1 18.7 18.7 18.8 18.8 20.9 21.5 22 23.3 21.7 25.1 20.9 22.3 23.1 20.1 20.4 20.6 22.5 20.8 20.6 20.6 23.7 24.5 24.1 24.1 24.4 20.5 20.6 23.7 23 24.3 21.5 19.5 20.4 21.2 22.4 23.1 22.8 22.6 24.5 24.6 24.5 25.6 25.2 25 24.6 24.8 24.6 25.3 25.3 23.8 23.5 23.5 22.3 21.1 21 20.9 21.2 23.1 23.6 24 23.3 23.6 24.4 24.4 24.1 22.4 21.1 19 19.4 18.2 18.6 18.3 17.7 18.2 18.3 18 20 21.2 19.6 21.3 21.6 21.9 20.8 20 19.8 18.8 18.6 18.9 19.8 18.9 16.8 16.9 16.8 16.3 14.3 14.4 15.2 15.1 15.6 15.7 15.8 15.6 14.7 15.6 15.5 12.6 12.9 12.3 15 15.2 14.4 13.5 13.3 15.3 15.4 15.5 11.9 13.9 15.7 15.6 12.1 12 13.3 12 13.2 13.1 10.8 12 12 9.8 10.2 11.2 11.4 12.3 12.8 12.1 12.4 10.2 12.3 10.8 10.7 12.3 10.5 10.3 10.3 9.8 9.7 8.6 8.2 11 10.1 11.6 11.6 11.2 8.3 8.9 8.6 9.2 9.4 9.2 7.9 7.5 8.3 7.8 7.9 8.5 8.2 8 8.1 7.2 7.7 6.6 7.9 7.8 7.9 8 8.5 7.9 6.5 6.7 5.2 5.1 4.3 3.7 3.5 3.5 5.7 4.5 4.6 5.3 4.8 5.3 5 5.1 5 3.7 4.1 5 2.1 1.3 1.4 2.8 2.4 2.3 3.2 3.6 3.2 8.5 5.6 4.6 6 8.9 5.8 6.1 6.2 6.2 8.8 8.9 7.7 7.7 3.2 7.5 7.1 7.2 7.3 8.8 8.6 8.9 7.7 8.9 8.6 8.5 8.6 8.3 8 6.5 7 6.1 6.2 4.2 11.2 7.8 7.2 7.2 7.4 7.5 9.2 8.2 8.1 8 8.1 8.3 7.9 8 7.9 7.9 8.4 7.9 9.8 9.2 9.1 9.8 9.4 8 8.1 8.2 4.7 8 8.1 8.1 8 7.9 8 7.8 8.4 7.7 7.8 9.1 9.6 9.8 9.7 10.1 9.2 9 9.1 10.6 12.9 12.1 12 11.7 12.9 13.2 11.2 12 11.2 11.2 12.3 12.1 12.3 14.1 13.3 13 12.7 12.9 12.4 12.1 12.4 12.4 13 12.3 13.4 12.8 12.7 12.6 13.2 12.9 15.2 15.4 15.5 15.4 15.4 15.6 15.7 15.3 16.8 16 15.2 14.9 13.2 14.7 14.8 15.3 15.4 18.9 18.8 17.5 17.6 17.7 17.6 17.7 17.8 18.1 19.6 19.4 16.7 17.9 18.3 18.1 19.1 20.1 17.4 17.5 17.6 17.9 18.2 17.6 17.8 21.3 21.5 23.6 18.8 23.1 23.2 23.4 22.1 22.5 24.1 22.4 25.3 23.4 24.2 24.3 24 21.9 22.6 23.1 22.8 24.3 23.1 23.9 23 24 24.5 24.2 23.4 21.5 21.9 22.1 20.1 20 20 21.2 21.1 21.4 21.3 21.5 24.2 24.2 20.9 21 21.2 20.9 20.8 20.9 21.4 21.4 21.3 21.2 21.9 22 21.7 20.9 21 22 20.1 21.2 21.1 21 20.2 20.1 20.2 20.8 22.1 20.1 22 20.1 21.7 21.8 18.7 19 20.2 20.1 20.2 19.9 19.3 21.1 21 19.9 19.6 19.2 19.4 19.1 19.3 18.8 19.1 19 18.9 19.5 19 19.2 18.8 18.3 17.7 17.6 17.5 17 16.9 17 16.8 17.4 17.2 0.12 17 18.9 18.2 18.5 16.9 15.3 15.4 15 15.1 15.2 13.2 16.6 14.1 12.7 12.4 12.1 12.2 12.3 12.5 11.8 12.9 13.3 11.8 11.9 12.3 12.4 14.2 11 10.2 10.1 9.8 16.3 11.7 11.3 11.2 11.4 11.3 11.1 11.8 11.3 11.1 9.6 8.4 8.2 8.4 9.1 9 5.8 6 6.1 11.6 11.4 10.8 10.7 10.6 10.4 10.6 10.4 7 7.4 8.6 4.4 3.9 7.9 3.8 10.5 10.6 10.9 10.7 10.9 11 8.1 7.9 6.9 6.2 6.1 6.3 6.5 7 6.8 7 6.2 7.1 7.2 7 6.6 6.7 2.5 5.2 4.8 5.5 5.6 3.9 3.7 6.8 6.6 7.2 6.8 6.5 6.8 6.7 6.8 6.5 6.7 6.7 6.5 6.6 6.7 6.5 6.3 6.5 6.3 6.5 6.4 6.6 6.7 6.8 6.9 7 6.8 6.9 6.6 6.2 6 6 6.2 5.9 6.1 5.2 6 6.8 7 8.7 7.6 7.4 11.6 11.4 10.6 11 11.2 11.5 11.4 7.5 7.8 7.4 7.8 7.9 7.8 7.7 07.08 7.9 8 7.8 7.6 7.4 7.3 7.6 7.8 7.18 7.6 7.5 7.4 7.5 5.4 7.7 7.9 8.1 8.2 7.9 8.1 8.7 8.3 9.2 12 12.3 12.4 12.6 12.5 12.3 12.6 12.3 11.2 11 11.2 12 12.1 12 12.1 12 12.1 19.9 19.2 12.1 12.3 13 12.9 13.4 13.2 13.3 13.4 13.2 8.6 13 13.3 13.1 12.8 13 12.9 13 13.1 13.3 13.4 14.1 13.9 14.2 14.2 14.3 14.4 16.2 16.4 15.5 16.1 16 16.4 16.7 19.2 19.6 19.4 19.3 19.2 19.4 19.5 19.9 19.8 20.4 20.3 20.2 20.08 20.4 19.2 17.1 18.6 18.9 19.1 21.5 21.6 21.7 21.8 22 22.1 23.5 23 19.9 19.7 19.6 20.2 19 19.7 19 21.1 20.2 20.4 20.9 20.4 20.5 20.2 22 21.9 21.6 21.1 21 21.1 21.2 20.6 22.8 22.3 22.5 22.6 22.4 22.4 21.6 21.5 20.9 21 23.8 24.8 25 25.3 25.4 24.8 24.9 24.7 23.5 23.1 25.1 24.7 24.6 24.1 22.1 23.2 22.5 22.7 22.8 22.7 22 20.9 20.9 19.9 20.7 20.5 20.6 22.9 22.4 21.1 21.5 22.2 22 21.8 21.4 19.2 19.1 19.3 19.1 19.4 19.5 22.1 19.8 19.2 19.5 18.8 18.7 18.5 18.6 18.4 18.4 18.1 16.8 16.6 14.5 16.6 16.4 16.1 16 15.8 14.3 17.5 17.6 17.5 17.2 16.7 16.4 16.2 15.1 18.1 18.2 17.9 18 18.4 18.5 17.1 17.2 17.1 17 14.7 14.5 14.2 14 16.9 15.2 12.1 13.2 11.2 13.4 13.2 13 12.7 12.5 12.2 14.2 12.3 9.8 12.1 11.9 10.7 10.5 10.4 10.6 10.3 10.1 10.2 9.9 9.8 8.2 9.7 12.7 12.1 12 12.4 12.2 9.7 9.5 9.2 8.8 8.9 5.2 14.9 9.3 6.8 6.9 6.9 7 6.9 7 6.9 6.8 6.9 5.9 6.3 6.4 6.5 6.4 6.3 6.5 6.6 6.7 6.9 6.8 6.9 6.7 6.8 6.9 6.8 5.9 6.2 5.9 6.1 6.4 6.5 6.7 6.6 5.5 5.5 5.7 5.8 5.7 5.8 6.1 5.9 6 5.9 5.8 5.6 2.8 4 3.8 3.7 3.6 3.8 3.9 4 4.1 3.8 3.9 4.2 3.2 3.1 2.9 2.8 2.6 2.8 2.7 2.8 2.6 2.5 2.5 9.2 07.05 09.08 9.2 6.3 13.2 13.1 12.3 13 12.8 10 4.7 5.2 6.3 6.2 6.7 6.6 12.7 13 12.6 13.1 12.2 12.4 12 9.7 6.7 10.2 11.7 11.5 10.2 12.6 12.5 16 16.9 16.8 16.8 13.2 13.3 13.6 13.8 14 14.2 15.8 15.6 15.8 13.6 16.4 12.5 17.8 18.2 19 19.1 19.4 19.2 19.5 19.3 19.4 19.6 19.4 18.9 18.6 18.5 18.4 18.2 18.4 18.6 18.8 18.9 19 17.5 21.5 21.6 21.9 22 22 22.2 21.8 21.6 21.3 17.3 21.8 21.9 22 24.5 22.5 22.1 22 22.2 23.4 23 21.2 21.3 21.4 21 20.9 20.7 20.6 20.9 20.8 21 20.8 20.2 19.8 18.9 19.5 20 20.6 20.6 20.05 20.8 18.9 21 20.9 21 20.8 20.4 20.6 20.5 20.1 20.6 20.8 20.9 21 21.3 21.1 21 21.1 21.6 21.1 21.3 21.7 22 22.1 22.1 22 22.2 22.5 22.3 22.8 21 20.8 22.5 23.4 23.4 22.1 22.2 22 24.8 24 23.5 23.4 24.1 23.8 22.9 20.6 20.4 22.8 22.3 22.8 22.9 22.3 22.4 20.4 20.1 19.8 22.3 22.2 22.3 22 22.5 22.3 22.1 22.1 22 21.9 21.5 20.8 20.9 20.4 21.1 21 20.8 20.6 20.1 19.9 17.2 17.3 17 17.1 17 17.1 16.8 17 17.1 17.2 16.1 16.2 17 16.2 16 16.8 16.6 15.9 15 16 15.9 14.2 14.2 14 12.9 13 12.9 13 13 14 14.2 13.9 17.2 17 14.2 14.1 13.9 6.3 6.8 7.2 12.2 11.9 11.7 11.7 11.5 9.6 9.6 9.4 9.2 8.9 8.9 5.9 5.3 5.4 5.2 5.3 5.4 8.1 8 8.6 8.1 8.4 8 8 8 8.1 8.2 8 8.1 7.8 8 8.2 7.9 7.7 7.7 7.7 7.6 7.5 7.7 6.2 6.3 5.8 6 6.8 6.8 6.9 6.8 6 5.6 5.4 5.3 5.1 5.2 4.8 4.4 4.2 4.2 4.3 4.4 5.8 6 6.1 5.6 5.5 6 6,00 6,01 6 3.9 4.1 4.9 5.3 5.4 5.6 6 5.8 5.7 5.4 5.2 4.7 5 5.7 5.4 5.3 6.3 6.4 6.3 6 6.4 6.9 6.4 6.3 5.8 5.4 6.2 6.3 6.6 7 6.8 6.8 6.7 6.8 6.9 7 7.1 7.1 7 7.8 8.3 8.5 8.3 8.5 8.7 9.3 9.4 9.6 9.8 9.9 9.5 9.7 11.2 11.1 11.9 12.2 12.1 12.3 12.2 12.7 12.8 12 14.9 14 13.8 13.8 13.7 11.1 11.4 11.8 11.8 11.9 12 12.2 13.3 13.4 14 14.5 14.4 12.3 12.1 12 12.4 13.2 11.4 11.6 13.7 13.5 13.6 14.2 14 14.1 14.3 14 14.3 14.7 14.5 15 15.1 14.9 15 14 14.1 14.2 14.3 14.3 14.6 16.2 17.3 17 16.8 16.5 16.6 16.9 18.3 18.4 20.4 20.1 20.2 20.1 20.4 20.9 21 21.2 21.3 21.6 22.7 24 22.1 22 22.1 22 23.2 23.1 29.9 29.4 28.7 25.6 25.1 25.9 26.1 22.4 21.2 21 21.2 21.4 21.5 22 22.2 21.2 21.8 7.73 21.8 22 22.4 23.9 24 23.2 23.9 23.7 23.9 24 23.8 24 24.2 24.3 24 24.1 22.3 22.2 23 22.8 23 21.9 20.7 20.9 22.6 22.7 23.4 23.3 23.6 23.7 23.8 23.6 23.5 23.6 21.9 21.8 24.4 20.5 21 20.9 21.4 20.8 21.5 19.8 18.8 19.1 18.9 19.3 17.8 18 17.9 17.7 17.8 17.9 17.5 17.1 17 17.1 17 17.1 16.9 16.9 17.1 17.5 17.7 17.5 17.4 18.4 18.5 17.6 17.8 17.7 16.8 16.5 16.1 15.5 15.4 15.3 15.3 15.1 14.4 14.3 14 12.2 12.1 12 12.3 12.1 11.6 11.9 12.9 12.6 12.5 13.5 13.3 13.4 13.3 13.2 13 13.1 12.9 12.7 12.8 12.7 12.6 9.3 8.5 7.1 6.2 6.3 5.9 5.8 5.7 5.6 5.5 5.5 5.6 5.7 6 6.1 6.2 6.4 6.5 6.6 6.7 7.6 7.4 7.3 7.4];
time=[6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 147 146 148 149 151 153 152 154 155 156 157 158 159 160 161 162 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 228 229 230 231 232 233 234 235 236 237 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 306 307 308 309 310 311 312 314 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 360 361 362 363 364 365 2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 112 113 114 115 116 117 118 119 120 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 306 307 308 309 310 311 312 313 314 316 317 318 318 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 361 362 363 364 365 2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 26 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 65 65 66 67 68 68 69 70 71 72 72 73 74 75 76 77 78 78 79 79 80 81 82 83 84 84 85 86 87 88 89 89 90 91 92 93 94 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 241 242 243 244 245 246 247 249 248 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 306 307 308 309 310 311 312 313 314 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 360 361 362 363 364 365 2 3 4 5 7 8 9 10 11 12 13 14 15 17 16 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 69 69 69 69 69 70 71 71 71 72 73 74 75 76 76 76 76 77 78 79 80 81 81 81 82 83 84 85 86 88 89 90 91 92 93 94 95 96 97 98 99 101 100 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 125 126 127 128 129 130 131 132 133 134 135 136 137 139 138 140 141 142 143 144 145 146 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 199 198 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 272 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 304 305 307 308 309 310 311 312 313 314 315 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 351 352 353 354 355 356 357 358 359 361 362 363 364 365 366 2 3 4 5 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 93 94 95 96 97 98 100 101 102 103 104 105 107 108 109 110 111 112 114 115 116 117 118 119 120 121 122 124 125 126 128 129 130 131 132 133 135 136 137 138 139 140 142 143 144 145 146 147 149 150 151 152 153 154 156 157 158 159 160 161 163 164 165 167 168 170 171 172 173 174 175 177 178 179 180 181 182 183 184 185 185 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 275 276 277 278 279 280 282 283 284 285 286 287 289 290 291 292 293 294 296 297 298 299 300 301 302 303 304 306 307 308 310 311 312 313 314 315 317 318 319 320 321 322 324 325 326 327 328 329 331 332 333 334 335 336 338 339 340 341 342 343 345 346 347 348 349 350 352 353 354 355 356 357 360 361 362 363 364 2 3 4 5 7 8 9 10 11 12 13 15 16 17 18 19 20 22 23 24 25 26 27 29 30 31 32 33 34 36 37 38 39 40 41 43 44 45 46 47 48 50 51 52 53 54 55 57 58 59 60 61 62 64 66 67 68 69 71 72 73 74 75 76 78 79 80 81 82 83 85 86 87 88 89 90 92 93 93 94 95 96 97 99 100 101 102 103 104 106 107 108 109 110 111 113 114 115 116 117 118 120 122 124 125 127 128 129 130 131 132 134 135 136 137 138 139 141 142 143 144 145 146 147 148 149 150 152 153 155 156 157 158 159 160 162 163 164 165 166 167 168 169 170 171 172 173 174 176 177 178 179 180 181 182 183 184 185 186 187 190 188 191 191 192 193 194 195 197 198 199 200 201 202 204 205 206 207 208 209 211 212 213 214 215 216 217 218 219 220 221 222 219 219 223 225 226 228 229 230 232 233 234 235 236 237 238 239 240 241 242 243 244 246 247 247 247 247 248 249 250 251 253 254 255 256 257 258 259 260 261 262 263 264 265 267 268 269 270 271 272 274 275 276 277 278 279 281 282 283 284 285 286 288 289 290 291 292 293 295 296 297 298 299 300 302 303 304 306 307 309 310 311 312 313 315 317 318 319 320 321 323 324 325 326 327 330 331 332 333 334 335 336 337 338 339 340 341 342 344 345 345 345 345 345 345 346 346 346 347 348 349 351 352 353 354 355 356 358 360 361 362 363 365 2 3 4 5 7 8 9 10 11 12 14 15 16 17 18 19 21 22 23 24 25 26 28 29 30 31 32 33 34 35 36 37 38 39 40 42 43 44 45 46 47 49 50 51 52 53 54 56 57 58 59 60 61 63 64 65 66 67 68 70 71 72 73 74 75 77 78 79 80 81 82 84 85 86 87 88 89 91 92 93 94 95 96 98 99 100 101 102 103 105 106 107 108 109 110 112 113 114 115 116 117 119 120 122 124 126 127 128 129 130 131 133 134 135 136 137 138 140 141 142 143 144 145 147 148 149 150 151 152 154 155 156 157 158 159 161 162 163 164 165 166 168 169 170 172 173 175 176 177 178 179 180 182 184 185 186 187 189 190 191 192 193 194 196 197 198 199 200 201 203 204 205 206 207 208 210 211 212 213 214 215 217 218 219 220 221 222 224 225 226 228 229 231 232 233 234 235 236 238 239 240 241 242 243 245 246 247 248 249 250 252 253 254 255 256 257 259 260 261 262 263 264 266 267 268 269 270 271 273 274 275 276 277 278 280 281 282 283 284 285 287 288 289 290 291 292 294 295 296 297 298 299 301 302 303 304 306 308 309 310 311 312 313 316 317 318 319 322 323 324 325 326 328 329 330 331 332 333 334 336 337 338 339 340 341 343 344 345 346 347 348 350 351 352 353 354 355 357 358 361 362 364 365];
ldt=length(time);
sumdt=0; 
Time(1) = time(1);
for(i=2:ldt) 
    if(time(i-1)-time(i)>300) 
        sumdt=sumdt+time(i-1); 
    end
    Time(i)=time(i)+sumdt;  
end
lr=5; % liczba rysunk�w
% figure(99)
% subplot(lr,1,1); plot(Time,Time,'k',Time,time,'r'); title('Z��czenie danych rocznych 2013-2019');  ylabel('Nr dnia'); xlabel(sprintf('Liczba danych = %d', length(time)));
dTim=diff(Time); nluk=find(dTim>1 | dTim<1);
% subplot(lr,1,2); plot(Time(nluk),dTim(nluk),'ko'); title('Aberracje pomiar�w   <1 zostan� pomini�te, (zero - pomiary wykonane jednego dnia; ujemne - b��d kolejno�ci'); ylabel('Odst�p [dni]'); xlabel('Czas [doba]'); ylabel('Odst�p [dni]')
dobre=find(dTim>=1); Temp=data(dobre+1); nTim=Time(dobre+1);  xlabel(sprintf('Ldobre = %d, Lluk = %d, Lodrzuconych = %d', length(Temp), length(nluk), length(time)-1-length(Temp)));
% subplot(lr,1,3); plot(nTim,Temp,'k.-'); title('2-wie temperatury b��dne( piki wynikaj�ce z braku przecinka przy wprowdaniu w labolatorium'); ylabel([ '[' char(176) 'C]']); 
popr=find(Temp>=1 & Temp<30); Temp=Temp(popr); nTim=nTim(popr); xlabel(sprintf('Ldanych = %d', length(nTim))); 
dTim=diff(nTim); 
if(~isempty(find(dTim<1)))
    dobre=find(dTim>=1); % find(dTim<1)
    Temp=Temp(dobre+1); nTim=nTim(dobre+1); 
end
% subplot(lr,1,4); hold on; plot(nTim,Temp,'r.'); title('Zakceptowane pr�bki'); hold off; ylabel([ '[' char(176) 'C]']); 
lTim=length(nTim); k=1; rTemp(k)=Temp(1); 
for(i=2:lTim) 
    if(nTim(i)-nTim(i-1)==1) k=k+1; rTemp(k)=Temp(i);
    else
        dn=nTim(i)-nTim(i-1); bT=(Temp(i)-Temp(i-1))/dn;  % delta interpolacji
        for(n=1:dn) k=k+1; rTemp(k)=Temp(i-1)+bT*n; end
    end
end
k=k+1;  rTemp(k)=7.3;
lrT=k; czas=[1:lrT]; 

% subplot(lr,1,5); plot(czas,rTemp,'k.-');  title('Przygotowane dane do modelu (braki zosta�y interpolowane) (redundancje - pomini�te)');ylabel([ '[' char(176) 'C]']); xlabel(sprintf('Ldanych = %d', lrT)); 
return
[a,fname,c] = fileparts( mfilename('fullpath'));  % nazwa tego m-pliku
print( strcat(fname,'.png'),'-dpng');

