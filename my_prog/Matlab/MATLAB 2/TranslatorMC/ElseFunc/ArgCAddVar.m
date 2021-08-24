%Jezeli mam zapis: A[cos][cos]
%Ilosc realokacji:
%   Jezeli jest * w nazwie to dopisuje jedna realokacje(zmiane rozmiaru)
cReal=0;
[bP,idx]=strIsIn('*',str(idxB:idxE));
tType=tDefB;
if(bP)
    %Jezeli mam zapis: *A[10] lub *A[10][10];, dopisuje typ-> typ*
    if(strIsIn('[',str))
        tType(end+1)='*';
        idxB=idxB+1;
    %Jezeli mam zapisy *A, *B i powinienem rozpatrywac jeszcze **A;
    else
        str=[str(1:idxB-1+idx-1) str(idxB+idx:end)];
        cReal=1; 
    end
end
if(IsLike(str(idxB:idxE),'%s][%s'))
    %pierwszy indeks
    t=str(idxB:idxE);
    [pusty,idxL1]=strIsIn('[',t);
    [pusty,idxR1]=strIsIn(']',t);
    td=[t(idxL1+1:idxR1-1)];
    %drugi indeks
    t=str(idxB+idxR1:idxE);
    [pusty,idxL2]=strIsIn('[',t);
    [pusty,idxR2]=strIsIn(']',t);
    td2=[t(idxL2+1:idxR2-1)]; 
    tName=str(idxB:idxB-1+idxL1-1);
    if(~bDefStuc)
        if(IsNumber(td)&&IsNumber(td2)) AddToNL({tName tType str2num(td) str2num(td2) 0 cReal});
        elseif(IsNumber(td)&&~IsNumber(td2)) AddToNL({tName tType str2num(td) td2 0 cReal});
        elseif(~IsNumber(td)&&IsNumber(td2)) AddToNL({tName tType td str2num(td2) 0 cReal});
        else AddToNL({NametType td td2 0 cReal}); end
    %Podana jest definicja struktury
    else
        for l=1:length(lDefStuc)
            ttName=[GetVarName(lDefStuc{l}) '.' tName];
            if(IsNumber(td)&&IsNumber(td2)) AddToNL({ttName tType str2num(td) str2num(td2) 0 cReal});
            elseif(IsNumber(td)&&~IsNumber(td2)) AddToNL({ttName tType str2num(td) td2 0 cReal});
            elseif(~IsNumber(td)&&IsNumber(td2)) AddToNL({ttName tType td str2num(td2) 0 cReal});
            else AddToNL({ttName td td2 0 cReal}); end
        end
    end
%Zapis A[cos]
elseif(strIsIn('[',str(idxB:idxE)))
    t=str(idxB:idxE);
    [pusty,idxL]=strIsIn('[',t);
    [pusty,idxR]=strIsIn(']',t);
    td=[t(idxL+1:idxR-1)];
    tName=t(1:idxL-1);
    if(~bDefStuc)
        if(IsNumber(td)) AddToNL({tName tType 1 str2num(td) 0 cReal});
        else AddToNL({tName tType 1 td 0 cReal}); end
    else
        for l=1:length(lDefStuc)
            ttName=[GetVarName(lDefStuc{l}) '.' tName];
            if(IsNumber(td)) AddToNL({ttName tType 1 str2num(td) 0 cReal});
            else AddToNL({ttName tType 1 td 0 cReal}); end
        end
    end
%Zwykla zmienna wskaznikowa   
else
    tName=str(idxB:idxE);
    if(~bDefStuc)
        if(bP) AddToNL({tName tType 1 1 0 cReal}); else AddToNL({tName tType 1 1 1 cReal}); end
    else
        for l=1:length(lDefStuc)
            ttName=[GetVarName(lDefStuc{l}) '.' tName];
            if(bP) AddToNL({tName tType 1 1 0 cReal}); else AddToNL({ttName tType 1 1 1 cReal}); end
        end
    end
end