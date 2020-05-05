function [ ret ] = IsInList( what, in )
%Funckja sprawdza czy cos jest w czyms
ret=0;
length(in)
for i=1:length(in)
    if isequal(what,in{i})
        ret=1;
        return;
    end
end

