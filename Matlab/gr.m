% https://uk.mathworks.com/help/matlab/ref/digraph.html

function [return_value] = przyklad_rysowania_z_pliku(filename)

%PRO TIP: podpowiedzi sk³adni po naciœniêciu klawisza Tab (trzeba wprowadziæ przynajmniej jeden znak)

if exist(filename, 'file')  == 0 % Jeœli pliku nie ma, stwórz przyk³adow¹ macierz
    M = magic(3);
    csvwrite(filename,M);
end

M = csvread('filename',2,0)

s = [1 1 1 2 2 3 3 4 5 5 6 7];
t = [2 4 8 3 7 4 6 5 6 8 7 8];
weights = [10 10 1 10 1 10 1 1 12 12 12 12];
names = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'};
G = digraph(s,t,weights,names)

% plot(G,'Layout','force','EdgeLabel',G.Edges.Weight);

filename='out.txt';
M = magic(3);
row = size(M,2)
col =  size(M,1)
csvwrite(filename,M);
    
type filename
