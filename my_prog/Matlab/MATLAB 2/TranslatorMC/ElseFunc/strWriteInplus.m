function [ outstr ] = strWriteInplus( string,gdzie,oco )
%strWriteIn funkcja rozszerzaj�ca string o dowolny gi�g znak�w 

Lstr=length(string);
if(gdzie>Lstr)
    outstr=[string oco];
else
    temp='';
    for(i=1:gdzie-1)
        temp=[temp string(i)];
    end
    temp=[temp oco];
    Loco=length(oco);
    for(i=gdzie+1:Lstr)
        temp=[temp string(i)];
    end
    outstr=temp;
end
end

