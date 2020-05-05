function [ b_out ] = IsNumber( sig )
%Sprawdza czy podany znak jest liczba, pomija znak -
%Mozna podac do sprawdzania caly ciag np: -122.., i sprawdzony
%zostaje pierwszy znak lub pierwszy znak po wystapieniu '-'

%Dodatkowe sprawdzenie jakby sig bylo zwyczajna liczba
sig=num2str(sig);

%jezeli podamy w zapisie np. z minusem
if length(sig)>1
    %jezeli podany jest minus przed liczba
    if sig(1)=='-'
        sig=sig(2:end);
    end
    %DOPISAC OPCJE NA MINUS !!
    if(~((sig(1)<58)&&(sig(1)>47)))
        b_out=false;
        return;
    end
else
    if(~((sig<58)&&(sig>47)))
        b_out=false;
        return;
    end
end
b_out=true;