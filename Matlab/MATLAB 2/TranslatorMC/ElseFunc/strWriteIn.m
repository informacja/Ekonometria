function [ outstr ] = strWriteIn( string,gdzie,oco )
%strWriteIn funkcja rozszerzaj¹ca string o dowolny gi¹g znaków 

Lstr=length(string);
if(gdzie>Lstr)
    outstr=[string oco];
else
    temp='';
    for(i=1:gdzie)
        temp=[temp string(i)];
    end
    temp=[temp oco];
    Loco=length(oco);
    for(i=gdzie+Loco:Lstr)
        temp=[temp string(i)];
    end
    outstr=temp;
end
end