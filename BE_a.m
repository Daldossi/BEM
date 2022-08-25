function [PT,i_POL] = BE_a(ver, h, i_pol, z)
% Discretizzazione adattiva dei lati del poligono
% INPUT:  ver: ogni riga rappresenta un vertice del poligono, senso antiorario
%         pol: mx2 (m numero di poligoni da discretizzare) la riga j-esima 
% indica la posizione nel vettore ver del vertice di inizio e quella del  
% vertice di fine del poligono j
%         n: numero di punti per lato
%         z: parametro del metodo adattivo
% OUTPUT: PT: in cui ogni riga rappresenta un punto della mesh sul bordo
%         POL: ogni riga indica la posizione in PT del vertice di inizio e
% quella del vertice di fine del rispettivo poligono 

n_pol = size(i_pol,1);          % numero di poligoni totali
PT = [];                        % inizializzazione
i_POL = zeros(n_pol+1,2);       % inizializzazione
for j = 1:n_pol                 % ciclo sui poligoni p_j
    counter_nodes = 0;          % contatore dei nodi sul p_j
    ver_j =  [ver(i_pol(j,1):i_pol(j,2),:); ver(i_pol(j,1),:)]; % vertici del p_j
    n_edges = size(ver_j,1)-1;  % numero elementi/vertici del p_j
    PT_j = [];                  % vettore dei nodi di quadratura del p_j
    for i = 1:n_edges           % ciclo sui lati l_i
        len = norm(ver_j(i,:)-ver_j(i+1,:)); % lunghezza del l_i
        [pt_i,n_i] = adaptive(ver_j(i,:),ver_j(i+1,:),fix(len/h),z);
        PT_j = [PT_j; pt_i];
        counter_nodes = counter_nodes + n_i;
    end
    PT = [PT;PT_j];
    i_POL(j+1,:) = [i_POL(j,2) + 1, i_POL(j,2) + counter_nodes];
end
i_POL = i_POL(2:end,:);
end
