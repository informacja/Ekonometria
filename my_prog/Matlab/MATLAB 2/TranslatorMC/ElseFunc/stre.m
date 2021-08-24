function [ outline,strBufM,ename_list ] = stre( line,ename_list,strBufM )
%stre -> funkcja zamieniaj¹ca notacjê naukowa na liczbow¹ 
%   Detailed explanation goes here
if(nargin<2) ename_list=cell(1); end;
if(nargin<3) strBufM={}; end;
a=0; epsflag=0; spaceeps='';przypis=1;flag=0;
Lline=length(line);
for(i=2:Lline)
         if(line(i)=='='||line(i)=='<'||line(i)=='>')
             flag=1;
         end
             if(flag||line(i)=='+'||line(i)=='*'||line(i)=='/'||line(i)=='\'||line(i)=='-')
                 if(line(i-1)=='e')
                 else
                    przypis=i+1;
                    flag=0;
                 end
             end
         %end
         if(i>3)
             if(i>3||(i+1)==Lline)
                if((line(i-1)=='e' && (line(i-2)=='.'||line(i-3)=='.')))
                    if(IsLike(line(i),'%l#1 2 3 4 5 6 7 8 9 0 - #'))%||IsLike(line(i+1),'%l#1 2 3 4 5 6 7 8 9 0#'))
                epsflag=1;
                spaceeps=line(i-1);
                a=a+1;
                krop(a)=i-3;
                    end
                end
             end
            if(epsflag==1)
                if(IsLike(line(i),'%l#1 2 3 4 5 6 7 8 9 0 -#'))
                    spaceeps=[spaceeps line(i)];
                    epsend=i;
                else
                epsflag=0;
                end 
            end
            if(a~=0&&epsflag==1)
                Mepsend(a)=epsend;
                Mprzypis(a)=przypis;
                Cspaceeps{a}=spaceeps;
            end
         end
end
while(przypis>1 && a~=0)
    if(IsLike(line(przypis),'%l#1 2 3 4 5 6 7 8 9 0#'))
        przypis=przypis-1;
    else
        break;
    end
end
tfq=0;
if(~isempty(spaceeps)&& a~=0)%zamiana e-----------------------------
            przypis=Mprzypis(a);
            epsend=Mepsend(a);
            spaceeps=Cspaceeps{a};
            inpline='C_';
            prawline='';
            for(q=przypis:epsend)
                if(line(q)=='.'||line(q)=='-')
                    inpline=[inpline '_'];
                    prawline=[prawline line(q)];
                    continue;
                end
                inpline=[inpline line(q)];
                prawline=[prawline line(q)];
            end
            for(i=1:length(ename_list))
                if(~isempty(ename_list{i}))
                    tfq=strcmp(ename_list{i},inpline);
                    if(tfq)
                        break;
                    end
                end
            end
            if(tfq)
            else
                ename_list{end+1}=inpline;
                strBufM{end+1}=[inpline '=' prawline];
            end
            lewline='';
            for(i=1:przypis-1)
                lewline=[lewline line(i)];
            end
            pewline='';
            for(i=epsend+1:Lline)
                pewline=[pewline line(i)];
            end
            inpline=[lewline inpline pewline];
else
    inpline=line;
end
%---------------------------------------------------------------
outline=inpline;
end

