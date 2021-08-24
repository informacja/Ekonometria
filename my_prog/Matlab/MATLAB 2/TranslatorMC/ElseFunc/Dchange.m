function [ strBufC,vname_change ] = Dchange( vname_change,strBufC )
%Dchange Aktualizacja listy zmiennych vname_list
%   potrzebuje strBufC do alokacji zmiennych rozszerzonych :D
%   wa¿ne podmieñ vname_change bo nie wyzeruje!!!!!!!!!!!!
if(nargin<2||isempty(strBufC))
    strBufC={};
end
if(isempty(vname_change))
else
    for(i=1:length(vname_change))
        if(isempty(vname_change{i}))
            continue;
        end
        for(j=1:5)
            eel{j}=vname_change{i}{j};
        end
        outline=AddToNL(eel);
        if(~isempty(outline))
            strBufC{end+1}=outline;
            outline='';
        end
        eel={};
    end
    vname_change=cell(1);
end

end

