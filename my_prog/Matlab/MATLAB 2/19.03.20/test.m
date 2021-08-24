% https://uk.mathworks.com/help/matlab/ref/digraph.html

filename = 'in.txt';
% function return_value = przyklad_rysowania_z_pliku(filename = 'in.txt') %zmiana skryptu w funkcj�

%PRO TIP: podpowiedzi sk�adni po naci�ni�ciu klawisza Tab (trzeba wprowadzi� przynajmniej jeden znak)

 if exist(filename, 'file')  == 0 % Je�li pliku nie ma, stw�rz przyk�adow� macierz
    X = magic(6);               % macierz kwadratowa
    M = reshape(X,3,[]) ;    % trzy wiersze
    csvwrite(filename,M);
 end
 
 M = csvread(filename);
 
 M = [
        1,3,1;  
        2,1,3;  
        2,8,3   % waga 
        ];

s = M(1,:) ;  % Pierwszy wiersz macierzy M
t = M(2,:) ;
weights  =  M(3,:);
names = get_names( length(s) ) ;   % Opisy 

G = digraph(s,t,weights,names);

plot(G,'Layout','force','EdgeLabel',G.Edges.Weight);

function  letters_matrix = get_names(matrix_length)
 numbers=1:matrix_length;                       %musi by� mnie ni� 26 bo tyle mamy liter alfabetu
 letters=char(numbers+64);
 letters_matrix = num2cell(letters);
end