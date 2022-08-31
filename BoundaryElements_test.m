close all
clear all
clc
% Parametri
h = 0.1;
z = 2; % se z=1 => BE_qu == BE_adaptive

%% Triangolo
ver_tr = [0+0i; 0+1i; 1+0i]; 
pol_tr = [1,3];
[PT_u, ~] = BE_u(ver_tr, h, pol_tr);
[PT_a, ~] = BE_a(ver_tr, h, pol_tr, z);
subplot(1,3,1)
plot([real(ver_tr); real(ver_tr(1))], [imag(ver_tr); imag(ver_tr(1))])
axis equal
xlim([-0.5 1.5])
ylim([-0.5 1.5])
title('Dominio')
subplot(1,3,2)
scatter(real(PT_u), imag(PT_u), '.')
axis equal
xlim([-0.5 1.5])
ylim([-0.5 1.5])
title('Mesh uniforme')
subplot(1,3,3)
scatter(real(PT_a),imag(PT_a), '.')
axis equal
xlim([-0.5 1.5])
ylim([-0.5 1.5])
title('Mesh adattiva')
figure()

%% Quadrato
ver_q = [0.5+0.5*1i; 0.5+1.5*1i; 1.5+1.5*1i; 1.5+0.5*1i]; 
pol_q = [1,4];
[PT_u, ~] = BE_u(ver_q, h, pol_q);
[PT_a, ~] = BE_a(ver_q, h, pol_q, z);
subplot(1,3,1)
plot([real(ver_q); real(ver_q(1))], [imag(ver_q); imag(ver_q(1))])
axis equal
xlim([0 2])
ylim([0 2])
title('Dominio')
subplot(1,3,2)
scatter(real(PT_u),imag(PT_u), '.')
axis equal
xlim([0 2])
ylim([0 2])
title('Mesh uniforme')
subplot(1,3,3)
scatter(real(PT_a),imag(PT_a), '.')
title('Mesh adattiva')
axis equal
xlim([0 2])
ylim([0 2])
figure()

%% Gabbia a U rovesciata
ver_g = [0+0i; 0+1i; 1+1i; 1+0i; 0.75+0i; 0.75+0.75i; 0.25+0.75i; 0.25+0i]; 
pol_g = [1,8];
[PT_u, ~] = BE_u(ver_g, h, pol_g);
[PT_a, ~] = BE_a(ver_g, h, pol_g, z);
subplot(1,3,1)
plot([real(ver_g); real(ver_g(1))], [imag(ver_g); imag(ver_g(1))])
axis equal
xlim([-0.5 1.5])
ylim([-0.5 1.5])
title('Dominio')
subplot(1,3,2)
scatter(real(PT_u),imag(PT_u), '.')
axis equal
xlim([-0.5 1.5])
ylim([-0.5 1.5])
title('Mesh uniforme')
subplot(1,3,3)
scatter(real(PT_a),imag(PT_a), '.')
axis equal
xlim([-0.5 1.5])
ylim([-0.5 1.5])
title('Mesh adattiva')
figure()

%% Fenditura
ver_f = [0.3+0i; 0.3+0.4i; 0.4+0.4i; 0.4+0i; 0.3+0.6i; 0.3+1i; 0.4+1i; 0.4+0.6i]; 
pol_f = [1,4; 5,8];
[PT_u, ~] = BE_u(ver_f, h, pol_f);
[PT_a, ~] = BE_a(ver_f, h, pol_f, z);
subplot(1,3,1)
plot([real(ver_f(pol_f(1,1):pol_f(1,2))); real(ver_f(pol_f(1,1)))], [imag(ver_f(pol_f(1,1):pol_f(1,2))); imag(ver_f(pol_f(1,1)))], 'k')
hold on
plot([real(ver_f(pol_f(2,1):pol_f(2,2))); real(ver_f(pol_f(2,1)))], [imag(ver_f(pol_f(2,1):pol_f(2,2))); imag(ver_f(pol_f(2,1)))], 'k')
hold off
axis equal
xlim([0 1])
ylim([0 1])
title('Dominio')
subplot(1,3,2)
scatter(real(PT_u), imag(PT_u), 'k.')
axis equal
xlim([0 1])
ylim([0 1])
title('Mesh uniforme')
subplot(1,3,3)
scatter(real(PT_a),imag(PT_a), 'k.')
axis equal
xlim([0 1])
ylim([0 1])
title('Mesh adattiva')
figure()

%% Cerchio
ver_c = [0.5+0.5i; 0.25]; % [coord centro; raggio]
pol_c = [1,2];
[PT_uc, ~] = BE_u_c(ver_c, h, pol_c);
subplot(1,2,1)
pos = [[real(ver_c(1)) imag(ver_c(1))]-ver_c(2) 2*ver_c(2) 2*ver_c(2)]; rectangle('Position',pos,'Curvature',[1 1])
axis equal
xlim([0 1])
ylim([0 1])
title('Dominio')
subplot(1,2,2)
scatter(real(PT_uc),imag(PT_uc), 'k.')
axis equal
xlim([0 1])
ylim([0 1])
title('Mesh uniforme')
