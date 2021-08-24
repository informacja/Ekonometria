function [ b, fidx ] = strInOp( fstr, sstr, exOp)
%STRINOP sprawdza czy ciag fstr jest w stringu operacji sstr
%IN:
%fstr - szukany ciag znakowy
%sstr - przeszukiwany ciag z operacjami
%exOp - dodatkowe dzialania funkcji:
%       1 - uznaje przecinki jako operatory  
%OUT:
%b - zwraca 1 jezeli szukany ciag jest w przeszukiwanym
%fidx - pozycja pierwszego znalezionego elementu

if(nargin<3) exOp=0; end
b=false;
fidx=0;
if(iscell(fstr)||iscell(sstr)) return; end;
for i=1:(length(sstr)-length(fstr)+1) 
    %Sprawdzam czy ZmWyn wystepuje w obliczeniach
    if(strcmp(fstr,sstr(i:(i-1)+length(fstr))))
        if(exOp)
            if(((i-1)>0)&&(~IsOperator(sstr(i-1))&&(sstr(i-1)~=','))) continue; end
            if(((i+length(fstr))<length(sstr))&&(~IsOperator(sstr(i+length(fstr)))&&(sstr(i+length(fstr))~=','))) continue; end
        else
            if(((i-1)>0)&&~IsOperator(sstr(i-1))) continue; end
            if(((i+length(fstr))<length(sstr))&&~IsOperator(sstr(i+length(fstr)))) continue; end
        end
        b=true; fidx=i; break;
    end
 end
end

