%function Fig5_DeltaControls
%% trends w QWave, QTide, QRiver
load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QTide','QWave','QRiver_prist','QRiver_bedload','Discharge_prist','delta_name','BasinID2')
load('D:\Drive\2026 Delta SedimentRetention\code\GlobalDeltaArea.mat','delta_area');

QRiver = QRiver_bedload+QRiver_prist;
fr = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);
fr = min(1,fr);
fr_dist = get_retention_montecarlo(QRiver,Discharge_prist,delta_area,7000,1600);
f = 365*24*3600./1600; %convert kg/s to m3/yr
src = (f*QRiver)>1e5 & delta_area>1e4;

%% fluxes
subplot(2,2,1)
x = QWave(src);
x_edg = [floor(min(x)) logspace(0,4,9) ceil(max(x))];
[y] = discretize(x,x_edg);
f_y = accumarray(y,fr(src),[],@mean);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([x_edg(1:end-1)],f_y,f_y_std,'-ok','MarkerFaceColor','b'),
set(gca,'XScale','log')
xticks(x_edg(2:2:end))
xlabel('Q{wave} (kg/s)'), ylabel('r{topset}')

hold on
x = QRiver(src);
x_edg = [logspace(0,4,9) ceil(max(x))];
[y] = discretize(x,x_edg);
f_y = accumarray(y,fr(src),[],@mean);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([x_edg(1:end-1)],f_y,f_y_std,'-ok','MarkerFaceColor','r'),

hold on
x = QTide(src);
x_edg = [floor(min(x)) logspace(0,4,9) ceil(max(x))];
[y] = discretize(x,x_edg);
f_y = accumarray(y,fr(src),[],@mean);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([x_edg(1:end-1)],f_y,f_y_std,'-ok','MarkerFaceColor','g'),
legend(["Wave","River","Tide"])
set(gca,'XLim',[0.5 2e4],'YLim',[0 0.5])

%% dominance ratios
subplot(2,2,2)
x = QTide(src)./QRiver(src);
x_edg = [floor(min(x)) logspace(-3,2,6) ceil(max(x))];
[y] = discretize(x,x_edg);
f_y = accumarray(y,fr(src),[],@mean);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([x_edg(1:end-1)],f_y,f_y_std,'-ok','MarkerFaceColor','r'),
xlabel('T'),
set(gca,'XScale','log')
xticks(x_edg(1:2:end-1))
set(gca,'XLim',[0.5e-3 2e2],'YLim',[0 0.2])
hold on,
x = QRiver(src)./QWave(src);
x_edg = [floor(min(x)) logspace(-3,2,6) ceil(max(x))];
[y] = discretize(x,x_edg);
f_y = accumarray(y,fr(src),[],@mean);
f_y_std = accumarray(y,var(fr_dist(src,:),1,2),[],@(x) (sqrt(mean(x))./sqrt(numel(x))));
errorbar([x_edg(1:end-1)],f_y,f_y_std,'-ok','MarkerFaceColor','b'),
xlabel('R'),
set(gca,'XScale','log')
xticks(x_edg(1:2:end-1))
set(gca,'XLim',[0.5e-3 2e2],'YLim',[0 0.1])



%load data from actual deltas
kf_data = readtable('SI_SedimentRetentionLiterature.xlsx');
[~,kf_xx] = ismember(kf_data.BasinID2,BasinID2);
kf_name = string(kf_data.DeltaName);
kf_name = extract(kf_name,1)+extract(kf_name,2);


subplot(2,2,[3:4])

[QRiver_log,QWave_prist_log,QTide_prist_log] = DeltaLogMaker(QRiver,QWave,QTide);
[~,x0,y0] = ternplot(QTide_prist_log,QRiver_log,QWave_prist_log);
xn = 0:0.005:1;
yn = 0:0.005:1;
[fn,xgrid,ygrid] = gridfit(x0(src),y0(src),fr(src),xn,yn,'smoothness',8); %'interp','bilinear',

%mean absolute error
[fr_interp] = interp2(xgrid,ygrid,fn,x0,y0); mean(abs(fr_interp(src)-fr(src)));

out = (yn>(xn.*2*sqrt(3/4))' | yn>(2*sqrt(3/4).*(1-xn)'))';
fn(out) = nan;
contourf(xgrid,ygrid,fn,[0:0.025:0.15])
colormap(flipud(cbrewer('div', 'RdYlBu', 64)))
caxis([0,0.15])
set(gca,'Layer','top')
set([findall(gcf,'String','  25'); findall(gcf,'String','25')],'String','0.1')
set([findall(gcf,'String','  50'); findall(gcf,'String','50')],'String','0.5')
set([findall(gcf,'String','  75'); findall(gcf,'String','75')],'String','0.9')
hold on
scatter(x0(src),y0(src),'.k')
h = colorbar('East');
axis equal
ylabel(h,'r{topset}')
%


%kf_data.retention_from_riverflux
scatter(x0(kf_xx),y0(kf_xx),50,'o','filled','MarkerFaceColor','k')
text(x0(kf_xx),y0(kf_xx),kf_name,'FontSize',8)

set(gca, 'FontSize', 8,'FontName','Helvetica')
saveas(gcf,'Fig5_DeltaControls.svg')