%% load data

load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QRiver_prist','QRiver_bedload','delta_name','Discharge_prist','BasinID2');
load('D:\Drive\2026 Delta SedimentRetention\GlobalSedimentRetention\GlobalDeltaArea.mat','delta_area');

%load data from actual deltas
kf_data = readtable('SI_SedimentRetentionLiterature.xlsx');
kf_data(kf_data.DeltaName=="Kura",:) = [];
[~,kf_xx] = ismember(kf_data.BasinID2,BasinID2);

kf_name = string(kf_data.DeltaName);
kf_name = extract(kf_name,1)+extract(kf_name,2);

%calculate retention
QRiver = QRiver_prist+QRiver_bedload;

[fr,depth,Vdelta] = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);


%% validation figure
tiledlayout('flow')

    
f_lin = @(x,y) (mean(x-y)./mean(x));
f_cor = @(x,y) (corr(log10(x),log10(y)).^2);
f_rmse = @(x,y) (sqrt(mean((x-y).^2)));
f_cv = @(x,y) (std(x-y)./mean(x));

for ii=1:6,
    a(ii) = nexttile;
set(a(ii),'XScale','log','YScale','log','DataAspectRatio',[ 1 1 1],'PlotBoxAspectRatio',[1 1 1],'box','on')
grid on, hold on
plot(a(ii),[1e-10,1e10],[1e-10,1e10],'--k')
end

%observed on y-axis
%modelled on x-axis

%sediment flux
ii=1;
y = kf_data.fluvialSedimentLoad_kg_s_.*3600*365*24/1600;
x = QRiver(kf_xx).*3600*365*24/1600; %into m3/yr
numel(y)
ta(ii,1) = f_lin(x,y);
ta(ii,2) = f_cor(x,y);
scatter(a(ii),x,y)
text(a(ii),x,y,kf_name)
title(a(ii),'QRiver (m3/yr)')

%delta area
ii=2;
y = kf_data.DeltaPlainArea_km2_;
x = delta_area(kf_xx)./1e6;
numel(y)
ta(ii,1) = f_lin(x,y);
ta(ii,2) = f_cor(x,y);
scatter(a(ii),x,y)
text(a(ii),x,y,kf_name)
title(a(ii),'Delta plain area (km2)')

%topset depth
ii=3;
kf_nan = isnan(kf_data.deltaPlainDepth_m_);
y = kf_data.deltaPlainDepth_m_(~kf_nan);
x = depth(kf_xx(~kf_nan));

numel(y)
ta(ii,1) = f_lin(x,y);
ta(ii,2) = f_cor(x,y);
f_rmse(x,y)
scatter(a(ii),x,y)
text(a(ii),x,y,kf_name(~kf_nan))
title(a(ii),'Delta topset thickness (m)')

%delta plain flux
ii=4;
kf_nan = isnan(kf_data.deltaPlainDepositionalFlux_m3_yr_);
y = kf_data.deltaPlainDepositionalFlux_m3_yr_(~kf_nan);
x = Vdelta(kf_xx(~kf_nan));
numel(y)
ta(ii,1) = f_lin(x,y);
ta(ii,2) = f_cor(x,y);
scatter(a(ii),x,y)
text(a(ii),x,y,kf_name(~kf_nan))
title(a(ii),'Qplain Volume (m3/yr)')

%retention comparison
ii=5;
kf_nan = isnan(kf_data.retention_literature);
y = kf_data.retention_literature(~kf_nan);
x = fr(kf_xx(~kf_nan));
numel(y)
ta(ii,1) = f_lin(x,y);
ta(ii,2) = f_cor(x,y);
f_cv(x,y)
scatter(a(ii),x,y)
text(a(ii),x,y,kf_name(~kf_nan))
title(a(ii),'Delta plain sediment retention')

%retention using observed river flux
ii=6;
y = kf_data.retention_literature;

Q_plain = kf_data.DeltaPlainArea_km2_.*1e6.*depth(kf_xx)./7000;

x = Q_plain./(kf_data.fluvialSedimentLoad_kg_s_.*3600*365*24/1600);

