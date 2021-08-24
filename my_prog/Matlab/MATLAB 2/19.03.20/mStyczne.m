function rv = mStyczne(f,a,b)
% parmaetry domyœlne
a = 0;
b = 4;
f = @(x)x^3+x^2-1;

z = a:0.1:b;

eps = 0.001;

f=@(x)x^3+x^2-1;
% c=a-f(a)*((b-a)/(f(b)-f(a)));
 c=b-f(b)*((b-a)/(f(b)-f(a)));

 syms a
 
while abs(f(c))>eps    
    a =b;
    b=c;
    fp = diff(f);
    c=a-(f(a)/diff(f(a)));
%     f(c);
%     b=a;
%     a=c;   
     plot(f(z))
end