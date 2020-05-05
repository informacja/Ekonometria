function [ size, type ] = GetSizeType( ls_op, vname_list, temp_list )
%Funkcja zwraca maksymalny rozmiar oraz typ jaki powinna
%miec zmienna lub tablica wynikowa po wykonaniu dzialaniu w ls_op
%IN
%ls_op - lista posortowanych operacji, wynik funkcji SortOp
%      - jezeli podany jest jeden element {'temp0'} lub 'temp0' to jest zwrocony jego
%        rozmiar
%vname_list - lista obowiazujacych zmiennych z ich rozmiarami i typami

%(ZROBIONE)Dorobic mnozenie A*A*A to (A*A)*A
%Dorobic poprawne okreslanie rozmiaru na dzielenie macierzowe
maxrow=1; maxcol=1;
type=''; %0 char, 1 long int, 2 double
size=[];
curr_op='0';
bMul=false; %odpowiada za to czy wczesniej bylo juz jakies mnozenie,lub dzieleni
            %np: A*B*C gdzie A[2x2] B[1x2] C[2x1] daje: Y[2x2]
            %Rozpatruje wtedy 1)A*B, a pozniej wynik z tego (A*B)*C
ntype=''; nrow=0; ncol=0;
%jezei pojedynczy element
if(length(ls_op)==1||~iscell(ls_op))
    elA={};
    if(iscell(ls_op)) 
        [b,elA]=GetFromNL(ls_op{1},vname_list);
        if((~b)&&IsNumber(ls_op{1})) b=true; elA={num2str(ls_op{1}) GetType(ls_op{1}) 1 1 1}; end
    else
        [b,elA]=GetFromNL(ls_op,vname_list);
        if((~b)&&IsNumber(ls_op)) b=true; elA={num2str(ls_op) GetType(ls_op) 1 1 1}; end
    end
    if(b)
        size=[elA{3} elA{4}];
        type=elA{2};
        return;
    else
        return;
    end 
end
for i=1:length(ls_op)
    if IsNumber(ls_op{i}) 
        ntype=GetType(ls_op{i});
    elseif IsLetter(ls_op{i})
        [b, el]=GetFromNL(ls_op{i},vname_list);
        %Jezeli nie ma w liscie vname_list oraz temp_list jest podana
        if(~b&&(nargin>2))
            [b, el]=GetFromNL(ls_op{i},temp_list);
        end
        if ~b 
            warning('Nie znaleziono elementu: %s',ls_op{i});
            return;
        end
        %sprawdzam czy obecnym operatorem dzialania jest mnozenie lub
        %dzielenie
        %a elementem przed operatorem jest macierz, -2 poniewaz obecnie 
        %jestem jeden element za mnozeniem
        if((curr_op=='*')||(curr_op=='/')||(curr_op=='\'))&&(~IsNumber(ls_op{i-2}(1)))
            %dobieram 2 element w mnozeniu, ten wczesniejszy, przed
            %mnozeniem
            [b2, el2]=GetFromNL(ls_op{i-2},vname_list);
            %Jezeli nie ma w liscie vname_list oraz temp_list jest podana
            if(~b2&&(nargin>2))
                [b2, el2]=GetFromNL(ls_op{i-2},temp_list);
            end
            if ~b2 
                error 'Nie znaleziono elementu drugiego przy Mnozeniu!'
            end
            %A jest macierza/wektorem i B jest Macierza/wektorem
            if((el{3}>1)||(el{4}>1))&&((el2{3}>1)||(el2{4}>1))
                if(bMul) %Mam ciaglosc dzialania: A\B*C\A
                    %Mnozenie
                    if(curr_op=='*')
                        %A i B sa macierzami
                        %A*B=C[A_ROW x B_COL]
                        %Jezeli jest mnozenie np. A*B i A[100x100] a
                        %B=[100x20] to jezeli A zostanie wczesniej sprawdzone to
                        %macierz powstala po wymnozeniu bedzie mniejsza niz macierz
                        %A i wynikowy rozmiar macierzy bedzie niepoprawny.
                        %nrow=el2{3}; %to jest po to zeby pozniejsze ify zwracaly false
                        %ncol=el{4};
                        %Dlatego przypisuje rozmiar na sztywno bo zakladm ze to
                        %bedzie aktualny poprawny maksymalny rozmiar
                        %maxrow=el2{3};
                        %maxcol=el{4};
                        %Skrocony powyzsze zapisy
                        nrow=maxrow;
                        %maxrow=nrow; %To zostaje bez zmian bo:
                        %(A*C)[maxrow,maxcol]*B[el{3},el{4}]
                        ncol=el{4};  maxcol=ncol;
                    elseif(curr_op=='\')
                        %el2\el
                        %X=A\C => A*X=A*(A\C) => A[n,m]*X[m,j]=C[n,j]
                        nrow=maxcol; maxrow=nrow;
                        ncol=el{4}; maxcol=ncol;
                    elseif(curr_op=='/')
                        %el2/el
                        %X=A/C =>  X*C=(A/C)*C => X[n,m]*C[m,j]=A[n,j]
                        nrow=maxrow;
                        ncol=el{3}; maxcol=ncol;
                    end
                %Mam dzialanie bez kontynuacji, pierwsze wystapienie
                elseif(curr_op=='\')
                    %el2\el
                    %X=A\C => A*X=A*(A\C) => A[n,m]*X[m,j]=C[n,j]
                    nrow=el2{4}; maxrow=nrow;
                    ncol=el{4}; maxcol=ncol;
                elseif(curr_op=='/')
                    %el2/el
                    %X=A/C =>  X*C=(A/C)*C => X[n,m]*C[m,j]=A[n,j]
                    nrow=el2{3}; maxrow=nrow;
                    ncol=el{3}; maxcol=ncol;
                %zwyczajne mnozenie
                else nrow=maxrow; ncol=el{4}; maxcol=ncol; end
                bMul=true;
            %Jezeli A lub B nie jest Macierza to sprawdzam tylko A
            %poniewaz B jest poprzednim elementem na liscie ls_op
            %i bylo juz sprawdzone
            else
                nrow=el{3};
                ncol=el{4};
            end
            %Interesuje mnie tylko nowy typ A poniewaz B juz bylo 
            %sprawdzane
            ntype=el{2};
        %jezeli sprawdzam rozmiar pojedynczej macierzy, zmiennej
        else
            %Jezeli tlumaczenie dziala poprawnie to w tym momencie musi
            %byc podane el
            nrow=el{3};
            ncol=el{4};
            ntype=el{2};
        end
    elseif IsOperator(ls_op{i})
        curr_op=ls_op{i}(1);
        if(bMul&&((~strcmp(curr_op,'*'))&&(~strcmp(curr_op,'/'))&&(~strcmp(curr_op,'\')))) bMul=false; end
        continue;
    end
    
    %sprwadzam czy rozmiary nie sa wieksza oraz typ
    if(maxrow<nrow) maxrow=nrow; end;
    if(maxcol<ncol) maxcol=ncol; end;
    %jezeli typy sie roznia
    if(~strcmp(type,ntype))
        if(strcmp('double',ntype)&&(strcmp(type,'char')||strcmp('long int',type)))
            type=ntype;
        elseif(strcmp('long int',ntype)&&(strcmp(type,'char')))
            type=ntype;
        elseif(strcmp('char',ntype))
            type=ntype;
        elseif(isempty(type))
            type=ntype;
        end
    end
    
end

size=[maxrow maxcol];

end