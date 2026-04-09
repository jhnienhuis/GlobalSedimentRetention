function [fr,depth,Q_plain] = get_retention(QRiver,Discharge_prist,area,t_delta,rho_bulk)
%
depth = 0.08*Discharge_prist.^0.65;
depth = min(depth,69);

Q_river = QRiver.*365.25*24*3600./rho_bulk;
Q_plain = area.*depth./t_delta;
fr = Q_plain./Q_river;