function rv = mSieczne(f,a,b)
a = 0;
b = 4;
f = @(x)x^3+x^2-1;

przedzial = [a,b];
% z = a:0.1:b;
eps = 0.0000001;

c=b-f(b)*((b-a)/(f(b)-f(a)));

 
 %próbowa³em liczyæ i rysowaæ funkcjê, ale jest ezplot :)
%  z= [a,b];
%  x = z 
%  for i = 1:0.1:b
%  x(i) = f(x(i));
% 
%  plot(x,z)
%  pause(1)

while abs(f(c))>eps    
    a =b;
    b=c;
    c=b-f(b)*((b-a)/(f(b)-f(a)));

    ezplot(f,przedzial);
    hold on   
    grid on
    fz = [a,f(b)];
    plot(fz);
    pause(0.01);
    hold off;
    
end
rv = c;

hold on

ezplot(f, przedzial)
z= [a,b];
fz = [a,f(b)];
plot(fz)

scatter(c,0)    % ma zaznaczyæ miejsce zerowe, chyba mam zamienione osie x z osi¹ y ?

end

