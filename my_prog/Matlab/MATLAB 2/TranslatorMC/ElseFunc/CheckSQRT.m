[b,idxb2]=strIsIn('(',str(idxb1+1:end)); idxb2=idxb2+idxb1;
[pusty,idxd]=strIsIn(',',str(idxb1+1:end)); idxd=idxd+idxb1;
%sprawdzam czy znaleziono drugi nawias otwierajacy
%przed wystapienie przecinka
if(b&&(idxd>idxb2))
    %przeszukuje do drugiego elementu
    cnaw=1; j=idxb2+1;
    while(cnaw||str(j)~=',') if(str(j)=='(') cnaw=cnaw+1; elseif(str(j)==')') cnaw=cnaw-1; end; j=j+1; end;
    idxd=j;
end