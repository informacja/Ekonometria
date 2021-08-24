function [ out ] = strcopy( LSznak,LEznak,orginal )
% kopiowanie znaków 
%LSznak=start kopiowania / LEznak=koniec kopiowania / co kopiujemy
out='';
if(LSznak~=1)
    start=LSznak-1;
    j=1;
    stop=LEznak-start;
    for(i=LSznak:LEznak)
        if((j)~=stop+1)
        out(j)=orginal(i);
        j=j+1;
        end
    end
else
    for(i=LSznak:LEznak)
        out(i)=orginal(i);
    end
end
end