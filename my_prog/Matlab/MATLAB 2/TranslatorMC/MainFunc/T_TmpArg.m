function [ lN_out, stmpIdx_out, strBufC_out] = T_TmpArg(str, stmpIdx, strBufC, bLEqArg)
%T_TMPT Summary of this function goes here
%IN:
%str - polecenie do zamienienia, A(1) A(1:2, 2:3)
%OUT:
%lN_out - nazwa zmiennej ktora zwraca wartosc przetlumaczonej operacji Matlaba na C
%stmpIdx_out - numer tempa od ktorego mozna zaczac dalsze dodawanie po wyjsciu z funkcji
%strBufC_out - lista z przetlumaczonym kodem w C
%bLEqArg - okresla czy jest to specjalne wywolanie dla tej funkcji, wtedy
%          zostaja inaczej zwrocone wartosci oraz nie zostaje dopisane EqM..
%
% %Operacja A(B, B) gdzie B jest Macierza, otrzymujemy
% [srowB, scolB]=size(B);
% [srowC, scolC]=size(C);
% t=ones((srowB*scolB),(srowC*scolC));
% for i=1:(srowB*scolB)
%     for j=1:(srowC*scolC)
%         t(i,j)=A(B(i),C(j)); 
%     end
% end
%Kiedye bLErArg jest wlaczone:
%    stmpIdx_out={stmpIdx tmpList(lista tempow)};
%    lN_out={temp_el(macierz A(..)) lEl{1:end}(przetlumaczone indeksy)};
%    strBufC_out=strBufC;

global vname_list fname_list opt defMainFunc;
if(nargin<4) bLEqArg=false; end
if(nargin<3) strBufC={}; end
if(nargin<2) stmpIdx=0; end
if(isempty(opt)) opt.decConstIndexMatrix=1; opt.decVarIndexMatrix=0;end
    
lN_out=''; stmpIdx_out=stmpIdx; strBufC_out=strBufC;
tmpList={};%lista zmiennych tymczasowych: temp0, temp1, temp2..
elA={};%zmienna z tymczasowym elementem

strOld=str;
%Jezeli nie mam specjalnego dzialania funkcji to tworze wartosc zwracana
if(~bLEqArg)
    lNm=[];%nazwa po lewej stronie znaku rownosci
    for i=1:length(str)
        if(str(i)=='=')
            lNm=str(1:i-1); %zapisanie nazwy zmiennej wynikowej
            str=str(i+1:end);%usuniecie lewej strony nazwy zmiennej oraz znaku rownosci
            break;
        end
    end
    %Jezeli w lNm znajduje nawias to znaczy ze jest to zapis A(..)=..
    %i przekazuje to do innej funkcji
    %Jezeli nie mam lNm, tworze tempa zwracanego przez funkcje lub element zwracany
    if(isempty(lNm)) lNm=['temp' num2str(stmpIdx)]; stmpIdx=stmpIdx+1; 
    else 
        if(strIsIn('(',lNm)&&~strIsIn('.',lNm))
            [lN_out,stmpIdx_out,strBufC_out]=T_LEqArg(str,stmpIdx,strBufC);
            return;
        end
    end
end

%usuwanie niepotrzebnych nawiasow typu: (A(1)) (((A(1)))
% i=0; while((str(i+1)=='(')&&(str(end)==')')) i=i+1; end
% if(i>0) str=str((i+1):1:(end-1)); end
%Usuniecie srednika z konca
if(str(end)==';') str=str(1:(end-1)); end
% lArrNm=[];%nazwa Macierzy do ktorej sie odwolujemy A(..)->A, B(..)->B
[bb,idxb]=strIsIn('(',str);
[bd,idxd]=strIsIn('.',str);
% Przypadek A(..).cos i nie jest to operator
if(bb&&bd&&(idxb<idxd)&&~IsOperator(str(idxd:idxd+1)))
    [pusty,idxb2]=strIsIn('(',str(idxd+1:end));
    lArrNm=str(1:idxd+idxb2-1);
    str=str(idxd+idxb2+1:end-1);
else
    lArrNm=str(1:idxb-1); %zapisanie nazwy zmiennej wynikowej
    %w celu pominiecia znakow po ), jakichs spacji usuwam wszystkie
    str=[str(1:idxb) strDelChar(str(idxb+1:end),' ')];
    str=str(idxb+1:end-1);%usuniecie znakow nawiasu
