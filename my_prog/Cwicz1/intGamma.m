function p=intGamma(x,a)
eps=1.e-5;
if(x<a+1)
   ap = a;
   sum = 1/ap;
   del = sum;
   while norm(del,'inf') >= 10*eps*norm(sum,'inf')
      ap = ap + 1;
      del = x* del/ap;
      sum = sum + del;
   end
   p = sum* exp(-x + a*log(x) - gammaln(a+realmin));
   return;
end
a0 = 1; a1 = x;
b0 = 0; b1 = a0;
fac = 1;
n = 1;
g = b1;
gp = b0;
while norm(g-gp,'inf') >= 10*eps*norm(g,'inf');
      gp = g;
      ana = n - a;
      a0 = (a1 + a0*ana)* fac;
      b0 = (b1 + b0*ana)* fac;
      anf = n*fac;
      a1 = x* a0 + anf* a1;
      b1 = x* b0 + anf* b1;
      fac = 1/a1;
      g = b1* fac;
      n = n + 1;
end
p = 1 - exp(-x + a*log(x) - gammaln(a+realmin))* g;
