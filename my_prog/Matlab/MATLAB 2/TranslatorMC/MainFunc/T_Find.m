function [ strBufM ] = T_find( nazwa_pliku )
%   'usuniêcie'->zakomentowanie funkcji zbêdnych przy dalszej edycji wstepne
%   przygotowanie.(wszystkie funkcje rysowania itp.) rozdzielenie
%   operacji, usuniêcie notacji naukowej, dopisanie 0 do .o
%       Wejœcie: 
%   nazwa_pliku->ci¹g znakowy zawieraj¹cy istniej¹cy plik z rozszerzeniem
%   MATLAB
%       Wyjscie:
%   strBufM->lista zestandaryzowanych funkji
strBufM={};
serplo='%splot(%s';
sersub='%ssubplot(%s';
sertit='%stitle(%s';
seraxi='%saxis%s';
sergri='%sgrid%s';
serhon='%shold(%s';
serleg='%slegend%s';
serclr='%sclear%s';
serclc='%sclc';
serglo='%sglobal%s';
serfor='%sfor%s';
serif='%sif%s%s';
serend='%s%l#end#';%'%send%s';
serwhile='%swhile%s';
serele='%selse%s';
serele1='%selse';
sereleif='%selseif%s';
serinput='%sinput%s';
serfig='%sfigure(%s';
serxlab='%sxlabel(%s';
ename_list=cell(1);
%------------------------------------------------------------------
i=1;%ile odczyta³em znaków
tekst=''; xtekst=''; endline=0;line=''; spaceeps='';
f=0;spec=0;
tf1=0; tf2=0; tf3=0; tf4=0; tf5=0; ft6=0; tf7=0; tf8=0;
tf9=0;tf10=0;tf11=0;tf12=0;tf13=0;tf14=0;tf15=0; tf16=0;
komen=0; kom=0; stopi=0; specend=0; nawias=0;ost=0; endloop=0;loop=0;
znacznik=1; xadd=0; usun=0; empty=0;kropka=0; epsflag=0; rez=1;Lnawias=0; 
c=0; epsend=0; floop=0; extraline=0; eding=1; pozendline=0; specendline=0;
extra=0; efloop=0; effor=0; pozefloop=0; incef=0;
%--------------------------------------------------------------------------
id=fopen(nazwa_pliku,'r');%tryb do odczytu nazwa_pliku='main.m';
% di=fopen('temp.m','w');%tworzenie nowego pliku.//komentowanie czego nie robimy
% fseek(di, 0, 'bof');
while ~feof(id)
     line=fgetl(id);
     while(isempty(line)||length(line)<2)
         line=fgetl(id);
     end
     if(line==(-1))
         break;
     end
     %przeszukiwanie istotnych s³ów kluczowych
     tf1=IsLike(line,serplo);
     tf2=IsLike(line,sersub);
     tf3=IsLike(line,sertit);
     tf4=IsLike(line,seraxi);
     tf8=IsLike(line,serleg);
     tf11=IsLike(line,serend);
     tf5=IsLike(line,sergri);
     tf6=IsLike(line,serhon);
     tf7=IsLike(line,serclr);
     tf9=IsLike(line,serfor);
     tf91=IsLike(line,'%sfor %s');
     tf10=IsLike(line,serif);
     tf101=IsLike(line,'%sif %s');
     tf12=IsLike(line,serwhile);
     tf13=IsLike(line,serglo);
     tf14=IsLike(line,serclc);
     tf15=IsLike(line,serele);
     tf151=IsLike(line,serele1);
     tf16=IsLike(line,serinput);
     tf17=IsLike(line,serfig);
     tf18=IsLike(line,serxlab);
     Lline=length(line);
     %---------------------------------------+
     i=1;
     while(i<Lline) %q=1.; i tylko takie
         if(line(1)==char(32)||line(1)==char(11)||line(1)==char(9))
             line(1)='';
             Lline=Lline-1;
             continue;
         end
         if(i>2&& i<length(line))
            if(line(i)=='.'&&line(i-2)=='='&&~isempty(str2num(line(i-1)))&&isempty(str2num(line(i+1))))
                %q=1.;  
                 if(line(i+1)=='e')
                else
                 line=strWriteIn(line,i,'0');
                 Lline=Lline+1;
                end
            end
         end
         i=i+1;
     end
     %---------------------------------------start :D
     Lline=length(line);
     if(Lline>1&&line(1)==' '&& line(2)==' ')
         usun=1; empty=1;
     end
     bline='';
     i=1;    
     while(i<=Lline)
         if(line(i)==' ' && empty==1)
             usun=usun+1;
         else
             empty=2;
         end
         if(i>2)
            if(empty==2&&line(i)==' '&&line(i-1)==' ')
            else
                bline=[bline line(i)];
            end
         else
            bline=[bline line(i)];
         end
         if(length(bline)>2)
            if(bline(end-1)=='.' && bline(end-2)~=')'&&~isempty(str2num(bline(end))))
                if(~IsLike(bline(end-2),'%l#1 2 3 4 5 6 7 8 9 0#'))%q=.1;
                    kropka=length(bline)-1;
                    bline=strWriteIn(bline,kropka-1,'0');
                end
            end
         end
         i=i+1;
     end
     Lline=length(bline);
     if(usun>=1&&usun<=Lline && empty==2)
         bline=strcopy(usun,Lline,bline);
     elseif(usun>=Lline && empty==2)
         empty=0;
     end
     line=bline;
     bline='';
     
     Lline=length(line);
     Lendline=0;
     bline=''; pozelese=0;
     %-------------------------------------------sz
     %mam zapis definicji funkcji, zostawiam
     if(Lline>length('function')&&strcmp('function',line(1:length('function'))))
         strBufM{end+1}=line;
         continue;
     end
     for(i=1:Lline)
         if(pozelese<1&&(tf15||tf151))
            bline=[bline line(i)];
         end
         if(strcmp(bline,'else')||strcmp(bline,' else'))
             pozelese=i;
             bline='';
         end
         if(line(i)==' ' && empty==1)
             usun=usun+1;
         else
             empty=2;
         end
         if(line(i)=='%')%komentarz
             extra=i;
            komen=i;
            znacznik=i;
            kom=2;
            if(ost==1)
                kom=0;
            end
            if(i==1||i==2)
                kom=3;
                break;
            end
            if(Lnawias==0)
                break;
            end
         end
            if(i>3)
            if(line(i-1)=='d'&&line(i)==','&&line(i-2)=='n')
                eding=i;
            end
            end
         if(line(i)==')') 
             komen=0;
             Lnawias=Lnawias-1;
             nawias=0;
             if((floop)&&Lnawias==0)
                specendline(rez)=i;
                rez=rez+1;
                floop=0;
                komen=1;
             end
         end
         if(line(i)=='(') 
             komen=0; nawias=1; Lnawias=Lnawias+nawias; ost=1;
             if(i>2)
                 loop=[line(i-2) line(i-1)];
                 if(IsLike(loop,'or')||IsLike(loop,'if')||IsLike(loop,'le'))
                     if(tf12||tf9||tf10)
                     kom=1; komen=1;
                     floop=1;
                     end
                 end
             end
         end
         if(line(i)=='[') endline=0; nawias=1; ost=1; end
         if(line(i)==']') endline=1; nawias=0; ost=0; end
         if(line(i)==')') 
             extra=0; nawias=0;
             Lnawias=Lnawias-nawias;
             ost=0;
         end
         if(line(i)=='='||line(i)=='<'||line(i)=='>') 
             if(komen==0)
                 przypis=i+1;
             end
         end

           if(i>2)%---...
              if(line(i-2)=='.' && line(i-1)=='.'&& line(i)=='.')
                nawias=1; extraline=1;
              end
           end
         if(i>2)
            if(line(i)==';'||((line(i)==',' && line(i-1)=='d')))%endline (koniec lini) lub end,->jako koniec lini 
                if(nawias==0)
                    endline=1;Lendline=Lendline+1;
                    c=c+1;
                    pozendline(c)=i;
                end
            end
         end
         if(tf91||tf101)%for -if -while -
             if(i>2)
             if(line(i)==' ')
                 if(efloop==3)
                     efloop=2;
                 else
                    if(efloop==2)
                        pozefloop=i-1;
                        incef=1;
                        efloop=1;
                    end
                 end
                 eloop=[line(i-2) line(i-1)];
                 if((strcmp(eloop,'or')||strcmp(eloop,'if')||strcmp(eloop,'le')))
                     %if(tf12||tf91||tf101)
                     kom=1; komen=1;
                     efloop=1;
                     %incef=incef+1;
                     if(pozefloop>0)
                        specendline(rez)=pozefloop;
                        rez=rez+1;
                        pozefloop=0;
                     end
                     effor=0;
                     %end
                 end
             elseif(line(i)==':'&&efloop==1)%dla for
                 effor=effor+1;
                 if(line(i+1)==' ')
                     efloop=3;
                 else
                 efloop=2;
                 end
             elseif(line(i)=='<'||line(i)=='>'||line(i)=='='&&efloop==1&&incef==0)
                 if(line(i+1)==' ')
                     efloop=3;
                 else
                 efloop=2;
                 end
             end
             end
         end        
     end
     incef=0;
     if(pozefloop>0)%(for )
        specendline(rez)=pozefloop;
        rez=rez+1;
        pozefloop=0;
     end
     if(tf9||tf10||tf12||tf11)
         if(kom~=3)
            kom=1; komen=1; Lendline=Lendline+2;
         end
     end
     if(tf1||tf2||tf3||tf4||tf5||tf6||tf8||tf14||tf16||tf17||tf18)%czego nie kt³umaczymy
        if(extra==0||tf18)
            line=['%' line];
            kom=3;
        end
     end
     if(tf15||tf151)
         if(kom~=3)
         kom=1; komen=1; Lendline=Lendline+2; %r=1;
         end
     end 
     if(tf13)
         kom=3;
     end
     %------------------------------------------------------------

     if(kom==2&&komen>0)
         tempBuf={};
         if(empty==1)
             komen=komen-usun+1;
             Lline=Lline-usun;
             empty=0;
             usun=0;
         end
        tekst=strcopy(1,komen-1,line);%tekst bez komentarza
        if(length(pozendline)>1)
            a=1;
            for(i=1:length(pozendline))
                xkomen=strcopy(a,pozendline(i),tekst);
