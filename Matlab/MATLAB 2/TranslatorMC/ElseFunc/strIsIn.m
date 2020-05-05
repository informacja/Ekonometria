function [ b, idx] = strIsIn( strWhat, strSrch )
%STRISIN sprawdza czy podany znak jest w stringu
%Narazie sprawdza tylko pojdeyncze znaki
%IN: 
% strWhat - co szukam
% strSrch - w czym szukam
%OUT:
% b - czy znaleziono, 0/1
% idx - pozycja znalezionego elementu w strSrch
b=false;
idx=0;
if(length(strWhat)==1)
    for i=1:length(strSrch)
        if strWhat==strSrch(i)
            b=true;
            idx=i;
            return;
        end
    end
end

end

