function [ b_out, val ] = IsOperator( str, bBr)
%Funkcja do sprawdzania czy podany znak/znaki to operator, mozliwa opcja
%pomijania nawiasow i trakotowania jako normalne znaki
%IN:
%str - znak lub 2 znaki wejsciowe operatora
%bBr - jezeli true to nawiasy nie sa operatorami
%OUT:
%b_out - prawda jezeli znak jest operatorem
%val - wartosc znaku w obliczeniach

%Edit: 
%-Dodanie operatora ':' jako C_LVL_0
%-Dodanie operatora ''' jako C_LVL_0 'Transpozycja'

% 0 - nawiasy: (,),:,'
C_LVL0=0;
% ^, .^  logika: <,>
C_LVL1=1;
% *, /, \, .*, .\, ./
C_LVL2=2;
% +,-
C_LVL3=3;

if(nargin<2) bBr=false; end

if length(str)>1
    sig=str(1);
    sig2=str(2);
else
    sig=str(1);
end
val=-1;
b_out=false;
if(iscell(str)) return; end;

if(~bBr)
    %Length dolozony do sprawdzania czy nie jest podane: -C -12 -3.2 itp.
    if((sig=='+')||(sig=='-')&&(length(str)<2))
        val=C_LVL3;
        b_out=true;
    elseif((sig=='\')||(sig=='/')||(sig=='*'))
        val=C_LVL2;
        b_out=true;
    elseif((sig=='.')&&(length(str)>1))
        if((sig2=='*')||(sig2=='/')||(sig2=='\'))
            val=C_LVL2;
            b_out=true;
        elseif(sig2=='^')
            val=C_LVL1;
            b_out=true;
        end
    elseif(sig=='^'||sig=='>'||sig=='<')
        val=C_LVL1;
        b_out=true;
    elseif((sig=='(')||(sig==')')||(sig==':')||(sig==39))
        val=C_LVL0;
        b_out=true;
    end
else
    %Length dolozony do sprawdzania czy nie jest podane: -C -12 -3.2 itp.
    if((sig=='+')||(sig=='-')&&(length(str)<2))
        val=C_LVL3;
        b_out=true;
    elseif((sig=='\')||(sig=='/')||(sig=='*'))
        val=C_LVL2;
        b_out=true;
    elseif((sig=='.')&&(length(str)>1))
        if((sig2=='*')||(sig2=='/')||(sig2=='\'))
            val=C_LVL2;
            b_out=true;
        elseif(sig2=='^')
            val=C_LVL1;
            b_out=true;
        end
    elseif(sig=='^'||sig=='>'||sig=='<')
        val=C_LVL1;
        b_out=true;
    elseif((sig==':')||(sig==39))
        val=C_LVL0;
        b_out=true;
    end    
end;
end

