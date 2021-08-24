function [ outputstr ] = strconnmod( str1,str2,go )
%wstawianie jednego stringa w drugi 
%str1->bazowy | str2-> wstawiany string | go-> gdzie wstawiamy str2 punkt
%startowy
strL1=length(str1);
strL2=length(str2);
rozm=strL1+strL2;
for(i=1:go)
outputstr(i)=str1(i);
end
j=1;
for(i=go:rozm)
    outputstr(i)=str2(j);
    j=j+1;
    if(j>strL2)
        break;
    end
end
for(i=go:strL1)
outputstr=[outputstr str1(i)];
end
end

