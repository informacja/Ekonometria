function [ bAdd, val, lTC] = FDefConst(el, lTC)
%FDEFCONST Funkcja szukajaca definicje stalych w liscie przetlumaczonego
%kodu w C
%IN:
% el - wyszukiwany element
% lTC - lista do przeszukiwania
%OUT:
% bAdd - czy znalazlem przypisanie do dodania
% val - wartosci stalej

global opt defMalloc;

val='';
bAdd=false;
lEl={};
bCheckEnd=false; 
[pusty,nB]=size(lTC);
for nnB=1:nB
    k=1;
    while(k<=length(lTC{nnB}))
        str=lTC{nnB}{k};
        %Jezeli mam zapis EqCC..
        if(isempty(lTC{nnB}{k})||isempty(lTC{nnB}{k}(1)=='/')) k=k+1; continue; end;
        if((lTC{nnB}{k}(1)=='E')&&(length(lTC{nnB}{k})>3)&&strcmp(lTC{nnB}{k}(1:4),'EqCC'))
            [~,lEl]=GetElFromDef(lTC{nnB}{k},1);
            %Jezeli znalazlem EqCC(el{1},..)
            if(strcmp(lEl{1},el{1}))
                if(IsNumber(lEl{2}))
                    %sprawdzam czy opcja
                    %komentowania usuwanego kodu jest wlaczona
                    if(opt.commentInOpty) lTC{nnB}{k}=['// Dodanie stalej: ',lTC{nnB}{k}(1:end)];
                    %Jezeli opcja komentowania jest wylaczona
                    else lTC{nnB}={lTC{nnB}{1:k-1} lTC{nnB}{k+1:end}}; end
                    bAdd=true;
                end
                bCheckEnd=true;
                break;
            end
        %Jezeli mam zapis A=10;    
        elseif((length(lTC{nnB}{k})>length(el{1}))&&IsLike(lTC{nnB}{k}(1:length(el{1})+1),[el{1} '%s=']))
            if(IsLike(lTC{nnB}{k},['%s=' defMalloc '%s'])) k=k+1; continue; end
            %znalazlem przypisanie:
            [b,idx]=strIsIn('=',lTC{nnB}{k});
            if(b&&~isnan(str2double(lTC{nnB}{k}(idx+1:end-1))))
                lEl{2}=lTC{nnB}{k}(idx+1:end-1);
                %sprawdzam czy opcja
                %komentowania usuwanego kodu jest wlaczona
                if(opt.commentInOpty) lTC{nnB}{k}=['//',lTC{nnB}{k}(1:end)];
                %Jezeli opcja jest wylaczona
                %k-2 zeby usunac dodatkowe //Trans: ..
                else lTC{nnB}={lTC{nnB}{1:k-2} lTC{nnB}{k+1:end}}; 
                end
                bAdd=true;
            end
            bCheckEnd=true;
            break;
        end
        k=k+1;
    end
    if(bCheckEnd) break; end;
end

if(bAdd) val=lEl{2}; end
end

