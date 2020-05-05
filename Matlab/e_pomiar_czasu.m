
% clear A; N=1000; A=rand(N,N); tic, B=inv(A); toc, tic, C=A^-1; toc,
% max(max(abs(B./C-1)))
 clear A; N=100000; tic, A(N)=0; for(i=1:N) A(i)=i; end; toc, tic, for(i=1:N) A(i)=-i; end; toc,