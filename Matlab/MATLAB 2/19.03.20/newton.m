function [ x0 ] = newton(g, x0)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
eps = 0.0001;
f = feval(g, x);
df = diff(feval(g, x));
syms x;
x1 = x0 - 1;
f0 = f(x0);
i = 64;
while i > 0 && abs(x1 - x0) > eps && abs(f0) > eps
    f1 = df(x0);
    if abs(f1) < eps
        disp('zly punkt startowy')
        break;
    end;
    if abs(f1) > eps 
        x1 = x0;
        x0 = x0 - f0 / f1;
        f0 = f(x0);
    end;
    i = i - 1;
end;
end

