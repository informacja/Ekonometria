function [ strBufC_out ] = T_ArgC( lInst, lDefStuc )
%T_ARGC Interpretuje kod C umieszczony w bloku #CSTART - #CEND lub jednej
%lini #C
%IN:
%lInst-lista instrukcji lub jedna pojedyncza instrukcja
%lDefStuc-lista z nazwami struktur, podawana przy definicji struktur
%       struct{ double a,b;}Ala,Cela; zostaje zemienione na wyowalnie
%       funkcji z:
%       lInst={'double a,b;'}; lDefStuc={'Ala','Cela'};
%OUT:
%strBufC_out-lista z kodem w C do dopisania
%
%Ogolne zasady pisania:
%   *) Blok jednolinijkowy zaczyna siê od: %#C, mozna to zmienic w opcjach,
%   wielkosc liter nie ma znaczenia.
%   *) Blok wielolinijkowy jest rozpatrywany miedzy %#CSTART..%#CEND, mozna
%   to zmienic w opcjach, wielkosc liter nie ma znaczenia. 
%   *) Po nazwie poczatku bloku wielolinijkowego (#CSTART) nie powinno nic
%   byc, wszelkie komendy po slowie kluczowym sa ignorowane, to samo
%   dotyczy #CEND.
%   *) Makra #defina s¹ jednolinijkowe i nie moze byc ich wiecej niz jedno
%   w pojedynczej lini
%   *) Slowa kluczowe definicji typow sa zapisane w zmiennej checkType, aby
%   dodac nowe slowa kluczowe, nalezy dopisac je po spacji miedzy znaki '#'
%   *) Starac sie pisac jeden typ - jedna linijka.
%   *) Aby dodac zmienna globalna, nalezy przed blokiem #C dodac slowko
%   kluczowe w Matlabie global A; a pozniej w bloku #C okreslic jakiego
%   rodzaju jest zmienna A. Program wtedy poprawnie zinterpretuje ja jako
%   globalna.
%   *) Z zalozen maksymalny indeksowany rozmiar tablicy w definicji moze
%   byc dwuwymiarowy, czyli zapisy: double A[10][10][100]; sa
%   niedopuszczalne.
%   *) W definicjach struktur, nazwy struktury musza byc podane w jednej
%   linijce po klamrze zamykajacej definicje pol struktury.
%   Przyklad: }St1,st2,st3;
%   *) W definicji wielolinijkowej struktury nie moze byc lini pustych i
%   musi byc zachowany schemat:
%       struct{
%       ...//definicje pol;
%       }nazwaStruktury1,nazwaStruktury2;
%   *) Pola struktur musza byc zmiennymi stalymi, nie wskaznikowymi.
%   *) Zakazane sa zapisy typu: (), {}, ,, ;;.
%   *) Kazda instrukcja(oprocz makrodefinicji) konczy sie pojedynczym
%   srednikiem.
global tConst tVarInit tvn_list idxStartStock vname_list defCBStuc;

strBufC_out={}; bDefStuc=false;
%Jezeli mam podana definicje struktury do wpisania
if(nargin>1&&~isempty(lDefStuc)&&iscell(lDefStuc)) bDefStuc=true; end
if(isempty(lInst)) return; end
if(~iscell(lInst)) lInst={lInst}; end

