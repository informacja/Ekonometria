function [x] = sieczne(a, b)
    f = @(x)x^3 + x^2 - 1;
    eps = 0.00001;
    c = b - f(b) * (b - a) / (f(b) - f(a));
    while abs(f(c)) > eps
        c = b - f(b) * (b - a) / (f(b) - f(a));
        b = a;
        a = c;
    end;
    x = c;
end