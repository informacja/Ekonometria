syms x
licznik = x^5 + 7*x^3 + x - 1;
mianownik = 3*x^6 - x^2 + 3;
f = licznik / mianownik;
subs(f,2);

syms omega t;
f = sin(omega * t);
%disp(diff(f,t,2));

%syms x
%disp(limit(tan(x), x, 0, 'right'));

disp(limit((2*sin(x)^2+sin(x)-1)/(2*sin(x)^2 - 3*sin(x) + 1), x, pi/6));
disp(int(5*x^2-6*x+3-2/x+5/x^2));
disp(int(sin(x)^5*cos(x)));

x = solve('a*x^2 + b*x +c = 0');
simplify(x);