function [ nEl, lEl, tEl, idxEl, typeEl ] = GetElFromDef( str, btF, typebtF)
%GETELFROMDEF zwraca elementy z podanego defaina
%IN:
%str - string z podana definicja(zakladam ze zawsze jest poprawnie podane)
%btF - opcjonalne, czy podac w liscie elementow zwracanych, element wynikowy
%      defina ( Hprod(W,..) element W)
%typebtF-opcjonalne, czy podac w liscie zwracanej typeEl, typ elementu
%      wynikowego, nie zawsze w definicji jest on podany, np w EqMMM jest od
%      domyslny, i ma on typ elementu pobieranego z Macierzy A
%      ~~Jezeli btF nie jest ustawione to opcja niedostepna~~
%OUT:
%nEl - liczba znalezionych elementow
%lEl - lista z elementami
%tEl - lista z typami elementow M/C
%idxEl - lista zawierajaca index poczatku i konca elementu 
%typeEl - typ elementu podanego do makrodefinicji

if(nargin<2) btF=false; typebtF=false; end
if(nargin<3) typebtF=false; end
nEl=0;
lEl={};
tEl={};
idxEl={};
typeEl={};
%Ide do pierwszego nawiasu HProdMC(..
for i=1:length(str)
    if(str(i)=='(') break;
    elseif(i==length(str)) return; end
end

j=i-1;
while((j>1)&&((str(j)=='M')||(str(j)=='C')||(str(j)=='T')))
    %znalazlem typ elementu
    if((str(j)=='M')||(str(j)=='C')) nEl=nEl+1; tEl={str(j) tEl{1:end}}; end
    j=j-1;
end

%Ide do pierwszego przecinka, po nim sa elementy
%Tutaj tez okreslam typ elementow
nFind=0;
if(~btF)
    while(i<length(str))
        i=i+1;
        if(str(i)==',') break; end
    end
    %Pobieram typy elementow
    nFind=nEl;
%Zaczynam od pierwszego nawiasu
else
    nEl=nEl+1; 
    if(typebtF) nFind=nEl;
    else nFind=nEl-1; end
end

%Pobieram typy elementow z definicji
%Zaczynam od konca
l=length(str)-1;
if(str(l)==')') l=l-1; end
while(l>=1)
    k=l-1;
    while(str(k)~=',') k=k-1; end; k=k+1;
    if(~IsOperator(str(k:l))) typeEl{nFind}=str(k:l); nFind=nFind-1;end
    if(~nFind) break; end
    l=k-2;
end

l=1; j=i+1;
while l<=nEl;
    k=j;
    while(str(k)~=',') k=k+1; end
    lEl{l}=str(j:k-1); idxEl{l}=[j k-1];
    j=k+1; l=l+1;
end
end

