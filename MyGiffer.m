function MyGiffer(xx,yy,M,GifName)
% Generate time-harmonic animation of complex field M on points xx/yy, 
% export as gif in file GifName --- not very reliable
% Do not touch mouse & keyboard while running!
figure
pcolor(xx,yy,(real(M)));
colormax = max(max(abs(M)));
caxis([-colormax,colormax]);
axis tight;  axis equal;  shading interp;
set(gca,'nextplot','replacechildren','visible','off')
f = getframe; %(gcf); % gcf sometimes avoids errors but gives ugly gray box
[im,map] = rgb2ind(f.cdata,256,'nodither');
for t_count = 1:25  % loop over 25 frames
    t = t_count*2*pi/25;
    pcolor((real(exp(-t*1i)*M)));
    axis tight;    axis square;   shading interp;
    f = getframe; %(gcf);
    im(:,:,1,t_count) = rgb2ind(f.cdata,map,'nodither');
end
imwrite(im,map,GifName,'gif','DelayTime',0,'LoopCount',inf);
hold off;
close;
end     
