function dz=row_b(x,z)
    dz=zeros(2,1);
    dz(1) = z(2);
    dz(2)= - 1.5*z(1) - 2*z(2) - 7.5*cos(3*x);
end