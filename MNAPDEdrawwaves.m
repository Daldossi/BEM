% MNAPDEdrawwaves.m     AM, Pavia, MNAPDE 2019-2022
%
% Draw several Helmholtz solutions in 2D:
% draw real and imaginary part, magnitude,
% gif animation of time-harmonic evolution.
%
%
% If Matlab opens empty figures and freezes, try typing 
% opengl('save','software') at the command prompt and restart Matlab.


function MNAPDEdrawwaves
%% Choose all parameters here
PlotLim = 1;               % Plot functions on square max{|x|,|y|}<PlotLim
k = 30;                    % Wavenumber (>0)
np = 300;                  % Number of points in x & y directions for field plots, affects speed and size of png/gif

anglePW = pi/6;            % Angle defining direction of plane wave
EvanescentParam = 0.3;     % Parameter for definition of evanescent wave
CWindex = 3;               % Index of Fourier-Bessel smooth circular wave
OutCWindex = 5;            % Index of Fourier-Hankel outgoing circular wave
OutCWtruncation = 2;       % Truncate field at this magnitude to improve plot (keep ~2)
nquad = 10;                % Number of Gauss quadrature points in angular coordinate for Herglotz wave
th0 = 0;                   % Herglotz density is = 1 on interval [th0,th1] and 0 outside
th1 = pi/6;
MieRadius = 1/4;           % Radius of disc for Mie scattering

WithSaveFig = 0;           % Save all figures as .png, choose 1 or 0
WithGif = 0;               % Generates time-harmonic animated gifs
% Warning: gif-making is slow, closes all pics, don't use PC while running it!


%% Set up  ----------------------------------------------------------
tic;
close all;
x = linspace(-PlotLim,PlotLim,np);
[xx,yy] = meshgrid(x,x);                % Matrices of x and y coordinates where to evaluate and plot fields
TitleString = sprintf('on $(%g,%g)^2$, $k=%g$', -PlotLim,PlotLim, k);

%% Plane wave
PW_Val = exp(1i*k*(xx*cos(anglePW)+yy*sin(anglePW)));
FH_PW = MyFieldPlot(xx,yy,PW_Val, sprintf('Plane wave $e^{ikx.d}$ %s, angle = %.3g',TitleString,anglePW));
    
%% Stationary wave, sum of two plane waves
SW_Val = cos(k*(xx*cos(anglePW)+yy*sin(anglePW)));
FH_SW = MyFieldPlot(xx,yy,SW_Val, sprintf('Stationary wave $(e^{ikx.d}+e^{-ikx.d})/2$, %s, angle = %.3g',TitleString,anglePW));

%% Evanescent wave
EW_Val = exp(1i*sqrt(EvanescentParam^2+1)*k*xx-EvanescentParam*k*yy);
FH_EW = MyFieldPlot(xx,yy,EW_Val, sprintf('Evanescent wave $e^{iK.x}$ %s, $K=(%g,i%g)$',TitleString,sqrt(EvanescentParam^2+1)*k,EvanescentParam*k));

%% Fundamental solution
FS_Val = (1i/4)*besselh(0,1,k*sqrt(xx.^2+yy.^2));
FH_FS = MyFieldPlot(xx,yy,FS_Val, sprintf('Fundamental solution %s',TitleString));

%% Smooth circular wave
CW_Val = besselj(CWindex,k*sqrt(xx.^2+yy.^2)) .* exp(1i*CWindex*angle(xx+1i*yy));
FH_CW = MyFieldPlot(xx,yy,CW_Val,  sprintf('Smooth circular wave $J_l(kr)e^{ilt}$ (Fourier--Bessel) %s, index $l=%g$',TitleString,CWindex));

%% Outgoing circular wave
OutCW_Val = besselh(OutCWindex,1,k*sqrt(xx.^2+yy.^2)) .* exp(1i*OutCWindex*angle(xx+1i*yy));
OutCW_Val = OutCW_Val .* (abs(OutCW_Val)<OutCWtruncation);     % Truncate to 0 where magnitudes are >OutCWtruncation
FH_OutCW = MyFieldPlot(xx,yy,OutCW_Val,  sprintf('Outgoing circular wave $H^{(1)}_l(kr)e^{ilt}$ (Fourier--Hankel) %s, index $l=%g$, truncated at $|u|<%g$',...
    TitleString,OutCWindex,OutCWtruncation));

%% Sum of two outgoing circular waves with opposite index
OutCW2_Val = besselh(OutCWindex,1,k*sqrt(xx.^2+yy.^2)) .* exp(1i*OutCWindex*angle(xx+1i*yy)) ...
             + besselh(-OutCWindex,1,k*sqrt(xx.^2+yy.^2)) .* exp(-1i*OutCWindex*angle(xx+1i*yy));
OutCW2_Val = OutCW2_Val .* (abs(OutCW2_Val)<OutCWtruncation);     % Truncate to 0 where magnitudes are >OutCWtruncation
FH_OutCW2 = MyFieldPlot(xx,yy,OutCW2_Val, sprintf('Sum of 2 outgoing circular waves $H^{(1)}_l(kr)e^{ilt}+H^{(1)}_{-l}(kr)e^{-ilt}$ %s, index $l=%g$, truncated at $|u|<%g$',...
    TitleString,OutCWindex,OutCWtruncation));

