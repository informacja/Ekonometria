% clear all;

Ystart = 2013;
Ystop  = 2019;

if ~exist( 'x','var')
    x = []; y = [];
    for i = Ystart:Ystop  
    %     x = importfile('Raport_Pomiarow.xls', string(i));
        x = [x; importCelsjusz('Raport_Pomiarow.xls', string(i))];
        y = [y; size(x(:,7),1)];
    end
end

%% table to matrix

id_lp   = find(string(x.Properties.VariableNames) == "Lp");
id_date = find(string(x.Properties.VariableNames) == "Datapoboru");
id_celc = find(string(x.Properties.VariableNames) == "Wynik");
id_place= find(string(x.Properties.VariableNames) == "Miejscepoboru");

c       = string(x{:,id_celc});     % Temperatura w Celcjuszach
place   = strtrim(strip(string(x{:,id_place}),'both'));    % Miejsce
lp      = x{:,id_lp};       % Liczba porzadkowa
d       = x{:,id_date};     % Data poboru probki
date    = datetime(d ,'InputFormat','dd.MM.yyyy  ', 'Format', 'yyyy-MM-dd');

exp='(\d*[.,]*\d*)';
celc = regexp(c, exp, 'match');

if length(celc) == length(date)
    disp("ok");
else
    error("Rozne dlugosci tablic")
    length(celc)
    length(data)
end
%%

z = [];
Tdate = [];
for i = 1:size(celc,1)
    if contains( place(i), 'SUW £ukanowice')
            
        if double(celc{i}) > 30 | double(celc{i}) < 1
%             disp(grp2idx(celc(i)))
            date(i)
            (celc(i))
        else
            Tdate = [Tdate; date(i)];
            d =  double(celc{i});
            z = [z; d ];
        end
    end
%     z = x(i,1)
%     c(i)
end

z(size (Tdate,1)) = 0;
% size (z)
% size (Tdate)

plot( Tdate, z  )
