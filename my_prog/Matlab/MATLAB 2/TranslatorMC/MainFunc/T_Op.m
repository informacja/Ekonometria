function [ lN_out, stmpIdx_out, strBufList] = T_Op(str, stmpIdx, strBufC, delTmp)
%funkcja
%IN:
%str - dzialanie
%stmpIdx - liczba uzywanych i juz zainicjalizowanych zmiennych tymczasowych
%          domyslnie 0
%strBufC - lista z kolejnymi linijkami przetlumaczonego kodu w C
%delTemp - zmienna okreslajaca zwalniac zaalokowana pamiec zminnych
%          tymczasowych temp, domyslnie zwalniam
%
%OUT:
%stmpIdx_out - indeks od ktorego mozna zaczac dalsza indeksacje poza
%              funkcja, zazwyczaj 0 lub 1 przy pojedynczym wywolaniu
%              funkcji

%*Na poczatku sprwadzic czy w obliczeniach nie ma tablic tymczasowych
%   typu: [...], 1:..:100, 
%   zastapic wyrazenia funkcji sum(A..)
%   zamienic wyrazenia tymczasowych krotkich odwolan: A(3:end) A(1:4,2:3)
%-(ZROBIONE) Wielokrotne u¿ywanie tych samych zmiennych tymczasowych do tych samych
%           fragmentów kodu: A=A'*A'/B na A=temp0*temp0/B
%           A=(A/B)*2+(A/B)^5*(A/B)*((A/B)-1) na A=t0*2+t0^5*t0*(t0-1)
global vname_list tmpPre opt;

%% Glowne zmienne
if(nargin<2) stmpIdx=0; end;
if(nargin<3) strBufC={}; end;
if(nargin<4) delTmp=1; end;
lN_out=[];
stmpIdx_out=stmpIdx;
b=false;%pomocnicza zmienan logiczna uzywana w roznych fragmentach funkcji
if(~isempty(strBufC)) strBufList=strBufC;
else strBufList={}; end %Bufor kolejnych linijek przetlumaczonego kodu Matlaba na C
tmpList={};%lista zmiennych tymczasowych: temp0, temp1, temp2..
             %ostatnim elementem na liscie jest nazwa zmiennej wynikowej
opTmpList={};%lista przechowuje fragmenty dzialan odpowiadajacych zmiennych tymczasowych
        %temp0='A+B', temp1='B+C' itd.. 
