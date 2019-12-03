function p=chi2distr(x,v)
 if(x<=0 |v<0.1) p=0; return; end
 p = intGamma(x/2,v/2);
