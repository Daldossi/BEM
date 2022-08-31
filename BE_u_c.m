function [PT,i_POL] = BE_u_c(ver, h, i_pol)
% Discretizzazione uniforme del bordo del dominio
% INPUT:  ver: ogni riga rappresenta un vertice del poligono, senso antiorario
%         h: ampiezza massima di ogni elemento della discretizzazione
%         i_pol: mx2 (m numero di poligoni da discretizzare), la riga j-esima
% indica la posizione nel vettore ver del vertice di inizio e quella del
% vertice di fine del poligono j
% OUTPUT: PT: in cui ogni riga rappresenta un punto della mesh sul bordo
%         i_POL: ogni riga indica la posizione in PT del vertice di inizio e
% quella del vertice di fine del rispettivo poligono

n_pol = size(i_pol,1);              % numero di figure totali
PT = [];                            % inizializzazioni
i_POL = zeros(n_pol+1,2);
X = [];
for j = 1:n_pol                     % ciclo sui cerchi c_j
    ver_j =  [ver(i_pol(j,1):i_pol(j,2),:)];    % info del solo c_j
    c = 2*pi*ver_j(2);              % lunghezza della circonferenza c_j
    n_i = ceil(c/h);                % numero di intervalli di ampiezza H su c_j
    PT_j = zeros(n_i);              % inizializzazione vettore dei nodi di c_j
    x = zeros(n_i);                 % inizializzazione dei punti in [0,1)
    H = c/n_i;
    for t = 1:n_i
        x(t) = (t-1)*H/c;           % prendo il pt nell'intervallo [0,1)
        theta = 2*pi*x(t);          % definisco l'angolo per mappare in c_j
        PT_j(t,:) = (ver_j(2)*cos(theta)+real(ver_j(1))) + (ver_j(2)*sin(theta)+imag(ver_j(1)))*1i;
    end
    PT = [PT;PT_j];
    i_POL(j+1,:) = [i_POL(j,2) + 1, i_POL(j,2) + n_i];
end
i_POL = i_POL(2:end,:);             % tolgo la prima riga che ha solo zeri
end