%                 fprintf(di,'%s\n',xkomen);
                [xkomen,strBufM,ename_list]=stre(xkomen,ename_list,strBufM);
                tempBuf{end+1}=xkomen;
                a=pozendline(i)+2;
            end
            pozendline=0;
            xkomen=strcopy(komen,Lline,line);
%             fprintf(di,'%s\n',xkomen); 
            %strBufM{end+1}=xkomen;
            strBufM{end+1}=xkomen;
            i=1;
            while(~isempty(tempBuf{i}))
                strBufM{end+1}=tempBuf{i};
                i=i+1;
                if(i>length(tempBuf))
                    break;
                end
            end
         tempBuf{end}={};
        else
        %tekst=strDel(tekst,' ');
        if(~isempty(xtekst))
            tekst=[xtekst tekst];
            xtekst='';
        end
        xkomen=strcopy(komen,Lline,line);
        if(isempty(xkomen))
            [tekst,strBufM,ename_list]=stre(tekst,ename_list,strBufM);
%             fprintf(di,'%s\n',tekst);
            strBufM{end+1}=tekst;
            tekst='';
            xkomen='';
            kom=0;
            endline=0;
        elseif(isempty(tekst))
%             fprintf(di,'%s\n',xkomen);
            strBufM{end+1}=xkomen;
            tekst='';
            xkomen='';
            kom=0;
            endline=0;
        else
            [tekst,strBufM,ename_list]=stre(tekst,ename_list,strBufM);
