%decRegr20
co=-1; 
if(0) %dalej<0) kOdrzuc==0;
else
    if(Km>1)
        if(kMaxR>0)
            kOdrzuc=input(sprintf('USUNAC <Ent>: DODAC - <1>; Koniec - <-1> ?? '));
        else kOdrzuc=[];
        end
        if(isempty(kOdrzuc)) 
            kOdrzuc=1; 
        else if(kOdrzuc<0) co=-1; return; else kOdrzuc=0; co=0; end, 
        end
    else if(kOdrzuc<0) return; end
    end
end
if(kOdrzuc==0)
    while(1)
        co=input(sprintf('\nDodac we: %d <Ent>(R=%.2f/%.2f) lub <%d> lub STOP <-1> ?? ',...
            kMaxR,Rmax,Rgr,kminSt));
        if(~isempty(co))
            if(co<0) return; end
            if(co>1 && co <=Kd)
                if(istot(co)>0)
                    fprintf(1,' We.%d juz wlaczone !!! ',co); continue; 
                else kMaxR=co;
                end
            end
        end
        istot(kMaxR)=1; fprintf(1,' Wlaczono FI(%d) ',kMaxR);
        return; 
    end
else
    while(1)
        co=input(sprintf('\nUsunac we: %d <Ent>(t=%.2f) lub <%d> lub STOP <-1> ?? ',...
            kminSt,tSt(kminSt),kMaxR));
        if(~isempty(co))
            if(co<0) return; end
            if(co>1 && co <=Kd)
                if(istot(co)<=0)
                    fprintf(1,'  We.%d juz usuniete !!! ',co); continue; %return;
                else kminSt=co;
                end
            end
        end
        istot(kminSt)=0; fprintf(1,' Usunieto FI(%d) ',kminSt);
        break; 
    end
end
