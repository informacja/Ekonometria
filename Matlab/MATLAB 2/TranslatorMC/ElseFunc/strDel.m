function [ str_out ] = strDel( str_in, del_char )
%Funkcja usuwa podany znak z ciagu, oraz zwraca nowo utworzony ciag
%IN:
%str_in - podany ciag z ktorego usuwamy znak
%del_char - usuwany znak
%
%OUT:
%str_out - zwracany ciag znakowy bez usuwanego znaku

%Sprawdzenie ile jest wystapien podanego znaku
ile=0;
for i=1:length(str_in)        
    if str_in(i)== del_char
        ile=ile+1;
    end
end
%jezeli ile==0 to nie ma szukanego znaku, nic nie robimy
if ile==0
    str_out=str_in;
else
    %tworze bufor zwracany
    str_out=str_in(1:length(str_in)-ile);
    %tworze ciag wynikowy
    j=1;
    for i=1:length(str_in)
        if str_in(i)~= del_char
            str_out(j)=str_in(i);
            j=j+1;
        end
    end
end
if(i>3)
    loop='for';
    tloop=[str_out(1) str_out(2) str_out(3)];
    if(strcmp(loop,tloop))
        str_out=strWriteIn(str_out,3,' ');
    end
end
if(i>2)
    loop='if';
    tloop=[str_out(1) str_out(2)];
    if(strcmp(loop,tloop))
        str_out=strWriteIn(str_out,2,' ');
    end
end        
end

