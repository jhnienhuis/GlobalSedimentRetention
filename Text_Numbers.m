clr
load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QTide','QWave','TidalAmp','QRiver_prist','delta_name','QRiver_dist','Discharge_prist','BasinID2','QRiver_bedload')
%load('D:\Drive\github\GlobalDeltaSeaLevel\export_data\GlobalDeltaArea.mat','delta_area')
load('D:\Drive\2026 Delta SedimentRetention\code\GlobalDeltaArea.mat','delta_area');

QRiver = QRiver_prist+QRiver_bedload;
fr = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);
fr_dist = get_retention_montecarlo(QRiver,Discharge_prist,delta_area,7000,1600);

f = 365*24*3600./1600; %convert kg/s to m3/yr
%src = ; % (f*QRiver>2e5);
src = (f*QRiver)>1e5 & delta_area>1e4;

%% abstract and key points

sum(src) %total nr of deltas we consider

%total delta area in analysis compared to global
sum(QRiver(src))./sum(QRiver)


%mean global trapped fraction
sum(fr(src).*QRiver(src))./sum(QRiver(src))
sqrt(sum(var(fr_dist(src,:).*QRiver(src),1,2)))./sum(QRiver(src))

%sediment flux compared to global, adjust to latest science
Qglobal = 11e12/(365*24*3600); %kg/sec
sum(fr(src).*QRiver(src)).*Qglobal./sum(QRiver).*365*3600*24/1e12 %GT/yr

%mean retention
mean(fr(src)), sqrt(mean(var(fr_dist(src,:),1,2)))./sqrt(sum(src))


%most efficient morphology
[~,mor] = max([QRiver,QTide,QWave],[],2);
accumarray(mor(src),fr(src),[],@mean)
accumarray(mor(src),var(fr_dist(src,:),1,2),[],@(x) sqrt((mean(x)))./sqrt(numel(x)))

%sediment-weighted fraction per morphology
accumarray(mor(src),(fr(src).*QRiver(src)),[],@sum)./accumarray(mor(src),(QRiver(src)),[],@sum)




%% methods
sum(src) %total nr of deltas we consider

%percentage of global fluv flux
sum(QRiver(src))./sum(QRiver)

%also in MT/yr
sum(QRiver(src)).*3600*24*365./1e9
sum(QRiver).*3600*24*365./1e9

%distributions
p = fitdist(delta_area(src),'Lognormal');
p = fitdist(QRiver(src),'gev');

sum(delta_area(src))./1e6

%for correlation coefficients, see FigS1_validation.m




%% results
%mean retention
mean(fr(src)), sqrt(mean(var(fr_dist(src,:),1,2)))./sqrt(sum(src))

%mean global trapped volume
sum(fr(src).*QRiver(src))./sum(QRiver(src))
sqrt(sum(var(fr_dist(src,:).*QRiver(src),1,2)))./sum(QRiver(src))

%total volume of deposits in deltas
(sum(fr(src).*QRiver(src))).*7000.*f./1e9

%averaged acretion rate across modern delta area
sum(fr(src).*QRiver(src)).*f./sum(delta_area(src))
sqrt(sum(var(fr_dist(src,:).*f.*QRiver(src),1,2)))./sum(delta_area(src))

%accretion rate for individual deltas
nanmean(fr(src).*QRiver(src).*f./delta_area(src))
sqrt(mean(var(fr_dist(src,:).*QRiver(src).*f./delta_area(src))))./sqrt(sum(src))

%retention per region
load regions.mat regions
act_margin = regions==15 | regions==2 | regions==4 | regions==13;

sum(fr(act_margin &src).*QRiver(act_margin &src))./sum(QRiver(act_margin &src))
sum(fr(~act_margin & src).*QRiver(~act_margin & src))./sum(QRiver(~act_margin & src))

%most efficient morphology
[~,mor] = max([QRiver,QTide,QWave],[],2);
accumarray(mor(src),fr(src),[],@mean)
accumarray(mor(src),var(fr_dist(src,:),1,2),[],@(x) sqrt((mean(x)))./sqrt(numel(x)))

%sediment weighted morphology
accumarray(mor(src),(fr(src).*QRiver(src)),[],@sum)./accumarray(mor(src),(QRiver(src)),[],@sum)


%spearmans correlation
corr(QRiver(src),fr(src),'Type','Kendall')
corr(QTide(src),fr(src),'Type','Kendall')
corr(QWave(src),fr(src),'Type','Kendall')

