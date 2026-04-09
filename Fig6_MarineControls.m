%function Fig4_MarineControls
load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QRiver_prist','QRiver_bedload','delta_name','Discharge_prist','BasinID2','Hs','TidalAmp')
load('D:\Drive\2026 Delta SedimentRetention\code\GlobalDeltaArea.mat','delta_area');
QRiver = QRiver_bedload+QRiver_prist;

fr = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);
fr_dist = get_retention_montecarlo(QRiver,Discharge_prist,delta_area,7000,1600);
f = 365*24*3600./1600; %convert kg/s to m3/yr
fr = min(1,fr);
src = (f*QRiver)>1e5 & delta_area>1e4;

% x = alpha./beta;
% x_edg = [0:0.2:0.9 max(x)];
% [y] = discretize(x(src),x_edg);
% f_y = accumarray(y,fr(src),[],@mean);
% f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
% errorbar([x_edg(1:end-1)],f_y,f_y_std,'-ok','MarkerFaceColor','b'),
% xlabel('sig. wave height (m)'), ylabel('topset sediment retention')
% xlim([0 2.75]), xticklabels('auto'),yticklabels('auto')
% ylim([0 0.5])%




tiledlayout('flow')
nexttile

hs_edg = [0:0.25:2.5 4];
[y] = discretize(Hs(src),hs_edg);
hs_edg(end) = 2.5;
f_y = accumarray(y,fr(src),[],@mean);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([hs_edg(1:end-1)+diff(hs_edg)/2],f_y,f_y_std,'-ok','MarkerFaceColor','b'),
xlabel('sig. wave height (m)'), ylabel('topset sediment retention')
xlim([0 3]), xticklabels('auto'),yticklabels('auto')
ylim([0 0.1])%
%set(gca, 'FontSize', 8,'FontName','Helvetica')

nexttile


tidalamp_edg = [0 0.5:0.25:2 20];
[y] = discretize(TidalAmp(src),tidalamp_edg);
tidalamp_edg(end) = 2.5;
f_y = accumarray(y,fr(src),[],@mean);
s = accumarray(y,fr(src),[],@numel);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([tidalamp_edg(1:end-1)+diff(tidalamp_edg)/2].*2,f_y,f_y_std,'-ok','MarkerFaceColor','b'),
xlabel('tidal range (m)')


xlim([0 5])
ylim([0 0.1])

%{
nexttile
%gunzip('rsl.7.xyz.gz');
%fid = fopen(['rsl.7.xyz']); 
%SL = textscan(fid,'%f %f %f');
%save SL7k.mat SL
%fclose(fid);
%idx = dsearchn([SL{1} SL{2}],[MouthLon MouthLat]);
%SL_6k = SL{3}(idx);
%save SL7k.mat SL_7k
load SL7k
sl_edg = [min(SL_7k(src)) -20:5:5 max(SL_7k(src))];
[y] = discretize(SL_7k(src),sl_edg);
f_y = accumarray(y,fr(src),[],@mean);

f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));

errorbar((-22.5:5:7.5),f_y,f_y_std,'-ok','MarkerFaceColor','b'),
xlabel('Sea-level at 7ka BP (m)')
xlim([-25 10])
ylim([0 0.2])
%}

set(gcf, 'Units', 'Centimeters', 'OuterPosition', [0, 0, 18.3, 10]);
%set(gca, 'FontSize', 8,'FontName','Helvetica')
saveas(gcf,'Fig4_MarineControls.svg')
