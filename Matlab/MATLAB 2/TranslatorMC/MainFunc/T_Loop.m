function [ strBufC,stmpIdx ] = T_Loop( linia, stmpIdx,strBufC,deltmp )
%T_Loop= 
%   konwersja na C wygl�d p�tli + zmijszenie indeksacji od 0 
%   zak�adam �e odczytywanie jest do ko�ca lini 
%tf=wci�cie 'indentation'
%for(i=0;i<10;i=i+1)
%while(warunek)
%do while(warinek)
%switch(warunek) {case: break; deflaut break; }
%line=NextL(fw,linijka);
%outline=strBufC + delkaracja a
if(nargin<2) stmpIdx=0; end
if(nargin<3) strBufC={}; end
if(nargin<4) deltmp=0; end
serfor='for';
serif='if';
serend='end';
serwhile='while';
serswitch='switch';
serlen='length';
tekst='';
tmplist={};
out=cell(1);
global Ncase
tf=1;
f1=0; f2=0; f3=0; f5=0; ok=0;

for(i=1:length(linia))
    if(linia(i)==' '||linia(i)=='('||linia(i)==')')
        if(ok==0)
        f1=strcmp(serfor,tekst);
        f2=strcmp(serif,tekst);
        f3=strcmp(serwhile,tekst);
        f5=strcmp(serswitch,tekst);
        if(f1||f2||f3||f5)
            ok=1;
            tekst='';
        end
        end
    end
    %else
     tekst=[tekst linia(i)];
    %end
end
tekst=strDelChar(tekst,' ');%usuwanie spacji
%tf=f1;
outline=tekst;
ini=''; war=0;
if(f1)%for
    krok=0;
    tf=tf+1;
    for(i=1:length(tekst))
        if(tekst(i)=='(')
            continue;
        end
        if(tekst(i)==':')
            krok=krok+1;
            gkrok=i+1;
        end
        if(tekst(i)=='=')
%             if(tekst(i+1)=='1')
%                 if(tekst(i+2)==':')
%                     tekst(i+1)='0';
%                 end
% %             else
% %                 war=1;
%             end
            inizm=ini;
        end
        if(krok==0)
            if(IsNumber(tekst(i)))
                wwq=str2double(tekst(i))-1;
                tekst(i)=num2str(wwq);
            end
            ini=[ini tekst(i)];%instr_inicjalizuj�ca
        end
        %-----------------------
    end
%     if(war==1)
%         ini=strconn(ini,'-1');
%     end
    ww='';%wyrazenie_warunkowe
    if(krok==1)
        if(isempty(str2num(ww)))
            %[ww,stmpIdx,strBufC]=Mtlength(tekst,gkrok,strBufC,stmpIdx);
            ww=strcopy(gkrok,length(tekst),tekst);
        end
        f4=1;
    else
        f4=0;
        q=gkrok-2;
        ikroku='+';
        while(tekst(q)~=':')%instr_kroku
            ikroku=[tekst(q) ikroku];
            q=q-1;
        end
        
        ww=strcopy(gkrok,length(tekst),tekst);
        if(isempty(str2num(ww)))
            [ww,stmpIdx,strBufC]=Mtlength(tekst,gkrok,strBufC,stmpIdx);
            tf=10;
        end
    end
    Myzm{1}=inizm;
    Myzm{2}='long int';
    Myzm{3}=1;
    Myzm{4}=1;
    Myzm{5}=1;
    outline=AddToNL(Myzm);
    if(~isempty(outline))
        strBufC{end+1}=outline;
    end
    outline='for(';
    if(IsLike(ini,'%s%l# - * / #%s'))
        %nie nazwana;(Pan inz Kamil Krzeminski)
        [out{1},out{2},strBufC]=T_Op(ini,stmpIdx,strBufC);
        ini=out{1};
        stmpIdx=out{2};
    end
    outline=strconn(outline,ini);
    outline=[outline ';'];
    outline=strconn(outline,inizm);
    outline=[outline '<'];
    if(IsLike(ww,'%s%l# = - * / #%s'))
        if(ww(1)~='-')
        %nie nazwana;(Pan inz Kamil Krzeminski)
        [out{1},out{2},strBufC]=T_Op(ww,stmpIdx,strBufC);
        ww=out{1};
        stmpIdx=out{2};
        else
            outline(end)='>';
            if(f4==1)
                f4=3;
            end
        end
    else
        if(IsLike(ww,'%s%l# ( )#%s')&& tf~=10)
            [ww,stmpIdx,strBufC]=T_TmpArg(ww,stmpIdx,strBufC);
        end
    end

    outline=strconn(outline,ww);
    outline=[outline ';'];
    outline=strconn(outline,inizm);
    if(f4==1)
        outline=strconn(outline,'++){');
    elseif(f4==3)
        outline=strconn(outline,'--){');
    else
        outline=[outline '='];
        if(IsLike(ikroku,'%s%l# = - * / #%s'))
            if(ikroku(1)~='-')
                %nie nazwana;(Pan inz Kamil Krzeminski)
                [out{1},out{2},strBufC]=T_Op(ikroku,stmpIdx,strBufC);
                ikroku=out{1};
                stmpIdx=out{2};
            end
        end
        outline=strconn(outline,inizm);
        if(ikroku(1)=='-')
            ikroku(1)='-';
            ikroku(end)='';
        else
            ikroku=['+' ikroku];
            ikroku(end)='';
        end
        outline=[outline ikroku];
        outline=[outline '){'];
    end
    Ncase=-1;
end

if(f2)%if
    tf=tf+1;
    for(i=1:length(tekst))
        if(tekst(i)=='~')
            tekst(i)='!';
        end
    end
    outline=[serif  '(' tekst ')' '{'];
    Ncase=-1;
end

if(f3)%while
    tf=tf+1;
    outline=[serwhile '(' tekst ')' '{'];
    Ncase=-1;
end
if(f5)%switch
    tf=tf+1;
    outline=[serswitch '(' tekst ')' '{'];
    Ncase=0;
end
%outline=ini;
if(ok==1)
    [out,Ncase]=T_LoopOther(outline,ok,Ncase);
else
    [out,Ncase]=T_LoopOther(linia,ok,Ncase);
end
    if(~isempty(tmplist))
        frebuf=FreeTmp(tmplist);
        for(i=1:length(frebuf))
            if(isempty(frebuf))
                continue;
            end
             mstrBufC{end+1}=frbuf{i};
        end
    end
outline=out;
strBufC{end+1}=outline;
end