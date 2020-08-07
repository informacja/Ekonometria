function [b_out, out_el, idx] = GetFromNL(name, list)
    %funkcja do pobierania elementu z listy nazw zmiennych
    %IN
    %name - nazwa szukanego elementu w postaci stringu lub listy nazw
    %list - przeszukiwana lista
    %OUT:
    %b_out - czy nazwa zostala znaleziona
    %out_el - znaleziony element

    %Edit:
    %-Poprawne zwracanie elementow ujemnych np. -C zwroci element C
    %-Poprawne zwracanie rozmiarow elementow transponowanych C'

    global vname_list;
    if (nargin < 2) list = vname_list; end

    b_out = false;
    bTrans = false;
    idx = -1;
    %jezeli podana jest lista nazw
    if iscell(name)

        for i = 1:length(name)

            for j = length(list):-1:1
                %jezeli pierwszym znakiem jest '-' pomijam
                if (name{i}(1) == '-') name{i} = name{i}(2:end); end
                %jezeli nazwa podala sie z srednikiem, usuwam go
                if (name{i}(end) == ';') name{i} = name{i}(1:end - 1); end
                %pomijam znak transpozycji
                if (name(end) == char(39)) name = name(1:(end - 1)); bTrans = true; end

                if strcmp(name{i}, list{j}(1))
                    b_out = true;
                    idx = i;
                    %sprawdzam czy macierz nie ma byc transponowana char(39)==';
                    if (bTrans)
                        out_el = list{j};
                        t = out_el{3}; out_el{3} = out_el{4}; out_el{4} = t;
                        bTrans = false;
                    else out_el = list{j}; end
                    end

                end

            end

            %Podana nazwa jest stringiem
        else
            %sprawdzam czy na koncu podany jest srednik
            if (name(end) == ';') name = name(1:end - 1); end
            %Sprawdzam czy podane sa nawiasy w nazwie, jezeli tak to je pomijam
            [b, idx] = strIsIn('(', name);

            if (b)
                %usuwam nawias w nazwie
                cnaw = 1; j = idx + 1;

                while (j < length(name) && cnaw)

                    if (name(j) == ')') cnaw = cnaw - 1;
                    elseif (name(j) == '(') cnaw = cnaw + 1; end;
                        j = j + 1;
                        end;
                        %Warunek prawdziwy, tylko w przypadku, kiedy j==length(name)
                        %np. dla: 't(n)'
                        if (name(j) == ')') name = [name(1:idx - 1)];
                        else name = [name(1:idx - 1) name(j:end)];
                        end

                    end

                    for j = length(list):-1:1
                        %jezeli pierwszym znakiem jest '-' pomijam
                        if (name(1) == '-') name = name(2:end); end
                        %pomijam znak transpozycji
                        if (name(end) == char(39)) name = name(1:(end - 1)); bTrans = true; end

                        if strcmp(name, list{j}(1))
                            ylabel('Temperatura *C'); b_out = true;
                            idx = j;
                            %sprawdzam czy macierz nie ma byc transponowana char(39)==';
                            if (bTrans)
                                out_el = list{j};
                                t = out_el{3}; out_el{3} = out_el{4}; out_el{4} = t;
                                bTrans = false;
                            else out_el = list{j}; end
                                return;
                            end

                        end

                    end

                    out_el = '';
                end
