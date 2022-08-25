function [pt,n] = adaptive(a,b,n,z)
% Individua i punti su ogni metà del lato che inizia in a e finisce in b
% INPUT: a: vertice di inizio del lato l_i
%        b: vertice di ifne del lato l_i
%        n: numero dei punti su l_i per una mesh uniforme
%        z: parametro del metodo adattivo
% OUTPUT: pt: punti adattivi
%         n: numero di pti definiti sul lato
if  mod(n,2) == 1               % se il numero n di punti è pari,
    n = n+1;                    % allora ne considero n+1
end
pt = zeros(2*n,1);              % inizializzo l'output
x_m = 0.5 * (a+b);              % pt medio del lato 
alpha = (x_m-a);                % definisco i parametri
beta = (x_m-b);
for i = 1:n+1 
    x = (i/(n+1))^z;            % prendo il pt nell'intervallo [0,1)
    % fisso il pt della discretizzazione nella prima metà del lato
    pt(i,:) = (real(alpha)*x + real(a)) + (imag(alpha)*x + imag(a))*1i;
    % fisso il pt della discretizzazione nella seconda metà del lato
    pt((2*(n+1))-i,:) = (real(beta)*x + real(b)) + (imag(beta)*x + imag(b))*1i;
end
pt = [a; pt(1:end-1)];
end