%% Herglotz function with piecewise-constant kernel
[xth,wth] = gaussquad(nquad);  % Gauss quadrature in angular coordinate
xth = th0 + xth*(th1-th0);
Hergl_Val = zeros(size(xx));
for QuadratureIndex = 1:nquad
    Hergl_Val = Hergl_Val + wth(QuadratureIndex)* exp(1i*k*(xx*cos(xth(QuadratureIndex))+yy*sin(xth(QuadratureIndex))));
end
FH_Hergl = MyFieldPlot(xx,yy,Hergl_Val, sprintf('Herglotz function %s, constant kernel supported on (%.3g,%.3g)',TitleString,th0,th1));

%% PW scattering by sound-soft disc, Mie series
Mie_SS_Val =  zeros(size(xx));
MaxL = 2*k*MieRadius + 10;   % Cautious choice for truncation of Mie series
for lMie = -MaxL:MaxL    
    Mie_SS_Val = Mie_SS_Val - (1i^lMie*besselj(lMie,k*MieRadius)*exp(-1i*lMie*anglePW)/besselh(lMie,1,k*MieRadius)) ...
        * besselh(lMie,1,k*sqrt(xx.^2+yy.^2)) .* exp(1i*lMie*angle(xx+1i*yy));
end
Mie_SS_Val = Mie_SS_Val .* (xx.^2+yy.^2 > MieRadius^2) ;   % chop field in the scatterer to 0
Mie_SStot_Val = Mie_SS_Val + PW_Val .* (xx.^2+yy.^2 > MieRadius^2);
ScatteringString = sprintf(' disc with Mie series %s, incoming PW angle %.3gpi, radius %.3g',TitleString,anglePW/pi,MieRadius);
FH_SSscat = MyFieldPlot(xx,yy,Mie_SS_Val, strcat('Field scattered by sound-soft (Dirichlet)', ScatteringString));
FH_SStot = MyFieldPlot(xx,yy,Mie_SStot_Val, strcat('Total field for scattering by sound-soft (Dirichlet)', ScatteringString));

%% PW scattering by sound-hard disc, Mie series
Mie_SH_Val =  zeros(size(xx));
for lMie = -MaxL:MaxL    
    Mie_SH_Val = Mie_SH_Val - ...
        (  1i^lMie*(besselj(lMie-1,k*MieRadius)-besselj(lMie+1,k*MieRadius))*exp(-1i*lMie*anglePW)...
        /(besselh(lMie-1,1,k*MieRadius)-besselh(lMie+1,1,k*MieRadius))  ) ...
        * besselh(lMie,1,k*sqrt(xx.^2+yy.^2)) .* exp(1i*lMie*angle(xx+1i*yy));
end
Mie_SH_Val = Mie_SH_Val .* (xx.^2+yy.^2 > MieRadius^2) ;    % chop field in the scatterer to 0
Mie_SHtot_Val = Mie_SH_Val + PW_Val .* (xx.^2+yy.^2 > MieRadius^2);
FH_SHscat = MyFieldPlot(xx,yy,Mie_SH_Val, strcat('Field scattered by sound-hard (Neumann)', ScatteringString));
FH_SHtot = MyFieldPlot(xx,yy,Mie_SHtot_Val, strcat('Total field for scattering by sound-hard (Neumann)', ScatteringString));

%% Dirichlet eigenfunction in unit disc
IndexDisc = 9; kDisc = 13.354300477435331;
EigenDisc_Val = besselj(IndexDisc,kDisc*sqrt(xx.^2+yy.^2)) .* exp(1i*IndexDisc*angle(xx+1i*yy)) .* ((xx.^2+yy.^2)<1);
FH_EigenDisc = MyFieldPlot(xx,yy,EigenDisc_Val, sprintf('Unit disc eigenfunction, $k=%g$: $u(x)=J_{%d}(kr)e^{i%d t}$',kDisc,IndexDisc,IndexDisc));

%% Random eigenfunction of the square
EigenIndex = ceil(rand(1,2)*10);
k_Eigenv = .5*pi*norm(EigenIndex)/PlotLim;
Eigen_Val = sin((.5*pi*EigenIndex(1)/PlotLim)*(xx+PlotLim)).* sin((.5*pi*EigenIndex(2)/PlotLim)*(yy+PlotLim));
FH_Eigen = MyFieldPlot(xx,yy,Eigen_Val, sprintf('Dirichlet eigenfunction on $(-%g,%g)^2$, index (%g,%g), $k=%g$',...
    PlotLim,PlotLim,EigenIndex(1),EigenIndex(2),k_Eigenv));

