function [outputArg1,outputArg2] = figPW(saveAs, OverwrieProtection)
% Figure Pretty & Write
%  if(narg  < 1)
%      saveAs
%  end 
fTitle = '_'; % do zapisywanej nazwy pliku
h1 = gcf; % handle to figure

% find title
% h1.CurrentObject.CurrentObject.CurrentObject.Children.Title 
% if(narg  < 2) % jeœli jeden parametr
%     get( get(gcf,'Number'), 'Name' )
% if( ~isempty(h1.Title.String))    
% %     get( get(gcf,'Number'), 'Name' ) las figure title name
% %  [ get( get(gcf,'Number'), 'Name' ), h1.Title.String ] 
% 
%     % titre=h1.Title.String
%     title( datestr(now,'yyyy-mm-dd HH:MM:ss') ); % default timestamp title
% 
% else
%     fTitle = ['_' h1.Title.String '_' ];
% end
%  end 
% title([{'Dziedzina czasu'},{'Cha-ka skokowa'}]);  
% xlabel('Oœ rzeczywista'); ylabel('Oœ urojona'); 
% legend(str{:}); 

    [path, filename, ext] = fileparts( mfilename('.')); [~, folderName] = fileparts(pwd());                      % nazwa TEGO *.m-pliku
    print( strcat(folderName, fTitle, num2str(get(gcf,'Number')), '.png'),'-dpng'); % Zapisz jako tenMPlik_nrOstatniejFigury.png
end

