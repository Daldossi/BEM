function [E] = Error(flag1,flag2,PT,POL,k,PWave,Omega,u,X,Y,R)
% Calcola l'errore dell'onda approssimata u_scat prendendo di riferimento l'onda
% incidente ui e l'onda totale u, confronto svolto all'esterno del cerchio di
% raggio R e centro l'origine
% INPUT: flag1: stringa che indica il metodo da usare ('col' o 'gal')
%        flag2: stringa che indica se usare la isngularity extraction ('se')
%           oppure no ('no')
%        PT: vettore punti della mesh (sul bordo del poligono), valori complessi
%        POL: indici su PT di inizio e fine dei poligoni 
%        k: parametro dell'equazione di Helmholtz
%        PWave: funzione a una variabile, è il dato
%        Omega: dominio, valori complessi
%        u: onda di riferimento 
%        X: ascissa della griglia di valutazione
%        Y: ordinata della griglia di valutazione
%        R: raggio del cerchio al cui esterno si calcola l'errore
% OUTPUT: E: errore in norma L^2
        
if (strcmpi(flag1,'col') && strcmp(flag2,'no'))
    u_scat = BEM_col(PT,POL,k,PWave,Omega,'no');
elseif (strcmpi(flag1,'col') && strcmp(flag2,'se'))
    u_scat = BEM_col(PT,POL,k,PWave,Omega,'se');
elseif (strcmpi(flag1,'gal') && strcmp(flag2,'no'))
    u_scat = BEM_gal(PT,POL,k,PWave,Omega,'no');
elseif (strcmpi(flag1,'gal') && strcmp(flag2,'se'))
    u_scat = BEM_gal(PT,POL,k,PWave,Omega,'se');
end
err = (u_scat - u).*(X.^2 + Y.^2 > R); 
err(isnan(err)) = 0;    % salvo i Nan come 0
E = norm(err);
end