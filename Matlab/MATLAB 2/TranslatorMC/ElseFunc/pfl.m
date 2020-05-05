function pfl( vnList , blTC)

if(nargin>1)
    if(blTC)
        [~,a]=size(vnList);
        for i=1:a
            for j=1:length(vnList{i})
                fprintf('%s\n',vnList{i}{j});
            end
        end
    end
    return;
end

%Do wypisywania elementow z listy
if isempty(vnList) fprintf('Lista pusta\n'); return; end
if ~iscell(vnList{1})
    for i=1:length(vnList)
        fprintf('%s\n',num2str(vnList{i}));
    end
else
    for i=1:length(vnList)
        t=vnList{i};
        str=[]; 
        for(j=1:length(t))
            if(~iscell(t{j}))str=[str ' ' num2str(t{j})];
            else [a,b]=size(t{j}); str=[str,' cell[',num2str(a),'x',num2str(b),']']; end
        end
        fprintf('%s\n',str);
    end    
end
end
