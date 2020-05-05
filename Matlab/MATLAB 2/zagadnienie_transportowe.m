% https://uk.mathworks.com/help/matlab/ref/digraph.html
clc; clear;

row = 3;
col = 5;

filename = strcat( int2str(row), 'x', int2str(col), '.csv' ); % examle: 3x5.csv

if exist(filename, 'file')  == 0 % Jeœli pliku nie ma, stwórz przyk³adow¹ macierz
    X = magic(col);               % macierz kwadratowa
    M = reshape(X,row,[]) ;    % trzy wiersze
    csvwrite(filename,M);
end

%  M = [
%         1,3,1;  
%         2,1,3;  
%         2,8,3   % waga 
%         ];
% 100; 120; 120;
% 50,40,70,90,90;

M = csvread(filename)

Sx(1:size(M,1),1) = 0

for i=1:size(M,1)
    for k=1:size(M,2)
        Sx(i,1) = M(i,k)*i*k+Sx(i,1);
    end
end

Sx

s = M(1,:);  % Pierwszy wiersz macierzy M
t = M(2,:);
A = { M(1,:) , M(2,:), M(3,:) };
weights  =  M(3,:);

tmp = size(M); % dimensions
% Iloœæ liter alfabetu do wygeneroania. Dla ka¿dego elementu macierzy 
 numbers=1:tmp(1)*tmp(2);        %musi byæ mnie ni¿ 26 bo tyle mamy liter alfabetu
 letters=char(numbers+64);
 names = num2cell(letters);
 
% G = digraph(s,t,weights,names);

% plot(G,'Layout','force','EdgeLabel',G.Edges.Weight);

     % Construct the same digraph as in the previous example using two
        % tables to specify edge and node properties.
        s = [1 1 1 2 2 3 3 4 5 5 6 7]';
        t = [2 4 8 3 7 4 6 5 6 8 7 8]';
        weights = [10 10 1 10 1 10 1 1 12 12 12 12]';
        names = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'}';
%         EdgeTable = table([s t],weights,'VariableNames',{'EndNodes' 'Weight'})
%         NodeTable = table(names,'VariableNames',{'Name'})
%         G = digraph(EdgeTable,NodeTable)
 
% plot(G,'Layout','force','EdgeLabel',G.Edges.Weight);

% clear A; N=1000; A=rand(N,N); tic, B=inv(A); toc, tic, C=A^-1; toc,
% max(max(abs(B./C-1)))
% clear A; N=100000; tic, A(N)=0; for(i=1:N) A(i)=i; end; toc, tic, for(i=1:N) A(i)=-i; end; toc,