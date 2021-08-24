function [ out ] = strlink( str1,str2 )
%laczenie dwuch stringow w jeden
Lstr1=length(str1);
Lstr2=length(str2);
out=str1;
for(i=1:Lstr2)
    out(i+Lstr1)=str2(i);
end
end

