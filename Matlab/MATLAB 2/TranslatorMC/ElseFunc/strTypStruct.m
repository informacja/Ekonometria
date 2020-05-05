function [ vname_change ] = strTypStruct( value,vname_change,namestr)
%strTypStruct-> typowanie pól w strukturze i nadawanie jej rozmiaru 
%   value-> nazwa struktury vname_change->lista zmian namesyr->nazwa
%   struktury
Tabstr=struct2array(value);
Lobj=size(Tabstr);
Mystr=struct2nv(value);
for(i=1:length(Mystr))
    for(j=1:Lobj(1))
        obj=num2str(j);
        dorozm=['size(value(' obj ').' Mystr{i} ')'];
        chartyp=['ischar(value(' obj ').' Mystr{i} ')'];
        rozm=eval(dorozm);%rozmiar
        sizes=rozm(1)*rozm(2);
        if(sizes==1)
            dowart=['value(' obj ').' Mystr{i}];
            wart=eval(dowart);
            dotyp=num2str(wart);
            typ=strGetType(dotyp);
            rodz=1;
        else
            char=eval(chartyp);%char
            if(char==1)
                typ='char';
            else
            typ='double';
            end
            rodz=0;
        end
         name=[namestr '.' Mystr{i}];
        vname_change{end+1}={name typ rozm(1) rozm(2) rodz 0 0 0 0};
    end
    
end
end

