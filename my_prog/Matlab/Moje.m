function [x] = Moje(a,b)

a = csvread('in.csv')

plot(a)

% asig = csvread('in.csv',15,0);
%tim =sig(1:1000000,1);
% aamp = asig(1:2000000,2);
% ts = asig(2,1) - asig(1,1);
% tim = [0:2000000 - 1]*ts;
% time = tim';
% plot(time, aamp);
% %set(h,'Motion','horizontal','Enable','on');
% axis([0 max(tim) -0.1 1.9]);
% ax_handle = gca;
% xlimit_orig = get(ax_handle, 'Xlim');
% win_xlimit = [0 0.001];
%     offset = 0.001;
% %   %Iterativley change the xlimit for the axes to pan across the figure
%       while win_xlimit(2) <= xlimit_orig(2)
%           set(ax_handle, 'Xlim', win_xlimit);
%           pause(0.05);
%           win_xlimit = win_xlimit + offset;
%       end


a = -2; b= 3;
f=@(x)x^3+x^2-1;
f=@(x)x+2;
eps=0.01;
c=a-f(a)*((b-a)/(f(b)-f(a)));

    while abs(f(a)-f(b))>eps    
       
    
        c=a-f(a)*((b-a)/(f(b)-f(a)));
        f(c)
        x=[0,1];
        
        plot([0:100],f(c))
         pause(0.1);
        b=a;
        a=c;   
    end
x=c;

end