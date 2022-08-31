function [u_scat] = ScatteredWave(PT,POL,x_val,psi,k)
% Calcolo dell'onda scatterata
% INPUT: PT: pti della mesh (estremi della discretizzazione, numeri complessi), 
%        POL: indici dei pti di inizio e fine dei poligoni, 
%        x_val: matrice (griglia) dei pti (22500) su cui valutare u_scat, 
%        psi: coefficienti (densità),
%        k: parametro dell'equazione di Helmholtz
% OUTPUT: u_scat: matrice delle valutazioni dell'onda scatterata in x_val

n_pol = size(POL,1);                % numero totale di poligoni
u_scat = 0;                         % inizializzazione
for j = 1:n_pol                     % ciclo sui poligoni p_j
    pt = [PT(POL(j,1):POL(j,2)); PT(POL(j,1))];     % pti in p_j
    n_pt = length(pt)-1;            % numeri dei pti in p_j
    L = pt(2:end)-pt(1:n_pt);       % distanza tra i pti in p_j
    len = abs(L);                   % lunghezze elementi in p_j
    n_quad = 7;                     % numero nodi di quadratura
    [x_gauss,w] = gaussquad(n_quad);% quadratura di Gauss
    for q = 1:n_quad                % ciclo sui nodi di quadratura
        BH = besselh(0, 1, k.*abs( reshape((pt(1:n_pt) + L.*x_gauss(q)),1,1,n_pt) - x_val ));
        u_scat = u_scat + sum( (reshape(psi(POL(j,1):POL(j,2)).*len,1,1,n_pt).*BH), 3) .* w(q);
    end
end
u_scat = (1i/4)*u_scat;
end