%Stale rozroznialne
tBuf={};
tDefB='';
bSInst=0; %czy zaczeta jest jakas instrukcja, kazda instrukcja konczy sie srednikiem
bAddLine=0; %czy dodawac linie kodu zawarte w C w bloku do przetlumaczonego kodu
idxSInst=0; %indeks poczatku instrukcji w C
checkType='%l#unsigned long double int char struct#';
%przeszukuje liste instrukcji w C
i=1;
while i<=length(lInst)
    str=lInst{i}; j=1;
    %Usuwam wszystko przed znakami, ASCII(32) to spacja
    if str(j)<33
        while str(j)<33 j=j+1; end;
        %nie mam zadnych znakow w linijce
        if(j>=length(str)) i=i+1; continue; end
        str=str(j:end);
    end
    j=1;
    %Jezeli pierwszym elementem jest { to znaczy ze otwarty jest blok
    if(str(1)=='{') 
        str=[str(2:end)]; 
        %w jednym rozpoczetym bloku, mam tylko jeden dodatkowy stos
        if(idxStartStock==1) idxStartStock=length(vname_list)+1; end
        bAddLine=true;
        tBuf{end+1}='{';
    end
    %jezeli elementem jest '}' to znaczy ze konczymy blok, wszyzstie
    %instrukcje po tym znaku, w tej samej lini, sa igrnorowane
    if(str(1)=='}')
        %zapisanie zmiennych bloku do tymczasowej listy zmiennych
        tvn_list{end+1}={vname_list{idxStartStock:end}};
        %usuniecie zmiennych wystepujacych w bloku
        vname_list={vname_list{1:idxStartStock-1}};
        idxStartStock=1;
        tBuf{end+1}='}';
        i=i+1; continue;
    end
    %optymalizacja, miedzy instrukcjami sa tylko pojedyncze spacje,
    %cos takiego: a ,b -> a,b
    j=1; cS=0;
    while(j<=length(str))
        %mam juz spacje, wiec usuwam powtarzajace sie spacje
        if(cS&&(str(j)==' '))
            if((j+1)<=length(str)) str=[str(1:j-1) str(j+1:end)];
            else str=[str(1:j-1)]; end
            continue;
        %mam spacje i pojawil sie przecinek lub srednik
        %usuwam obecna spacje, przed jakimi znakami usuwac spacje
        elseif(cS&&IsLike(str(j),'%l#, ;#'))
            if((j-2)>0) str=[str(1:j-2) str(j:end)];
            else str=[str(j:end)]; end
            cS=0; continue;
        elseif(cS) cS=0;
        %za jakimi znakami usuwac spacje
        elseif((str(j)==' ')||IsLike(str(j),'%l#, ;#')) cS=1; end %mam spacje,przecinek,srednik
        j=j+1;
    end
    %Dopisanie tlumaczonej linijki
    if(bAddLine)
        tBuf{end+1}=str;
    end
    
    j=1;
    %przegladam instrukcje znak po znaku.
    while(j<=length(str))
        %% SPRAWDZAM DEFINICJE STALYCH
        if(str(1)=='#')
            lDef=length('#define');
            if((length(str)>lDef)&&strcmp(str(1:lDef),'#define'))
                %wybieram nazwe
                [pusty,idxS]=strIsIn(' ',str);
                [pusty,idxM]=strIsIn(' ',str(idxS+1:end)); idxM=idxM+idxS-1;
                t=str(idxS+1:idxM-1); %nazwa
%                 td=str(idxM+1:end);%wartosc
                AddToNL({t 'long int' 1 1 1 0 0 1});
                tConst={tConst{1:end} str};
                break;
            end
        end
        %% SPRAWDZAM CZY MAM PODANA DEFINICJE STRUKTURY
        %Czy znalazlem definicje struktury
        if(str(j)=='s'&&((j+length(defCBStuc)-1)<=length(str))&&strcmp(str(j:j-1+length(defCBStuc)),defCBStuc))
            %ide do konca definicji, uwzgledniam mozliwosc zapisu
            %wielolinijkowego
            ii=i; idxF=0; lNStuc={};
            while(ii<=length(lInst)) 
                [b,idxF]=strIsIn('}',lInst{ii}); 
                %Znalazlem klamre, pobieram nazwy struktur
                if(b) 
                    %Zeby nie utrudniac sa 2 znaki konczace/rozdzielajace
                    %nazwy struktur: ',' ';'
                    tstr=strDelChar(lInst{ii}(idxF+1:end),' ');
                    k=1;
                    while(k<length(tstr))&&(tstr(k)~=';')
                        %pobieram srednik i przecinek
                        [bS,idxS]=strIsIn(',',tstr);
                        [bM,idxM]=strIsIn(';',tstr);
                        %Nie mam przecinka lub jest dalej niz srednik, ostatnia instrukcja.
                        if(~bS||(bS&&bM&&(idxS>idxM)))
                            lNStuc{end+1}=tstr(k:idxM-1);
                            k=idxM;
                        %Znalazlem przecinek i jest on przed srednikiem
                        elseif(bS&&bM&&(idxS<idxM))
                            lNStuc{end+1}=tstr(k:idxS-1);
                            tstr=tstr(idxS+1:end);
                            k=1;
                        %Nie znalazlem srednika, blad    
                        elseif(~bM)
                            return;
                        end
                    end
                    break; 
                end; 
                ii=ii+1; 
            end
            %Jezeli licznik jest wiekszy niz rozmiar listy to nie
            %znaleziono nawiasu zamykajacego, wychodze bo cos jest zle
            if(ii>length(lInst)) return; end;
            %Jezeli nie mam podanych nazw struktur to ignoruje kod i ide
            %dalej
            if(~isempty(lNStuc))
                %Tworze definicje struktur
                tName='struct ';
                for l=1:length(lNStuc) tName=[tName lNStuc{l} ',']; end
                tName(end)=';';
                %Jezeli definicja struktury jest jednolinijkowa
                if(i==ii)
                    %Pobieram index nawiasu zamykajacego w str;
                    [pusty,idxF]=strIsIn('}',str);
                    ttBuf=T_ArgC(str(j+length(defCBStuc):idxF-1),lNStuc);
                    %Dopisuje definicje struktur
                    [pusty,idxM]=strIsIn(';',str(idxF:end));
                    str=[str(1:j-1) tName str(idxF+idxM:end)];
                %Wielolinijkowa definicja struktury
                else
                    [pusty,idxF]=strIsIn('}',lInst{ii});
                    ttBuf=T_ArgC({lInst{i+1:ii-1}},lNStuc);
                    lInst={lInst{1:i-1} tName lInst{ii+1:end}};
                    str=lInst{i};
                end
            end
        end
        
        %% ROZPATRUJE INSTRUKCJE: DOUBLE...
        %pobieram pierwsza instrukcje
        if(~bSInst)
            [bS,idxS]=strIsIn(' ',str(j:end)); idxS=idxS+j-1;
            [bM,idxM]=strIsIn(';',str(j:end)); idxM=idxM+j-1;
            if((bS&&~bM)||(bS&&bM&&(idxS<idxM)))
                if(IsLike(str(j:idxS-1),checkType))
                    tDefB=[tDefB str(j:idxS-1) ' '];
                end
                j=idxS;
            %Nie znalazlem spacji, lub ja znalazlem ale po sredniku    
            elseif((~bS)||(bS&&bM&&(idxS>idxM)))
                bSInst=1;
                if(~isempty(tDefB)) tDefB=[tDefB(1:end-1)]; end
                continue;
            end
        %mam tDefB, czyli dodaje zmienne    
        elseif(~isempty(tDefB))
            %lapie przecinek
            [bS,idxS]=strIsIn(',',str(j:end)); idxS=idxS+j-1;
            [bM,idxM]=strIsIn(';',str(j:end)); idxM=idxM+j-1;
            if((bS&&~bM)||(bS&&bM&&(idxS<idxM)))
                %dodaje zmienne do przecinka
                idxB=j; idxE=idxS-1;
                ArgCAddVar;
                j=idxS;
            %Nie znalazlem spacji, lub ja znalazlem ale po sredniku    
            elseif((~bS&&bM)||(bS&&bM&&(idxS>idxM)))
                bSInst=0;
                idxB=j; idxE=idxM-1;
                ArgCAddVar;
                %usuwam dodany fragment
                tDefB='';
                str=str(idxM+1:end);
                if(isempty(str)) break; end
                j=1; continue;
            end
        %mam jakas blizej nie okreslona instrukcje w C, i dodawanie lini
        % w bloku jest wylaczone, wklejam ja
        else
            if(~isempty(str(1:j))&&~bAddLine) strBufC_out{end+1}=str(1:j); end
        end
        j=j+1;
    end
    i=i+1;
end

strBufC_out=tBuf;
end