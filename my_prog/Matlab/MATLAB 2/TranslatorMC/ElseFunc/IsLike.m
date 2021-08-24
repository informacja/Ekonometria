function [ b_out ] = IsLike( str,  arg)
%Funkcja zwraca czy podany fragment podobny jest do wzorca    
%IN: 
%   str - ciag do sprawdzenia
%   arg - wzorzec w postaci ciagu BEZ SPACJI
%Argumenty wzorca:
%   %s - dowlony ciag znaków
%   %l# .. # - dwolna lista argumentow, oddzielona spacjami
%Przyklad:
%   IsLike('A=[1:1:100]','%s=%s')  zwroci true(1)
%   IsLike('A=[1:1:100]','%s=[%s:%s:%s]') zwroci true(1)
%   IsLike('A=[1:1:100]','%s=[%s:%s]') zwroci true(1)
%   IsLike('A=[1:1:100]','%s=%s+%s') zwroci false(0)

%Opcje:
sig_arg='%'; %znak poczatku argumentu 
sig_list_frame='#'; %znak nawiasow w lisice argumentow

if isempty(str)
    error 'Ciag do porownania nie moze byc pusty!'
end

b_out=false;
l_arg={};
act_arg='s'; %aktualny argument wzorca
%Rozbicie wzorca na liste z jego argumentami
i=1;
while i<=length(arg)
    if(arg(i)==sig_arg)
        i=i+1;
        act_arg=arg(i);
        %tutaj moze byc dodanie jakich znakow/liczb.. czego szukamy
        %pomiedzy symbolami
        l_arg{length(l_arg)+1}=[sig_arg act_arg];
    else
        %Tutaj mozna rozbudowac funkcje o dodanie nowych argumentow
        %pamietac aby zbudowac dla nich odpowiednie porownanie w 
        %petli poruwnujacej (nastepnej petli)
        switch act_arg
            %argument dowolnego ciagu znakowego
            case 's'
                %tutaj wydzielam fragment do porownania
                j=i+1;
                while(j<=length(arg))
                    if arg(j)==sig_arg
                        break;
                    end
                    j=j+1;
                end
                l_arg{length(l_arg)+1}=arg(i:(j-1));
                i=j;
                continue; %aby nie wykonywac kolejnego i=i+1;
            %argument listy mozliwych znakow
            case 'l'
                %sprawdzam czy podany jest nawias
                if(arg(i)==sig_list_frame)
                    %omijam spacje na poczatku listy
                    j=i+1;
                    while(j<length(arg)&&arg(j)==' ')
                        j=j+1;
                    end
                    temp_pocz=j; %indeks poczatku elementu dodawanego do listy
                    temp_list={}; %tymczasowa lista z elementami
                    while(j<=length(arg))
                        if arg(j)==sig_list_frame %koniec listy argumentow
                            %sprawdzam czy nie musze dodac jakiegos
                            %elementu ktory przylega do '#' np. '.. $#'
                            %wtedy przed koncem petli musze dodac '$'
                            if temp_pocz~=j
                              temp_list{length(temp_list)+1}=arg(temp_pocz:(j-1));
                            end
                            break;
                        elseif arg(j)==' '%koniec elementu, dodaje do listy
                            temp_list{length(temp_list)+1}=arg(temp_pocz:(j-1));
                            %omijam spacje i znajduje kolejny element albo
                            %koniec listy
                            while(j<length(arg)&&arg(j)==' ')
                                j=j+1;
                            end
                            temp_pocz=j;
                            continue; %zeby nie wykonywac przeskoku do kolejnego elementu j=j+1
                        end
                        j=j+1;
                    end
                    %sprwadzam czy lista nie jest pusta
                    if ~isempty(temp_list) 
                        l_arg{length(l_arg)+1}=temp_list;
                    %jezeli jest pusta, to oznacza ze Ÿle podana jest lista
                    %argumentow, usuwam argument '%l'
                    else
                        l_arg={l_arg{1:length(l_arg)-1}};
                    end
                    
                i=j;
                act_arg='s';
                %jezeli nie mam podanego znaku "nawiasu" # to znaczy ze 
                %lista jest zle podana i usuwam element '%l'
                else
                    l_arg={l_arg{1:length(l_arg)-1}};
                    act_arg='s';
                    continue;
                end
            %koniec case 'l'
        end
    end
    i=i+1;
end

