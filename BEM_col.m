function [u_scat,psi] = BEM_col(PT,POL,k,g_D,x_val,flag)
% Risolve BIE con il metodo collocazione e poi ricava il valore di u_scat
% tramite ScatteredWave.m
% INPUT: PT: pti della mesh (complessi)
%        POL: indici dei vertici di inizio e fine di ogni poligono
%        k: parametro dell'equazione di Helmholtz
%        g_D: funzione su Gamma (input: x numero complesso)
%        x_val: pti su cui valutare u_scat
%        flag: stringa che indica se svolgere ('se') o no ('no') la 
%        singularity extraction
% OUTPUT: u_scat: onda scatterata valutata in x_val

n_POL = size(POL,1);                    % numero dei poligoni del dominio
n_edges = length(PT);                   % numero dei segmenti totali della mesh
A = zeros(n_edges);                     % inizializzazione
F = zeros(n_edges,1);

for j = 1:n_POL                                      % ciclo sui poligoni
    PT_j = [PT(POL(j,1):POL(j,2)); PT(POL(j,1))];    % matrice dei pti del solo p_j
    n_PTj = length(PT_j)-1;                          % numero elementi nel p_j
    x_m = (PT_j(2:n_PTj+1)+PT_j(1:n_PTj))./2;        % punti medi degli elementi
    for i = 1:n_POL
        PT_i = [PT(POL(i,1):POL(i,2)); PT(POL(i,1))];% matrice dei pti del solo p_i
        n_PTi = length(PT_i)-1;                      % numero elementi nel p_i
        L = PT_i(2:n_PTi+1)-PT_i(1:n_PTi);           % distanze dei pti
        len = abs(L);                                % Lunghezze degli elementi

        % ASSEMBLAGGIO della matrice A^col
        n_quad = 5;                     % numero nodi di quadratura 
        [x,w] = gaussquad(n_quad);      % nodi e pesi di quadratura 
        A_pol = 0;                      % inizializzazione della matrice A
        for q = 1:n_quad                % formula di quadratura di Gauss
            A_pol = A_pol + besselh(0, 1, k.*abs((PT_i(1:n_PTi) + L*x(q)).'-x_m)).*w(q);
        end
        A_pol = (1i/4)*(len').*A_pol;
        % DIAGONALE
        if i == j
            if strcmp(flag,'se')                     % con singularity extraction
                A_pol(1:(n_PTi+1):n_PTi^2) = (len./(2*pi)).*( (pi*1i)/2 - log(k/2) - eulergamma - log(len./2) + 1 );
            elseif strcmp(flag,'no')                 % senza singularity extraction
                n_diag = 10;                         % numero nodi di quadratura
                [x_diag,w_diag] = gaussquad(n_diag); % nodi e pesi di quadratura
                A_pol(1:(n_PTi+1):n_PTi^2) = sum( (len./2).*(1i/2).*besselh(0, 1, k.*(x_diag.').*(len./2)).*(w_diag.'),2 );
            end
        end
        A(POL(j,1):POL(j,2), POL(i,1):POL(i,2)) = A_pol;
    end

    % ASSEMBLAGGIO del vettore F^col
    F(POL(j,1):POL(j,2)) = -g_D(x_m);
end

% Densità
psi = A\F;
% Onda scatterata
u_scat = ScatteredWave(PT, POL, x_val, psi, k);

end