end
[bAr, elArrNm]=GetFromNL(lArrNm,vname_list);
[bFunc]=GetFromNL(lArrNm,fname_list);
%je¿eli nie znalazlem macierzy i funkcji to nie mam czego tlumaczyc
if(~bAr&&~bFunc)
    %Jezeli mam specjalne wywolanie funkcji, to wtedy nie mam zmiennej lNm
    if(opt.implicit&&~bLEqArg)
        %Wylapuje deklaracje funkcji
        if(IsLike(lNm,'function %s'))
            %dziwne, druga definicja funkcji w jednym tlumaczonym pliku
            if(~isempty(defMainFunc)) return; end
            defMainFunc={lArrNm};
        elseif(~IsTmpN(lNm)) 
            lN_out=lNm; stmpIdx_out=stmpIdx; strBufC_out={[strOld ';']};
            return;
        end
    else return; end
end

lEl={}; %lista elementow, A(lEl{1},lEl{2},lEl{3})
t=0; %przechowuje indeks ostatniego przecinka
cnaw=0;
for i=1:length(str) %Tworze liste elementow
    if(str(i)=='(') cnaw=cnaw+1; continue; end
    if(str(i)==')') cnaw=cnaw-1; end
    if(cnaw~=0) continue; end
    if(str(i)==',') lEl{end+1}=str((t+1):(i-1)); t=i; 
    elseif(i==length(str)) lEl{end+1}=str((t+1):(i)); end
end

%Wyjscie po dodanej definicji funkcji
if(opt.implicit&&~bAr&&~bFunc&&~isempty(defMainFunc))
    defMainFunc{end+1}=lEl;
end

elA={}; elB={};
%sprawdzam czy w elementach indeksow sa obliczenia lub zapisy Typu [1 2 3]
%lub inne np. 'end'
for i=1:length(lEl)
    [b,tidx]=strInOp('end',lEl{i});
    if(b&&bAr) %end jest podane w elemencie
        %jest jeden elemtn podany A(end)
        if(length(lEl)<2) tend=num2str(elArrNm{3}*elArrNm{4}); 
        else tend=num2str(elArrNm{2+i}); end%jezeli i=1, chodzi o wiersze, i=2 o kolumny
        %tworze bufor z mozliwyim operacjami, ktore mogly byc w lEl{i} np (end-1)
        tstr=lEl{i};
        tstr=[tstr(1:(tidx-1)) tend tstr((tidx+length('end')):end)];
        tB=str2num(tstr); %proboje wykonac mozliwe obliczenie,
        if(~isempty(tB)&&(length(tB)==1)) lEl{i}=num2str(tB); %jezeli sie udalo to zapisuje
        else lEl{i}=tstr; end %jezeli nie to zapisuje stworzony bufor
    end
    %Sprawdzam czy nie ma zapisow A(:,C); A(:); A(C,:)...
    if(strInOp(':',lEl{i})&&bAr)
        tB=[];
        %jest jeden elemtn podany A(end)
        tN=[]; tIdx=0; tBufC={};
        if(length(lEl)<2) 
            tend=num2str(elArrNm{3}*elArrNm{4});
            %podana jest Macierz w A(..) wiec musze utworzyc wektor poziomy
            if((elArrNm{3}>1)&&(elArrNm{4}>1)) 
                tB=['(1:',num2str(tend),')',char(39)]; 
                [tN, ~, tBufC]=T_Op(tB, stmpIdx);
            else
                tB=['(1:',tend,')']; 
                [tN, ~, tBufC]=T_Init(tB, stmpIdx);
            end
        else
            tend=num2str(elArrNm{2+i});%jezeli i=1, chodzi o wiersze, i=2 o kolumny
            tB=['(1:',tend,')']; 
            [tN, ~, tBufC]=T_Init(tB, stmpIdx);
        end
        %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
        if(isempty(tN)) return; end
        strBufC={strBufC{1:end} tBufC{1:end}};
        stmpIdx=stmpIdx+1;
        tmpList{end+1}=tN;
        lEl{i}=tN;      
    %Sprwadzam czy w elemencie jest zapis 1:2 lub 1:2:4
    elseif(IsLike(lEl{i},'%s:%s')&&bAr)
