function [ out_type ] = GetType( str )
%Funkcja zwraca typ podanego ciagu znakowego, np.
% '1.222' - double
% 'A' - char
% '-200 - long int

%Edit: 
%-Poprawnie okresla liczby ujemnych
%-Poprawnie okresla liczby transponowane
%-Dodane ze wszystkie liczby sa double
global opt;

out_type='';
%pomijam zapis 12' 
if(str(end)==39) str=str(1:(end-1)); end
for i=1:length(str)
    if(str(i)=='.')&&(~isnan(str2double(str))) 
        out_type='double';
        return;
    end
end
%sprawdzam czy jest to liczba calkowita
%str2double jest szybsze nic str2num
t=str2double(str);
if ~isempty(t)
%     t=int64(t);
%     if(t<129)&&(t>-128)
%         out_type='char';
%     else
%         out_type='long int';
%     end
    %Proste tlumaczenie jest wlaczone
    if(opt.implicit)
        out_type='long int';
    else
        out_type='double';
    end
    return;
end
%sprawdzam czy podany jest znak
if ischar(str)
    out_type='char';
end

end