strOld=str;
%% Wstepne przygotowanie:
% * Usuniecie zbednych spacji
str=strDelChar(str,' ');
% * Usuniecie srednika z konca
if(str(end)==';') str=str(1:(end-1)); end
% * Usuwanie niepotrzebnych nawiasow typu: (A(1)) (((A(1)))
% i=0; while((str(i+1)=='(')&&(str(end)==')')) i=i+1; end
% if(i>0) str=str((i+1):1:(end-1)); end
% * Pobranie nazwy wynikowej, jezeli taka jest
lNe=[];%nazwa zmiennej po lewej stronie znaku rownosci (wynikowa zmienna)
bCheck=false; %zmienna okresla czy nazwa wynikowa ma postac A(12)=..
for i=1:length(str)
    if str(i)=='='
        if(bCheck)
            [lN_out,stmpIdx_out,strBufList]=T_LEqArg(str,stmpIdx,strBufC);
            return;
        end
        lNe=str(1:i-1); %zapisanie nazwy zmiennej wynikowej
        str=str(i+1:length(str));%usuniecie znaku rownosci
        break;
    elseif(str(i)=='(') bCheck=true; end
end
slNe=0; %Status nazwy wynikowej: 0: ZmWyn nie wystepuje w obliczeniach A=C+D;
        %                        1: ZmWyn wystepuje w obliczeniach i
        %                           trzeba sprawdzic czy jej rozmiar zwracany
        %                           jest inny niz ten w obliczeniach A=A*C;
        %                        2: (tego nie ma)ZmWyn wystepuje w obliczeniach oraz
        %                           jej rozmiar zwracany jest inny niz ten w
        %                           obliczeniach(stosuje tempa + przypisanie
        %                           na koncu 'Eq')
wtmpNe=0;%Logiczna wartosc czy mamy utworzona zmienna temp jako wynik dzialania
% * Jezeli nie mam lewej nazwy wynikowej to ja tworze
if(isempty(lNe)) lNe=[tmpPre num2str(stmpIdx)]; stmpIdx=stmpIdx+1; wtmpNe=1;
elseif(strInOp(lNe,str)) slNe=1; end

%% Dodanie tymczasowych zmiennych typu: A', A(1:2), 1:2:3, 
%Zamiana skladni 'A(1)' ,A(1,2), A(temp0), A(C,C), itd..
if(IsLike(str,'%s(%s)')&&~strIsIn(char(39),str))
    i=2;
    while i<=length(str)
        if((i>1)&&(str(i)=='(')&&(IsLetter(str(i-1))||IsNumber(str(i-1))))
            %cofam sie do poczatku
            j=i-1;
            %Musze pomijac kropke przy polach struktur
            %while((j>1)&&(IsLetter(str(j))||str(j)=='.')) j=j-1; end
            while((j>1)&&~IsOperator(str(j))) j=j-1; end
                
            k=i+1; inden=1;
            while((inden>0)&&(k<=length(str))) 
                if(str(k)=='(') inden=inden+1; 
                elseif(str(k)==')') inden=inden-1;
                end
                k=k+1;
            end
            %jedno ze sprpawdzen czy nie mam podene czegos takiego:
            %(2*sqrt(3)), wtedy k bedzie na ostatnim ')' i bedzie mialo rozmiar length, czyli
            %str(j:k)=='sqrt(3))', a to blad!
            if((k-1>0)&&str(k-1)==')') k=k-1;
            elseif k~=length(str) k=k-1; end
            %j-indeks poczatku nazwy z nawiasami 'ala(C(..))'
            %k-indeks ostatniego nawiasu pasujacego do ciagu wywolani 'ala(..)'
            tN=''; tBufC={};
            %Bardzo wazne sprawdzenie, zapobiega nadmiarowosci tempow
            %przy tlumaczeniu B=A(..):
            % temp1=malloc(sizeof(double)*4*1);
            % HProdMC(temp1,C,1,4,1,1,1,double,double,long int,-);
            % temp0=malloc(sizeof(double)*4*1); <--ZBEDNY TEMP 
            % EqMMC(temp0,A,temp1,1,4,4,1,4,1,1,double,double,long int);
            % free(temp1); <--TO WSZYTKO PONIZEJ ZBEDNE
            % free(D); D=malloc(sizeof(double)*4*1);
            % EqMM(D,temp0,4,1,double,double);
            % free(temp0);
            %Powinno byc tylko:
            %free(D); D=malloc(sizeof(double)*4*1);
            %EqMMC(D,A,temp1,1,4,4,1,4,1,1,double,double,long int);
            if(j>1) j=j+1; 
            elseif(j==1&&IsOperator(str(j))) j=j+1; 
            end 
            %Jezeli mam zapis: st1(..).pole(..) to przekazuje cale pole
            %struktury i zamieniam na tempa
            %Jezeli mam zapis: st1(..).pole to przekazuje specjalne
            %wywolanie struktury, zmieniam indeks st1 i zostawiam
            bCheck=false; %Czy jest zapis st1(..).pole
            if(((k+1)<length(str))&&(str(k+1)=='.'))
                bCheck=true;
                if(k+3<length(str)&&~IsOperator(str(k+1:k+2)))
                    l=k+2;
                    %szukam poczatku nawiasu w polu struktury
                    while(l<length(str)) 
                        %mam poczatek nawiasu w polu struktury
                        if(str(l)=='(') 
                            bCheck=false; cnaw=1; %szukam konca nawiasu w polu struktury
                            while((k<length(str))&&cnaw) 
                                if(str(l)=='(') cnaw=cnaw+1; elseif(str(l)==')') cnaw=cnaw-1; end
                                k=k+1;
                            end;
                        %podana jest kropka lub operator
                        elseif(IsOperator(str(l))||str(l)=='.') k=l-1; break; 
                        end;
                        l=l+1;
                        if(l==length(str)) k=l; end
                    end;
                else
                    bCheck=false;
                end
            end
            %sprawdzam czy nie mam zapisow typu A=zeros(2,2), wtedy
            %tworzone sa niepotrzebne tempy
            if((j==1)&&(k==length(str)))
                [lN_out,stmpIdx_out,strBufList]=T_TmpArg(strOld,stmpIdx,strBufC);
                return;
            end
            %Tutaj zapisy st1(..).pole
            if(bCheck)
                [tN,tIdx,strBufList,ttList]=idxCStruct(str(j:k),stmpIdx,strBufList);
                if(~isempty(ttList))
                    if(isempty(tmpList)) tmpList=ttList; else tmpList={tmpList{1:end} ttList{1:end}}; end;
                    for l=1:(tIdx-stmpIdx) opTmpList{end+1}=''; end;
                    stmpIdx=tIdx;
                end
            %zwyczajna zmienna/funkcja do T_TmpArg
            %st1(..).pole(..), zm(..), func(..)
            else
                %Pamietac, jest 3 w nocy, pisze to samo co u gory
                %Prawdopodobnie do poprawki, o dziwo dziala :)
                [bb,idxb]=strIsIn('(',str);
                [bd,idxd]=strIsIn('.',str);
                %Dodatkowe sprawdzenie, ktore kontroluje czy nie ma
                %podanego zapisu: A(cos)*0.5, wtedy znajdzie zaleznosc
                %prawidlowa jak w strukturze
                if(bd&&((idxd+1)<=length(str))&&IsNumber(str(idxd+1))) bd=0; end
                % Przypadek A(..).cos i nie jest to operator
                if(bb&&bd&&(idxb<idxd)&&~IsOperator(str(idxd:idxd+1)))
                    [tN,tIdx,strBufList,ttList]=idxCStruct(str(j:k),stmpIdx,strBufList);
                    if(length(tN)==(k-j+1)) str(j:k)=tN;
                    else str=[str(1:j-1) tN(1:end) str(k+1:end)];
                    end;
                    if(~isempty(ttList))
                        if(isempty(tmpList)) tmpList=ttList; else tmpList={tmpList{1:end} ttList{1:end}}; end;
                        for l=1:(tIdx-stmpIdx) opTmpList{end+1}=''; end;
                        stmpIdx=tIdx;
                    end
                end
                %analizuje: st1(..).pole(..), zm(..), func(..)
                [tN,tIdx,tBufC]=T_TmpArg(str(j:k),stmpIdx);                
                if(isempty(tN)) return; end
                strBufList={strBufList{1:end} tBufC{1:end}};
                stmpIdx=stmpIdx+1;
                tmpList{end+1}=tN; opTmpList{end+1}=''; 
                i=j+length(tN);
            end
            str=[str(1:j-1) tN str(k+1:end)];
%                 [tN,tIdx,tBufC]=T_TmpArg(str(j:k),stmpIdx);
%                 str=[tN str(k+1:end)];
%             else
%                 [tN,tIdx,tBufC]=T_TmpArg(str(j+1:k),stmpIdx);
%                 str=[str(1:j) tN str(k+1:end)];
%             endf
        end
        i=i+1;
    end
