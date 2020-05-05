function [ bufC ] = FreeTmp( tmpList )
%Zwalnia zaalokowana pamiec przez tempy o nazwie z tmpList
%Zakladam ze podane nazwy tempow w liscie tmpList istnieja i sa zaalokowane
%IN:
%tmpList-lista z nazwami tempow
%OUT:
%buC-lista z linijkami przetlumaczonego kodu w C

global vname_list;

bufC={};
if isempty(tmpList) return; end

%jezeli podana jest lista
if iscell(tmpList)
    for i=1:length(tmpList)
        for j=length(vname_list):-1:1
            el=vname_list{j};
            %jezeli znalazlem tempa o podanej nazwie to "zwalniam" mu pamiec
            if strcmp(tmpList{i},el{1})
                bufC{end+1}=['free(',tmpList{i},');'];
                el{3}=0; el{4}=0;
                vname_list{j}=el;
            end
        end
    end
%Podana jest jedna nazwa zmiennej tymczasowej do usuniecia
else
    for i=length(vname_list):-1:1
        el=vname_list{i};
        %jezeli znalazlem tempa o podanej nazwie to "zwalniam" mu pamiec
        if strcmp(tmpList,el{1})
            bufC={['free(',tmpList,');']};
            el{3}=0; el{4}=0;
            vname_list{i}=el;
        end
    end
end

end

