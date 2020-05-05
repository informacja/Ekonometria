function [ vname_change,vname_inic ] = MyDebug( instr,vname_inic )
%MyDebug -> przygotowuje oraz weryfikuje zmiany w liscie zmiennych po
%wykonaniu nameplik

global kod gInLoop opt;
if(opt.implicit) vname_change={}; vname_inic={}; return; end;
if(nargin<2) vname_inic={}; end;
stru=0;
vname_change={};
if ~gInLoop
    id=fopen(kod); %czy pierwsze u¿ycie
    if(id==-1)
        kod=loadW();
    else
        fclose(id);
        clear  id
    end
    change=zeros(1,3);
    f1=0;f2=0;f3=0; x=0;
    if(~iscell(instr))%zczytujemy pêtlê z bufora do endu
        [stname,kod]=Luckyluke(instr,kod);
        for(i=1:length(stname))
            [yes,el]=GetFromNL(stname(i).name);
%             if((~yes||~strcmp(el{2},stname(i).class))&&~strcmp(stname(i).class,'struct'))%deklaracja nowej zmiennej
%                 valuel=load(kod,stname(i).name);
%                 val=['valuel.' stname(i).name];
%                 vvaluel=eval(val);
%                 dotyp=strTyping(vvaluel);
%                 stname(i).class=dotyp;
%                 clear vlauel val vvlaluel
%                 f1=1;
%                 x=x+1;
%                 change(x)=2;
%             end
            if(yes&&el{3}~=stname(i).size(1))
                f2=1;
                x=x+1;
                change(x)=3;
            end
            if(yes&&el{4}~=stname(i).size(2))
                f3=1;
                x=x+1;
                change(x)=4;
            end
        if(f1||f2||f3||~yes)
            if(stname(i).size(1)>1||stname(i).size(2)>1)
                rodz=0;
            else
                rodz=1;
            end
            if(~yes||strcmp(el{2},'UnDef')) vname_change{end+1}={stname(i).name stname(i).class stname(i).size(1) stname(i).size(2) rodz 0 0 0 change};
            else vname_change{end+1}={stname(i).name el{2} stname(i).size(1) stname(i).size(2) rodz 0 0 0 change}; end
            change=zeros(1,3);
            end
        end
    else
        allinstr='';
        for(i=1:length(instr))
            if(isempty(instr{i})||instr{i}(1)=='%')
                continue
            end
%             if(i>2)
%                 if(strcmp(instr{i-1},instr{i}))
%                     allinstr=[allinstr ';'];
%                 end
%             end
            %zmienne przy inicjalizacji for([i]=1:
%             txt=[instr{i}(1) instr{i}(2) instr{i}(3)];
            if((length(instr{i})>=3)&&strcmp(instr{i}(1:3),'for'))
                    fins=instr{i};
                    ninc='';
                    dotyp='';
                    fd=0;
                    for(it=5:length(fins))
                        if(fins(it)==':')
                            break;
                        end
                        if(fd||fins(it)=='=')
                            dotyp=[dotyp fins(it)];
                            fd=1;
                        end 
                        if(fd==0)
                            ninc=[ninc fins(it)];
                        end
                    end
                    dotyp(1)='';
                    typ=strGetType(dotyp);
                    add_inic=0;
                   for(iinc=1:length(vname_inic))
                       if(strcmp(vname_inic{iinc}{1},ninc))
                           add_inic=1;
                       end
                   end
                   if(add_inic==0)
                       vname_inic{end+1}={ninc typ};
                   end
            end
            allinstr=[allinstr  ' ' instr{i}];
        end
        [stname,kod]=Luckyluke(allinstr,kod);
            for(i=1:length(stname))
                [yes,el]=GetFromNL(stname(i).name);
                adinkr=true;
                %----------------------------------
                    %zmiana typow zminnych inkrementowanych
                    for(it=1:length(vname_inic))
                        if(strcmp(vname_inic{it}{1},stname(i).name))%?????
                            stname(i).class=vname_inic{it}{2};
                            adinkr=false;
                        end
                    end
                %-------------
                %zaawansowanie rozpoznawanie typow
%                 if(adinkr)
%                     valuel=load(kod,stname(i).name);
%                     val=['valuel.' stname(i).name];
%                     vvaluel=eval(val);
%                     if(~strcmp(stname(i).class,'struct'))
%                         dotyp=strTyping(vvaluel);
%                         stname(i).class=dotyp;
%                         clear vlauel val vvlaluel
%                     else
%                         stru=1;
%                         if(~yes)
%                             vname_change=strTypStruct(vvaluel,vname_change,stname(i).name);
%                             clear vlauel val vvlaluel
%                         end
%                     end
%                 end
                %---------------------------------
                if(yes)
%                     if(~strcmp(el{2},stname(i).class))%zmiana ttypu
%                         if(stru==1)
%                              vname_change=strTypStruct(vvaluel,vname_change,stname(i).name);
%                              clear vlauel val vvlaluel
%                         end
%                         f1=1;
%                         x=x+1;
%                         change(x)=2;
%                     end
                    if(el{3}~=stname(i).size(1))
                        f2=1;
                        x=x+1;
                        change(x)=3;
                    end
                    if(el{3}~=stname(i).size(2))
                        f3=1;
                        x=x+1;
                        change(x)=4;
                    end
                end
                if(f1||f2||f3||~yes)
                    rodz=0;
    %                 if(stname(i).size(1)==1 && stname(i).size(2)==1)
    %                     rodz=1;
    %                 end
                    if(~yes||strcmp(el{2},'UnDef')) vname_change{end+1}={stname(i).name stname(i).class stname(i).size(1) stname(i).size(2) rodz 0 0 0 change};
                    else vname_change{end+1}={stname(i).name el{2} stname(i).size(1) stname(i).size(2) rodz 0 0 0 change}; end
                    change=zeros(1,3);
                end
            end
    end
end
end