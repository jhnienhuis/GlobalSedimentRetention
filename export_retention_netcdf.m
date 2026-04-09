function export_retention
load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QTide','QWave','TidalAmp','QRiver_prist','delta_name','QRiver_dist','Discharge_prist','BasinID2','QRiver_bedload','MouthLat','MouthLon')
%load('D:\Drive\github\GlobalDeltaSeaLevel\export_data\GlobalDeltaArea.mat','delta_area')
load('D:\Drive\2026 Delta SedimentRetention\code\GlobalDeltaArea.mat','delta_area');

QRiver = QRiver_prist+QRiver_bedload;
[fr,depth,QPlain] = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);
fr_dist = get_retention_montecarlo(QRiver,Discharge_prist,delta_area,7000,1600);

f = 365*24*3600./1600; %convert kg/s to m3/yr
%src = ; % (f*QRiver>2e5);
src = (f*QRiver)>1e5 & delta_area>1e4;

out.delta_name = delta_name(src);
out.BasinID2 = double(BasinID2(src));
out.MouthLat = MouthLat(src);
out.MouthLon = MouthLon(src);
out.Dplain_m = depth(src);
out.Darea_m2 = delta_area(src);
out.Qplain_m3_yr = QPlain(src);
out.QRiver_m3_yr = QRiver(src);
out.fr = fr(src);

t = struct2table(out);

save("GlobalDeltaRetention.mat",'-struct',"out")
writetable(t,"GlobalDeltaRetention.xlsx");