end
%%Jezeli jest podany ciag znakowy: A='Ala'
[b,idx]=strIsIn(char(39),str);
if(b)
    %Czy mam podane: A='Ala';
    tN=[]; tIdx=0; tBufC={};
    if(~IsTmpN(lNe))
        %Pobieram rozmiar z listy zmiennych, poniewaz Debug dobrze okresla
        [pusty,el,idx]=GetFromNL(lNe);
        [tN,tIdx,tBufC]=T_Init([lNe '=' str],stmpIdx);
        if(isempty(tN)) return; end;
        vname_list{idx}=el;
        strBufList={tBufC{1:end}};
        return;
    %Dziwna sytuacja, jest samo 'Ala', ale zwracamy tempa
    %Nie zajmujemy sie takimi przypadkami
    else
%         [tN,tIdx,tBufC]=T_Init(str,stmpIdx);
        return;
    end
end
%Zamiana 1:2:3
if(IsLike(str,'%s:%s'))
    i=1;
    while i<=length(str)
        if(str(i)==':')
            %krok wstecz, Petla Do-While
            j=i;
            while 1 
                j=j-1;
                if(str(j)==')')
                    j=j-1; cnaw=1;
                    while((j>0)&&(cnaw>0))
                        if(str(j)==')') cnaw=cnaw+1;
                        elseif(str(j)=='(') cnaw=cnaw-1; end
                        j=j-1;
                    end
                end
                %Warunek wyjscia z petli, szukam najwczesniejszego nawiasu
                if(((j-1)==0)||(str(j)=='(')) break; end;
            end
            if(j<1) j=j+1; end
            %krok wprzod, Petla Do-While
            k=i; 
            while 1 
                k=k+1;
                if(str(k)=='(')
                    k=k+1; cnaw=1;
                    %pomijam nawiasy
                    while((k<=length(str))&&(cnaw>0))
                        if(str(k)=='(') cnaw=cnaw+1;
                        elseif(str(k)==')') cnaw=cnaw-1; end
                        k=k+1;
                    end
                end
                %Warunek wyjscia z petli, pomijam operatory ':'
                if(((k+1)>length(str))||(str(k)==')')) break; end;
            end
            if(k>length(str)) k=k-1; end
            tN=''; tBufC={};
 
            if(j==1) 
                [tN,tIdx,tBufC]=T_Init(['(',str(j:k),')'],stmpIdx);
                str=[tN str(k+1:end)];
            else
                [tN,tIdx,tBufC]=T_Init(['(',str(j:k),')'],stmpIdx);
                str=[str(1:j-1) tN str(k+1:end)];
            end
            if(isempty(tN)) return; end
            strBufList={strBufList{1:end} tBufC{1:end}};
            tmpList{end+1}=tN; opTmpList{end+1}=''; 
            stmpIdx=stmpIdx+1;
            i=(j-1)+length(tN);
        end
        i=i+1;
    end
end

%Zamiana [...]
if(IsLike(str,'%s[%s'))
    i=1;
    while i<=length(str)
        if(str(i)=='[')
            j=i+1; cnaw=1;
            while(j<=length(str)&&(cnaw>0))
                if(str(j)==']') cnaw=cnaw-1;
                elseif(str(j)=='[') cnaw=cnaw+1; end
                j=j+1;
            end
            %Dodanie tempa Wicia
            %jeden raz za duzo sie wykona j=j+1
            j=j-1; tN=''; tBufC={};
            if(i==1) 
                [tN,tIdx,tBufC]=T_Init(str(i:j),stmpIdx);
                str=[tN str(j+1:end)];
            else
                [tN,tIdx,tBufC]=T_Init(str(i:j),stmpIdx);
                str=[str(1:i-1) tN str(j+1:end)];
            end
            if(isempty(tN)) return; end
            strBufList={strBufList{1:end} tBufC{1:end}};
            tmpList{end+1}=tN; opTmpList{end+1}=''; 
            stmpIdx=stmpIdx+1;
            i=i+length(tN);
        end
        i=i+1;
    end
