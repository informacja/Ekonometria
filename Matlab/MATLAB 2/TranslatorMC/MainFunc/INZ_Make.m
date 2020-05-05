function [ lOut ] = INZ_Make(fpath,defNam,implict)
%Funkcja tlumaczy plik *.m na *.c
%IN:
%fpath - sciezka do pliku w postaci '..'
%OUT:
%err - kod bledu:
%       0 - to wszystko ok
%       1 - nie mozna otworzyc pliku

if(nargin<3) implicit=0; end
if((nargin<2)||isempty(defNam)) defNam='main.c'; end

%% Ustawienia i inicjalizacja globalnych zmiennych
global gInDen vname_list tmpPre gInLoop fname_list kod opt defMalloc mypwd...
       defCLine defCBS defCBE defCBStuc...
       tConst tVarInit defMainFunc idxStartStock tvn_list;
defMalloc='MyMalloc'; 
defCLine='#C';
defCBS='#CSTART';
defCBE='#CEND';
defCBStuc='struct{';
fname_list={{'sum' 0},{'ones' 0},{'sqrt' 0},...
            {'zeros' 0},{'length' 0},{'eye' 0},...
            {'inv' 0},{'exp' 0},{'fprintf' 0}};
lcfname_list=length(fname_list);
gInLoop=false;
kod='imagekey.mat';
vname_list={};
idxStartStock=1;

tmpPre='temp'; %Nazwa od kotrej zaczynam nazewnictwo zmiennych tymczasowych
stcPre='stTypeDef'; %Nazwa od ktorej zaczynam nazewnictwo definicj struktur

%Ustawienia translacji, domyslne
opt.trshBl=150; %treshold(poziom) jednego bloku danych, powyzej tej wartosci jest tworzony nowy blok danych
opt.trnScrOnlOnes=1;%Czy tlumaczyc skrypty tylko raz
opt.trnScrDoubTim=1;%Czy tlumaczyc skrypty podwojnie(drugie tlumaczenie jest dodawane, opcja wylaczona jezeli nie ma ustawienia tlumaczenia tylko raz na true), zapobiega to podwojnej alokacji zmiennych nieralkowalnych

opt.numVarInLine=10;%Ile definicji zmiennych umiescic w jednej linijce kodu(MIN=2).
opt.numStrInLine=3;%Ile inicjalizacji zmiennych znakowych umiescic w jednej linijce kodu(MIN=2).

opt.conStructWithSameNField=1;%Czy laczyc struktury z tymi samymi nazwami pol ale innymi typami
opt.conStructWithSameTSField=0;%Czy laczyc struktury z polami o tym samym typie i rozmiarze
opt.conStructInBigest=1;%Czy laczyc struktury w wieksze struktury, sugerujac sie tymi samymi
                        %nazwami pol. Wtedy niektore struktury moga miec niewykorzystywane pola
                        %Opcja niedostepna gdy nie jest wlaczone opt.conWithThisSameField
opt.commentInOpty=0;%czy komentowac usuwane fragmenty kodu w optymalizacji
opt.decConstIndexMatrix=1;%czy automatycznie zmniejszac indeksy stale tablic o 1
opt.decVarIndexMatrix=0;%czy automatycznie zmniejszac indeksy zmienne(podane jako zmienne) tablic o 1
opt.decConstIncLoop=1; %czy dekrementowac staly iterator w petli
opt.implicit=implict; %Czy uruchomic proste, prawie doslowne tlumaczenie MATALB na ANSI C
                      %*Zmienne stale nie maja uwzglednianej zmiany typu,
                      %typem wynikowym zmiennej jest ostatnio uzyty
                      %*jest uwzgledniana zmiana rozmiaru
                      %*wszystkie zmienen powinny byc zdefiniowane w bloku #C
