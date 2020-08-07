function dz = row_a(x,z)
    dz=zeros(2,1);
    dz(1) = z(2);
    dz(2) = -2*z(1) - 2*z(2);
end