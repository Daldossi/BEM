clear all
close all

%% Parametri
load MPSpackBenchmarkSquareScatt.mat;

k = 20;                         % Numero d'onda, parametro dell'eq di Helmholtz
h = 0.1;                        % Ampiezza della mesh (sul bordo)
z = 2;                          % Parametro per la mesh adattiva
theta = -pi/4;                  % direzione di u_inc
PWave = @(x) -exp(1i*k*(real(x)*cos(theta)+imag(x)*sin(theta))); % u_inc = onda piana
ver = [-0.5-0.5*1i; 0.5-0.5*1i; 0.5+0.5*1i; -0.5+0.5*1i]; % vertici del poligono (quadrato)
i_pol = [1,4];                  % indici vertici dei poligoni
[X,Y] = meshgrid(gx,gy);        % griglia XxY su cui valutare la funzione
n_points = 150;                 % dimensione dominio
Omega = X+Y*1i;                 % info del dominio in numeri complessi

%% Errore in norma L^2 del metodo con e senza singularity extraction

H = zeros(6,1);
E_col = zeros(length(H),1); %errore collocazione
E_gsl = zeros(length(H),1); %errore galerkin
R = 1; % all'esterno del cerchio unitario
u(isnan(u)) = 0;
for i = 4:9
    h = 2^(-i);                        % Ampiezza della mesh (sul bordo)
    H(i-3) = h;
    [PT_u,POL_u] = BE_u(ver, h, i_pol);
    [PT_a,POL_a] = BE_a(ver, h, i_pol, z);
    % Mesh uniforme
    % Metodo collocazione
    E_colu(i-3) = Error('col','no',PT_u,POL_u,k,PWave,Omega,u,ui,X,Y,R);
    % Metodo collocazione con singularity extraction
    E_colu_se(i-3) = Error('col','se',PT_u,POL_u,k,PWave,Omega,u,ui,X,Y,R);
    % Metodo Galerkin
    E_galu(i-3) = Error('gal','no',PT_a,POL_a,k,PWave,Omega,u,ui,X,Y,R);
    % Metodo Galerkin con singularity extraction
    E_galu_se(i-3) = Error('gal','se',PT_u,POL_u,k,PWave,Omega,u,ui,X,Y,R);
    % Mesh adattiva
    % Metodo collocazione
    E_cola(i-3) = Error('col','no',PT_a,POL_a,k,PWave,Omega,u,ui,X,Y,R);
    % Metodo collocazione con singularity extraction
    E_cola_se(i-3) = Error('col','se',PT_a,POL_a,k,PWave,Omega,u,ui,X,Y,R);
    % Metodo Galerkin
    E_gala(i-3) = Error('gal','no',PT_a,POL_a,k,PWave,Omega,u,ui,X,Y,R);
    % Metodo Galerkin con singularity extraction
    E_gala_se(i-3) = Error('gal','se',PT_a,POL_a,k,PWave,Omega,u,ui,X,Y,R);
end

figure
subplot(2,2,1)
loglog(H,E_colu,'-o')
hold on
loglog(H,E_colu_se,'-o')
hold on
xlabel('h')
ylabel('errore in norma L2')
legend('Senza singularity extraction','Con singularity extraction')
title('Collocazione uniforme')
subplot(2,2,2)
loglog(H,E_cola,'-o')
hold on
loglog(H,E_cola_se,'-o')
hold on
xlabel('h')
ylabel('errore in norma L2')
legend('Senza singularity extraction','Con singularity extraction')
title('Collocazione adattiva')
subplot(2,2,3)
loglog(H,E_galu,'-o')
hold on
loglog(H,E_galu_se,'-o')
ylabel('errore in norma L2')
legend('Senza singularity extraction','Con singularity extraction')
title('Galerkin uniforme')
subplot(2,2,4)
loglog(H,E_gala,'-o')
hold on
loglog(H,E_gala_se,'-o')
hold on
loglog(H,H,'--')
hold on
loglog(H,H.^(3/2),'--')
legend('Senza singularity extraction','Con singularity extraction','h','h^{3/2}')
title('Galerkin adattiva')
sgtitle('Errore L2 sul dominio quadrato')