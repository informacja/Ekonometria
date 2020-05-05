figure(1)
% hold off;
plot3(1, 2, 3,  'o')
% hold on;
plot3([0 0 3 4 5],[0 2 3 4 5],[1 2 -NaN 4 5])
xlabel('Cia³o')
ylabel('Psychika')

% hold off;
% load carsmall
% tbl = table(Horsepower,MPG,Cylinders);
% s = scatterhistogram(tbl,'Horsepower','MPG', ...
%     'GroupVariable','Cylinders','HistogramDisplayStyle','smooth', ...
%     'LineStyle','-');

 x=[0:1:4];
 y=[0:1:2];
 [xx,yy]=meshgrid(x,y);
 zz=xx+(2*xx.*yy.^2)+3*xx; % HERE
 
 surf(xx,yy,zz);

 
 [x y] = meshgrid(-1:0.1:1); % Generate x and y data
z = zeros(size(x, 1)); % Generate z data
surf(x, y, z) % Plot the surface
 
% x = 0:0.1:4;
% y = sin(x.^2).*exp(-x);
% stem(x,y)


patch([1 -1 -1 1], [1 1 -1 -1], [0 0 0 0], [1 1 -1 -1])
patch( [1 -1 -1 1] , [0 0 0 0], [1 1 -1 -1], [1 1 -1 -1])