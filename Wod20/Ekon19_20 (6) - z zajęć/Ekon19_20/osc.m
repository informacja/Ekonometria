function dz=osc(t,z)
    global m l g
    dz=zeros(2,1);
    dz(1) = z(2);
    dz(2) = -g*z(1)/(m*l);
end