function [ lTC ] = T_MatTrans( lTC, fpath)
%T_MATTRANS Tlumaczy podany skrypt Matlaba(m-plik)
%IN:
%lTC - lista z juz przetlumaczonym kodem(mam nadzieje ze sie poda przez
%      referencje)
%fpath - sciezka do tlumaczonego skryptu
%OUT:
%lTC - wynikowa lista z przetlumaczonym kodem
global fname_list gInLoop opt vname_change vname_list mypwd defCLine defCBS defCBE;

fw=fopen(fpath,'r');
if(fw==-1)
    warning('Nie mozna otworzyc pliku: %s',fpath);
    return; 
end;
fclose(fw);
lMatOp=T_Find(fpath);
%Koniec tego co zamiast tlumaczenia Wicia
fprintf('Tlumacze: %s\n',fpath);
%tlumaczenie kodu
i=1; nB=1;
while i<=length(lMatOp)
    try
    inst=lMatOp{i};
    if(isempty(inst)) i=i+1; continue; end
    if((inst(1)~='%')&&(inst(end)==';')) inst=inst(1:end-1); end
    while 1
        %% INSTRUKCJE WARUNKOWE IF
        if IsLike(inst,'%l#if if( else elseif elseif(#%s')||strcmp(inst,'else')
            if(gInLoop) gInLoop=gInLoop+1; end
            [tBufC]=T_Loop(inst);
            if(~iscell(tBufC)) tBufC={tBufC}; end
            if(~isempty(tBufC)&&~isempty(tBufC{1})) lTC{nB}={lTC{nB}{1:end} tBufC{1:end}};
            else lTC{nB}={lTC{nB}{1:end} ['//BLAD: ' inst]}; end;
            break;
        end
        %% PETLE
        if IsLike(inst,'%l#while while( for for(#%s')
            %pobranie wszystkich instrukcji w petli, pominiecie wszystkich
            %elementow z koncem bloku 'end'
            cnaw=1; j=i+1;
            while(cnaw) 
                if(IsLike(lMatOp{j},'%l#while for if switch #%s')) cnaw=cnaw+1;
                elseif(strcmp(lMatOp{j},'end')||strcmp(lMatOp{j},'end;')||strcmp(lMatOp{j},'end,')) 
                    cnaw=cnaw-1;
                    if strcmp(lMatOp{j},'end') lMatOp{j}='end;'; end
                end
                j=j+1;
            end
            vname_change=MyDebug({lMatOp{i:j-1}});
            %zwiekszam zmienna, ktora okresla poziom zagniezdzenia
            for k=1:length(vname_change)
                t=AddToNL({vname_change{k}{1:4}});
                if(t) lTC{nB}={lTC{nB}{1:end} t}; end
            end
            gInLoop=gInLoop+1;
            [tBufC]=T_Loop(inst);
            if(~iscell(tBufC)) tBufC={tBufC}; end
            if(~isempty(tBufC)&&~isempty(tBufC{1})) lTC{nB}={lTC{nB}{1:end} tBufC{1:end}};
            else lTC{nB}={lTC{nB}{1:end} ['//BLAD: ' inst]}; end;
            break;
        end
        %% SWITCHE
        if IsLike(inst,'%l#switch case otherwise break#')
            if(gInLoop&&IsLike(inst,'%sswitch%s')) gInLoop=gInLoop+1; end
            [tBufC]=T_Loop(inst);
            if(~iscell(tBufC)) tBufC={tBufC}; end
            if(~isempty(tBufC)&&~isempty(tBufC{1})) lTC{nB}={lTC{nB}{1:end} tBufC{1:end}};
            else lTC{nB}={lTC{nB}{1:end} ['//BLAD: ' inst]}; end;
            break;
        end
        %% KOMENTARZE
        if IsLike(inst,'%l#%#%s')
            %sprawdzam czy jest wlaczone proste tlumaczenie
            if(opt.implicit)
                %sprawdzam czy mam podany kod w C do tlumaczenia
                if(length(inst)>3&&strcmp(upper(inst(2:3)),defCLine))
                    %sprawdzam czy jest podany blok kodu w C
                    %Wielolinijkowy blok C
                    if((length(inst)>=(length(defCBS)+1))&&strcmp(upper(inst(2:length(defCBS)+1)),defCBS))
                        lInst={};
                        %Wczytuje liste instrukcji
                        j=i+1;
                        while j<length(lMatOp)
                            %jezeli nie mam komentarza to wychodze
                            if(lMatOp{j}(1)~='%') break; end
                            %pomijam spacje i komentarze '%'
                            k=2;
                            while((k<length(lMatOp{j}))&&((lMatOp{j}(k)==' ')||lMatOp{j}(k)=='%'))
                                k=k+1;
                            end
                            %k nie jest na koncu lMatOp, mam cos do dodania
                            if(k<length(lMatOp{j})) lInst{end+1}=lMatOp{j}(k:end); end
                            %jezeli znalazlem koniec komentarzy lub koniec bloku
                            j=j+1;
                            if((length(lMatOp{j})>=(length(defCBE)+1))&&strcmp(upper(lMatOp{j}(2:length(defCBE)+1)),defCBE))
                                break;
                            end
                        end
                        i=j;
                        %Jezeli mam cos do dodania
                        tBuf=T_ArgC(lInst);
                    %Jednolinijkowy blok C
                    %sprawdzam czy po #C mam cos
                    elseif(length(inst)>(length(defCLine)+2))
                        k=length(defCLine)+2;
                        while((k<length(inst))&&((inst(k)==' ')||inst(k)=='%'))
                            k=k+1;
                        end
                        %Nie sprawdzam zamkniecia klamer { }
                        tBuf=T_ArgC(inst(k:end));
                    end
                    if(~isempty(tBuf)) lTC{nB}={lTC{nB}{1:end} tBuf{1:end}}; end
                    break;
                end
            end
            lTC{nB}={lTC{nB}{1:end} ['//' inst]};
            break;
        end
        %% PRZYPISANIA
        if IsLike(inst,'%s=%s')
            vname_change=MyDebug(inst);
            %zwiekszam zmienna, ktora okresla poziom zagniezdzenia
            tD={};
            for k=1:length(vname_change)
                t=AddToNL({vname_change{k}{1:4}});
                if(~isempty(t)) tD{end+1}=t; end
            end
            [tN, tIdx, tBufC]=T_Op(inst);
            if(~isempty(tBufC)) 
                if(isempty(tD)) lTC{nB}={lTC{nB}{1:end} ['//Trans: ' inst] tBufC{1:end}};
                else  lTC{nB}={lTC{nB}{1:end} ['//Trans: ' inst] tD{1:end} tBufC{1:end}}; end;
            else lTC{nB}={lTC{nB}{1:end} ['//BLAD: ' inst] ' '}; end;
            break;
        end
        %% A()
        if IsLike(inst,'%s(%s)%s') || IsLike(inst,'%s(%s)')
            vname_change=MyDebug(inst);
            %zwiekszam zmienna, ktora okresla poziom zagniezdzenia
            for k=1:length(vname_change)
                t=AddToNL({vname_change{k}{1:4}});
                if(t) 
                    %Pierwsza a
                    lTC{nB}={lTC{nB}{1:end} t}; 
                end
            end
            [tN, tIdx, tBufC]=T_TmpArg(inst);
            lTC{nB}={lTC{nB}{1:end} ['//Trans: ' inst] tBufC{1:end} ' '};
            if(~isempty(tBufC)) lTC{nB}={lTC{nB}{1:end} ['//Trans: ' inst] tBufC{1:end} ' '};
            else lTC{nB}={lTC{nB}{1:end} ['//BLAD: ' inst] ' '}; end;
            break;
        end
        %% KONIEC BLOKU
        %Jezeli znalazlem end to koniec bloku
        if IsLike(inst,'end')
           if(gInLoop) gInLoop=gInLoop-1; end
           lTC{nB}{end+1}='}';
           break;
