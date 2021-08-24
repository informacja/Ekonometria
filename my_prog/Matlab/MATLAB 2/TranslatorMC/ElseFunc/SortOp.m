function [ lOut] = SortOp( str )
%Funkcja rozdziela dzialanie w postaci stringu na liste operacji:
%zmienna op zmienna2 op zmienna3
%IN:
%str - dzialanie w formacie stringu

%Edit: 
%-Dodawanie do listy liczb ujemnych
%-Dodawanie do listy liczb i macierzy transponowanych

%Inicjalizacja zmiennych
lOut={};
if(isempty(str)) return; end;

i=1; bAdd=false;%czy dodac jakis znak
while i<=length(str)
   k=i+1;
   while(k<=length(str))
       %ujemnosc zmiennej
       if(str(k)=='-'&&IsOperator(str(k-1))) k=k+1; continue; end
       %transpozycja zmiennej
       if((str(k)==39)&&(IsLetter(str(k-1))||IsNumber(str(k-1)))) k=k+1; continue; end
       %Czy znalazlem operator MATALBA
       if(str(k)=='.')
           %Tutaj dodatkowo sprawdzam czy nie mam zapisu: 1.e-10
           %Jezeli przed kropka jest liczba, a po e jest '-' i liczba to pomijam i inkrementuje do liczby po '-'
           if(((k-1>0)&&IsNumber(str(k-1)))&&(str(k+1)=='e')&&((k+3<=length(str))&&(str(k+2)=='-')&&IsNumber(str(k+3))))
               k=k+3; continue;
           end
           if(IsOperator(str(k:k+1))) bAdd=true; break; end;
            %Pomijam nawiasy
       else if(IsOperator(str(k))&&(str(k)~='(')&&(str(k)~=')')) bAdd=true; break; end;
       end
       k=k+1;
   end
   %Jezeli dodaje ostatni element to wychodze
   if(k==length(str)) lOut{end+1}=str(i:k); return;
   else lOut{end+1}=str(i:k-1); end
   %Jezeli dodaje jakis znak
   if(bAdd) 
       if(str(k)=='.') lOut{end+1}=str(k:k+1); k=k+1; 
       else lOut{end+1}=str(k); end
       bAdd=false;
   end
   i=k+1;
end

   
end

