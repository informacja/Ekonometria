function [strOut] = AddToNL( addEl )
%ADDTONL 
%Funkcja dodaje elementy do listy nazw zmiennych
%sprawdza czy dana zmienan juz istnieje, realokuje ja jezeli zachodzi taka
%potrzeba.
%W przypadku struktur, kiedy jest podane wywolanie struktury wraz z polem:
%St1.pole=10; sprawdzane jest czy dana struktura jest w lisicie
%vname_change, jezeli jest to zostaje dodana do vname_list.
%Kiedy podane jest odwo³anie do struktury z indeksem: st(2).pole, indeks
%jest pomijany i funkcja realizuje dzialanie jak dla: st.pole;
%IN:
%addEl - dodawany element
%opNL - opcjonalna lista zmiennych, domyslnie global vname_list
%OUT:
%strOut - utworzona linijka z instrukcja w kodzie C, jezeli pusta to znaczy
%       ze nie mozna bylo dodac elementu do listy, element dodawany jest wtedy
%       liczba zwyczajna -12.0 itp.
%
%Budowa addEl
%     addEl{1} - Nazwa zmiennej
%     addEl{2} - Typ zmiennej
%     addEl{3} - Ilosc wierszy (LICZBA)
%     addEl{4} - Ilosc kolumn  (LICZBA)
%     addEl{5} - Rodzaj zmiennej:
%                    * 0 - Macierz
%                    * 1 - stala
%     addEl{6} - Ilosc realokacji
%     addEl{7} - Ilosc zmian typu
%     addEl{8} - Ilosc przypisan, zmian wartosci: A=1; A=2; -> jedna zmiana
%     addEl{9} - Flaga czy zmienna jest stala, lub flaga do vname_change

global vname_list defMalloc vname_change opt idxStartStock;
strOut='';
%Sprawdzam czy jest podana liczba, jezeli tak to koncze i zwracam pusty
%zapis swiadczacy o niemozliwosci dodania do listy nazw
%przy globalnych niezdefiniowanych mam [-1 -1] rozmiar
%Nie dodaje do listy, zmiennych ktorych rozmiar jest rowny [0 0]
if(IsNumber(addEl{1})||IsNumber(addEl{3})&&(addEl{3}==0)||IsNumber(addEl{4})&&(addEl{4}==0)) return; end
%sprawdzam czy 5 element nie jest pusty, czesty przypadek po debugu
if((length(addEl)<5)||isempty(addEl{5}))
    if(IsNumber(addEl{3})&&(addEl{3}>1)||IsNumber(addEl{4})&&(addEl{4}>1)) addEl={addEl{1:end} 0 0 0 0 0};
    else addEl={addEl{1:end} 1 0 0 0 0}; end;
end
rN=addEl{1}; %prawdziwa pelna nazwa zmiennej z odwolaniem
%Sprawdzam czy mam strukture z wywolaniem indeksu st1(..).pole;
[b,idx]=strIsIn('(',addEl{1});
if(b)
    %usuwam nawias w nazwie struktury
    cnaw=1; j=idx+1;
    while(j<=length(addEl{1})&&cnaw) 
        if(addEl{1}(j)==')') cnaw=cnaw-1; 
        elseif(addEl{1}(j)=='(') cnaw=cnaw+1; end; 
        j=j+1; 
    end;
    nN=addEl{1}(1:idx-1);
    addEl{1}=[addEl{1}(1:idx-1) addEl{1}(j:end)];
    %sprawdzam czy w vname_change jest struktura nN, jezeli jest to musze
    %ja dodac do fname_list
    [b,el]=GetFromNL(nN,vname_change);
    [b1,el1]=GetFromNL(nN,{vname_list{idxStartStock:end}});
    %w liscie vname_list jest juz podana struktura
    if(b&&b1) AddToNL({el{1:5} el1{6:end}});
    %Nie mam podanej struktury w liscie vname_list
    elseif(b) AddToNL({el{1:5}}); end;
    %W innych przypadkach, struktura jest ta sama
end

%Sprawdzam czy nazwa jest w liscie zmiennych vname_list
if(idxStartStock>1) 
    [b, el, idx]=GetFromNL(addEl{1},{vname_list{idxStartStock:end}}); idx=idx+idxStartStock-1;
else [b, el, idx]=GetFromNL(addEl{1},{vname_list{1:end}}); end
%jezeli nie to dodaja ja oraz alokuje, 
%alokuje tez jezeli zmienna jest juz na liscie, ale nie ma rozmiaru
if(~b)
    if(length(addEl)<5) 
        if(IsNumber(addEl{3})&&(addEl{3}>1)||IsNumber(addEl{4})&&(addEl{4}>1)) addEl={addEl{1:end} 0 0 0 0 0};
        else addEl={addEl{1:end} 1 0 0 0 0}; 
        end;
    elseif(length(addEl)<6) addEl={addEl{1:end} 0 0 0 0};
    elseif(length(addEl)<7) addEl={addEl{1:end} 0 0 0}; 
    elseif(length(addEl)<8) addEl={addEl{1:end} 0 0}; 
    elseif(length(addEl)<9) addEl={addEl{1:end} 0}; 
    end;
    
    vname_list={vname_list{1:end} addEl};
