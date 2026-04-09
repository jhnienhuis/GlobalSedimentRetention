function [fr_dist] = get_retention_montecarlo(QRiver,Discharge_prist,area,t_delta,rho_bulk)

len = size(QRiver);

for ii=1:1000,
    
    t_delta_r = lognrnd(log(t_delta),0.1,len); %std/mean of depth
    area_r = lognrnd(log(area),0.76); %std of x/y
    Discharge_prist_r = lognrnd(log(Discharge_prist),0.184); %std/mean of depth
    
    QRiver_r = lognrnd(log(QRiver),0.38);  %+/- 38% from cohen et al 2013
    
    rho_bulk_r = lognrnd(log(rho_bulk),0.1,len); %std/mean of depth
    
    [fr_dist(:,ii)] = get_retention(QRiver_r,Discharge_prist_r,area_r,t_delta_r,rho_bulk_r);
    
end

end