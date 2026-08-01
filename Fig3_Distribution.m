clr
load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QWave','QTide','QRiver_prist','QRiver_bedload','delta_name','Discharge_prist','BasinID2');
load('D:\Drive\2026 Delta SedimentRetention\code\GlobalDeltaArea.mat','delta_area');

%a = readtable("D:\Drive\github\GlobalDeltaSeaLevel\Edmondsetal2020_NatCom_suppdata.xlsx");
%a.NienhuisBasinID2(isnan(a.GeomoprhicArea)) = 0;
%b = readtable("D:\Drive\2025 Delta SedimentRetention\code\lammerink_thesis\DeltaProperties2.xlsx");

%[~,area_edmonds] = ismember(a.NienhuisBasinID2,BasinID2);
%[~,area_lammerink] = ismember(b.BasinID2,BasinID2);


%compare both sources
%[~,idx,idx2] = intersect(a.NienhuisBasinID2,b.BasinID2);
%scatter(a.GeomoprhicArea(idx),b.area_km2(idx2))
%set(gca,'xscale','log','yscale','log')

%add to global delta dataset structure
%delta_area = zeros(size(BasinID2));
%delta_area(area_lammerink(area_lammerink>0)) = b.area_km2(area_lammerink>0).*1e6;
%delta_area(area_edmonds(area_edmonds>0)) = a.GeomoprhicArea(area_edmonds>0).*1e6;
%save GlobalDeltaArea delta_area BasinID2

QRitver = (QRiver_prist+QRiver_bedload);
f = 365*24*3600./1600; %convert kg/s to m3/yr
src = (f*QRiver)>1e5 & delta_area>1e4;
sum(src)


%src = delta_area>1e4;
delta_area = delta_area./1e6;
%delta_area = max(delta_area,100);

%{
tiledlayout('flow')
nexttile
ecdf(delta_area(src),'Function','survivor');
%lognfit fit
p = fitdist(delta_area(src),'Lognormal');
line(logspace(-2,5,100),1-cdf(p,logspace(-2,5,100)),'color','r');
%p = lognfit(delta_area(src)+eps);
%line(logspace(4,11,100),1-logncdf(logspace(4,11,100),p(1),p(2)),'color','r');
set(gca,'XScale','log','YScale','log')
ylabel('fraction larger than')
xlabel('delta area (m^2)')
legend('delta area','lognormal fit')
set(gca,'XLim',[1e-2 1e5])


nexttile
ecdf(f.*QRiver(src),'Function','survivor');
p = fitdist(f.*QRiver(src),'gev');
line(logspace(5,9,100),1-cdf(p,logspace(5,9,100)),'color','r');
set(gca,'XScale','log','YScale','log')
ylabel('fraction larger than')
xlabel('fluvial sediment supply (m3yr-1)')
legend('ranked fluvial sediment supply','gev fit')
set(gca,'XLim',[1e5 1e9])


%}

%easier to show simple distribution
tiledlayout('flow')
nexttile
histogram(log10(delta_area(src)),-2:0.25:5)
set(gca,'XLim',[-2 5])
nexttile
histogram(log10(f.*QRiver(src)),5:0.20:10.6)
%hold on
%histogram(log10(f.*QRiver_bedload(src)),0:0.25:10)
%hold on
%histogram(log10(f.*QRiver_prist(src)),0:0.25:10)
set(gca,'XLim',[5 11])

[~,mor] = max([QWave,QRiver,QTide],[],2);
nexttile
n=14;
edges = [0 logspace(-2,5,n+1)];
edges(end-1) = [];
mor = mor(src);
[xbin] = discretize(delta_area(src),edges);
dom(1:n,1) = accumarray(xbin,mor==1,[n 1],@sum);
dom(1:n,2) = accumarray(xbin,mor==2,[n 1],@sum);
dom(1:n,3) = accumarray(xbin,mor==3,[n 1],@sum);

plot(edges(1:end-1)+diff(edges)./2,dom./sum(dom,2),'o-')
set(gca,'XScale','log')
xlabel('delta area (m^2)')
ylabel('fraction morphology')
legend('wave','river','tide')
set(gca,'XLim',[1e-2 1e5])

set(gcf, 'Units', 'Centimeters', 'OuterPosition', [0, 0, 18.3, 10]);
set(gca, 'FontSize', 8,'FontName','Helvetica')
saveas(gcf,'Fig2_Distributions.svg')