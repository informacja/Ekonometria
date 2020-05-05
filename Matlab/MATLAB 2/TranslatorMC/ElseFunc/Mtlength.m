function [ ww,stmpIdx,strBuf ] = Mtlength( tekst,gkrok,strBufC,stmpIdx )
%zamiana length na c jako sizeof

wwtemp='';
strBuf={};
ww='';
serlen='length';
error=1;
for(j=gkrok:length(tekst))
    if(tekst(j)=='('||tekst(j)==')')
       continue;
    end
    if(error==0||strcmp(serlen,wwtemp))
        error=0;
        ww=[ww tekst(j)];
    else
        wwtemp=[wwtemp tekst(j)];
    end
end
if(error==0)
%     ww(1)='';
%     ww(end)='';
    [yes,Myzm]=GetFromNL(ww);
    if(yes==0)
        mstrBufC{end+1}={'error nazwa krok nie istnieje'};
        return;
    end
    [ww, stmpIdx, strBufC_out] = T_MatFunc(wwtemp, Myzm, stmpIdx);
    strBuf={strBufC{1:end} strBufC_out{1:end}};
else
    ww=wwtemp;
end
end