opt.impIgnrChngTyp=1; %Czy ignorowac zmiany typu w trybie implicit(wyswietlic ostrzezenie). 
                      %Jezeli ignorowanie nie jest wylaczone, to przy zmianie typu program
                      %wyrzuci error i zakonczy dzialanie.
opt.impFindConst=0; %Czy wyszukiwac stale w zmiennych, podczas tlumaczenia w 
                    %trybie doslownym.
opt.maxMulNumInPow=4; %Maksymalna liczba "recznego" wpisania mnozen, zamiast malych poteg, gdzie wykladnik jest calkowity
                      %Np: A=A^2 -> A=A*A, B=B^4 -> B=B*B*B*B
                      %A te ktore sa powyzej to: PowINT(A,A,6,..);
lTC={}; %lista kodu w C, juz przetlumaczonego

mypwd='';
tConst={}; tGlobal={}; tVar={};
defMainFunc={}; %pusta lista, zawiera definicje dotlumaczanej funkcji przy wlaczonym prostym tlumaczeniu opt.implicit
%sprawdzenie zapisu z '\'
[b,idx]=strIsIn('\',fpath);
%Mam podana sciezke w postaci :\cos\cos\
if(b) for i=idx:length(fpath) if(fpath(i)=='\') idx=i; end; end;
else
    %Sprawdzam zapis z '/'
    [b,idx]=strIsIn('\',fpath);
    if(b) for i=idx:length(fpath) if(fpath(i)=='\') idx=i; end; end; end;
end
if(idx>1) mypwd=[fpath(1:idx)]; end
%Utworzenie folderu dla tlumaczonych plikow
sFolder='Trans';
t=mkdir([mypwd sFolder]);
if(t==1) sFolder=[sFolder '/']; else sFolder=''; end

%nazwa funkcji, od nazwy pliku
[b,idx]=strIsIn('.',defNam);
if(b) fdefNam=defNam(1:idx-1); else fdefNam=defNam; end
lTC{1}={'#include <stdio.h>',...
    '#include <stdlib.h>',...
    '#include <math.h>',...
    '#include "trans.h"',...
    '//#CONST Tutaj beda stale',...
    '//#STRUCT Tutaj def struktur',...
    '//#GLOBAL Tutaj beda globalne zmienne',...
    ['int ' fdefNam '(int argc,char** argv){'],...
    '//#VAR Tutaj beda zmienne',' '};
% lTC{2}={};

%% TRANSlACJA KODU:
lTC=T_MatTrans(lTC,fpath);
%zamkniecie klamra w main.tmp
lTC{end}{end+1}='return 0;';
lTC{end}{end+1}='}';
%% DOPASOWANIE STRUKTUR,
% lStuc: lStuc{1}-Pierwsza struktura
%        lStuc{k}{1} - lista nazw k-tej struktury
%        lStuc{k}{1}{n} - nazwa n-tego elementu k-tej struktury
%        lStuc{k}{2} - lista z polami k-tej struktury
%        lStuc{k}{2}{n} - lista z n-tym polem k-tej struktury(pole ma postac elementu z vname_list
lStuc={};
%przeszukuje liste zmiennych
%Dodaje struktury do listy lStuc
j=1;
while j<=length(vname_list)
    [b,idx]=strIsIn('.',vname_list{j}{1});
    %Znalazlem pole struktury
    if(b)
        %{Nazwa_struktur(po zmiennej) {Nazwa_pola+wszysto_Z_vname_list}}
        if(isempty(lStuc)) lStuc{1}={{vname_list{j}{1}(1:idx-1)} {{vname_list{j}{1}(idx+1:end) vname_list{j}{2:end}}}};
        else
            bFind=0;%indeks znalezionego elementu
            for k=1:length(lStuc) if(strcmp(lStuc{k}{1},vname_list{j}{1}(1:idx-1))) bFind=k; end, end;
            %Znalazlem strukture o podanej nazwie
            if(bFind) 
                %Sprawdzam czy podane pole jest podane
                bFindP=0;
                for k=1:length(lStuc{bFind}{2}) if(strcmp(lStuc{bFind}{2}{k}{1},vname_list{j}{1}(idx+1:end))) bFindP=k; end, end;
                %Jezeli nie mam dodanego tego pola to dodaje
                if(~bFindP) 
                    lStuc{bFind}={lStuc{bFind}{1} {lStuc{bFind}{2}{1:end} {vname_list{j}{1}(idx+1:end) vname_list{j}{2:end}}}};
                end
            %Nie znalazlem struktury o podanej nazwie to ja dodaje
            else
                lStuc{end+1}={{vname_list{j}{1}(1:idx-1)} {{vname_list{j}{1}(idx+1:end) vname_list{j}{2:end}}}};
            end
        end
    end
    j=j+1;
end
%Lacze pola struktur
j=1; %Lece po strukturach lStuc{j}{2}{l}
while j<length(lStuc) 
    if(opt.conStructWithSameNField&&~opt.conStructWithSameTSField)
        %Szukam pol o tych samych nazwach, roznych typach i lacze je w duze struktury
        if(opt.conStructInBigest)
            bFind=0;
            %Po strukturch lStuc{k}{2}{m}
            k=j+1;
            while k<=length(lStuc)
                %Tutaj musze znalezc jedno pasujace pole
                for l=1:length(lStuc{j}{2})
                    for m=1:length(lStuc{k}{2})
                        %Porownuje nazwy pol struktur
                        if(strcmp(lStuc{j}{2}{l}{1},lStuc{k}{2}{m}{1}))
                            bFind=k; break;
                        end
                    end
                    if(bFind) break; end
                end
                %Jezeli znalazlem pasujace pole to lacze te struktury
                if(bFind)
                    ScaleStructAndDelOld;
                    k=k-1;
                end
            k=k+1;
            end
        %Szukam pol o tych samych nazwa, roznych typach ale nie
        %lacze je w duze struktury, nie dodaje dodatkowych pol
        else
            %Po strukturch lStuc{k}{2}{m}
            k=j+1;
            while k<=length(lStuc)
                %Jezeli ilosc pol w obu strukturach sie zgadzaja to
                %wtedy ma sens sprawdzanie ich
                if(length(lStuc{j}{2})==length(lStuc{k}{2}))
                    %Sprawdzam pola, wszystkie nazwy musza sie zgadzac
                    bFind=0;
                    for l=1:length(lStuc{j}{2})
                        for m=1:length(lStuc{k}{2})
                            %Porownuje nazwy pol struktur
                            if(strcmp(lStuc{j}{2}{l}{1},lStuc{k}{2}{m}{1}))
                                bFind=bFind+1; break;
                            end
                        end
                    end
                    %Jezeli znalazlem wszystkie pola z pierwszej
                    %struktury w drugiej, to dodaje nazwe struktury
                    %i aktualizuje pola
                    if(bFind==length(lStuc{j}{2}))
                        ScaleStructAndDelOld;
                        k=k-1;
                    end
                end
                k=k+1;
            end
        end
    %Tutaj tworzymy dla roznych przypadkow osobne struktury
    %Rygorystyczne laczenie struktur
    elseif(opt.conStructWithSameNField&&opt.conStructWithSameTSField)
        %Po strukturch lStuc{k}{2}{m}
        k=j+1;
        while k<=length(lStuc)
            %Jezeli ilosc pol w obu strukturach sie zgadzaja to
            %wtedy ma sens sprawdzanie ich
            if(length(lStuc{j}{2})==length(lStuc{k}{2}))
                bFind=0;
                %Sprawdzam pola, wszystkie nazwy, typy, musza sie zgadzac
                %Brak realokacji i zmian typu
                for l=1:length(lStuc{j}{2})
                    for m=1:length(lStuc{k}{2})
                        %Porownuje nazwy pol struktur
                        if(strcmp(lStuc{j}{2}{l}{1},lStuc{k}{2}{m}{1})&&... %Te same nazwy
                           strcmp(lStuc{j}{2}{l}{2},lStuc{k}{2}{m}{2})&&... %Te same typy
                           ((lStuc{j}{2}{l}{6}==0)&&(lStuc{k}{2}{m}{6}==0)||...%Brak realokacji w obu elementach
                           (lStuc{j}{2}{l}{6}>0)&&(lStuc{k}{2}{m}{6}>0))&&...%Albo realokacja w kazdym
                           (lStuc{j}{2}{l}{3}==lStuc{k}{2}{m}{3})&&(lStuc{j}{2}{l}{4}==lStuc{k}{2}{m}{4})&&...%Te same rozmiary
                           ((lStuc{j}{2}{l}{7}==0)&&(lStuc{k}{2}{m}{7}==0)||...%Brak zmian typu
                           (lStuc{j}{2}{l}{7}>0)&&(lStuc{k}{2}{m}{7}>0)))%albo zmiana typu w kazdym
                           bFind=bFind+1; break;
                        end
                    end
                end
                %Jezeli znalazlem wszystkie pola z pierwszej
                %struktury w drugiej, to dodaje nazwe struktury
                %i aktualizuje pola
                if(bFind==length(lStuc{j}{2}))
                    ScaleStructAndDelOld;
                    k=k-1;
                end
            end
            k=k+1;
        end
    end
    j=j+1;
end

%% Aktualizacja definicji funkcji przy prostym tlumaczeniu kodu
tv=vname_list;%zapisanie tymczasowo list vname_list
if(opt.implicit&&~isempty(defMainFunc))
    for i=1:length(lTC{1})
        if(strcmp(lTC{1}{i},['int ' fdefNam '(int argc,char** argv){']))
            str=lTC{1}{i};
            [pusty,idxS]=strIsIn(' ',str);
            [pusty,idxB]=strIsIn('(',str);
            %dopisanie poprawnej nazwy, i zamiana na zapis: func(
            if(~strcmp(str(idxS+1:idxB-1),fdefNam))
                str=[str(1:idxS-1) str(idxB)];
            else
                str=[str(1:idxB)];
            end
            %dopisanie definicji zmiennych
            for j=1:length(defMainFunc{2})
               [b,el,idx]=GetFromNL(defMainFunc{2}{j},vname_list);
               %mam element wiec mam typ
               if(b)
                   if(el{6}>0)
                       str=[str(1:end) el{2} ' *' el{1} ','];
                   else
                       str=[str(1:end) el{2} ' ' el{1} ','];
                   end
               end
               if(idx==1) vname_list={vname_list{2:end}};
               else vname_list={vname_list{1:idx-1} vname_list{idx+1:end}}; end
            end
            %jezeli nia mam pustej listy i byly zmienne do dopisania
            if(length(defMainFunc)>1&&~isempty(defMainFunc{2}))
                str=[str(1:end-1) '){']; %zamiana ostatniego przecinka na nawias
            end
            %zapisanie zmodyfikowanej linijki
            lTC{1}{i}=str;
            break;
        end
    end
end
%% ANALIZA ZMIENNYCH
%Tutaj dopisanie zmiennych do list definicji: tConst tGlobal tVar
bEnd=false;
i=1;
[pusty,nB]=size(lTC);
%Analiza zmiennych, podzial na grupy:
%Wybranie ciagow znakowych
nInLine=opt.numStrInLine; %Po ile zmienych znakowych w jednej linijce
j=1; tType='char ';  nGInL=0; nVInL=0;
while j<=length(vname_list)
    el=vname_list{j};
    %Nie temp, jedno przypisanie, nie moze byc Macierza i
    %nie moze byc realokowalne
    if(strcmp(el{2},'char'))
        nel=[el{1} '='];
        for nnB=1:nB
            k=1;
            while(k<=length(lTC{nnB}))
                %znalazlem linijke z kodem
                if((length(lTC{nnB}{k})>length(nel))&&strcmp(lTC{nnB}{k}(1:length(nel)),nel))
                    %sprawdzam czy opcja
                    %komentowania usuwanego kodu jest wlaczona
                    if(opt.commentInOpty) lTC{nnB}{k}=['//',lTC{nnB}{k}(1:end)];
                    %Jezeli opcja jest wylaczona
                    %k-2 zeby usunac dodatkowe //Trans: ..
                    else lTC{nnB}={lTC{nnB}{1:k-2} lTC{nnB}{k+1:end}}; 
                    end
                    [b,idx]=strIsIn(char(39),lTC{nnB}{k});
                    %podane jest cos innego niz alokacja: A='cos';
                    if(b&&(lTC{nnB}{k}(end)==';')) 
                      el{1}=[el{1},'[',num2str(el{4}+1),']="',lTC{nnB}{k}(idx+1:end-2),'"'];
                    elseif(b)
                      el{1}=[el{1},'[',num2str(el{4}+1),']="',lTC{nnB}{k}(idx+1:end-1),'"'];
                    end
                end
                k=k+1;
            end
        end
        CheckGlobalLocalVar;
    end
    j=j+1;
end
if(~isempty(tVar)) tVar{1}(end)=';'; tVar{end+1}=''; end
if(~isempty(tGlobal)) tGlobal{1}(end)=';'; tGlobal{end+1}=''; end
%Wybranie stalych
j=1; 
while j<=length(vname_list)
    el=vname_list{j};
    %Nie temp, jedno przypisanie, nie moze byc Macierza i
    %nie moze byc realokowalne
    if(strIsIn('.',el{1})) j=j+1; continue; end
    if(~IsTmpN(el{1})&&(el{5}==1)&&(el{8}<=2)&&(el{8}>0)&&(el{6}==0)&&(el{7}==0))
        %opcja prostego tlumaczenia, nie szukamy stalych, musza byc
        %zdefiniowane
        if(opt.implicit)
            %sprawdzam czy podana zmienna jest juz w tConst
            t=['%s' el{1} '%s']; bAdd=false;
            for k=1:length(tConst)
                if(IsLike(tConst{k},t))
                    if(j==1) vname_list={vname_list{2:end}};
                    else vname_list={vname_list{1:j-1} vname_list{j+1:end}};
                    end
                    bAdd=true;
                    break;
                end
            end
            if(bAdd) continue; end
        end
        %Jezeli mam wylaczone wyszukiwanie zmiennych w trybie implicit
        if(opt.implicit&&~opt.impFindConst)
            j=j+1; continue;
        end
        %Mam pojedyncze przypisanie, wiec jest to albo kod glowny, albo w
        %jednym ze skryptow ktory ma tylko jedno tlumaczenie
        bAdd=false; val='';
        if(el{8}<=1)
            %szukam odpowiedniego przypisania w kodzie stalej
            [bAdd,val,lTC]=FDefConst(el,lTC);
            %przeszukuje pojedyncze tlumaczenia skryptow
            if(~bAdd)
                for k=length(fname_list):-1:lcfname_list
                    if((fname_list{k}{2}>0)&&(length(fname_list{k})<4))
                        %zapis pierwszego i drugiego tlumaczenia
                        [bAdd,val,fname_list{k}{3}]=FDefConst(el,fname_list{k}{3});
                        if(bAdd) break; end;
                    end
                end
            end
        %Mam podwojne przypisanie wiec sprawdzam tylko podwojnie tlumaczone
        %skrypty, jezeli tam tego nie ma, to nie jest to stala
        else
            %przeszukuje podwojne tlumaczenia skryptow
            for k=length(fname_list):-1:lcfname_list
                if((fname_list{k}{2}>0)&&(length(fname_list{k})>3))
                    %zapis pierwszego i drugiego tlumaczenia
                    [tAdd1,val1,fname_list{k}{3}]=FDefConst(el,fname_list{k}{3});
                    [tAdd2,val2,fname_list{k}{4}]=FDefConst(el,fname_list{k}{4});
                    if(tAdd1&&tAdd2&&strcmp(val1,val2)) bAdd=true; val=val1; break; end;
                end
            end
        end
        if(bAdd)
            tConst={tConst{1:end} ['#define ',el{1},' (',val,')']};
            if(j==1) vname_list={vname_list{2:end}};
            else vname_list={vname_list{1:j-1} vname_list{j+1:end}};
            end
            continue; %usuwam obecny element wiec musze zaczac znow od tego sameog indeksu       
        end
    end
    j=j+1;
end
%Dopisanie wszystkich zmiennych
%Najpierw void *ptr;
nInLine=opt.numVarInLine; %Po ile zmienych w jednej linijce
j=1; tType='void '; nGInL=0; nVInL=0;
while j<=length(vname_list)
    el=vname_list{j};
    if(~strIsIn('.',el{1})&&(IsTmpN(el{1})||(el{6}>0&&el{7}>0)))
        el{1}=['*',el{1}];
        %Skrypt do porownania oraz aktualizacji listy zmiennych
        CheckGlobalLocalVar;
        continue; %usuwam obecny element wiec musze zaczac znow od tego sameog indeksu
    end
    j=j+1;
end
if(~isempty(tVar)&&(length(tVar)>0)&&~isempty(tVar{end})) tVar{end}(end)=';'; tVar{end+1}=''; end
if(~isempty(tGlobal)&&(length(tGlobal)>0)&&~isempty(tGlobal{end})) tGlobal{end}(end)=';'; tGlobal{end+1}=''; end
%Dodanie wszystkich zmiennych
j=1; 
while j<=length(vname_list)
    el=vname_list{j};
    %Nie dodaje pol struktur i struktur, to jest zrobione pozniej
    if(~strIsIn('.',el{1})&&~strcmp(el{2},'struct'))
        k=j; ttType=el{2}; nGInL=0; nVInL=0;
        while j<=length(vname_list)
            el=vname_list{j};
            if(~strIsIn('.',el{1})&&strcmp(el{2},ttType))
                %Dodatkowe sprawdzenie, jezeli typ jest double* to, '*'
                %dodaje do zmiennej a nie do typu
                while(strIsIn('*',el{2})) 
                    [pusty,idx]=strIsIn('*',el{2});
                    el{1}=['*',el{1}(1:end)];
                    el{2}=[el{2}(1:idx-1) el{2}(idx+1:end)];
                end
                %Jezeli rozmiar jest wiekszy od 1 to jest to macierz/ wektor lub jezeli jest wiele realokacji
                %ale 0 zmian typu, zamiana na el{5}==0 <-Macierz
                %STARE:if((el{5}==0)||(el{6}>0&&el{7}==0)) 
                if(el{5}==0||el{6}>0) 
                    CreatStatDynamTab;
                end
                tType=[el{2} ' '];
                %Skrypt do porownania oraz aktualizacji listy zmiennych
                CheckGlobalLocalVar;
                continue;
            end
            j=j+1;
        end
        j=k;
        if(~isempty(tVar)&&~isempty(tVar{end})) tVar{end}(end)=';'; tVar{end+1}=''; end
        if(~isempty(tGlobal)&&~isempty(tGlobal{end})) tGlobal{end}(end)=';'; tGlobal{end+1}=''; end
        continue;
    end
    j=j+1;
end
%% DOPISANIE ZMIENNYCH
%Dopisanie zmiennych do listy z przetlumaczonym kodem w C lTC
while (~bEnd)&&(i<length(lTC{1}))
    line=lTC{1}{i};
    if(isempty(line)) i=i+1; continue; end;
    while 1
        if IsLike(line,'//#%s')
            if IsLike(line,'%sCONST%s')
                %Dopisanie wszystkich stalych
                if(~isempty(tConst)) lTC{1}={lTC{1}{1:i} tConst{1:end} lTC{1}{i+1:end}}; end               
                break;
            end
            if IsLike(line,'%sSTRUCT%s')
                %Dopisanie definicji struktur oraz utworzenie zmiennych
                % lStuc: lStuc{1}-Pierwsza struktura
                %        lStuc{k}{1} - lista nazw k-tej struktury
                %        lStuc{k}{1}{n} - nazwa n-tego elementu k-tej struktury
                %        lStuc{k}{2} - lista z polami k-tej struktury
                %        lStuc{k}{2}{n} - lista z n-tym polem k-tej struktury(pole ma postac elementu z vname_list
                if(~isempty(lStuc))
                    %ide po strukturach, Tworzenie definicji struktur
                    for j=1:length(lStuc)
                        tStruct={};
                        tStruct{1}=['typedef struct{'];
                        for k=1:length(lStuc{j}{2})
                            type=lStuc{j}{2}{k}{2};
                            tAdd=[]; stcN=[stcPre lStuc{j}{1}{1}];
                            %Jezeli sa zmiany typow
                            if(lStuc{j}{2}{k}{7}>0) tAdd=['void *' lStuc{j}{2}{k}{1},';'];
                            %Jezeli tylko realokacje to typ*
                            elseif(lStuc{j}{2}{k}{6}>0) tAdd=[type ' *' lStuc{j}{2}{k}{1},';'];
                            %Stala Macierz
                            elseif(lStuc{j}{2}{k}{5}==0)
                                %Wyrzucenie zapisow B[1][10];
                                if(IsNumber(lStuc{j}{2}{k}{3})&&(lStuc{j}{2}{k}{3}==1)) tAdd=[type ' ' lStuc{j}{2}{k}{1},'[',num2str(lStuc{j}{2}{k}{4}),'];'];
                                elseif(IsNumber(lStuc{j}{2}{k}{4})&&(lStuc{j}{2}{k}{4}==1)) tAdd=[type ' ' lStuc{j}{2}{k}{1},'[',num2str(lStuc{j}{2}{k}{3}),'];'];
                                else tAdd=[type ' ' lStuc{j}{2}{k}{1},'[',num2str(lStuc{j}{2}{k}{3}),'][',num2str(lStuc{j}{2}{k}{4}),'];']; end;
                            %Stala zmienna
                            else
                                tAdd=[type ' ' lStuc{j}{2}{k}{1} ';'];
                            end
                            tStruct{k+1}=tAdd;
                        end
                        for k=1:length(lStuc{j}{1})
                            %Aktualizuje liste zmiennych o typy dodanych
                            %elementow
                            [b,~,idx]=GetFromNL(lStuc{j}{1}{k},vname_list);
                            if(b)
                                vname_list{idx}{2}=stcN;
                            %Nie mam struktury w liscie
                            else
                                el={lStuc{j}{1}{k},stcN,1,1,1};
                                AddToNL(el);
                            end 
                        end
                        tStruct{end+1}=['} ',stcN,';'];
                        lTC{1}={lTC{1}{1:i} tStruct{1:end} ' ' lTC{1}{i+1:end}};
                    end
                    %Dopisanie struktur, oraz reszte typow, jezeli jakies
                    %sa (a nie powinno ich byc),
                    %Na tym etapie mam poprawny typ struktur w vname_list
                    k=1;
                    while k<=length(vname_list)
                        el=vname_list{k};
                        %Pola pomijam
                        if(~strIsIn('.',el{1})) tType=vname_list{k}{2};
                        else
                            k=k+1;
                            continue; 
                        end
                        j=k;
                        while j<=length(vname_list)
                           el=vname_list{j};
                           if(strcmp(el{2},tType))
                               %Dopisuje wlasciwy typ struktury
                               [pusty,pusty,idx]=GetFromNL(el{1},tv);
                               tv{idx}{2}=tType;
                               %Wszystkie sa struct*
                               el{1}=[' *',el{1}];
                               %Problem poniewaz w skrypcie CheckGlobalLocalVar usuwam po zmiennej j
                               %a w tym momencie musze usuwac po zmiennej k
                               %Rozw: zamiana k i j kolejnoscia
                               CheckGlobalLocalVar;
                               continue;
                           end
                           j=j+1;
                        end
                        if(~isempty(tVar)&&~isempty(tVar{end})) tVar{end}(end)=';'; tVar{end+1}=''; end
                        if(~isempty(tGlobal)&&~isempty(tGlobal{end})) tGlobal{end}(end)=';'; tGlobal{end+1}=''; end
                    end
                end
                break;
            end
            if IsLike(line,'%sGLOBAL%s')
                %Dopisanie wszystkich globalnych zmiennych
                if(~isempty(tGlobal)) lTC{1}={lTC{1}{1:i} tGlobal{1:end} lTC{1}{i+1:end}}; end 
                break;
            end
            if IsLike(line,'%sFUNCTION%s')
                %Dopisanie wszystkich funkcji
                break;
            end
            %Dodaje zmienne, pomijam pola struktur
            if IsLike(line,'%sVAR%s')           
                %dodanie utworzonych zmiennych 
                if(~isempty(tVar)) lTC{1}={lTC{1}{1:i} tVar{1:end} lTC{1}{i+1:end}}; end
                %Warunek wyjscia z glownego whila
                bEnd=true;
                break;
            end
        end
        break;
    end
    i=i+1;
end
vname_list=tv;
fprintf('Nazwa/Typ/lcol/lrow/Typ_Zmi(M/S)/l_re/lPrzy\n');
pfl(vname_list);

%% OPTYMALIZACJA KODU GLOWNEGO I SKRYPTOW
%Optymalizacja g³ównego kodu
lTC=OptymFunc(lTC);
%Optymalizacja funkcji
for i=1:length(fname_list)
    fname_list{i};
    %skrypt/funkcja urzutkownika
    if(fname_list{i}{2}>0)
        if(length(fname_list{i})>=4)
            %zapis pierwszego i drugiego tlumaczenia
            fname_list{i}{3}=OptymFunc(fname_list{i}{3});
            fname_list{i}{4}=OptymFunc(fname_list{i}{4});
        else
            %zapis tylko pierwszego tlumaczenia
            fname_list{i}{3}=OptymFunc(fname_list{i}{3});
        end
    end
end

%% ZAPISANIE TLUMACZEN SKRYPTOW
fprintf('\nFunkcje:\n');
pfl(fname_list)
%Zapisanie tlumaczen funkcji do pliku:
for i=1:length(fname_list)
    el=fname_list{i};
    %skrypt/funkcja urzutkownika
    if(el{2}>0)
        if(length(el)>=4)
            %zapis pierwszego i drugiego tlumaczenia
            if(WLFunc2F(el{3},[mypwd sFolder el{3}{1}{1}(3:end)])) return; end;
            if(WLFunc2F(el{4},[mypwd sFolder el{4}{1}{1}(3:end)])) return; end;
        else
            %zapis tylko pierwszego tlumaczenia
            if(WLFunc2F(el{3},[mypwd sFolder el{3}{1}{1}(3:end)])) return; end;
        end
    end
end
 %% ZAPISANIE GLOWNEGO PLIKU MAIN.C
%Zapisanie do pliku glownego
if(WLFunc2F(lTC,[mypwd sFolder defNam])) return; end; %jezeli sie nie powiodlo to zwracam pusta liste

%% KONIEC
%Zwrot przetlumaczonego kodu w liscie lTC, usuniecie tymczasowego pliku z
%przechowywanym 'workspace-em' z pliku tlumaczonego
delete(kod);
lOut=lTC;
end