%     strOut=[addEl{1} '=(',addEl{2},'*)malloc(sizeof(' addEl{2}...
%               ')*' num2str(addEl{3}) '*' num2str(addEl{4}) ');'];
%     if(addEl{4}>0&&addEl{5}>0) strOut=[rN,'=',defMalloc,'(',num2str(addEl{3}),'*',num2str(addEl{4}),',',addEl{2},');']; end;
    strOut=[rN,'=',defMalloc,'(',num2str(addEl{3}),'*',num2str(addEl{4}),',',addEl{2},');'];
    b=true;
%Jezeli zmienna jest juz podana to sprawdzam typ i rozmiar
else
   %Podana zmienna istnieje ale nie jest zaalokowana
   if(el{3}==0&&el{4}==0)
       %sprawdzam: stala czy macierz
       if((addEl{3}>1)||(addEl{4}>1)) addEl{5}=0; else addEl{5}=1; end
       addEl{6}=el{6}+1; %Dodaje informacje o realokacji
       if(~strcmp(addEl{2},el{2})) addEl{7}=el{7}+1; else addEl{7}=el{7}; end
       addEl{8}=el{8}; %Liczba zmian wartosci
       addEl{9}=el{9}; %Czy globalna
       vname_list{idx}=addEl;
%        strOut=[addEl{1} '=(',addEl{2},'*)malloc(sizeof(' addEl{2}...
%           ')*' num2str(addEl{3}) '*' num2str(addEl{4}) ');'];
%       if(addEl{4}>0&&addEl{5}) strOut=[rN,'=',defMalloc,'(',num2str(addEl{3}),'*',num2str(addEl{4}),',',addEl{2},');']; end;
      strOut=[rN,'=',defMalloc,'(',num2str(addEl{3}),'*',num2str(addEl{4}),',',addEl{2},');'];
      return;
   end
   %Cos sie rozni, musze najpierw zwolnic pamiec
   if((addEl{3}~=el{3})||(addEl{4}~=el{4})||(~strcmp(addEl{2},el{2})))
       if((length(addEl)<5)||isempty(addEl{5})) 
           if((addEl{3}>1)||(addEl{4}>1)) addEl{5}=0; else addEl{5}=1; end;
       end
       if(length(el)>=8) addEl{8}=el{8}; %Liczba zmian wartosci
       else addEl{8}=0; 
       end
       if(length(el)>=9) addEl{9}=el{9}; %Czy globalna
       else addEl{9}=0; 
       end
       %jezeli jest podana opcja prostego tlumaczenia to nie przyjmuje
       %realokacji typow zmiennych stalych, nie tempow, wiec za rozmiar
       %ostateczny przyjmuje ostatni typ jaki ma dana zmienna
       if(~opt.implicit||IsTmpN(el{1}))
           addEl{6}=el{6}+1; %Dodaje informacje o realokacji
           if(~strcmp(addEl{2},el{2})) addEl{7}=el{7}+1; else addEl{7}=el{7}; end
           strOut=['free(',rN,'); ',rN,'=',defMalloc,'(',num2str(addEl{3}),'*',num2str(addEl{4}),',',addEl{2},');'];
       %wyjatek przy wlaczonym opt.implicit, do pierwszej alokacji
       %zmiennych globalnych
       elseif(opt.implicit&&addEl{9}&&(el{6}<0)||(el{7}<0))
           if(el{6}<0) addEl{6}=0; end
           if(el{7}<0) addEl{7}=0; end
       elseif(opt.implicit)
           %Wyswietlam komunikat o zmianie typu zmiennej, mimo wlaczonej
           %opcji implicit(Tlumaczenie doslowne, gdzie takie przypadki nie
           %moga miec miejsce)
           if(~opt.impIgnrChngTyp)
               error('Command:Exit','\nZMIANA TYPU ZMIENNEJ \nZ: %s %s\nNA: %s %s',el{1},el{2},addEl{1},addEl{2});
           end
           addEl{6}=el{6};
           addEl{7}=el{7};
       end
       vname_list{idx}=addEl;
%        strOut=['free(' addEl{1} '); ' addEl{1} '=(',addEl{2},'*)malloc(sizeof(' addEl{2}...
%               ')*' num2str(addEl{3}) '*' num2str(addEl{4}) ');'];
%        if(addEl{4}>0&&addEl{5}) strOut=['free(',rN,'); ',rN,'=',defMalloc,'(',num2str(addEl{3}),'*',num2str(addEl{4}),',',addEl{2},');']; end;
   end
end

end

