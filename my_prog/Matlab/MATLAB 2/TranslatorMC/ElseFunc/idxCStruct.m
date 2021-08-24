function [ lN_out, stmpIdx_out, strBufC_out, tmpList ] = idxCStruct( str,  stmpIdx, strBufC)
%IdxCStruct Funkcja zamienia zapis: A(1).pole na zapis struktury poprawny w
%notacji C, uwzgledniajac opcje dekrementacji oraz wektorowosc struktury
%IN:
% str - struktura
%stmpIdx - liczba uzywanych i juz zainicjalizowanych zmiennych tymczasowych
%          domyslnie 0
%strBufC - lista z kolejnymi linijkami przetlumaczonego kodu w C
%OUT:
%lN_out - przetlumaczona struktura
%stmpIdx_out - numer tempa od ktorego mozna zaczac dalsze dodawanie po wyjsciu z funkcji
%strBufC_out - lista z przetlumaczonym kodem w C

if(nargin<3) strBufC={}; end
if(nargin<2) stmpIdx=0; end
lN_out=''; stmpIdx_out=stmpIdx; strBufC_out=strBufC;
tmpList={};

[pusty,idxb]=strIsIn('(',str);
[pusty,idxd]=strIsIn('.',str);
[a,b,tBufC]=T_TmpArg(str(1:idxd-1),stmpIdx,strBufC,true);
if(isempty(a)) return; end
%Zazwyczaj struktura bedzie podawana jako wektor, wiec sprawdzam
%ktory z elementow a{2} a{3} jest '0'-zerem
%sprawdzm kolejne warunki: (0,..), (..,0), (0,0), (..,..)
if(strcmp(a{2},'0')&&~strcmp(a{3},'0')) str=[str(1:idxb),a{3},str(idxd-1:end)];
elseif(~strcmp(a{2},'0')&&strcmp(a{3},'0')) str=[str(1:idxb),a{2},str(idxd-1:end)];
elseif(strcmp(a{2},'0')&&strcmp(a{3},'0')) str=[str(1:idxb),'0',str(idxd-1:end)]; 
else str=[str(1:idxb),a{2},',',a{3},str(idxd-1:end)]; end; %dziwny przypadek, Macierzowa struktura
%jezeli zostaly utworzone jakies zmienne
if(b{1}>stmpIdx) 
    stmpIdx=b{1};
    tmpList=b{2};
    if(isempty(strBufC)) strBufC=tBufC;
    else strBufC={strBufC{1:end} tBufC{1:end}}; end
end

lN_out=str;
stmpIdx_out=stmpIdx;
strBufC_out=strBufC;
end

