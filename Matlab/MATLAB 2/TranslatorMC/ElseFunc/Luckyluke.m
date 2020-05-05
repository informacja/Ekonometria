function [ outwhos, mat] = Luckyluke( list,kod )
%Debuger kodu + zapis 
%list->jako jedna instrukcja kod->plikmat

if(nargin>2)
    load(kod);
end
if(~isempty(list))
    load(kod);
    try
        eval([list ';']);
    catch e
        warning('Problem eval!\n W Lini: %s\n Error: %s',list,e.message);
    end;
    clear list kod e
    save('imagekey.mat');
    outwhos=whos();
else
    load(kod);
    clear list kod
    outwhos=whos();
    save('imagekey.mat');
end
mat='imagekey.mat';
end