%             fprintf(di,'%s\n%s\n',xkomen,tekst);%kolejnoœæ wyœwietlania komentarza
             strBufM{end+1}=xkomen;
             strBufM{end+1}=tekst;
            tekst='';
            xkomen='';
            kom=0;
            endline=0;
        end
        end
     elseif(kom==1&&komen==1)
         %line=strDel(line,' ');
         tempBuf={};
         a=1;
         b=1;
         d=1;%0;
         while(rez>=2)
             if(length(specendline)>=b)
                 while(specendline(b)>pozendline(d))
                     if(pozendline(d)==0)
                         break;
                     end
                     tekst=strcopy(a,pozendline(d),line);
                     tekst=strDel(tekst,' ');
                     [tekst,strBufM,ename_list]=stre(tekst,ename_list,strBufM);
%                      fprintf(di,'%s\n',tekst);
                     %strBufM{end+1}=tekst;
                     tempBuf{end+1}=tekst;
                     a=pozendline(d)+2;
                     d=d+1;
                     if(length(pozendline)==d-1)
                         break;
                     end
                 end
             end
            tekst=strcopy(a,specendline(b),line);%tekst bez komentarza
            tekst=strDel(tekst,' ');
            [tekst,strBufM,ename_list]=stre(tekst,ename_list,strBufM);
