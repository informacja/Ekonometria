
filename = 'temp191.csv';
folder   = 'temperatura/';
filename = '2018.csv';
 
for i = 2013:2018
    filename = append(num2str(i),'.csv');
    [Temp] = readvars( append(folder,filename) );  
    subplot(211); plot(Temp); title(filename);     
    filename = append(num2str(i+1),'.csv');
    [Temp] = readvars( append(folder,filename) );
    subplot(212); plot(Temp); title(filename); 
    xlabel('Dni roku'); ylabel(['Temperatura [' char(176) 'C]']);
%     pause(2); 
    input(append('Enter <> ',int2str(i)));
end
