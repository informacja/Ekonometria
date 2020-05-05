function [ outputstr ] = strconn( str1,str2 )
%?aczenie 2 string?w
%[ qweqwe qweqwe]
strL1=length(str1);
strL2=length(str2);
rozm=strL1+strL2;
outputstr=str1;

for(i=strL1+1:rozm)
    outputstr(i)=str2(i-strL1);
end
end


