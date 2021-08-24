function [  ] = typizer( linia )
%funkcja sprawdzaj¹ca typ danych tylko na podstawie podgl¹du kodu .m
%   aktualizacja globalnej listy zmiennych

global vname_list Lname
rozmiar=length(linia);
for(i=1:rozmiar)
    if(linia(i)=='=')
        istot(1)=i;
    elseif(linia(i)=='+')
        istot(2)=i;
    elseif(linia(i)=='-')
        istot(3)=i;
    elseif(linia(i)=='*')
        istot(4)=i;
    elseif(linia(i)=='/')
        istot(5)=i;
    end
end
buf=strcopy(
end

