%Jezeli mamy jakies realokacje to uzywamy wskaznika
if(el{6}>0) 
    el{1}=['*',el{1}];
%stala tablica bo brak realokacji
else
    if(IsNumber(el{3})&&(el{3}==1)) el{1}=[el{1},'[',num2str(el{4}),']'];
    elseif(IsNumber(el{4})&&(el{4}==1)) el{1}=[el{1},'[',num2str(el{3}),']'];
    else el{1}=[el{1},'[',num2str(el{3}),'][',num2str(el{4}),']'];
    end
end