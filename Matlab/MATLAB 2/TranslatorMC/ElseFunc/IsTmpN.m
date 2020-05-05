function [ b ] = IsTmpN( str )
%ISTMPN = funkcja sprawdza czy podana nazwa jest nazwa tempa
%IN:
%str-fragment do sprawdzenia
%OUT:
%b-true jezeli jest to nazwa tempa, false przeciwnie

global tmpPre;
if(str(1)=='-') if(str(end)==39) str=str(2:end-1); else str=str(2:end); end
elseif(str(end)==39) str=str(1:end-1); end
%(length(tmpPre)+1) poniewaz wszystkie tempy maja swoj numer temp0,temp1...
if(length(str)<(length(tmpPre)+1)) b=false; return; end
if(~strcmp(tmpPre,str(1:length(tmpPre)))) b=false; return; end;

for i=length(tmpPre)+1:length(str)
    if(~IsNumber(str(i))) b=false; return; end
end

b=true;
end

