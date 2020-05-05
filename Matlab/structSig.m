function structSig(x)
   names = fieldnames(x);
   for i = 1:length(names)
      signalAnalyzer(getfield(x,names{i}))
   end
end
