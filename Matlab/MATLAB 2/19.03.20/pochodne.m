syms omega x
f = @(x)x^3+2;
r = diff(f,x,2) % pochodna 2-ga
ezplot(r);

limit( (tg(5*x) / tg(x)) , x, 0)


