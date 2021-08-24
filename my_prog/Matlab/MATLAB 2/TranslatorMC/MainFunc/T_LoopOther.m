function [ outline,Ncase ] = T_LoopOther( line,tf,Ncase )
%T_LoopOther-> tlumaczenie pozostalych slow kluczowych odnoszacych sie do funkcji
% tf->wcicie ; Ncase->liczba case
%tf=3;%inkrementacja wci�cia
serelseif='elseif';
serend='end';
sercase='case';
serdef='otherwise';
tekst='';
if(tf==1)
    outline=line;
    f1=0; f2=0; f3=0; f4=0;
else
Lline=length(line);
if(Lline<2)
    outline=line;
    return;
end
for(i=1:Lline)
    if(line(i)==char(32)||line(i)==char(11)||line(i)==char(9))
        continue;
    end
    tekst=[tekst line(i)];
    f1=strcmp(serend,tekst);
    f2=strcmp(serelseif,tekst);
    f3=strcmp(sercase,tekst);
    f4=strcmp(serdef,tekst);
    if(f1||f2||f3||f4)
        break;
    end
end
end
if(f1)%end
    tf=tf-1;
    outline='}';
    if(Ncase==0)
        outline=strconn('break; ',outline);
        Ncase=-1;
    end
end
if(f2)%elseif
    tempout='';
    tekst='';
    for(i=1:Lline)
        if(line(i)==' '||line(i)=='(')
            if(isempty(tempout))
            tempout=tekst;
            tekst='';
            end
        else
            tekst=[tekst line(i)];%warunek
        end
    end
    separate='';
    for(j=1:length(tempout))
        separate=[separate tempout(j)];
        flaga=strcmp('else',separate);
        if(flaga)
            separate=[separate ' '];
        end
    end
    outline=separate;
    outline=[outline '(' ];
    outline=strconn(outline,tekst);
    outline=[outline ')' '{'];
end
if(f3)%case
    tf=tf+1;
    tekst=[line ':'];
    if(Ncase==-1)
        outline=tekst;
    else
        outline=strconn('break; ',tekst);
    end
    Ncase=0;
end
if(f4)%deflaut
    tf=tf+1;
    Ncase=-1;
    outline=[line ':'];
end
if(f1||f2||f3||f4)
else
    outline=line;
end
end