%             fprintf(di,'%s\n',tekst);
            %strBufM{end+1}=tekst;
            tempBuf{end+1}=tekst;
             rez=rez-1;
             a=specendline(b)+2;
             b=b+1;
         end
         %d=d+1;
         b=b-1;
         if(pozelese>0)
             tekst=strcopy(1,pozelese,line);
%              fprintf(di,'%s\n',tekst);
             %strBufM{end+1}=tekst;
             tempBuf{end+1}=tekst;
             a=pozelese+1;
         end
%          if(znacznik<=1||length(pozendline)>1)
             if(b==0)
                 if(pozelese==0)
                     if(Lline>znacznik&&specendline==0)
                         pozendline=znacznik-1;
                     else
                        pozendline(d)=Lline;
                     end
                 end
             else
                 a=specendline(b)+2;
             end
             while(Lendline>0)
                 if(a>Lline)
                     break;
                 end
                 tekst=strcopy(a,pozendline(d),line);%jeœli natrafi siê else???
                 if(isempty(tekst))
                     break;
                 end
                 if(tf15&&tekst(2)=='e'&&tekst(3)=='l'&&tekst(4)=='s')
                     xkomen=strcopy(2,6,tekst);
%                      fprintf(di,'%s\n',xkomen);
                     %strBufM{end+1}=xkomen;
                     tempBuf{end+1}=xkomen;
                     tekst=strcopy(7,length(tekst),tekst);
                     a=a+6;
                 end
                 if(isempty(tekst))
                     break;
                 end
                 if(strcmp(tekst,' end,'))
                     tekst(end)='';
                 end
                 if(length(tekst)>1)
                     if(tekst(1)==' ')
                         tekst(1)='';
                     end
                 end
                 [tekst,strBufM,ename_list]=stre(tekst,ename_list,strBufM);
%                  fprintf(di,'%s\n',tekst);
                 %strBufM{end+1}=tekst;
                 tempBuf{end+1}=tekst;
                 Lendline=Lendline-1;
                 a=pozendline(d)+1;
                 d=d+1;
                 if(length(pozendline)<d)
                     break;
                 end
             end
%          else
%              a=specendline(d)+1;
%              if(a~=znacznik&&znacznik>1&&specendline(end)==a-1)%wstawianie koomentarza
%                  a=znacznik;
%              end
%              if(tf11)
%                  tekst=strcopy(1,a-1,line);
%                   fprintf(di,'%s\n',tekst);
%                   %strBufM{end+1}=tekst;
%                   tempBuf{end+1}=tekst;
%              end
%          end
         if(length(specendline)>1&&b==1)
             b=a;
             for(i=2:length(specendline))
                 if(a>Lline)
                     break;
                 end
                     tekst=strcopy(b,specendline(i),line);
                     b=specendline(i);
                     if(~isempty(tekst))
