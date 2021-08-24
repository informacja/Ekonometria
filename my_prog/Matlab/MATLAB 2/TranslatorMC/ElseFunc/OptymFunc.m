function [ lTC ] = OptymFunc( lTC )
%OPTYMFUNC funkcja optymalizuje przetlumaczony kod w C

global vname_list defMalloc opt;

lmalloc=length(defMalloc);
%Podaje rozmiar 1xCOS
[~,nB]=size(lTC);
bCh=false;
for k=1:nB
    i=1;
    while i<=length(lTC{k})
        str=lTC{k}{i};
        %Usuniecie niepotrzebnych linijek
        if(isempty(str)) lTC{k}={lTC{k}{1:i-1} lTC{k}{i+1:end}}; continue; end
        if(length(str)<2) i=i+1; continue; end;
        %% OPTYM TYLKO DLA OBLICZEN STALYCH!!: 1*1, 0*1, 1*E itp..
        %sprawdzam czy nie ma zapisow typu: 1*1, 0*1, 1*E , 1\E itp.. 
        [b1,idx1]=strInOp('1',str,1);
        if(b1)
           %sa 2 przypadki: 1): 1*E, 2) E*1
           %1)
           if((idx1+1<=length(str))&&IsOperator(str(idx1+1)))
               if((str(idx1+1)=='*')||(str(idx1+1)=='\'))
                   lTC{k}{i}=[str(1:idx1-1) str(idx1+2:end)];
               end
           %2)    
           %idx1-1>1 zawsze spelnione bo nie moze byc rownan 1*1; <-nie tlumacze    
           elseif(IsOperator(str(idx1-1)))
               if((str(idx1-1)=='*')||(str(idx1-1)=='/'))
                   lTC{k}{i}=[str(1:idx1-2) str(idx1+1:end)];
               end
           end 
        end
        
        [b1,idx1]=strInOp('0',str,1);
        if(b1&&~((idx1==length(str))&&(idx1==0)))
           %sa 2 przypadki: 1): 0*E, 2) E*0
           %1)
           if((idx1+1<=length(str))&&IsOperator(str(idx1+1))&&(str(idx1+1)~=')'))
               if((str(idx1+1)=='*')||(str(idx1+1)=='/'))
                   %sprawdzam czy mam podanego nawias, jezeli tak ide do konca:
                   if(str(idx1+2)=='(')
                       cnaw=1; j=idx1+3;
                       while(cnaw) if(str(j)=='(') cnaw=cnaw+1; elseif(str(j)==')') cnaw=cnaw-1; end; j=j+1; end;
                       if(j==length(str)) j=j+1; end
                   %mam podana jakas zmienna/liczbe
                   else
                       j=idx1+3;
                       while(j<=length(str)&&~IsOperator(str(j))&&str(j)~=',') j=j+1; end
                   end
                   lTC{k}{i}=[str(1:idx1) str(j:end)];
               %Jezeli mam podane
               elseif((str(idx1-1)=='-')||(str(idx1-1)=='+'))
                   lTC{k}{i}=[str(1:idx1-1) str(idx1+2:end)];
               end
           %2)    
           %idx1-1>1 zawsze spelnione bo nie moze byc rownan: 1*1; <-nie tlumacze    
           elseif(IsOperator(str(idx1-1))&&(str(idx1+1)~='('))
               if(str(idx1-1)=='*')
                   %sprawdzam czy mam podanego nawias, jezeli tak ide do konca:
                   if(str(idx1-2)==')')
                       cnaw=1; j=idx1-3;
                       while(cnaw) if(str(j)==')') cnaw=cnaw+1; elseif(str(j)=='(') cnaw=cnaw-1; end; j=j-1; end;
                       if(j==1) j=j-1; end
                   %mam podana jakas zmienna/liczbe
                   else
                       j=idx1-3;
                       while((j>=1)&&~IsOperator(str(j))&&str(j)~=',') j=j-1; end
                   end
                   lTC{k}{i}=[str(1:j) str(idx1:end)];
               %Jezeli mam podane E-0, E+0
               elseif((str(idx1-1)=='-')||(str(idx1-1)=='+'))
                   lTC{k}{i}=[str(1:idx1-2) str(idx1+1:end)];
               end
           end 
        end
        switch str(1:2)            
            case 'HP' %HPrdo/HProdPow
            %% Hprdo/HprodPow
                if((length(str)>4)&&strcmp('HProd',str(1:5)))
                    [nEl,lEl,tEl,idxEl,typeEl]=GetElFromDef(str);
                    if(nEl<2) continue; end
                    ChVoidToGetPtr;
                    if(bCh)%Cos trzeba zmienic wiec zmieniam
                        lTC{k}{i}=[str(1:idxEl{1}(1)-1),lEl{1},',',lEl{2},str(idxEl{2}(2)+1:end)];
                    end
                i=i+1; continue;
                end
            case {'LD','RD'} %LDiv, RDiv
            %% [L/R]DIV
                if((length(str)>4)&&(strcmp('LDiv',str(1:4))||strcmp('RDiv',str(1:4))))
                    [nEl,lEl,tEl,idxEl,typeEl]=GetElFromDef(str);
                    if(nEl<2) continue; end
                    ChVoidToGetPtr;
                    if(bCh)%Cos trzeba zmienic wiec zmieniam
                        lTC{k}{i}=[str(1:idxEl{1}(1)-1),lEl{1},',',lEl{2},str(idxEl{2}(2)+1:end)];
                    end
                i=i+1; continue;
                end
            case 'Mu' %% Mul
            %% MUL
                if((length(str)>2)&&strcmp('Mul',str(1:3)))
                    [nEl,lEl,tEl,idxEl,typeEl]=GetElFromDef(str,true);
                    if(nEl<3) continue; end
                    %Dosprawdzenie czy element wynikowy mnozenia jest stal
                    %Jezeli tak do musze odwolywac sie do niego przez adres
                    [~,elW]=GetFromNL(lEl{1},vname_list);
                    if((elW{5}==1)&&(elW{6}<1)&&(elW{7}<1)) bCh=true; elW{1}=['&',elW{1}]; end
                    nEl=nEl-1; lEl={lEl{2:end}};
                    ChVoidToGetPtr;
                    if(bCh)%Cos trzeba zmienic wiec zmieniam
                        lTC{k}{i}=[str(1:idxEl{1}(1)-1),elW{1},',',lEl{1},',',lEl{2},str(idxEl{3}(2)+1:end)];
                    end
                i=i+1; continue;    
                end
                
            case 'Po'
             %% POW    
                if((length(str)>2)&&strcmp('Pow',str(1:3)))
                    [nEl,lEl,tEl,idxEl,typeEl]=GetElFromDef(str);
                    if(nEl<2) continue; end
                    ChVoidToGetPtr;
                    if(bCh)%Cos trzeba zmienic wiec zmieniam
                        lTC{k}{i}=[str(1:idxEl{1}(1)-1),lEl{1},',',lEl{2},str(idxEl{2}(2)+1:end)];
                    end
                    %Sprawdzam czy nie mam zapisu A^B gdzie A jest zmienna
                    %nie macierzowa, a B jest liczba calkowita lub zmienna
                    %calkowita
                    if(strcmp(tEl{1},'C')&&strcmp(tEl{2},'C'))
                        %Mam zmienna calkowita jako wykladnik
                        if(IsLike(typeEl{2},'%s%l#int char#'))
                            %jezeli jest liczba i jej wartosc jest mniejszy
                            %niz maksymalny ustawiony w opcji opt.opt.maxMulNumInPow
                            %to dopisuje rozwiniecie potegi: A=A*A*..
                            if(IsNumber(lEl{2})&&(str2double(lEl{2})<=opt.maxMulNumInPow))
                                val=str2double(lEl{2});
                                str=[lEl{1} '=' lEl{1}];
                                for j=2:val
                                    str=[str(1:end) '*' lEl{1}];
                                end
                                str(end+1)=';';
                            %Wszystko wpisuje do makra PowINT
                            else
                                [pusty,idx]=strIsIn('(',str);
                                str=['PowINT' str(idx:end)];
                            end
                            lTC{k}{i}=str;
                        end
                    end
                i=i+1; continue;
                end
            case {'Eq','LE'} %Eq/EqM
            %% Eq/EqM    
                if(((length(str)>1)&&strcmp('Eq',str(1:2)))||((length(str)>2)&&strcmp('LEq',str(1:3))))
                    [nEl,lEl,tEl,idxEl,typeEl]=GetElFromDef(str,1);
                    if(nEl<3) continue; end
                    %Sprawdzam czy podane jest EqMM/CC, jezeli tak to musze
                    %okreslic jakiego typu jest wynikowa wartosc EqMM to M,
                    %EqCC to C
                    if(nEl==3) tEl={tEl{1} tEl{1:end}}; 
                    elseif(nEl==4)
                        %przy Eq zalozenia prawdziwe w LEq zawsze wynikiem
                        %jest Macierz
                        if(~strcmp('LEq',str(1:3))&&(tEl{2}=='C')&&(tEl{3}=='C')) tEl={'C' tEl{1:end}};
                        else tEl={'M' tEl{1:end}}; end
                    end
                    ChVoidToGetPtr;
                    if(bCh)%Cos trzeba zmienic wiec zmieniam
                        if(nEl==3)
                            lTC{k}{i}=[str(1:idxEl{1}(1)-1),lEl{1},',',lEl{2},str(idxEl{2}(2)+1:end)];
                        elseif(nEl==4)
                            lTC{k}{i}=[str(1:idxEl{1}(1)-1),lEl{1},',',lEl{2},',',lEl{3},',',lEl{4},str(idxEl{4}(2)+1:end)];
                        end
                    end
                    %sprawdzam czy jest EqCC(.. jezeli tak to zamieniam na
                    %znak rownosci i puszczam jeszcze raz dla tej linijki
                    %i=i;
                    if(strcmp('EqCC(',str(1:5))||strcmp('LEqCCC(',str(1:7)))
                        %Przy LEqCCC, jest jedna opcja w optymalizacji,
                        %kiedy podaje A(1)=10; a A jest stala
                        %jezeli oba typy sa rowne
                        if(str(1)=='L')
                            [pusty,elA]=GetFromNL(lEl{1},vname_list);
                            %jezeli nie ma realokacji, zmian typu lub
                            %sama zmienna nie jest stala
                            if(~isempty(elA)&&((elA{5}==0)||(elA{6}>0)||(elA{7}>0))) i=i+1; continue; end;
                            %sprawdzam czy indeksy sa rozne niz C(1), czyli
                            %LEqCCC(C,0,0..
                            if(~strcmp(lEl{2},'0')||~strcmp(lEl{3},'0')) i=i+1; continue; end;
                            %przypisanie poprawnych elementow z def. LEqCCC
                            %typeEl{1}=typeEl{2}; 
                            %typeEl{2}=typeEl{3};
                            %idxEl{2}=idxEl{end};
                        end
                        if(strcmp(typeEl{1},typeEl{2}))
                            lTC{k}{i}=[str(idxEl{1}(1):idxEl{1}(2)),'=',str(idxEl{2}(1):idxEl{2}(2)),';'];
                        %Typy sa rozne, wiec rzutuje
                        else
                            lTC{k}{i}=[str(idxEl{1}(1):idxEl{1}(2)),'=(',typeEl{1},')',str(idxEl{2}(1):idxEl{2}(2)),';'];
                        end
                        continue;
                    end
                i=i+1; continue;
                end
%             case 'SQ'
%                 %Optymalizacja funkcji SQRT(
%                 if((length(str)>4)&&strcmp(str(1:5),'SQRT('))
%                     idxb1=5; %indeks pierwszego nawiasu w SQRT
%                     CheckSQRT;
%                     idxA=[idxb1+1,idxd-1];
%                     [b,elA]=GetFromNL(str(idxA(1):idxA(2)));
%                     
%                     idxb1=idxd+1; %indeks od kotrego szukam
%                     CheckSQRT;
%                     idxB=[idxb1+1,idxd-1];
%                     [b,elB]=GetFromNL(str(idxA(1):idxA(2)));
%                     
%                 end
        end
        %% PRZYISANIA ROWNOSCIOWE '=' A=...,
        %sprawdzam czy w linijce jest = moze to byc zapis Typu: T=A+B(stare HProdCC)
        %lub malloc z polem struktury(malloca dla pol z brakiem realokacji usuwamy)
        if(strIsIn('=',str)&&(str(end)==';'))
            %Sprawdzam czy na poczatku nie mam (free
            %Warunek sprawdzajacy niepotrzebny free + Alloc 
            %przy pierwszym dopisaniu zmiennych z MyDebug czasami takie
            %wychodzily
            if((length(str)>4)&&strcmp('free(',str(1:5))) [pusty,j]=strIsIn(' ',str); j=j+1; l=j; 
            else j=1; l=1; end;
            %pobieram lewa nazwe rownania GetPtr(T)=A..
            while(str(l)~='=') l=l+1; end
            [b,tmpEl]=GetFromNL(str(j:l-1));
            if(~b) i=i+1; continue; end %nie mam podanej zmiennej wychodze
            %Sprawdzam czy nie usunac niepotrzebnego MyMalloc(6znakow)a, dla zmiennych
            %stalych, stalych pol struktur
            if(~IsTmpN(tmpEl{1})&&((l+lmalloc)<length(str))&&strcmp(defMalloc,str(l+1:l+lmalloc))&&(tmpEl{6}==0)&&(tmpEl{7}==0))
                if(opt.commentInOpty) lTC{k}{i}=['//',str]; i=i+1; continue;
                else lTC{k}={lTC{k}{1:i-1} lTC{k}{i+1:end}}; continue; end
                %Zakomentowalem lub usunalem wiec kontynuje petle
            end
            
            %Jezeli lewa nazwa jest realokowalna lub ma jakies zmiany typu, 
            %czyli void* to wyluskuje wartosc, stale liczby to dlugosc
            %'GetPtr('
            if(IsLike(str,['%s' defMalloc '(%s'])) i=i+1; continue; end;
            if(IsTmpN(tmpEl{1})||tmpEl{6}>0||tmpEl{7}) 
                str=['GetPtr(',str(j:l-1),',',tmpEl{2},')',str(l:end)]; 
                j=(l+9)+length(tmpEl{2})+1; %jestem na znaku rownosci dlatego dodaje + 1
                bCh=true;
            else j=l+1;
            end
            
            %Sprawdzam realokacje w dalszych dzialaniach
            %ide do pierwszego znaku
            while(j<length(str)&&IsOperator(str(j))) j=j+1; end
            while(j<length(str))
                l=j+1;
                while(l<length(str)&&~IsOperator(str(l),1)) l=l+1; end
                [b,tmpEl]=GetFromNL(str(j:l-1));
                if(~b) j=l+1; continue; end %nie mam podanej zmiennej wychodze
                %Tutaj lapalo mi zapisy: B=st1(temp0).mtx*2.0;
                %Uwrazliwiam na to
                if((tmpEl{6}>0||IsTmpN(tmpEl{1})))
                    bCh=true;
                    str=[str(1:j-1),'GetPtr(',str(j:l-1),',',tmpEl{2},')',str(l:end)];
                    j=j+(l+10)+length(tmpEl{2}); %jestem na znaku wiec dodaje 1
                else
                    j=l+1;
                end
            end
            if(bCh) lTC{k}{i}=str; end
        end
        i=i+1;
    end
end
%% OPTYM NAZW STRUKTUR
%optymalizacja nazw struktur, dodanie strza³ki, dopisanie alokacji struktur
%dopisanie GetPtr(..) dla indeksow zmiennych,
[~,nB]=size(lTC);
idxFor=[0 0]; %numer bloku i indeks pierwszego fora
for k=1:nB
    i=1;
    while i<=length(lTC{k})
        str=lTC{k}{i};
        %pomijam komentarze
        if((length(str)>1)&&strcmp(str(1:2),'//')) i=i+1; continue; end;
        %oznacza ze jestesmy w petli
        if(IsLike(str,'%l#while( for(#%s')&&(idxFor(1)==0))
            idxFor=[k, i];
        end
        %sprawdzam czy w linijce jest nazwa struktur
        [b,idx]=strIsIn('.',str);
        %jest kropka w linijce
        if(b)
            %sprawdzam czy jest to struktura
            % w prawo do nawiasu, przecinka, rownosci, konca lini,
            l=idx+1;
            while(l<length(str)) if(IsOperator(str(l+1))||(str(l+1)==',')||(str(l+1)=='=')) break; end; l=l+1; end
            % w lewo pomijajac nawiasy )( do operacji, przecinka, rownosci,
            % poczatka lini
            cnaw=0; j=idx-1;
            while(j>1) 
                if(str(j)==')') cnaw=cnaw+1;
                elseif(str(j)=='(') 
                    cnaw=cnaw-1;
                    %tzn ze jest: (A(1).pole,...
                    if(cnaw<0) j=j+1; break; end
                end
                %jezeli: ..,A(1).pole lub ...*A(1).pole
                if(str(j-1)==','||IsOperator(str(j-1),1)||str(j-1)=='=') break; end
                j=j-1;
            end
            %sprawdzam czy struktura ma swoja alokacje
            [b,elA,idxEl]=GetFromNL(str(j:idx-1),vname_list);

            if(b)
                FreeTmp(elA{1}); t=AddToNL(elA);
                %zmiana jej nazwy, zeby drugi raz nie alokowac
                vname_list{idxEl}{1}=[vname_list{idxEl}{1} 'DefOk'];
                %jezeli dodaje alokacje przed forem:
                if(idxFor(1))
                    lTC{idxFor(1)}={lTC{idxFor(1)}{1:idxFor(2)-1} t lTC{idxFor(1)}{idxFor(2):end}};
                    i=i+1;%zwiekszylem liczbe elementow wiec zwiekszam i
                %Dopisuje przed pierwszym uzyciem zmiennej
                else
                    lTC{k}={lTC{k}{1:i-1} t lTC{k}{i:end}};
                    i=i+1; %zwiekszylem liczbe elementow wiec zwiekszam i
                end
            end
            
            %co uzyskalem to sprawdzam czy jest cos takiego, jezeli tak to
            %zamieniam . na ->, zamieniam str(1)->pole na (str+1)->pole
            if(GetFromNL(str(j:l),vname_list))
                lTC{k}{i}=[str(1:idx-1),'->',str(idx+1:end)]; 
                %sprawdzam czy w indeksie struktury nie mam zmiennej void
                %lub zmienna temp
                [bb,idxb]=strIsIn('(',str(j:l));
                [bd,idxb2]=strIsIn(')',str(j:l));
                [b,idxr]=strIsIn(',',str(j:l));
                %mam podana strukture wektorowa z nawiasami
                if(~b&&bb&&bd) 
                    %przesuniecie wzgledem poczatku str
                    idxb=idxb+j-1; idxb2=idxb2+j-1;
                    [bb,elA]=GetFromNL(str(idxb+1:idxb2-1));
                    if(bb&&(elA{7}||IsTmpN(elA{1})))
                        %jezeli temp to double to rzutuje
                        if(strcmp(elA{2},'double'))
                            lTC{k}{i}=[lTC{k}{i}(1:j-1) '(' lTC{k}{i}(j:idxb-1) '+'...
                                '(long int)GetPtr(' elA{1} ',' elA{2} ')' lTC{k}{i}(idxb2:end)];
                        else
                            lTC{k}{i}=[lTC{k}{i}(1:j-1) '(' lTC{k}{i}(j:idxb-1) '+'...
                                'GetPtr(' elA{1} ',' elA{2} ')' lTC{k}{i}(idxb2:end)];
                        end
                    %Nie mam podanej zmiennej tymczasowej, tylko zwyczajna
                    %liczbe stala
                    else
                        %jezeli w nawiasie jest 0
                        if(strcmp(str(idxb+1:idxb2-1),'0'))
                            lTC{k}{i}=[lTC{k}{i}(1:j-1) '(' lTC{k}{i}(j:idxb-1) lTC{k}{i}(idxb2:end)];
                        else
                            lTC{k}{i}=[lTC{k}{i}(1:j-1) '(' lTC{k}{i}(j:idxb-1) '+' lTC{k}{i}(idxb+1:end)];
                        end
                    end
                %w zalozeniach nie mam struktur macierzowych
                %struktura macierzowa
                elseif(bb&&bd)
                    warning('Podana jest struktura macierzowa: %s',str);
                    %ZOSTAWIAM JAKBY COS!!
%                     idxb=idxb+j-1; idxb2=idxb2+j-1; idxr=idxr+j-1;
%                     %pierwszy indeks
%                     [bb,elA]=GetFromNL(str(idxb+1:idxr-1));
%                     tStr=[]; %tymczasowy bufor na tekst
%                     if(bb&&(elA{7}||IsTmpN(elA{1})))
%                         tStr=lTC{k}{i}(idxb2:end);
%                         lTC{k}{i}=[lTC{k}{i}(1:idxb) 'GetPtr(' elA{1} ',' elA{2} '),'];
%                     end
%                     %sprawdzam drugi indeks
%                     [bb,elA]=GetFromNL(str(idxr+1:idxb2-1));
%                     if(bb&&(elA{7}||IsTmpN(elA{1})))
%                         %jezeli bufor tStr nie jest pusty to zmienialem cos
%                         %w pierwszym indeksie
%                         if(~isempty(tStr)) lTC{k}{i}=[lTC{k}{i}(1:end) 'GetPtr(' elA{1} ',' elA{2} ')' tStr(1:end)];
%                         %nic nie zmienialem wiec przepisuje do przecinka
%                         else lTC{k}{i}=[lTC{k}{i}(1:idxr) 'GetPtr(' elA{1} ',' elA{2} '),'];
%                         end;
%                     %nie zmienialem nic w drugim ale w pierwszym zmienilem
%                     elseif(~isempty(lStr))
%                         lTC{k}{i}=[lTC{k}{i}(1:idxb) elA{1} tStr(1:end)];
%                     end
                end
                continue; %sprawdzam czy nie mam jescze struktur w tej linijce
            end
        end
        i=i+1;
    end
end

end

