function [ strOut ] = IdxC( str )
%IDXC Zamienia podany w str index Matlabowski na indeks w C, odejmuje 1
%IN:
%str - indeks Matlabowski
%OUT
%strOut - indeks w C

if(IsNumber(str)) strOut=num2str(str2double(str)-1);
%Zmienna lub Macierz
else strOut=[str '-1']; end

end

