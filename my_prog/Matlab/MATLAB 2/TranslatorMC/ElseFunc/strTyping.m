function [ dotyp ] = strTyping( value )
%strTyping -> zaawansowwane typowanie zminnych i macierzy 
%   oparte o  rzutowanie char  
rozm=size(value);
yp=rozm(1)*rozm(2);
preftyp{1}='long int';
preftyp{2}='double';
preftyp{3}='char';
tabpreftyp=zeros(1);
x=1;%index typu
if(yp>1)%macierz
    for(i=1:rozm(1))
        for(j=1:rozm(2))
            war=num2str(value(i,j));
            lasttyp=strGetType(war);
            for(z=1:3)%rodzaje typow
                zx=preftyp{z};
                if(strcmp(zx,lasttyp))
                    tabpreftyp(x)=z;
                    x=x+1;
                end
            end
        end
    end
else%zmienna
    war=num2str(value);
    lasttyp=strGetType(war);
    for(z=1:3)%rodzaje typow
        zx=preftyp{z};
        if(strcmp(zx,lasttyp))
            tabpreftyp(x)=z;
            x=x+1;
        end
    end
end
Ltyp=max(tabpreftyp);
dotyp=preftyp{Ltyp};
end

