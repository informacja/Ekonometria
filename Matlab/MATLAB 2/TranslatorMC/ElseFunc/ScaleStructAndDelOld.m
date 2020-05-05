%Dodanie nazwy nowej struktury
lStuc{j}{1}={lStuc{j}{1}{1:end} lStuc{k}{1}{1:end}};
%Dodanie nowych pol i aktualizacja starych
%Aktualizacja polega na dodaniu informacji o
%realokacji, przypisaniach i zmianach typu
for l=1:length(lStuc{k}{2})
    bFind=0;
    for m=1:length(lStuc{j}{2})
        %Porownuje nazwy pol struktur
        if(strcmp(lStuc{j}{2}{m}{1},lStuc{k}{2}{l}{1}))
            bFind=m; break;
        end
    end
    %znalazlem pasujace pole, aktualizuje
    %parametry 
    if(bFind)
        lStuc{j}{2}{l}{6}=lStuc{j}{2}{l}{6}+lStuc{k}{2}{bFind}{6};
        lStuc{j}{2}{l}{7}=lStuc{j}{2}{l}{7}+lStuc{k}{2}{bFind}{7};
        lStuc{j}{2}{l}{8}=lStuc{j}{2}{l}{8}+lStuc{k}{2}{bFind}{8};
        %Jezeli roznia sie typami stala/macierz
        if(lStuc{j}{2}{l}{5}~=lStuc{k}{2}{bFind}{5}) lStuc{j}{2}{l}{6}=lStuc{j}{2}{l}{6}+1; end
        %Jezeli typy pol sie roznia
        if(~strcmp(lStuc{j}{2}{l}{2},lStuc{k}{2}{bFind}{2})) 
            lStuc{j}{2}{l}{7}=lStuc{j}{2}{l}{7}+1;
            lStuc{j}{2}{l}{2}='void';
        end
    %Nie znalazlem pola, dodaje je
    else
        lStuc{j}{2}={lStuc{j}{2}{1:end} lStuc{k}{2}{l}};
    end
end
%jezeli podane sa ustawienia laczace w  rozne typy to musze
%zaktualizowac liste vname_list
if(opt.conStructWithSameNField||opt.conStructInBigest)
    %Po nazwach struktur
    for l=1:length(lStuc{j}{1})
        %Po polach struktur
        for m=1:length(lStuc{j}{2})
            [b,elA,idx]=GetFromNL([lStuc{j}{1}{l},'.',lStuc{j}{2}{m}{1}],vname_list);
            if(b)
                if(elA{6}<lStuc{j}{2}{m}{6}) vname_list{idx}{6}=lStuc{j}{2}{m}{6}; end
                if(elA{7}<lStuc{j}{2}{m}{7}) vname_list{idx}{7}=lStuc{j}{2}{m}{7}; end
            end
        end
    end
end
%usuwam dodana strukture
lStuc={lStuc{1:k-1} lStuc{k+1:end}};