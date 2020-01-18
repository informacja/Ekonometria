clc

% ZADANIE 1

% rownanie a)
x=[0 20];
y0=[1 1];
[X, Y]=ode45(@row_a,x,y0);
plot(X,Y(:,1))
grid on
xlabel('x')
ylabel('y')
title('Rownanie a')

% rownanie b)

x=[0 20];
y0=[0 0];
[X, Y]=ode45(@row_b,x,y0);
figure;
plot(X,Y(:,1))
grid on
xlabel('x')
ylabel('y')
title('Rownanie b')

% ZADANIE 2

global m l g
m=0.2;
l=0.5;
g=9.81;
t=[0 5];
y0=[3*pi/4 0];

[T, Y] = ode45(@osc,t,y0);
figure;
plot(T,Y(:,1))
grid on
xlabel('t')
ylabel('y')
title('DRGANIA WAHADLA W CZASIE');

figure;
plot(Y(:,1),Y(:,2))
grid on
xlabel('y')
ylabel('dy/dt')
title('WYKRES FAZOWY')
