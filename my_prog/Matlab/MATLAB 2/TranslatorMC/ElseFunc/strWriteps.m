function [ outline ] = strWriteps( line,kropst,koniec,eps )
%StrWriteps-> potrzebuje jakis tekst zapisany w line iraz miejsce kropki w
%nim umiejscowione. nastêpnie wyszukuje wstecz od kropki liczby i nastêpnie
%zamiena od znalezionego poczotku(koniec liczb od kropki) do koniec na
%interpretacje eps
%   line-string bazowy | kropst-pozycja kropki | 
%   koniec-koniec interpretacji | eps-tam jaki tam eps jest |
%   outline-zmieniony line

Lline=length(line);
liczba=''; reszta='';
frac=0; MLliczba=0; bigfrac=0;
if(kropst>Lline|| koniec>Lline|| isempty(eps))
    outline='';
end

for(i=kropst-1:-1:1)%nie do 1
    if(IsLike(line(i),'%l#1 2 3 4 5 6 7 8 9 0#'))
        liczba=[line(i) liczba];
    else
        reszta=[reszta line(i)];%break;
    end
end
if(length(liczba)==1&&liczba(1)~='0')
    bigfrac=1;
end
MLliczba=length(liczba);
if(IsLike(liczba(1),'%l#1 2 3 4 5 6 7 8 9 0#'))
%     if(liczba(1)=='0')
%         Lliczba=Lliczba+1;
%     end
    qaz=1;
    if(IsLike(line(kropst+1),'%l#1 2 3 4 5 6 7 8 9#'))
        frac=1;%mam u³amek
    for(i=kropst-1:1:Lline)
        if(IsLike(line(i),'%l#1 2 3 4 5 6 7 8 9#')&&qaz==1)
            liczba=[liczba line(i)];
        elseif(line(i)=='e')
            qaz=0;
            break;
        end
    end
    end
end
Lliczba=length(liczba);
%eps
if(eps(1)=='-')
    znak=0;
else
    znak=1;
end
if(length(eps)>1)
    eps(1)='';
end
e=str2num(eps)+1;
if(frac==1)
    liczba(MLliczba)='';
end
if(frac==1&&znak==0)
    %Lliczba=MLliczba;
    %e=e+Lliczba;
    e=e+MLliczba-1;
end
if(znak==0)%do przodu
    %strDelChar(line,'.');
    for(i=2:Lliczba)
        if(liczba(i)=='0'&&liczba(i-1)=='0')
            liczba(i)='';
            e=e-1;
        end
        if(i+1>length(liczba))
            break;
        end
    end
    if(Lliczba>e)
        przes=Lliczba-e;
        liczba=strWriteIn(liczba,przes,'.');
    else
        e=e-Lliczba+1;
        if(bigfrac==1)
            e=e-1;
        end
        while(e>0)
            liczba=['0' liczba];
            e=e-1;
        end
        
       liczba=strWriteIn(liczba,1,'.');
    end
else%do ty³u
    if(MLliczba>0&& MLliczba~=Lliczba)
        MLliczba=MLliczba-1;
        e=e-MLliczba;
    end
    if(frac==1)
        e=e-1;
    end
    while(e>0)
        liczba=[liczba '0'];
        e=e-1;
    end
end
outline=liczba;
%outline=reszta;
end
