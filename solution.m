clear all
close all
clc
% Plot di 6 vincoli sound-soft diversi, ma sempre con un'onda incidente
% piana
%% Parametri
k = 20;                         % Numero d'onda, parametro dell'eq di Helmholtz
h = 0.1;                        % Ampiezza della mesh (sul bordo)
z = 1.2;                        % Parametro per la mesh adattiva
n_points = 150;                 % dimensione dominio
D = linspace(-1,2,n_points);
[X,Y] = meshgrid(D,D);
%% 1.Quadrato di centro [0,0] e raggio 1
ver = [-0.5-0.5*1i; 0.5-0.5*1i; 0.5+0.5*1i; -0.5+0.5*1i]; % vertici del poligono (quadrato)
i_pol = [1,4];                  % indici vertici dei poligoni
theta = -pi/4;                  % direzione di u_inc
load MPSpackBenchmarkSquareScatt.mat;
[Xq,Yq] = meshgrid(gx,gy);      % griglia XxY su cui valutare l'approssimazione dell'onda
BEM(Xq, Yq, ver, i_pol, k, h, z, theta, 'uniform','collocation','singex','plot');
%% 2.Triangolo di lato 1
ver = [0+0i; 0+1i; 1+0i]; 
i_pol = [1,3];
theta = pi/3;
BEM(X, Y, ver, i_pol, k, h, z, theta, 'uniform','collocation','singex','plot');
%% 3.U
ver = [0+0i; 0+1i; 1+1i; 1+0i; 0.75+0i; 0.75+0.75i; 0.25+0.75i; 0.25+0i]; 
i_pol = [1,8];
theta = pi/3;
BEM(X, Y, ver, i_pol, k, h, z, theta, 'uniform','collocation','singex','plot');
%% 4.Fenditura
ver = [0-1*1i; 0+0.3*1i; 0.1+0.3*1i; 0.1-1*1i; 0+0.7*1i; 0+2*1i; 0.1+2*1i; 0.1+0.7*1i]; 
i_pol = [1,4; 5,8];
theta = 0;
BEM(X, Y, ver, i_pol, k, h, z, theta, 'uniform','collocation','singex','plot');
%% 5.Stella a 4 punte
ver = [0.5-0.5*1i; 0.275+0.275*1i; -0.5+0.5*1i; 0.275+0.725*1i; 0.5+1.4*1i; 0.725+0.725*1i; 1.5+0.5*1i; 0.725+0.275*1i];
i_pol = [1,8];
theta = pi/3;
h_star = 0.001;
BEM(X, Y, ver, i_pol, k, h_star, z, theta, 'uniform','collocation','singex','plot');
%% 6.Doppio triangolo
ver = [0-0.6*1i; 0+0.4*1i; 1+0.4*1i; 0+0.6*1i; 0+1.6*1i; 1+0.6*1i];
i_pol = [1,3; 4,6];
theta = pi;
h_star = 0.1;
BEM(X, Y, ver, i_pol, k, h_star, z, theta, 'uniform','collocation','singex','plot');