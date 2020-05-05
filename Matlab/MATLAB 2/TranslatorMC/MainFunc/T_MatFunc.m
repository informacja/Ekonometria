function [ lN_out, stmpIdx_out, strBufC_out] = T_MatFunc(str, lEl, stmpIdx)
%T_MATFUNC - Translacja podstawowych funkcji Matlaba na makrodefinicje lub
%            funkcje

global vname_list kod;

if(nargin<3) stmpIdx=0; end
lN_out=[];
stmpIdx_out=stmpIdx;
strBufC_out={};
strBufC={};
% tmpList={};
lNe='';
while 1
    if(strcmp(str,'fprintf')||strcmp(str,'printf'))
        %jezeli mam zapis fprintf(1,'..',..) to pomijam pierwszy element
        s=1; %Od ktorego elementu startuje, wyzej opisane
        if(lEl{2}(1)==39) s=2; else s=3; end;
        tB=['fprintf(stderr,"',lEl{s}(2:end-1),'"'];
        for i=3:length(lEl) tB=[tB,',',lEl{i}]; end
        tB=[tB,');'];
        strBufC={strBufC{1:end} tB};
        stmpIdx=stmpIdx-1;
        break;
    end
    %Jezeli nie jest to  wypisanie fprintf to tworzymy wartosc zwracana:
    %Przyjmuje ¿e tutaj lista ma tylko 2 elementy
    lNe=lEl{1};
    lEl={lEl{2:end}}; %Wczesniej uzywalem tylko jednego elementu na liscie,
                   %wiêc tak zostawiam ¿eby nic nie zmieniaæ w kodzie
    if(strcmp(str,'sum'))
        [b, elA]=GetFromNL(lEl{1},vname_list);
        if((~b)&&IsNumber(lEl{1})) elA={lEl{1} GetType(lEl{1}) 1 1 1};
        elseif(b&&~strcmp(elA{1},lEl{1})) elA{1}=lEl{1}; %Sprawdzam czy nie podana jest transpozycja
        elseif(~b) return; end; %nic nie znalazlem
        
        %lNe=['temp' num2str(stmpIdx)];
        %warunek rozmiaru zwrotu, sum dziala sumujac po wierszach
        if((elA{3}>1)&&(elA{4}>1))t=AddToNL({lNe,elA{2},1,elA{4},0});
        else t=AddToNL({lNe,elA{2},1,1,1}); end
        if(~isempty(t))
            if isempty(strBufC) strBufC={t};
            else strBufC={strBufC{1:end} t}; end
        end
        %jezeli jest wektor to podaje go poziomo
        if(elA{4}>1&&elA{3}==1) t=elA{3}; elA{3}=elA{4}; elA{4}=t; end
        %SUM(W,A,srA,scA,tW,tA)
        tB=['SUM(',lNe,',',elA{1},',',num2str(elA{3}),',',num2str(elA{4}),...
            ',',elA{2},',',elA{2},');'];
        strBufC={strBufC{1:end} tB}; 
        break;%Wyjscie z switcha
    end
    if(strcmp(str,'length'))
        %LENGTH(W,A,srA,scA)
        [b, elA]=GetFromNL(lEl{1},vname_list);
        if((~b)&&IsNumber(lEl{1})) elA={lEl{1} GetType(lEl{1}) 1 1 1};
        elseif(b&&~strcmp(elA{1},lEl{1})) elA{1}=lEl{1}; %Sprawdzam czy nie podana jest transpozycja
        else return; end; %nic nie znalazlem
        
        %lNe=['temp' num2str(stmpIdx)];
        t=AddToNL({lNe,elA{2},1,1,1});
        if(~isempty(t))
            if isempty(strBufC) strBufC={t};
            else strBufC={strBufC{1:end} t}; end
        end
        tB=['LENGTH(',lNe,',',elA{1},',',num2str(elA{3}),',',num2str(elA{4}),');'];
        strBufC={strBufC{1:end} tB};
        break;%Wyjscie z switcha
    end
    if(strcmp(str,'ones')||strcmp(str,'zeros')||strcmp(str,'eye'))        
        %lNe=['temp' num2str(stmpIdx)];
        %sprawdzm czy mozna przeprowadzic str2num
        for i=1:2
            if(~isnan(str2num(lEl{i}))) lEl{i}=str2num(lEl{i}); 
            else
                [b,t]=TakeValMat(kod,lEl{i});
                if(~b)    
                    warning('T_MatFunc, Nie ma zmiennej:%s',lEl{i});
                    return;
                end
                lEl{i}=t;
            end
        end
        t=AddToNL({lNe,'double',lEl{1},lEl{2}});
        if(~isempty(t))
            if isempty(strBufC) strBufC={t};
            else strBufC={strBufC{1:end} t}; end
        end
        %ONES/ZEROS/EYE(W,srW,scW,tW)
        if(length(lEl)>1)
            tB=[upper(str),'(',lNe,',',num2str(lEl{1}),',',num2str(lEl{2}),...
                ',double);']; %zawsze na sztywno double
        else
            tB=[upper(str),'(',lNe,',',num2str(lEl{1}),',',num2str(lEl{1}),...
                ',double);']; %zawsze na sztywno double
        end
        strBufC={strBufC{1:end} tB}; 
        break;%Wyjscie z switcha
    end
    if(strcmp(str,'sqrt')||strcmp(str,'exp'))
        %SQRT/EXP(W,A,srA,scA,tW,tA);
        lDefN=str;
        [b, elA]=GetFromNL(lEl{1},vname_list);
        if((~b)&&IsNumber(lEl{1})) elA={lEl{1} 'double' 1 1 1}; b=1;
        elseif(b&&~strcmp(elA{1},lEl{1})) elA{1}=lEl{1}; %Sprawdzam czy nie podana jest transpozycja
        elseif(~b) return; end; %nic nie znalazlem
        
        %lNe=['temp' num2str(stmpIdx)];
        %Podana macierz/wektor
        if(elA{3}>1||elA{4}>1)
            t=AddToNL({lNe,elA{2},1,1,1});
            if(~isempty(t))
                if isempty(strBufC) strBufC={t};
                else strBufC={strBufC{1:end} t}; end
            end
            tB=[upper(lDefN),lNe,',',elA{1},',',num2str(elA{3}),',',num2str(elA{4}),',double,',elA{2},');'];
            strBufC={strBufC{1:end} tB};
        %Podana satal/zmienna
        else
            t=AddToNL({lNe,elA{2},1,1,1});
            if(~isempty(t))
                if isempty(strBufC) strBufC={t};
                else strBufC={strBufC{1:end} t}; end
            end
            tB=[lNe,['=' lower(lDefN) '('],elA{1},');'];
            strBufC={strBufC{1:end} tB};
        end
        break;
    end
    if(strcmp(str,'inv'))
        %INV/SQRT(W,A,srA,scA,tW,tA);
        lDefN='INV(';
        [b, elA]=GetFromNL(lEl{1},vname_list);
        if((~b)&&IsNumber(lEl{1})) elA={lEl{1} GetType(lEl{1}) 1 1 1};
        elseif(b&&~strcmp(elA{1},lEl{1})) elA{1}=lEl{1}; %Sprawdzam czy nie podana jest transpozycja
        else return; end; %nic nie znalazlem
        
        %lNe=['temp' num2str(stmpIdx)];
        t=AddToNL({lNe,elA{2},1,1,1});
        if(~isempty(t))
            if isempty(strBufC) strBufC={t};
            else strBufC={strBufC{1:end} t}; end
        end
        tB=[lDefN,lNe,',',elA{1},',',num2str(elA{3}),',',num2str(elA{4}),',double,',elA{2},');'];
        strBufC={strBufC{1:end} tB};
        break;
    end
end

stmpIdx_out=stmpIdx;
strBufC_out=strBufC;
lN_out=lNe;
end