%sprawdzam czy lista argumentow nie jest pusta, jezeli tak
%to zglaszam blad
if isempty(l_arg)
    error 'Podany wzorzec arg jest bledny';
end

c_w=1; %licznik elementow wzorca, musi byc wiekszy niz liczba elementow l_arg
szuk=l_arg{1};
i=1;
act_arg='s'; %aktualny argument wzroca
new_arg=false; %jezeli prawda to pobieram nowy argument/liste do poruwnania

%Ignoruje spacje
j=i;
while(j<=length(str)&&str(j)==' ') j=j+1; end
i=j;

while i<=length(str)
    
    if ~iscell(szuk)
        if(szuk(1)==sig_arg) new_arg=true; end
    end
    
    %sprawdzam czy mam pobrac nowy argument do porownania (nie %s %l..)
    if new_arg
        %pobieram kolejny element z listy argumentow i szukanych
        %ciagow wzorca
        new_arg=false;
        c_w=c_w+1;
        if c_w>length(l_arg) %warunek zapisu %s=[%s]%s
            szuk=[sig_arg 's'];
            break;
        end
        act_arg=szuk(2); %aktualny parametr/argument wzorca
        szuk=l_arg{c_w}; %aktualny ciag/znak/lista szukana/y w ciagu str 
    %Szukam podanego znaku/ciagu np: '[' '=['..
    else
        switch act_arg
            case 's'
                if szuk(1)==str(i)
                    %porownanie fragmentow ciagow znakowych
                    %sprawdzam czy dlugosc elementu z wzorca l_arg{c_w}
                    %nie jest za dluga, 
                    %jezeli jest za dluga to szukanie nie ma sensu
                    if (i+length(szuk)-1)<=length(str)
                        %jezeli podane ciagi sa takie same
                        if(isequal(szuk,str(i:i+(length(szuk)-1))))
                            i=i+length(szuk)-1; %przejscie do konca szukanego ciagu w str
                            c_w=c_w+1; %przejscie do kolejnego szukanego ciagu
                            if c_w<=length(l_arg)
                                szuk=l_arg{c_w};
                            end
                        end
                    else
                        break;
                    end
                end
                %Jezeli pierwszym elementem na liscie argumentow jest znak/ciag do
                %przeszukiwania i nie zostal on znaleziony to koncze
                %przeszukiwanie bo wzor nie pasuje
                if(c_w==1) break; end
            %koniec: case 's'
            case 'l'
                for j=1:length(szuk)
                    if szuk{j}(1)==str(i)
                        %porownanie fragmentow ciagow znakowych
                        %sprawdzam czy dlugosc elementu z wzorca l_arg{c_w}
                        %nie jest za dluga, 
                        %jezeli jest za dluga to szukanie nie ma sensu
                        if (i+length(szuk{j})-1)<=length(str)
                            %jezeli podane ciagi sa takie same
                            if(isequal(szuk{j},str(i:i+(length(szuk{j})-1))))
                                i=i+length(szuk{j})-1; %przejscie do konca szukanego ciagu w str
                                c_w=c_w+1; %przejscie do kolejnego szukanego ciagu
                                if c_w<=length(l_arg)
                                    szuk=l_arg{c_w};
                                end
                                %koncze petle poruwnujaca liste z
                                %argumentami z fragmentami ciagu
                                break;
                            end
                        end
                    end
                end
                %Jezeli drugim elementem na liscie argumentow jest lista
                %z elementami do przeszukiwan (pierwszym elementem na
                %liscie musi byc '%l') i jej elementy nie zostaly znalezione
                %to koncze przeszukiwanie bo wzor nie pasuje
                if(c_w==2) break; end
            %koniec: case 'l'
        end
        %inkrementacja numeru i-tego elementu sprawdzanego w ciagu str
        i=i+1;
    end
end

%Warunek I: 
%Jezeli wszystkie argumenty we wzorze zostaly znalezione(inne niz %s, %l..)
%oraz caly ciag str zostal przeszukany to wzor jest pasujacy
if (c_w>length(l_arg))&&(i>=length(str))
    b_out=true;
%Warunek II:
%Jezeli ostatnim parametrem do przeszukania bylo %s(czyli dowolny ciag),
%oraz ciag str mozna dalej przeszukiwac (czyli nie jest to jego koniec)
%to wzorzec jest dobry i zwracamy TRUE
elseif isequal(szuk,[sig_arg 's'])&&(i<length(str))
    b_out=true;
end

end