numel(y)
ta(ii,1) = f_lin(x,y);
ta(ii,2) = f_cor(x,y);
f_cv(x,y)
scatter(a(ii),x,y)
text(a(ii),x,y,kf_name(~kf_nan))
title(a(ii),'Retention from river flux')

ta
mean(ta)

xlabel(a(4),'this study')
ylabel(a(1),'manual retrieval')



set(a(1),'XLim',[1e5 1e9],'YLim',[1e5 1e9])
set(a(2),'XLim',[1e1 1e6],'YLim',[1e1 1e6])
set(a(3),'XLim',[1e-1 1e2],'YLim',[1e-1 1e2])
set(a(4),'XLim',[1e3 1e9],'YLim',[1e3 1e9])
set(a(5),'XLim',[1e-3 1e1],'YLim',[1e-3 1e1])
set(a(6),'XLim',[1e-3 1e1],'YLim',[1e-3 1e1])
%xticks(a(1),[1e-4 1e-3 1e-2]),yticks(a(1),[1e-4 1e-3 1e-2])




%set(gcf, 'Units', 'Centimeters', 'OuterPosition', [0, 0, 18.3, 10]);
set(gca, 'FontSize', 8,'FontName','Helvetica')
saveas(gcf,'Fig4_validation.svg')


%% assess bias

t = readtable("StanleyWarne_DeltaInitiation.xlsx");
[~,idx] = ismember(t.BasinID2,BasinID2);
sed = QRiver(idx(idx~=0));
scatter(log10(sed),t.CalibratedAge_calYrBP_1950_(idx~=0));

kf_nan = isnan(kf_data.deltaPlainDepth_m_);
scatter(Discharge_prist(kf_xx(~kf_nan)),kf_data.deltaPlainDepth_m_(~kf_nan))
hold on
fplot(@(x) (0.08*x^0.65),[0 5e4])
fplot(@(x) (0.15*x^0.5),[0 5e4])
fplot(@(x) (0.0025*x^1),[0 5e4])

scatter(delta_area(kf_xx(~kf_nan)),kf_data.deltaPlainDepth_m_(~kf_nan))
hold on
fplot(@(x) (0.00002*x^0.6),[0 8e10])

%test for age bias smaller deltas.
f = 365*24*3600./1600; %convert kg/s to m3/yr
src = (f*QRiver)>1e5 & delta_area>1e4;

[fr,depth,Vdelta] = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);
fit((log10(QRiver(src))),(log10(fr(src))),'poly1')

delta_age = 7000*ones(size(delta_area));
delta_age(QRiver<prctile(QRiver,99)) = 3500;
[fr,depth,Vdelta] = get_retention(QRiver,Discharge_prist,delta_area,delta_age,1600);
fit((log10(QRiver(src))),(log10(fr(src))),'poly1')



%% distributions and fitting:
%{
% discharge/depth function
kf_nan = isnan(kf_data.deltaPlainDepth_m_);
x = Discharge_prist(kf_xx(~kf_nan));
y = kf_data.deltaPlainDepth_m_(~kf_nan);
myfittype = fittype("a*(x^b)",...
    dependent="y",independent="x",...
    coefficients=["a" "b"]);
[myfit,gof] = fit(x,y,myfittype)
plot(myfit,x,y)

%sediment flux power law
y = sort(QRiver(src),1,"descend");
x = (1:length(y))';
myfittype = fittype("a*(x^b)",...
    dependent="y",independent="x",...
    coefficients=["a" "b"]);
[myfit,gof] = fit(x,y,myfittype)
plot(myfit,x,y)

%delta area lognormal
ecdf(delta_area(src),'Function','survivor');
%lognfit fit
p = fitdist(delta_area(src),'Lognormal');
line(logspace(3,11,100),1-cdf(p,logspace(3,11,100)),'color','r');
p = lognfit(delta_area(src)+eps);
%line(logspace(4,11,100),1-logncdf(logspace(4,11,100),p(1),p(2)),'color','r');
set(gca,'XScale','log','YScale','log')
ylabel('fraction larger than')
xlabel('delta area (m^2)')
legend('delta area','lognormal fit')
set(gca,'XLim',[1e3 1e11])

%}