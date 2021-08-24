function IncEl(nE,idxA)
%INCEL inkrementuje atrybut o podaynm indeksie elementu o podanej nazwie
%w liscie vname_list
%IN:
%nE - nazwa elementu
%idxA - indeks atrybutu
global vname_list;

for i=length(vname_list):-1:1
    if(strcmp(nE,vname_list{i}{1})) vname_list{i}{idxA}=vname_list{i}{idxA}+1;  break; end
end
end