%             [tBufC]=T_Loop(inst);
%             if(~iscell(tBufC)) tBufC={tBufC}; end
%             if(~isempty(tBufC)&&~isempty(tBufC{1})) lTC{nB}={lTC{nB}{1:end} tBufC{1:end}};
%             else lTC{nB}={lTC{nB}{1:end} ['//BLAD: ' inst]}; end;
%             break;
        end
        %% SLOWO KLUCZOWE GLOBAL
        if IsLike(inst,'global ')
            %Dopisuje debugowi odpowiednie zmienne globalne
            MyDebug(inst);
            %Przejscie do spacji po slowku global
            [b,j]=strIsIn(' ',inst);
            while j<=length(inst)
                if(IsLetter(inst(j)))
                    k=j+1;
                    while((k<=length(inst))&&(inst(k)~=' ')&&(inst(k)~=',')&&(inst(k)~=';')) k=k+1; end
                    k=k-1;
                    %Dodanie zmiennej jako global
                    [b,el,idx]=GetFromNL(inst(j:k));
                    %zmienna jest juz w liscie, zmieniam ja na globalna
                    if(b) vname_list{idx}{9}=1;
                    else AddToNL({inst(j:k) 'UnDef' -1 -1 -1 -1 -1 0 1});end;
                    j=k;
                end
                j=j+1;
            end;
            break;
        end
        %% WPISANIE INCLUDA PRZETLUMACZONEGO SKRYPTU
        %Jezeli mamy podany skrypt ktory jest juz przetlumaczony
        if(opt.trnScrOnlOnes&&GetFromNL(inst,fname_list))
            [~,el]=GetFromNL(inst,fname_list); 
            %Jezeli nie tlumacze podwojnie skryptow
            if(~opt.trnScrDoubTim)
                %Pierwszym elementem na liscie przetlumaczonego kodu
                %skryptu jest linijka //nazwa_skryptu
                %3 parametr, pierwszy blok, pierwsza linjka
                lTC{nB}{end+1}=['#include "',el{3}{1}{1}(3:end),'"'];
                break;
            %Jezeli tlumacze podwojnie skrypt
            else
                %sprawdzam czy element na liscie ma drugi przetlumaczony
                %kod funkcji length(el) musi byc >=4
                if(length(el)>=4)
                    lTC{nB}{end+1}=['#include "',el{4}{1}{1}(3:end),'"'];
                    break;
                end
            end
        end
        %% TLUMACZENIE SKRYPTOW Z PLIKU, DRUGIE DOTLUMACZENIE SKRYPTU
        %Jezeli mam podany skrypt, ktory nie jest przetlumaczony, lub musze
        %wykonac drugie tlumacznie
        fw=fopen([mypwd,inst,'.m']);
        if(fw~=-1)
            fclose(fw);
            tBuf{1}={};
            tBuf=T_MatTrans(tBuf,[mypwd,inst,'.m']);
            %Dodanie do listy funkcji, jezeli tlumaczymy tylko raz skrypty
            if(opt.trnScrOnlOnes)
                %Sprawdzam czy podana jest opcja podwojnego tlumaczenia dla skryptow
                if(opt.trnScrDoubTim)
                    [b,~,idx]=GetFromNL(inst,fname_list);
                    %Jezeli podany skrypt byl juz raz przetlumaczony to
                    %dopisuje jego przetlumaczona druga wersje
                    if(b)
                        tBuf{1}={['//' inst '.c'] tBuf{1}{1:end}};
                        fname_list{idx}={fname_list{idx}{1:end} tBuf};
                    else
                        %Dopisanie tlumacznej nazwy pliku
                        tBuf{1}={['//' inst '_FIRST.c'] tBuf{1}{1:end}};
                        fname_list{end+1}={inst 1 tBuf}; 
                    end
                else
                    tBuf{1}={['//' inst '.c'] tBuf{1}{1:end}};
                    fname_list{end+1}={inst 1 tBuf}; 
                end
                %Dopisanie linijki z dolaczeniem pliku
                lTC{nB}{end+1}=['#include "',tBuf{1}{1}(3:end),'"'];            
            %ciagle tlumaczenie skryptow
            else
                [~,b]=size(tBuf);
                if(b>1)
                    for(k=1:b)
                        nB=nB+1;
                        lTC{nB}={lTC{nB}{1:end} tBuf{k}{1:end}};
                    end
                else lTC{nB}={lTC{nB}{1:end} tBuf{1}{1:end}}; end
            end;
            break;
        end
        %% BRAK TLUMACZENIA PODANEJ INSTRUKCJI
        %Jezeli nic nie znalazlo to problem jest i wypisuje ze nie znalazlo,
        %a linijke dodaje do komentarza
        lTC{nB}{end+1}=['//#BLAD: ' inst];
        break;
    end
    catch e
        %Dorobic wyjscie i wyswietlenie komunikatu na 'Command:Exit')
        if(strcmp(e.identifier,'Command:Exit'))
            error('W INSTRUKCJI:\n%s\n%s',inst,e.message);
        end
        warning('\nBLAD W INSTRUKCJI:\n%s\n%s',inst,e.message);
        lTC{nB}{end+1}=['//#BLAD0: ' inst];
    end
    i=i+1;
    if(length(lTC{nB})>=(opt.trshBl)) nB=nB+1; lTC{nB}={}; end
end
fprintf('Koniec tlumaczenia: %s\n',fpath);
end

