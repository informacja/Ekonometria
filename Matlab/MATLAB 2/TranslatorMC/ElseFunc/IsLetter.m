function [ b_out ] = IsLetter( sig )
%Funkcja sprawdza czy podany znak jest litera, pomija znak -
%Mozna podac do sprawdzania caly ciag np: -Ala.., i sprawdzony
%zostaje pierwszy znak lub pierwszy znak po wystapieniu '-'
%Dodatkowo traktuje jako litere znak '_', - Zrobiono tylko na potrzeby
%SortOp bo g³upio mi wyszukiwalo
if length(sig)>1
    %pomijam znak '-'
    if sig(1)=='-'
        sig=sig(2:end);
    end
    if ~(((sig(1)>64)&&(sig(1)<91))||((sig(1)>96)&&(sig(1)<123))||sig(1)=='_')
        b_out=false;
        return;
    end
else
    if ~(((sig>64)&&(sig<91))||((sig>96)&&(sig<123))||sig=='_')
        b_out=false;
        return;
    end
end
b_out=true;
end

