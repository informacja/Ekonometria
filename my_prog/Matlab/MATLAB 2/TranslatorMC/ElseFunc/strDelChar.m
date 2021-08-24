function [ str_out ] = strDelChar( str_in, del_char )
%Funkcja usuwa podany znak z ciagu, oraz zwraca nowo utworzony ciag
%IN:
%str_in - podany ciag z ktorego usuwamy znak
%del_char - usuwany znak
%
%OUT:
%str_out - zwracany ciag znakowy bez usuwanego znaku
%WAZNE:
%Nie usuwa spacji w zapisach: [1 2 3]

%Sprawdzenie ile jest wystapien podanego znaku
ile=0;
cnaw=0;
for i=1:length(str_in)
    if (str_in(i)== del_char)&&(cnaw==0)
        ile=ile+1;
    end
    
    if(str_in(i)=='[') cnaw=cnaw+1;
    elseif(str_in(i)==']') cnaw=cnaw-1; end
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
        if(str_in(i)~= del_char)||(cnaw>0)
            str_out(j)=str_in(i);
            j=j+1;
        end
        if(str_in(i)=='[') cnaw=cnaw+1;
        elseif(str_in(i)==']') cnaw=cnaw-1; end
    end
end
end