%     elseif(IsLike(lEl{i},'%s:%s'))
        %skopiowane z T_Op:
        str=lEl{i};
        j=1;
        while j<=length(str)
            if(str(j)==':')
                %krok wstecz, Petla Do-While
                k=j;
                while 1 
                    k=k-1;
                    if(str(k)==')')
                        k=k-1; cnaw=1;
                        while((k>0)&&(cnaw>0))
                            if(str(k)==')') cnaw=cnaw+1;
                            elseif(str(k)=='(') cnaw=cnaw-1; end
                            k=k-1;
                        end
                    end
                    %Warunek wyjscia z petli, szukam najwczesniejszego
                    %operatora
                    if(((k-1)==0)||(str(k)=='(')) break; end;
                end
                if(k<1) k=k+1; end
                %krok wprzod, Petla Do-While
                l=j;
                while 1 
                    l=l+1;
                    if(str(l)=='(')
                        l=l+1; cnaw=1;
                        %pomijam nawiasy
                        while((l<=length(str))&&(cnaw>0))
                            if(str(l)=='(') cnaw=cnaw+1;
                            elseif(str(l)==')') cnaw=cnaw-1; end
                            l=l+1;
                        end
                    end
                    %Warunek wyjscia z petli, pomijam operatory ':'
                    if(((l+1)>length(str))||(str(l)==')')) break; end;
                end
                %k raz wykona sie niepotrzebnie
                if(l>length(str)) l=l-1; end
                tN=''; tBufC={};

                if(k==1) 
                    [tN,tIdx,tBufC]=T_Init(['(',str(k:l),')'],stmpIdx);
                    str=[tN str(l+1:end)];
                else
                    [tN,tIdx,tBufC]=T_Init(['(',str(k:l),')'],stmpIdx);
                    str=[str(1:k-1) tN str(l+1:end)];
                end
                if(isempty(tN)) return; end
                strBufC={strBufC{1:end} tBufC{1:end}};
                tmpList{end+1}=tN;
                lEl{i}=tN;
                stmpIdx=stmpIdx+1;
                j=j+length(tN);
            end
            j=j+1;
        end
    end
    if(IsLike(lEl{i},'%s%l#[ ] + - * ^ / \#%s')) 
        [tN, tIdx, tBufC]=T_Op(lEl{i}, stmpIdx);
        %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
        if(isempty(tN)) break; end
        strBufC={strBufC{1:end} tBufC{1:end}};
        stmpIdx=stmpIdx+1;
        tmpList{end+1}=tN;
        lEl{i}=tN;
    elseif(IsLike(lEl{i},'%s(%s'))
        [tN, tIdx, tBufC]=T_TmpArg(lEl{i}, stmpIdx);
        %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
        if(isempty(tN)) return; end
        strBufC={strBufC{1:end} tBufC{1:end}};
        stmpIdx=stmpIdx+1;
        tmpList{end+1}=tN;
        lEl{i}=tN;
    end
end

%sprawdzam czy lArrNm jest to funkcja, globalna zmienna fname_list
if(~bAr) %jezeli nie znaleziono Macierzy lArrNm, to moze byc to funkcja
    [b,elArrNm]=GetFromNL(lArrNm,fname_list);
    if(~b) 
        warning('Podana Macierz/Funkcja: %s, nie zostala znaleziona',lArrNm); 
        return;
    end
    %Podana Matlabowska funkcja i narazie innej nie moze byc
    if(elArrNm{2}==0)
       %dodanie nazwy wynikowej
       lEl={lNm lEl{1:end}};
       [tN, tIdx, tBufC]=T_MatFunc(lArrNm,lEl,stmpIdx_out);
       %Sprawdzam czy nie wystapil blad, jezeli tak to nie tlumacze
       if(isempty(tBufC)) return; end
       strBufC={strBufC{1:end} tBufC{1:end}};
       stmpIdx=stmpIdx+1;
