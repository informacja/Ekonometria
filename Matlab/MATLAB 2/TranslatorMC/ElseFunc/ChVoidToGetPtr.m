%Wiele razy wykorzystywany fragment przy zamianie void* na GetPtr(..)
for j=1:nEl
    if(tEl{j}=='C')
        [pusty,tmpEl]=GetFromNL(lEl{j});
        if(~isempty(tmpEl)&&((IsTmpN(lEl{j}))||(tmpEl{6}>0))) 
            if(~bCh) bCh=true; end 
            %Sprawdzam czy mam podane typy elementow, jezeli jest inaczej
            %to prawdopodobnie jest to jakis blad, ale wyrzucam tylko
            %ostrzezenie 
            if(j<=length(typeEl))
                if(lEl{j}(1)=='-') lEl{j}=['-GetPtr(',lEl{j}(2:end),',',typeEl{j},')'];
                else lEl{j}=['GetPtr(',lEl{j},',',typeEl{j},')']; end
            else
                %WARNING: TO JEST DO DEBUGOWANIA
                %warning('Przy optymalizacji, w ChVoidGetPtr, odwoluje sie do typu wartosci zwaracanej a nie jest on pobrany z definicji');
                if(lEl{j}(1)=='-') lEl{j}=['-GetPtr(',lEl{j}(2:end),',',tmpEl{2},')'];
                else lEl{j}=['GetPtr(',lEl{j},',',tmpEl{2},')']; end
            end
        end
    end
end