%% Downward plane waves reflected by horizontal line with Dirichlet/Neumann/Impedance BCs
d1 = abs(cos(anglePW));
d2 = abs(sin(anglePW));
IncomingVal = exp(1i*k*(xx*d1-yy*d2));
SnellReflVal = exp(1i*k*(xx*d1+yy*d2));
ReflDir_Val = IncomingVal - SnellReflVal ;
ReflNeu_Val = IncomingVal + SnellReflVal ;
% Impedance BCon {x_2=const}:  du/dn-ikZu = -du/dx_2-ikZu = 0  
ImpParamZ = 1;
%ImpParamZ = d2;   % For this impedance the incoming wave is completely absorbed
ReflImp_Val = IncomingVal + (d2-ImpParamZ)/(d2+ImpParamZ)* SnellReflVal;
FH_ReflDir = MyFieldPlot(xx,yy,ReflDir_Val, sprintf('Plane wave reflected by $(x_2=-%g)$, %s, Dirichlet BCs',PlotLim,TitleString));  
FH_ReflNeu = MyFieldPlot(xx,yy,ReflNeu_Val,sprintf('Plane wave reflected by $(x_2=-%g)$, %s, Neumann BCs',PlotLim,TitleString));
FH_ReflImp = MyFieldPlot(xx,yy,ReflImp_Val, sprintf('Plane wave reflected by $(x_2=-%g)$, %s, Impedance BCs, Z=%g',PlotLim,TitleString,ImpParamZ));

%% Reflection of Herglotz function on horizontal line
th0R = -pi/3;                   % Choose downward-propagating Herglotz function (-pi<th0R<th1R<0)
th1R = -pi/6;   
yyR = yy+1;                     % Translate coordinates upwards
xthR = th0R + xth*(th1R-th0R);
HerglR_Val = zeros(size(xx));
for QuadratureIndex = 1:nquad
    HerglR_Val = HerglR_Val + wth(QuadratureIndex)* exp(1i*k*(xx*cos(xthR(QuadratureIndex))+yyR*sin(xthR(QuadratureIndex))));
end
% Use uI(-x,-y)=conj{uI(x,y)} so uR(x,y):=uI(x,-y)=conj{uI(-x,y)} and
% symmetry around x=0 of domain:
HerglR_Val = HerglR_Val - conj(fliplr(HerglR_Val));
FH_HerglR = MyFieldPlot(xx,yyR,HerglR_Val, sprintf('Reflection of Herglotz function with constant kernel supported on (%.3g,%.3g), on sound-soft ($x_2=0$), on $(-1,1)$x$(0,2)$, $k=%g$',th0R,th1R,k));

%% Save figure and make GIF animations, if requested:
if WithSaveFig || WithGif
    dirpath = 'Figs';            % Name of folder where to save figures
    % if absent, make folder where to save figures and gifs
    if (exist(dirpath, 'dir') == 0), mkdir(dirpath); end
end
if WithSaveFig
    MyPrintFig = @(FigHandle,FigName) print(FigHandle,'-dpng',[dirpath,'/FieldPlot',FigName,'.png']);
    MyPrintFig(FH_PW,'PW');
    MyPrintFig(FH_SW,'SW');
    MyPrintFig(FH_EW,'EW');    
    MyPrintFig(FH_FS,'FS');
    MyPrintFig(FH_CW,'CW');
    MyPrintFig(FH_OutCW,'OutCW');
    MyPrintFig(FH_OutCW2,'OutCW2');
    MyPrintFig(FH_Hergl,'Hergl');
    MyPrintFig(FH_SSscat,'SoundSoftDiscScat');
    MyPrintFig(FH_SStot,'SoundSoftDiscTot');    
    MyPrintFig(FH_SHscat,'SoundHardDiscScat');
    MyPrintFig(FH_SHtot,'SoundHardDiscTot');
    MyPrintFig(FH_EigenDisc,'EigenfunctionDisc');
    MyPrintFig(FH_Eigen,'Eigenfunction');
    MyPrintFig(FH_HerglR,'HerglRefl');
end
if WithGif 
    close all  % Close all figure otherwise sometimes Matlab messes up
    MyGif = @(Val,Str) MyGiffer(xx,yy,Val,strcat(dirpath,'/AnimFieldPlot',Str,'.gif'));
    MyGif(PW_Val,'PW');
    MyGif(SW_Val,'SW');
    MyGif(EW_Val,'EW');
    MyGif(FS_Val,'FS');    
    MyGif(CW_Val,'CW');
    MyGif(OutCW_Val,'OutCW');    
    MyGif(OutCW2_Val,'OutCW2');
    MyGif(Hergl_Val,'Hergl');
    MyGif(Mie_SS_Val,'SoundSoftDiscScat');
    MyGif(Mie_SStot_Val,'SoundSoftDiscTot');
    MyGif(Mie_SH_Val,'SoundHardDiscScat');
    MyGif(Mie_SHtot_Val,'SoundHardDiscTot');    
    MyGif(EigenDisc_Val,'EigenfunctionDisc'); 
    MyGif(Eigen_Val,'Eigenfunction');
    MyGif(ReflDir_Val,'ReflDir');
    MyGif(ReflNeu_Val,'ReflNeu');
    MyGif(ReflImp_Val,'ReflImp'); 
    MyGif(HerglR_Val,'HerglRefl');  
end
toc
end