%                      fprintf(di,'%s\n',tekst);
                     %strBufM{end+1}=tekst;
                     tempBuf{end+1}=tekst;
                     a=b;
                     end
             end
         end
         tekst=strcopy(a,length(line),line);%tekst bez komentarza
         Ltekst=length(tekst);
         if(~isempty(tekst))
             if(Ltekst>3)
             if(tf11&&tekst(2)=='e'&&tekst(3)=='n'&&tekst(4)=='d')
                 xkomen=strcopy(2,4,tekst);
%                  fprintf(di,'%s\n',xkomen);
                 %strBufM{end+1}=xkomen;
                 tempBuf{end+1}=xkomen;
                 tekst=strcopy(6,length(tekst),tekst);
             else
                 if(tekst(1)==' ')
                     tekst(1)='';
                 end
             end
             elseif(Ltekst<1)
             else
                 if(tekst(1)==' ')
                     tekst(1)='';
                 end
             end
             if(~isempty(tekst))
                 if(length(tekst)>1)
                     if(tekst(1)~='%')
                     [tekst,strBufM,ename_list]=stre(tekst,ename_list,strBufM);
    %                fprintf(di,'%s\n',tekst);
                     %strBufM{end+1}=tekst;
                     end
                 end
                 tempBuf{end+1}=tekst;
             end
         end
         kom=0;komen=0;
         if(~isempty(tempBuf{end})) 
            if(tempBuf{end}(1)=='%')
            strBufM{end+1}=tempBuf{end};
            tempBuf{end}=[];
            end
         end
         i=1;
         while(~isempty(tempBuf{i}))
             strBufM{end+1}=tempBuf{i};
             i=i+1;
             if(i>length(tempBuf))
                 break;
             end
         end
         tempBuf{end}={};
         %line
     elseif(endline==1 && kom==0 && nawias==0)
         if(ost==1)
            %line=strDel(line,' ');
            ost=0;
            Lendline=1;
         end
         if(xadd==1)
             line=[xtekst line];
             xadd=0;
             Lendline=1;
         end
         if(Lendline~=1)
             midend=1;
             poink=1;
             while(Lendline~=0)
                 preline='';
                for(q=midend:Lline)
                    if(line(q)==';'||strcmp(preline,'else'))
                        if(pozendline(poink)==q)
                        midend=q;
                        preline=[preline ';'];
                        break;
                        end
                    end
                    if(line(q)==' ')
                        continue; 
                    end
                    if(line(q)==')'&&specendline(end)==q)
                        midend=q;
                        preline=[preline ')'];
                        break;
                    end
                    preline=[preline line(q)];
                end
                if(~isempty(preline))
                    [preline,strBufM,ename_list]=stre(preline,ename_list,strBufM);
%                     fprintf(di,'%s\n',preline);
                    strBufM{end+1}=preline;
                    midend=q+1;
                    Lendline=Lendline-1;
                    if(length(pozendline)>=poink+1)
                        poink=poink+1;
                    else
                        pozendline(poink)=Lline;
                    end
                else
                    break;
                end
             end
             Lendline=0;
         else
         %line
         if(Lline<1)
         else
            if(line(1)==' ')
                line(1)='';
            end
         end
         [line,strBufM,ename_list]=stre(line,ename_list,strBufM);
%          fprintf(di,'%s\n',line);
         strBufM{end+1}=line;
         endline=0;
         end
     elseif(nawias==1)
         %line=strDel(line,' ');
         if(extraline==1)
             line(i)='';line(i-1)='';line(i-2)='';
         end
         xtekst=[xtekst line];
         xadd=1;
     elseif(kom==3)
%          fprintf(di,'%s\n',line);
         strBufM{end+1}=line;
     else
%          fprintf(di,'%s\n',line);
         strBufM{end+1}=line;
         %line
     end
     empty=0;
     pozendline=zeros(1);
     c=0;
     usun=0;
     znacznik=1;
     extra=0;
     specendline=0;
     komen=0;
     kom=0;
     endline=0;
     efloop=0;
     rez=1;
end
fclose(id);
fclose('all');
% fclose(di);
end