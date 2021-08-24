function [ err ] = WLFunc2F( lTC, name )
%WLFUNC2F zapisuje podana liste z kodem funkcji do pliku

global gInDen;

gInDen=0;
err=0;

fw=fopen(name,'w');
%nie otwarto pliku
if fw==-1
    err=1;
    return;
end
for i=1:length(lTC)
    for j=1:length(lTC{i})
        %Jezeli mam pusta linijke to wstawiam spacje
        if(isempty(lTC{i}{j})) lTC{i}{j}=' '; end
        if(lTC{i}{j}(end)=='{') 
            WriteLine(fw,lTC{i}{j});
            gInDen=gInDen+1;
            continue;
        elseif(lTC{i}{j}(end)=='}'||lTC{i}{j}(1)=='}') 
            if(gInDen>0) gInDen=gInDen-1; end
            WriteLine(fw,lTC{i}{j});
            continue;
        end
        WriteLine(fw,lTC{i}{j});
    end
end
fclose(fw);
end