end
%% Optymalizacja stalych obliczen z opcja opt.implicit
if(opt.implicit&&~IsTmpN(lNe))
    %sprowadzenie wszystkich elementow do listy elementow + operatory
    tStr=strDelChar(strDelChar(str,'('),')');
    ls_op=SortOp(tStr);
    %przeszukanie listy
    bOnlyConst=true; isTmpIn=false; bHprodOp=false;
    for i=1:length(ls_op)
        [b,val]=IsOperator(ls_op{i});
        %jezeli mam operacje potegowania to musze je wykonac, wiec
        %przerywam sprawdzanie
        if(b) 
            %sprawdzm czy nie ma podanego potegowania i lewostronnego
            %dzielenia
            if(val>1&&~strIsIn('\',ls_op{i})) 
                %sprawdzam czy mam operacje z kropka: ./ .^
                if(strIsIn('.',ls_op{i})) bHprodOp=true; end;
                continue; 
            else bOnlyConst=false; break; 
            end; 
        end
        %Jezeli mam liczbe lub jednowymiarowy element z vname_list to wykonuje 
        %dalsze sprawdzenia, w przeciwnym wypadku wychodze ze sprawdzania i
        %wykonuje normalne dzialanie funkcji
        [b,el]=GetFromNL(ls_op{i},vname_list);
        if(b)
            if((IsNumber(el{3})&&el{3}>1)||(IsNumber(el{4})&&el{4}>1))
                bOnlyConst=false; break; 
            end
            %Czy w obliczeniach znajduja sie tempy, mozliwa operacja:
            %a=a+b(2);
            if(IsTmpN(el{1})) isTmpIn=true; end
        elseif(~IsNumber(ls_op{i})) bOnlyConst=false; break; 
        end;
    end
    %Jezeli mam same stale i dozwolone operacje w C to przepisuje rownanie
    if(bOnlyConst)
        if(isTmpIn)
            if(bHprodOp) 
                j=1;
                while(j<length(str))
                    if((str(j)=='.')&&IsOperator(str(j:j+1)))
                        str=[str(1:j-1) str(j+1:end)];
                    end
                    j=j+1;
                end
            end
            lN_out=lNe; stmpIdx_out=stmpIdx; strBufList={strBufList{1:end} [lNe '=' str ';']};
        else
            %Sprawdzam czy nazwa wyjsciowa jest w liscie zmiennych
            if(~GetFromNL(lNe))
                [pusty,tT]=GetSizeType(ls_op,vname_list);
                strBufList{end+1}=[AddToNL({lNe tT 1 1 1})];
            end
            %usuwam zapisy kropkowe w stalych operacjach
            if(bHprodOp) 
                j=1;
                while(j<length(strOld))
                    if((strOld(j)=='.')&&IsOperator(strOld(j:j+1)))
                        strOld=[strOld(1:j-1) strOld(j+1:end)];
                    end
                    j=j+1;
                end
            end
            lN_out=lNe; stmpIdx_out=stmpIdx; strBufList={strBufList{1:end} [lNe '=' str ';']};
        end
        %Inkrementuje przypisanie
        IncEl(lNe,8);
        return;
    end
end
%% Dodanie dodatkowych nawiasow + dodanie tempow
beg=[];%przechowuje indeks poczatku nawiasu, beg(1) to '(' a ends(1) to ')'
ends=[];%przechowuje indeks konca nawiasu
cnaw=0;%licznik nawiasow
%(ZROBIONE)DO ZROBIENIA WARUNEK WYJSCIA Z PETLI
%(ZROBIONE)DO ZROBIENIA Usuwanie tymczasowych tempow

% Usuniecie problemu "Pierwszego obliczenia"
% Problem: D=temp0*E/temp1*temp2; temp0,E,temp1-zmienne jednowymiarowe
%                                temp2-macierz/wektor
% Wychodzi:
% D=GetPtr(temp0,double)*E;
% HProdMC(D,D,GetPtr(temp1,double),1,4,1,1,double,double,double,/);
% MulMM(D,D,temp2,1,4,1,4,double,double,double,*);
% 
% Powinno byc:
% temp3=malloc(sizeof(double)*1*1);
% GetPtr(temp3,double)=(GetPtr(temp0,double)*E)/GetPtr(temp1,double);
% free(D); D=malloc(sizeof(double)*1*4);
% HProdCM(D,GetPtr(temp1,double),temp2,1,1,1,4,double,double,double,*);
% 
% Rozwiazanie:
% Dodanie dodatkowego poczatkowego nawiasu wszystkich elementow jednowymiarowych
% ktore wystepuja na poczatku rownania
j=0; k=1; nF=0; %nF liczba znalezionych pod rzad zmiennych 
i=1;
while i<=length(str)
    %znalazlem litere, sprawdzam czy zmienna jest jednowymiarowa
    if(~IsOperator(str(i)))
        if(j==0) j=i; end
        k=i+1;
        while((k<=length(str))&&~IsOperator(str(k))) k=k+1; end; k=k-1;
        [b,elA]=GetFromNL(str(i:k)); if(~b) break; end
        if(elA{5}==1) nF=nF+1; i=k;
        else
            %Jezeli mam zapis: D=(temp0*E/temp1)*temp2; to nie dodaje
            %albo k=length(str)
            if((nF<2)||((k<length(str))&&(str(k+1)==')'))||str(i-2)==')')
                break;
            end
            %Jezeli wszsytko ok to dodaje nawias
            if(j==1) str=['(',str(j:i-2),')',str(i-1:end)];
            else str=[str(1:j-1),'(',str(j:k-(k-i+2)),')',str(k-(k-i+1):end)]; end
            break;
        end
    end
    i=i+1;
end

str_old=str;
cAdd=0; %licznik dodanych tempow
%Dodanie nawiasow + tempow
while 1
    i=2;
    vsig=0;
    vsig_old=0;
    %Dodanie dodatkowych nawiasow
    while i<=length(str)
        sig=str(i);    
        if(sig=='.'&&~IsOperator(i-1))
            sig=[sig str(i+1)];
            i=i+1;
            [b, vsig]=IsOperator(sig);
        else
            [b, vsig]=IsOperator(sig);
        end
        if(~b) i=i+1; continue; end
        %pomijam nawiasy
        if(vsig==0) vsig_old=vsig; i=i+1; continue; end
        %sprawdzam czy obecny znak jest bardziej znaczacy niz poprzedni
        %jezeli tak to dodaje znak
        if(vsig<vsig_old)
            %cofam sie do poczatku zmiennej, liczby
            j=i-1; 
            while(~IsOperator(str(j)))
                j=j-1;
            end
            %sprawdzam czy nie podane jest *-C, jezeli tak to cofam o jescze
            %jeden znak
            if((str(j)=='-')&&((j-1)>0)&&IsOperator(str(j-1))&&(str(j-1)~=')')) j=j-1; end

            %przeszukuje az napotkam operator mniej znaczacy, koniec stringu
            %lub nawias
            vsig_old=vsig;
            for(k=(i+1):length(str))
                sig=str(k);
                %pominiecie zapisu z liczba ujemna A*-C albo -C*B
                if(((sig=='-')&&(k-1>0)&&IsOperator(str(k-1))&&(str(j-1)~=')'))||((sig=='-')&&(k==1))) continue; end
                if(sig=='.')
                    sig=[sig str(i+1)];
                    [b, vsig]=IsOperator(sig);
                else
                    [b, vsig]=IsOperator(sig);
                end
                %sprawdzam czy znaleziono znak oraz czy nie jestem na koncu
                %stringu, jezeli jestem to dodaje nawias, daltego nie wykonuje
                %tego ifa
                if(~b)&&(k+1<length(str)) continue; end

                %sprawdzam czy kolejnym operatorem zaraz po wejsciu w petle
                %jest operator inny niz dodawanie lub odejmowanie
                if((vsig>vsig_old)||(k==length(str))||(vsig==0))
                    %Wynikiem przemiany: A+C^2^(2^2) bylo: (2^2) i(C^2^)
                    %blad polegal na nie cofnieciu sie przed znak ktory byl
                    %przed nawiasem
                    if(sig=='(') k=k-1; end
                    %dodanie nawiasow
                    if(k<length(str))
                        str=[str(1:j) '(' str(j+1:k-1) ')' str(k:length(str))];
                    else
                        str=[str(1:j) '(' str(j+1:k) ')'];
                    end
                    break;
                end
                vsig_old=vsig;
            end
        elseif(b)
            vsig_old=vsig;
        end

        i=i+1;
    end
    %przygotowanie kolejnosci obliczania nawiasow
    %oraz wartosci ktore musza byc przechowywane w zmiennych tymczasowych
    i=1;
    %TU WSZYSTKO DZIALA NIC NIE ZMIENIAC !!!!!!!!
    %Dodanie poprawnego traktowania struktur z indeksem A(..).pole
    while i<=length(str)
        sig=str(i);    
        if(sig=='(')
            %mam A(..)
            if((i-1)>0&&(IsLetter(str(i-1))||IsNumber(str(i-1))))
                %ide do koncowego nawiasu A(..)
                cnaw=1; %szukam konca nawiasu w polu struktury
                while((i<length(str))&&cnaw) 
                    if(str(i)=='(') cnaw=cnaw+1; elseif(str(i)==')') cnaw=cnaw-1; end
                    i=i+1;
                end;
                continue;
            end;
            cnaw=cnaw+1;
            beg(cnaw)=i; %zapisanie pozycji poczatku nawiasu
        elseif(sig==')')
            ends(cnaw)=i; %zapisanie pozycji konca nawiasu        
            l_list=length(opTmpList);
            %zmienna zawiera index nazwy zmiennej tymczasowej
            %dodawanej z listy tmpList do obliczen, temp1..,
            %Zakladam ze stmpIdx jest stale i okresla indeks poczatkowy,
            %od ktorego numerujemy tempy
            add_index=stmpIdx+cAdd;
            %zapisanie fragmentu dzialania, (bez nawiasow-dodane w 11.10.2015)
            str_temp=str((beg(cnaw)+1):(ends(cnaw)-1));
            %dodanie do listy kolejnych etapow dzialan
            if(isempty(opTmpList))
                opTmpList={str_temp};
                tmpList={[tmpPre num2str(add_index)]};
                cAdd=cAdd+1; %inkrementuje licznik dodania
            else
                %sprwadzam czy podane rownanie jest w liscie
                %jezeli tak to add_index zawiera indeks nazwy tej zmiennej
                %w liscie tmpList
                tFind=false;
                for(j=1:length(opTmpList))
                    if strcmp(opTmpList{j},str_temp)
                        add_index=stmpIdx+j-1;
                        tFind=true;
                        break;
                    end
                end            
                %jezeli (stare)add_index==l_list+1, (nowe)add_index=stmpidx to dodaje 
                %nowa nazwe zmiennej tymczasowej
                %do listy zmiennych tymczasowych tmpList
                if ~tFind
                    opTmpList={opTmpList{1:end} str_temp};
                    tmpList={tmpList{1:l_list} [tmpPre num2str(add_index)]};
                    cAdd=cAdd+1; %inkrementuje licznik dodania
                end
            end        
            %dodanie nazwy symbolicznej 
            i=beg(cnaw); %powrot do poczatku dodawanej nazwy symbolicznej
            %Dlaczego tmpList{add_index+1}?? Poniewaz w add_index mam indeksacje od 0
            %czyli temp0 ma indeks 1 w tmpList, temp2 ma 3 itd..
            %Jezeli nie mam dodatkowego zwracanego tempa w lewej nazwie to
            %dodaje +1; wtmpNe=0
            %Wczesniej jak tego nie uwzglednialismy to gubi³ nam sie jeden
            %temp i przez to funkcja sie wykrzaczala
            if((stmpIdx-1)>=0)
                if(~wtmpNe) tAddIdx=add_index+1-(stmpIdx-1);
                else tAddIdx=add_index-(stmpIdx-1); end
            else
                if(~wtmpNe) tAddIdx=add_index+1-stmpIdx;
                else tAddIdx=add_index-stmpIdx; end
            end
            str=[str(1:(beg(cnaw)-1)) tmpList{tAddIdx} str((ends(cnaw)+1):length(str))];
            cnaw=cnaw-1;
        end    
        i=i+1;
    end 
    %Warunek wyjscia z petli, jezeli dodalismy juz wystarczajaca ilosc
    %nawiasow i tempow, czyli jezeli wczesniejszy str jest taki sam jak
    %obecny to wychodze z petli
    if(strcmp(str_old,str)) break; 
    else str_old=str; end
end
stmpIdx=stmpIdx+cAdd;
%% Dodanie jako ostatniego elementu na liscie, nazwy zmiennej wynikowej(ta po lewej stronie)
opTmpList={opTmpList{1:length(opTmpList)} str};
if(slNe==0) tmpList={tmpList{1:length(tmpList)} lNe}; %Dodaje lewa nazwe
%Tutaj zamieniam nazwe wynikowa, jezeli jest ona w dzialaniach
else
    IncEl(lNe,8);
    tmpList={tmpList{1:length(tmpList)} [tmpPre num2str(length(tmpList))]}; 
end

%% Wykonuje tlumaczenie obliczen, 
%zaczynam od poczatku czmiennych tymczasowych, koncze
%na ostatnim elemencie listy, czyli zmiennej wynikowej
lneTmp=[]; bOp=false; %jezeli true to w HProdCC jest rozpoczete dzialanie i mozna dopisywac
for i=1:length(tmpList)
    %% Pobranie elementow oraz okreslenie rozmiaru wyniku obecnego dzialnia
    %jezeli odpowiadajaca indeksowi lista operacji 'list' jest pusta to
    %pomijam tego tempa i ide do nastepnego
    if(isempty(opTmpList{i})) continue; end
    %Pobieram rozmiar i typ wynikowy z dzialania
    ls_op=SortOp(opTmpList{i});
    if(isempty(ls_op)) return; end; %wystapil blad w tlumaczeniu
    [size_el, type_el]=GetSizeType(ls_op,vname_list);
    %sprawdzam czy wszsytko jest wporzadku
    if(isempty(size_el))        
        return; 
    end;
    if size_el(1)>1 || size_el(2)>1 %Macierz
        %Jak zbudowany taki element -> w funckji AddToNL
        temp_el={tmpList{i} type_el size_el(1) size_el(2) 0};
    else%Stala
        temp_el={tmpList{i} type_el 1 1 1};
    end
    t=AddToNL(temp_el);
    if(~isempty(t))
        if isempty(strBufList) strBufList={t};
        else strBufList={strBufList{1:end} t}; end
    end
    
    %% TLUMACZENIE OBLICZEN
    %Mozliwe Operacje: MM, CM, MC, CC
    left_name=tmpList{i};
    %Jezeli mam jeden element w ls_op, to robie przypisanie, poniewaz moge
    %miec podane cos w stylu A=20; A=(1:end)', lub cos takiego
    if(length(ls_op)==1)
        [b, elA]=GetFromNL(opTmpList{i},vname_list);
        [~, elB]=GetFromNL(left_name,vname_list);
        IncEl(left_name,8);
        if((~b)&&IsNumber(opTmpList{i})) elA={num2str(opTmpList{i}) GetType(opTmpList{i}) 1 1 1}; end
        lDefN='';
        sigA='';
        
        if(elA{5}==0) 
            if(opTmpList{i}(end)==39) lDefN='EqMMT('; else lDefN='EqMM('; end
            if(opTmpList{i}(1)=='-') sigA=',-'; end %dodanie znaku - z przecinkiem
        else lDefN='EqCC('; end
        t=[lDefN,left_name,',',elA{1},',',num2str(elA{3}),',',...
            num2str(elA{4}),',',temp_el{2},',',elA{2},sigA,');'];
        strBufList={strBufList{1:end} t};
    %Mam normalne obliczenia
    else
        for j=1:length(ls_op)
            if IsOperator(ls_op{j})
                %Przy pierwszej operacji wykonuje LN=A*B; przy kazdej nastepnej
                %element A jest lewa wartoscia rownania 
                %np: LN=A*B/C -> LN=A*B; LN=LN/C;
                if((j-1)==1) 
                    [b, elA]=GetFromNL(ls_op{j-1},vname_list); %wczesniejszy    
                    if((~b)&&IsNumber(ls_op{j-1})) elA={num2str(ls_op{j-1}) GetType(ls_op{j-1}) 1 1 1};
                    elseif(~strcmp(elA{1},ls_op{j-1})) elA{1}=ls_op{j-1}; end%Jezeli nazwy sie roznia tzn. ze nie mam minusa
                else
                    %zawsze prawda bo left_name przed chwila bylo wpisane na
                    %vname_list
                    [~, elA]=GetFromNL(left_name,vname_list);
                end
                [b, elB]=GetFromNL(ls_op{j+1},vname_list); %pozniejszy
                if((~b)&&IsNumber(ls_op{j+1})) elB={num2str(ls_op{j+1}) GetType(ls_op{j+1}) 1 1 1};
                elseif(b&&~strcmp(elB{1},ls_op{j+1})) elB{1}=ls_op{j+1}; end%Jezeli nazwy sie roznia tzn. ze nie mam minusa
                
                lDefN=''; %nazwa operacji na elementacj A i B, HProd, Mul, Div, Pow, HProdPow
                pDefNA=''; %prawy znak elementu A do operacji: M,MT,C
                pDefNB=''; %prawy znak elementu B do operacji: M,MT,C
                sigA=''; %znak elementu A(dodatni/ujemny) Teraz domyslnie sigA=', '; jezeli bylo by sigA=',' 
                         %to zmienic warunek sprawdzania typu elementu w GetElFromDef
                sigB=''; %znak elementu B(dodatni/ujemny)
                while 1
    %**************** OBLICZENIA MM
                    if (elA{5}==0)&&(elB{5}==0)
                        %sprawdzam czy ktoras Macierz jest transponowana,
                        %uwzgledniam to i usuwam znak transpozycji
                        if(elA{1}(end)==39) pDefNA='MT'; elA{1}=elA{1}(1:end-1); else pDefNA='M'; end
                        if(elA{1}(1)=='-') sigA=',-'; elA{1}=elA{1}(2:end); end
                        if(elB{1}(end)==39) pDefNB='MT'; elB{1}=elB{1}(1:end-1); else pDefNB='M'; end
                        if(elB{1}(1)=='-') if(isempty(sigA)) sigA=', '; end; sigB=',-'; elB{1}=elB{1}(2:end); end
                        if IsLike(ls_op{j},'%l#.* ./ .\ + -#')
                            %obciecie kropki przy operatorze
                            if strcmp(ls_op{j},'.*')||strcmp(ls_op{j},'./')||strcmp(ls_op{j},'.\')
                                ls_op{j}=ls_op{j}(2);%obciecie kropki
                            end
                            if(strcmp(ls_op{j},'\')) %odwrotne dzielenie, zamieniam kolejnoscia elementy
                                t=elA; elA=elB; elB=t; ls_op{j}='/'; 
                                t=pDefNA; pDefNA=pDefNB; pDefNB=t;
                                t=sigA; sigA=sigB; sigB=t;
                            end
                            lDefN='HProd';
                        elseif strcmp(ls_op{j},'*')
                            lDefN='Mul';
                            ls_op{j}='';
                        elseif strcmp(ls_op{j},'/')||strcmp(ls_op{j},'\');
                            if(strcmp(ls_op{j},'\')) 
%                                 t=elA; elA=elB; elB=t; ls_op{j}='/'; 
%                                 t=pDefNA; pDefNA=pDefNB; pDefNB=t;
%                                 t=sigA; sigA=sigB; sigB=t;
                                lDefN='LDiv';
                            else
                                lDefN='RDiv';
                            end
%                             lDefN='Div';
                            ls_op{j}='';
                        elseif strcmp(ls_op{j},'.^')
                            lDefN='HProdPow';
                            ls_op{j}='';
                        else
                            error('Bledna operacja MM: %s',ls_op{j});
                        end

    %**************** OBLICZENIA:  MV/MN lub NM/VM, jeden z elementow jest Macierza
                    elseif elA{5}==0 || elB{5}==0
                        if(elB{5}==0)%elB to macierz
                            pDefNA='C';
                            %uwzgledniam transpozycje w elementach
                            if(elB{1}(end)==39) pDefNB='MT'; elB{1}=elB{1}(1:end-1); else pDefNB='M'; end
                            if(elB{1}(1)=='-') sigA=', '; sigB=',-'; elB{1}=elB{1}(2:end); end
                            if(elA{1}(end)==39) elA{1}=elA{1}(1:end-1); end %usuniecie znaku transpozycji z liczby
                        %Element elA to macierz
                        else
                            pDefNB='C'; 
                            if(elA{1}(end)==39) pDefNA='MT'; elA{1}=elA{1}(1:end-1); else pDefNA='M'; end
                            if(elA{1}(1)=='-') sigA=',-'; sigB=', '; elA{1}=elA{1}(2:end); end
                            if(elB{1}(end)==39) elB{1}=elB{1}(1:end-1); end; end
                        if IsLike(ls_op{j},'%l#* .* ./ / .\ \ + -#')
                           %obciecie kropki przy operatorze
                           if strcmp(ls_op{j},'.*')||strcmp(ls_op{j},'./')||strcmp(ls_op{j},'.\')
                               ls_op{j}=ls_op{j}(2);%obciecie kropki
                           end
                           %zamiana na obliczenia typu '/', zamiana
                           %kolejnosci elementow oraz zamiana nazw makr
                           if(strcmp(ls_op{j},'\')) 
                               ls_op{j}='/';
                               t=elA; elA=elB; elB=t;
                               t=pDefNA; pDefNA=pDefNB; pDefNB=t;
                               t=sigA; sigA=sigB; sigB=t;
                           end
                           lDefN='HProd';
                        elseif strcmp(ls_op{j},'^')
                           lDefN='Pow';
                           ls_op{j}='';
                        elseif strcmp(ls_op{j},'.^');
                           lDefN='HProdPow';
                           ls_op{j}='';
                        else
                           error('Bledna operacja MC: %s',ls_op{j});
                        end
    %**************** OBLICZENIA: VN NN VV NV CC
                    else
                        %usuniecie znaku transpozycji z liczby lub zmiennej
                        %jedno rozmiarowej
                        if(elA{1}(end)==39) elA{1}=elA{1}(1:end-1); end
                        if(elB{1}(end)==39) elB{1}=elB{1}(1:end-1); end

                        pDefNA='C'; pDefNB='C';
                        if IsLike(ls_op{j},'%l#* .* ./ / .\ \ + -#')
                           %obciecie kropki przy operatorze
                           if strcmp(ls_op{j},'.*')||strcmp(ls_op{j},'./')||strcmp(ls_op{j},'.\')
                               ls_op{j}=ls_op{j}(2);%obciecie kropki
                           end
                           %zamiana na obliczenia typu '/', zamiana
                           %kolejnosci elementow
                           if(strcmp(ls_op{j},'\')) t=elA; elA=elB; elB=t; ls_op{j}='/'; end
                           %lDefN='HProd';
                           %Dopisanie operacji T=A*B..
                           if(bOp) %mam juz jakies obliczenie rozpoczete
                               %czy nazwa wynikowa z poprzedniego dzialania jest inna niz w obecnym, 
                               %jezeli tak to zapisuje poprzednie dzialanie i rozpoczynam nowe
                               if(~strcmp(lneTmp,left_name))
                                   [~,tmpEl]=GetFromNL(lneTmp);
                                   if(IsTmpN(lneTmp)) lneTmp=['GetPtr(',lneTmp,',',tmpEl{2},')']; end
                                   str_temp=[lneTmp,'=',str_temp,';'];
                                   if isempty(strBufList) strBufList={str_temp};
                                   else strBufList={strBufList{1:end} str_temp}; end
                                   lneTmp=left_name;
                                   %sprawdzm czy tmp, jezeli tak to dodaje i uwzgledniam minus
                                   if(IsTmpN(elA{1}))
                                       if(elA{1}(1)=='-') elA{1}=['-GetPtr(',elA{1}(2:end),',',elA{2},')']; 
                                       else elA{1}=['GetPtr(',elA{1},',',elA{2},')']; end
                                   end
                                   if(IsTmpN(elB{1})) 
                                       if(elB{1}(1)=='-') elB{1}=['-GetPtr(',elB{1}(2:end),',',elB{2},')']; 
                                       else elB{1}=['GetPtr(',elB{1},',',elB{2},')']; end
                                   end
                                   str_temp=[elA{1},ls_op{j},elB{1}];
                                   break;
                               end
                               %sprawdzam czy element B jest tmpem oraz uwzgledniam minus
                               if(IsTmpN(elB{1})) 
                                   if(elB{1}(1)=='-') elB{1}=['-GetPtr(',elB{1}(2:end),',',elB{2},')']; 
                                   else elB{1}=['GetPtr(',elB{1},',',elB{2},')']; end
                               end
                               %Jezeli mam zapis ..(A,A,B..) <-analogia do HPrdoCC
                               if(strcmp(lneTmp,elA{1})) str_temp=['(',str_temp,')',ls_op{j},elB{1}];
                               %Jezeli mam zapis ..(A,B,A..) <-analogia do HPrdoCC
                               else str_temp=[elB{1},ls_op{j},'(',str_temp,')']; end                            
                           else %nie mam zadnego obliczenia, rozpoczynam nowe
                               bOp=true;
                               lneTmp=left_name;
                               %Sprawdzam czy element A i B sa tempami na tym etapie nie moge sprawdzac ich
                               %realokacje, dodaje - przed GetPtr jak jest taka potrzeba
                               if(IsTmpN(elA{1})) 
                                   if(elA{1}(1)=='-') elA{1}=['-GetPtr(',elA{1}(2:end),',',elA{2},')']; 
                                   else elA{1}=['GetPtr(',elA{1},',',elA{2},')']; end
                               end
                               if(IsTmpN(elB{1})) 
                                   if(elB{1}(1)=='-') elB{1}=['-GetPtr(',elB{1}(2:end),',',elB{2},')']; 
                                   else elB{1}=['GetPtr(',elB{1},',',elB{2},')']; end
                               end
                               str_temp=[elA{1},ls_op{j},elB{1}];
                           end
                           %Sprawdzam, przy ostatnim przejsciu musze
                           %dopisac utworzonego wczesniej str_tempa do
                           %wynikowej listy
                           if(j<(length(ls_op)-1)) break; end
                        elseif(strcmp(ls_op{j},'^')||strcmp(ls_op{j},'.^'))
                           lDefN='Pow';
                           ls_op{j}='';
                        else
                           error('Bledna operacja CC: %s',ls_op{j});
                        end
                    end
                    %Dopisuje utworzone wczesniej dzialanie w str_temp dla
                    %HprodCC 
                    IncEl(left_name,8);
                    if(bOp)
                        [~,tmpEl]=GetFromNL(lneTmp);
                        if(IsTmpN(lneTmp)) lneTmp=['GetPtr(',lneTmp,',',tmpEl{2},')']; end
                        str_temp=[lneTmp,'=',str_temp,';'];
                        if isempty(strBufList) strBufList={str_temp};
                        else strBufList={strBufList{1:end} str_temp}; end
                        bOp=false;
                        %Jezeli mamy ostani element(dzialanie) to wychodze, poniewaz
                        %nie mam nic wiecej do dopisywania
%                         if((i==length(tmpList))&&isempty(lDefN)) break; end
                        if((j==(length(ls_op)-1))&&isempty(lDefN)) break; end
                    end
                    %Tutaj dopisuje obecne dzialanie HProcMC/MM/ Mul,Div..
                    %sprawdzam czy ls_op{j} nie jest puste i dopisuje
                    %przecinek
                    if(~isempty(ls_op{j})) ls_op{j}=[',',ls_op{j}]; end 
                    str_temp=[lDefN pDefNA pDefNB '(' left_name ',' elA{1} ',' elB{1} ','...
                        num2str(elA{3}) ',' num2str(elA{4}) ','...
                        num2str(elB{3}) ',' num2str(elB{4}) ','...
                        type_el ',' elA{2} ',' elB{2},ls_op{j},sigA,sigB ');'];
                    if isempty(strBufList) strBufList={str_temp};
                    else strBufList={strBufList{1:end} str_temp}; end
                    break;
                end%Koniec While 1 "Switch"
            end
        end
    end
end

%% Tutaj optymalizacje np. do obliczen na liczbach stalych (to robie w INZ_Make)

%Jezeli zamienialem ZmWyn na tempa to robie przypisanie + ewentualna zmiane
%rozmiarow
if(slNe)
    [~, elW]=GetFromNL(lNe,vname_list);
    [~, elA]=GetFromNL(tmpList{end},vname_list);
    elW{2}=elA{2}; elW{3}=elA{3}; elW{4}=elA{4}; 
    t=AddToNL(elW);
    if(~isempty(t))
        if isempty(strBufList) strBufList={t};
        else strBufList={strBufList{1:end} t}; end
    end
    lDef='';
    if(elA{5}==0) lDef='EqMM'; %EqMM(W,A,srA,scA,tW,tA);
    else lDef='EqCC'; end %EqCC(W,A,srA,scA,tW,tA); 
    t=[lDef,'(',elW{1},',',elA{1},',',num2str(elA{3}),',',...
       num2str(elA{4}),',',elW{2},',',elA{2},');'];
    strBufList={strBufList{1:end} t};
end
%jezeli mamy nazwe wynikowa rownania to nie mam tempa, czyli wtmpNe=0
tBuf={};%tymczasowa zmienna, przechowuje przetlumaczony kod w C o zwolnieniu pamieci tempow
%prawdopodobnie rozroznianie nie jest potrzebne ale zostawiam 
if((~wtmpNe)&&(~slNe)) %Mam nazwe wynikowa i slNe=0;
    stmpIdx_out=stmpIdx-(length(tmpList)-1);
    if((length(tmpList)>1)&&delTmp) tBuf=FreeTmp({tmpList{1:end-1}}); end %Nie podaje nazwy wznikowej
else %Nie mam lewej nazwy, mam tempa
    stmpIdx_out=stmpIdx-(length(tmpList)-1); 
    if((length(tmpList)>1)&&delTmp) tBuf=FreeTmp({tmpList{1:end-1}}); end %Jezeli mam inne tempy poza zwracanym
end
if ~isempty(tBuf) strBufList={strBufList{1:end} tBuf{1:end}}; end
lN_out=tmpList{end};
end