%        tmpList{end+1}=tN;
       lEl{i}=tN;
    end
end

%Jezeli znalazlem Macierz i nie mam tlumaczenia funkcji
if(bAr)
    needLoop=false;%Jezeli potrzebuje petli do przypisywania wartosc true
    sMtx=[];%rozmiar Macierzy wynikowej Temp, sMtx(1)=sRow, sMtx(2)=sCol
    for i=1:length(lEl)
        [b, elA]=GetFromNL(lEl{i},vname_list);
        if((~b)&&IsNumber(lEl{i}))
            %jezeli uruchomiona opcja to odejmuje 1 od indeksu
            if(opt.decConstIndexMatrix) lEl{i}=IdxC(lEl{i}); end
            elA={lEl{i} GetType(lEl{i}) 1 1 1};
        elseif(~strcmp(elA{1},lEl{i})) elA{1}=lEl{i}; end%Sprawdzam czy nie podana jest transpozycja
        %Element jest liczba lub zmienna 'stala'
        if(elA{5}==1)
            %Jak bedzie zwrot tylko jednej liczby, to podaje przypisanie
            %temp0=&A[1]; W liscie okreslam rozmiar i typ zmiennej, 'A' musi
            %juz byc w tej liscie
            %Sprawdzam czy podana jest zmienna, jezeli nie to jest to liczba stala
            if(b)
                if(opt.decVarIndexMatrix)
                    [tN,tIdx,tStrBuf]=T_Op(IdxC(lEl{i}),stmpIdx); 
                    strBufC={strBufC{1:end} tStrBuf{1:end}};
                    stmpIdx=tIdx;
                    tmpList{end+1}=tN;
                    lEl{i}=tN;
                end
            %else -> Wyzej przy sprawdzeniu czy zmienna zostal znaleziona
            %sprawdzam ten przypadek
            end
            if(isempty(sMtx)) sMtx=1; %jeden bo zmienna lub liczba
            else sMtx=[sMtx 1]; end
        %Elementem jest Macierz lub wektor (jakas tablica)
        elseif(elA{5}==0)
            if(~needLoop) needLoop=true; end 
            %A=[size(B), size(C), size(D)...];
            if(opt.decVarIndexMatrix)
                [lEl{i},tIdx,tStrBuf]=T_Op(IdxC(lEl{i}),stmpIdx);
                strBufC={strBufC{1:end} tStrBuf{1:end}}; 
                stmpIdx=stmpIdx+1;
                tmpList{end+1}=lEl{i};
            end
            if(isempty(sMtx)) sMtx=elA{3}*elA{4};
            else sMtx=[sMtx elA{3}*elA{4}]; end
        end
    end

    %Na tym etapie mam zamienione 1:2:3 na temp0, [1 2 3] na temp0 itd;
    temp_el=[];
    if(bLEqArg) lNm=lArrNm; end;
    if(needLoop) %Potrzebuje petli wiec zwrotem jest Macierz lub wektor
        %Okreslenie rozmiaru dla Macierzy, roznica w wektorze zwracanym
        %Zwrot zalezy od wektora podanego w parametrze
        %Jezeli C jest poziome to A(C) tez poziome
        %Jezeli C jest pionowe to A(C) tez pionowe
        if(elArrNm{3}>1&&elArrNm{3})
            if(length(sMtx)<2)
                %sprawdzm czy elA jest Macierza, jezeli tak to zwracam jej
                %rozmiar
                if((elA{3}>1)&&(elA{4}>1)) sMtx(1)=elA{3}; sMtx(2)=elA{4}; end
                if(elA{3}==1) sMtx(2)=sMtx(1); sMtx(1)=1; %wektor poziomy
                %((elA{3}>1)&&(elA{4}==1)) %warunek wektora pionowego
                elseif(elA{4}==1) sMtx(2)=1; %wektor pionowy
                end
            end
        %Podany jest wektor i rozmiar macierzy zwracanej jest zalezny od
        %wektora/macierzy A, z ktorego pobieramy wartosc
        %Jezeli A poziomoe to A(C) tez poziome
        %Jezeli A pionowe to A(C) tez pionowe
        else
            %sprawdzm czy elA jest Macierza, jezeli tak to zwracam jej
            %rozmiar
            if((elA{3}>1)&&(elA{4}>1)) sMtx(1)=elA{3}; sMtx(2)=elA{4};
            %elA jest wektorem, sprawdzam rozmiar elArrNm
            else
                if(elArrNm{3}==1) sMtx(2)=sMtx(1); sMtx(1)=1; %wektor poziomy
                %((elA{3}>1)&&(elA{4}==1)) %warunek wektora pionowego
                elseif(elArrNm{4}==1) sMtx(2)=1; %wektor pionowy
                end
            end
        end
        temp_el={lNm elArrNm{2} sMtx(1) sMtx(2) 0};
    else%Stala
        temp_el={lNm elArrNm{2} 1 1 1};
    end
    if(~bLEqArg)
        t=AddToNL(temp_el);
        if(~isempty(t))
            if isempty(strBufC) strBufC={t};
            else strBufC={strBufC{1:end} t}; end
        end
    end

    %Na Tym etapie musze miec juz dobrze zaadresowane indeksy w C
    %nie moge miec zapisow typu (A-1) lub (12-1) albo inne takie
    %lEl{1} i lEl{2}=='Jedna nazwa zmiennej/macierzy, liczba'
    %Dodatkowo sprawdzam czy jako elArrNm nie mam podanej Funkcji
    if(needLoop&&(~bLEqArg))
        %!!Wazne, Pamietac aby wektory podawac jako poziome(Program ma generowac je poziomo)!!
        %Podany jeden element
        elA={}; elB={}; lDefNam='';
        if(length(lEl)<2) 
           lDefNam='EqM';
           [b, elA]=GetFromNL(lEl{1},vname_list); %wczesniejszy    
           elB={'1' 'long int' 1 1 1};
           %Element musi byc wektorem/Macierza, bo potrzebna jest petla
           if(~strcmp(elA{1},lEl{1}))%jezeli nazwy elementow sie roznia
               elA{1}=lEl{i}; lEl{1}=elA;
           end
           if(elA{1}(end)==39) %Uwzgledniam transpozycje 
               lDefNam=[lDefNam 'MT']; elA{1}=elA{1}(1:end-1); 
           else lDefNam=[lDefNam 'M']; end
           %To prawdopodobnie nie jest potrzebne
           if(elA{3}==1||elA{4}==1)
               %Jezeli wektor jest pionowy, robie z niego poziomy
               if(elA{3}>1) 
                   elA{4}=elA{3}; elA{3}=1;
                   lDefNam=[lDefNam 'C'];
               %Wektor jest poziomy
               else
                   elT=elA; elA=elB; elB=elT;
                   lDefNam=[lDefNam(1:(end-1)) 'C' lDefNam(end)];
               end
           end
        %Podane wiele elementow
        else
            lDefNam='EqM';
            for i=1:length(lEl)
                [b, elA]=GetFromNL(lEl{i},vname_list); %wczesniejszy    
                if((~b)&&IsNumber(lEl{i}))
                    elA={num2str(lEl{i}) GetType(lEl{i}) 1 1 1};
                end
                if(~strcmp(elA{1},lEl{i}))%jezeli nazwy elementow sie roznia
                    elA{1}=lEl{i}; lEl{i}=elA;
                end
                %element jest Macierza
                if(elA{5}==0)
                    if(elA{1}(end)==39) %Uwzgledniam transpozycje 
                        lDefNam=[lDefNam 'MT']; elA{1}=elA{1}(1:end-1); 
                    else lDefNam=[lDefNam 'M']; end
                    %Sprwadzam czy elementem jest wektor
                    if(elA{3}==1||elA{4}==1)
                        %Jezeli wektor jest pionowy, robie z niego poziomy
                        if(elA{3}>1) elA{4}=elA{3}; elA{3}=1; end
                    end
                %Elementem jest liczba
                else
                    %Z liczby pojedynczej usuwam znak transpozycji
                    if(elA{1}(end)==39) elA{1}=elA{1}(1:end-1); end
                    lDefNam=[lDefNam 'C']; 
                end
                %Przypisanie przygotowanego elementu do wpisania
                lEl{i}=elA;
            end
            elA=lEl{1}; elB=lEl{2};  
        end
        if(~bLEqArg)
            IncEl(lNm,8);
            strBufC{end+1}=strcat(lDefNam,'(', lNm, ',', lArrNm, ',', elA{1}, ',', elB{1}, ',',...
                   num2str(elArrNm{3}), ',', num2str(elArrNm{4}), ',', ...
                   num2str(elA{3}), ',', num2str(elA{4}), ',', ...
                   num2str(elB{3}), ',', num2str(elB{4}), ',', ...
                   elArrNm{2}, ',', elA{2}, ',', elB{2}, ');');  
        end
    else
        %Tutaj lEl{1} i lEl{2} sa zmiennymi o rozmiarze 1 element lub liczba;
        %Mam miec w C: (*(double*)pp)=(*((double*)(lArrNm)+idxR*elA{4}+idxC));
        %Ten Fragment NIE USUWAC! : do pozniejszej optymalizacji, gdy lNm
        %jest zmienna normalna o tym samym typie co macierz
    %     strBufList{end+1}=[ lNm '=(*((double*)('...
    %         lArrNm ')+' lEl{1} '*' elA{4} '+' lEl{2} '));']; 
        %EqMCC(W,A,idRow,idCol,srA,scA,tW,tA)
        if(length(lEl)<2)
            %Z liczby pojedynczej usuwam znak transpozycji
            if(lEl{1}(end)==39) lEl{1}=lEl{1}(1:end-1); end
            %jezeli Macierz ma wiele wierszy
            if(elArrNm{3}>1)&&(elArrNm{4}>1)
                tN=str2num(lEl{1});
                if(~isempty(tN)) %Jezeli udalo sie przetlumaczyc string na liczbe
                    t=mod(tN,elArrNm{3}); lEl{2}=num2str(floor(tN/elArrNm{3})); lEl{1}=num2str(t);
                else%Nie udalo sie przetlumaczyc, czyli podana jest zmienna
                    lEl{2}=num2str(lEl{1}); lEl{1}='0';
                end
            else
                lEl{2}=lEl{1}; lEl{1}='0';
            end
        %Podane 2 elementy w lEl
        else
           %Uwzgledniam transpozycje
           if(lEl{1}(end)==39) lEl{1}=lEl{1}(1:end-1); end
           if(lEl{2}(end)==39) lEl{2}=lEl{2}(1:end-1); end
        end
        if(~bLEqArg)
            IncEl(lNm,8);
            strBufC{end+1}=['EqMCC(' lNm,',',lArrNm,',',num2str(lEl{1}),',',num2str(lEl{2}), ',',...
                        num2str(elArrNm{3}), ',', num2str(elArrNm{4}), ',', ...
                       '1,1,1,1,',elArrNm{2}, ',','long int', ',','long int',');']; 
        end
    end
end

if(~bLEqArg)
    %sprawdzam czy mam tempy do zwolnienia
    if(~isempty(tmpList)) 
        tBuf=FreeTmp(tmpList); 
        if ~isempty(tBuf) strBufC={strBufC{1:end} tBuf{1:end}}; end
    end
    stmpIdx_out=stmpIdx;
    lN_out=lNm; 
    strBufC_out=strBufC;
%Mam specjalne wywolanie funkcji i inne wartosci zwracane
else
    stmpIdx_out={stmpIdx tmpList};
    lN_out={temp_el lEl{1:end}};
    strBufC_out=strBufC;
end
end