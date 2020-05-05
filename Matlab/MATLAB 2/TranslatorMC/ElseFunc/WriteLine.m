function [ b_ok ] = WriteLine( ofile, str, inden, pozfSeek)
%Wpisuje linijke tekstu do juz otwartego pliku
%IN:
%ofile - otwarty plik
%str - linijka tekstu
%inden - przesuniecie wzgledem zmiennej globalnej g_inden, domyslnie 0
%poz - pozycja od poczatku do wpisania, fseek, domyslnie 0

global gInDen;

if nargin<4 pozfSeek=0; end
if nargin<3 inden=0; end

fseek(ofile,pozfSeek,0);

buf=char(zeros(1,gInDen+inden));
for i=1:(gInDen+inden)
    buf(i)=char(9); %znak tabulacji
end
fprintf(ofile,'%s\r\n',[buf str]);
b_ok=true;
end