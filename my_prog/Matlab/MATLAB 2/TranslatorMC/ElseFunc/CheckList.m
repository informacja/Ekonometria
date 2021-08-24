function [ out ] = CheckList( vname_change,Myzm)
%checklist-> sprawdza czy zmienna (Myzm) różni od tego co jest na
%vnamechange
%   out=cell ->(typ,Lkol,Lwie)-> info do AddToNL
%   Myzm-> pełne info o zmiennej (nazwa,typ,Lkol,Lwie)
f=0;
if(isempty(vname_change))
    [yes,el]=GetFromNL(Myzm{1});
    out=Myzm;
    if(yes)
        TypNL=el{2};
        LkolNL=el{3};
        LwieNL=el{4};
        if(~strcmp(TypNL,Myzm{2}))%deklaracja nowej zmiennej
            out{2}=Ty;
        end
        if(LkolNL>Myzm{3})
            out{3}=LkolNL;
        end
        if(LkolNL>Myzm{4})
            out{4}=LwieNL;
        end
    end
else
    for(i=1:length(vname_change))
        if(isempty(vname_change{i}))
            continue;
        end
        if(strcmp(Myzm{1},vname_change{i}{1}))
            f=1; 
            break;
        end
    end
    if(f)
        [yes,el]=GetFromNL(Myzm{1});
        if(yes)
        TypNL=el{2};
        LkolNL=el{3};
        LwieNL=el{4};
        else
            TypNL=''; LkolNL=-1;LwieNL=-1;
        end
        TypCH=vname_change{i}{2};
        LkolCH=vname_change{i}{3};
        LwieCH=vname_change{i}{4};
        out={Myzm{1} TypNL LkolNL LwieNL};
        if(~strcmp(TypNL,TypCH)||~strcmp(TypCH,Myzm{2}))%deklaracja nowej zmiennej
            out{2}=TypCH;
        end
        if(LkolNL~=LkolCH||LkolCH>Myzm{3})
            out{3}=LkolCH;
        end
        if(LwieNL~=LwieCH||LkolCH>Myzm{4})
            out{4}=LwieCH;
        end
    else
        out=Myzm;
    end
end
end

