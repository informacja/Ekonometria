function [a]=sortq(a)
global b;
b=a;
N=length(b);
sortqq(1,N)
a=b;
end

function sortqq(od,do)
global b;
if od<do
    baza=b(od);
    m=od;
    for i=od+1:1:do
        if b(i)<baza 
            m=m+1;
            temp=b(i);
            b(i)=b(m);
            b(m)=temp;
        end
    end
    b(od)=b(m);
    b(m)=baza;
    sortqq(od,m-1);
    sortqq(m+1,do);
end
end


