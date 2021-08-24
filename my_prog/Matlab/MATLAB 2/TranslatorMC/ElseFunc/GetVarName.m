function ttName=GetVarName(str)
%Funkcja wyluskuje poprawna nazwe zmiennej, usuwa niepotrzebne nawiasy i
%gwiazdki przed sama nazwa, zapisuje pozniej wszystko do ttName;

%Przechodze na poczatek nazwy
h=1;
while ~IsLetter(str(h)) h=h+1; end
[b,m]=strIsIn('[',str);
%Jak jest podane: st1[10];
if(b) ttName=str(h:m-1);
else ttName=str(h:end); end

end