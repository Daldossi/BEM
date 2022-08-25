function FH = MyFieldPlot(xx,yy,Field,PlotTitle)
% Plot real part, imaginary part and magnitude of Field in points xx/yy
% in three subplots of a figure, superimposing PlotTitle string as title.
% Returns figure handle FH.

FH = figure;
set(gcf,'position',[50, 100, 1400,400]);

subplot(1,3,1)
pcolor(xx,yy,real(Field));
axis off;   axis equal; shading flat;   colorbar;
title('Real part')

subplot(1,3,2)
pcolor(xx,yy,imag(Field));
axis off;   axis equal; shading flat;   colorbar;
title('Imaginary part')

sp3 = subplot(1,3,3);
pcolor(xx,yy,abs(Field)); title('Absolute value');
%pcolor(xx,yy,log10(abs(Field))); title('log10(Absolute value)');
%pcolor(xx,yy,abs(Field).^2); title('(Absolute value)^2');
%pcolor(xx,yy,angle(Field)); title('Complex argument');
axis off;   axis equal; shading flat;
colormap(sp3,hot);
colorbar;
sgtitle(PlotTitle,'interpreter','latex'); % add main title
addToolbarExplorationButtons(gcf);  % Matlab old style zoom buttons   
end