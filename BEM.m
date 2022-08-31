function [u_scat,psi] = BEM(X, Y, ver, i_pol, k, h, z, theta, disc,method,singex,plt)
% Risolvo l'eq id Helmholtz tramite il BEM con metodo di discretizzazione
% e metodo di risoluzione del BIE come indicato in input
% INPUT: X,Y: griglia di valutazione
%        ver: vertici dei poligoni (numeri complessi)
%        i_pol: indici dei vertici di fine e di inizio dei poligoni
%        k: parametro dell'equazione di Helmholtz
%        h: ampiezza della mesh
%        z: parametro del metodo di discretizzazione adattivo
%        theta: angolo dell'onda incidente
%        disc: stringa che indica il metodo di discretizzazione ('uniform','adaptive')
%        method: stringa che indica il metodo di risoluzione del BIE 
%        ('collocation', 'galerkin')
%        singex: stringa che indica la presenza o meno della singularity  
%        extraction ('singex', 'nosingex')
%        plt: stringa che indica se plottare ('plot') o no
% OUTPUT: u_scat: onda scatterata valutata su X+Yi

% PARAMETRI
PWave = @(x) exp(1i*k*(real(x)*cos(theta)+imag(x)*sin(theta))); % u_inc = onda piana
Omega = X+Y*1i;                                    % info del dominio in numeri complessi

% Poligoni bianchi
n_pol = size(i_pol,1);
% nel vettore dei vertici separo ogni poligono con un Nan, così la funzione
% inpolygon riconosce ogni poligono separatamente
ver_nan = zeros(i_pol(end,2) + n_pol, 1).*(nan+nan*1i);
for j = 1:n_pol
    ver_nan((i_pol(j,1)+(j-1)):(i_pol(j,2)+(j-1))) = ver(i_pol(j,1):i_pol(j,2));
end
IN = inpolygon(X, Y, real(ver_nan), imag(ver_nan)); % indico il dominio Omega
I = find(IN);                                       % indici dei non zero

% DISCRETIZZAZIONE
if strcmp(disc, 'uniform')
    [PT,POL] = BE_u(ver, h, i_pol);
elseif strcmp(disc,'adaptive')
    [PT,POL] = BE_a(ver, h, i_pol, z);
else
    error('discretizzazione non accettabile')
end

% BIE
if (strcmp(method, 'collocation') && strcmp(singex,'nosingex'))
    [u_scat,psi] = BEM_col(PT,POL,k,PWave,Omega,'no');
elseif (strcmp(method, 'collocation') && strcmp(singex,'singex'))
    [u_scat,psi] = BEM_col(PT,POL,k,PWave,Omega,'se');
elseif (strcmp(method, 'galerkin') && strcmp(singex,'nosingex'))
    [u_scat,psi] = BEM_gal(PT,POL,k,PWave,Omega,'no');
elseif (strcmp(method, 'galerkin') && strcmp(singex,'singex'))
    [u_scat,psi] = BEM_col(PT,POL,k,PWave,Omega,'se');
else
    error('metodo non accettabile')
end

% Onda scatterata e onda incidente
u_scat(I) = nan+1i*nan;
u_inc = PWave(Omega);
u_inc(I) = nan+1i*nan;

% PLOT
if strcmp(plt, 'plot')
    MyFieldPlot(X,Y,u_inc,'Onda incidente');
    MyFieldPlot(X,Y,u_scat,'Onda scatterata');
    MyFieldPlot(X,Y,(u_inc+u_scat),'Onda totale');
end

end