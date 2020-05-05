%Sprawdzam czy globalna
if((length(el)>8)&&el{9}==1)
    %Najpierw sprawdzam czy samo tGlobal jest puste, bo moze
    %wczesniej nie zostalo nic zapisane do listy, a pozniej czy
    %podany podelement listy jest pusty
    if(nGInL==nInLine) tGlobal{end}(end)=';'; tGlobal{end+1}=''; nGInL=0; end;
    if(isempty(tGlobal)) tGlobal{1}=tType;
    elseif(isempty(tGlobal{end})) tGlobal{end}=tType; end
    tGlobal{end}=[tGlobal{end} el{1} ','];
    nGInL=nGInL+1;
%Zwyczajna zmienna
else
    if(nVInL==nInLine) tVar{end}(end)=';';  tVar{end+1}=''; nVInL=0; end;
    if(isempty(tVar))  tVar{1}=tType;
    elseif(isempty(tVar{end})) tVar{end}=tType; end
    tVar{end}=[tVar{end} el{1} ','];
    nVInL=nVInL+1;
end

if(j==1) vname_list={vname_list{2:end}};
else vname_list={vname_list{1:j-1} vname_list{j+1:end}};
end