%function FigS1_validation
load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','QRiver_prist','QRiver_bedload','delta_name','Discharge_prist','BasinID2','MouthLat','MouthLon');
load('D:\Drive\2025 Delta SedimentRetention\code\GlobalDeltaArea.mat','delta_area');

%calculate retention
QRiver = QRiver_prist+QRiver_bedload;
fr = get_retention(QRiver,Discharge_prist,delta_area,7000,1600);
f = 365*24*3600./1600; %convert kg/s to m3/yr
src = (f*QRiver)>1e5 & delta_area>1e4;




tiledlayout('flow')
nexttile
%h = worldmap('World');
%delete(findobj(allchild(h),'Type','text'));
axesm('Robinson','MapLonLimit', [0 360])
setm(gca,'Origin',[0 0])
land = shaperead('landareas.shp', 'UseGeoCoords', true);
rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', [1 0.92 0.8]);
axis tight
hold on
scatterm(MouthLat(src),MouthLon(src),'r','filled')


nexttile
%h = worldmap('World');
%delete(findobj(allchild(h),'Type','text'));
axesm('Robinson','MapLonLimit', [75 125],'MapLatLimit',[0 25])
geoshow(land, 'FaceColor', [1 0.92 0.8]);
axis tight
hold on
plotm([mouth_latlon(src,1) sho1_latlon(src,1) apex_latlon(src,1) sho2_latlon(src,1)]',[mouth_latlon(src,2) sho1_latlon(src,2) apex_latlon(src,2) sho2_latlon(src,2)]','r')

set(gcf, 'Units', 'Centimeters', 'OuterPosition', [0, 0, 18.3, 10],'Renderer','painters');
set(gca, 'FontSize', 8,'FontName','Helvetica')
saveas(gcf,'Fig2_MethodRetention.svg')



%%
tiledlayout('flow')
nexttile
%h = worldmap('World');
%delete(findobj(allchild(h),'Type','text'));
axesm('Robinson','MapLonLimit', [0 360])
setm(gca,'Origin',[0 0])
land = shaperead('landareas.shp', 'UseGeoCoords', true);
rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', [1 0.92 0.8]);
axis tight
hold on
scatterm(mouth_latlon(src,1),mouth_latlon(src,2),2*max(1,sqrt(delta_area(src)./1e6)),'r','filled','MarkerEdgeColor','k')