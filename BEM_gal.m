function [u_scat,psi] = BEM_gal(PT,POL,k,g_D,x_val,flag)
% Risolve BIE con il metodo Galerkin e poi ricava il valore di u_scat
% tramite ScatteredWave.m
% INPUT: PT: pti della mesh (complessi)
%        POL: indici dei vertici di inizio e fine di ogni poligono
%        k: parametro dell'equazione di Helmholtz
%        g_D: funzione su Gamma (input: x numero complesso)
%        x_val: pti su cui valutare u_scat
%        flag: stringa che indica se svolgere o no la singularity extraction, 'se o 'no'
% OUTPUT: u_scat: onda scatterata valutata in x_val

n_pol = size(POL,1);                    % numero dei poligoni del dominio
n_edges = length(PT);                   % numero dei segmenti totali della mesh
A = zeros(n_edges);
F = zeros(n_edges, 1);

for j = 1:n_pol                                          % ciclo sui poligoni p_j
    PT_j = [PT(POL(j,1):POL(j,2)); PT(POL(j,1))];        % matrice dei pti del solo p_j
    n_PTj = length(PT_j)-1;                              % numero elementi nel p_j
    L_j = PT_j(2:n_PTj+1)-PT_j(1:n_PTj);                 % distanze tra i pti
    len_j = abs(L_j);                                    % lunghezze degli elementi in p_j
    for i = 1:n_pol                                      % altro ciclo sui poligoni p_i
        PT_i = [PT(POL(i,1):POL(i,2)); PT(POL(i,1))];    % matrice dei pti del solo p_i
        n_PTi = length(PT_i)-1;                          % numero elementi nel p_j
        L_i = PT_i(2:n_PTi+1)-PT_i(1:n_PTi);             % distanze tra i pti
        len_i = abs(L_i);                                % lunghezze degli elementi in p_j

        % ASSEMBLAGGIO della matrice A
        n_quad = 5;                      % numero nodi di quadratura
        [x,w] = gaussquad(n_quad);       % nodi e pesi di quadratura
        A_pol = 0;                       % inizializzazione
        for p = 1:n_quad
            for q = 1:n_quad
                A_pol = A_pol + besselh(0, 1, k.*abs( (PT_j(1:n_PTj) + L_j.*x(p)) - ((PT_i(1:n_PTi) + L_i.*x(q))).' )).*w(p).*w(q);
            end
        end
        A_pol = (1i/4).*(len_j.*(len_i')).*A_pol;
        % DIAGONALE
        if i == j
            if strcmp(flag, 'se')         % con singularity extraction
                A_pol(1:(n_PTi+1):(n_PTi^2)) = ((len_i.^2)./(2*pi)).*( (1i*pi)./2 - log(k/2) - eulergamma - log(len_i) + 3/2 );
            elseif strcmp(flag, 'no')     % senza singularity extraction
                n_diag = 10;
                [x_diag, w_diag] = gaussquad(n_diag);
                A_pol(1:(n_PTi+1):(n_PTi^2)) = sum( 1i.*((len_i.^2)./2).*(1-x_diag.').*besselh(0, 1, k.*(x_diag.').*(len_i)).*(w_diag.'), 2);
            end
        end
        A(POL(j,1):POL(j,2), POL(i,1):POL(i,2)) = A_pol;
    end

    % ASSEMBLAGGIO del vettore F
    F(POL(j,1):POL(j,2)) = sum( len_j.*(-g_D( PT_j(1:n_PTj)+(x.').*L_j )).*(w.'), 2);
end

% Densità
psi = A\F;
% Onda scatterata
u_scat = ScatteredWave(PT,POL,x_val,psi,k);

end