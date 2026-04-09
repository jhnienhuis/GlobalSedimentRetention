function get_deltaarea

d1 = readtable("Edmondsetal2020_NatCom_suppdata.xlsx","Sheet","Edmonds 2020 data");
d2 = readtable("Edmondsetal2020_NatCom_suppdata.xlsx","Sheet","Lammerink 2025 data");

load('D:\Drive\github\GlobalDeltaChange\GlobalDeltaData.mat','BasinID2',"delta_name")

delta_area = zeros(size(BasinID2));
source = zeros(size(BasinID2));

[ia,ib] = ismember(d2.BasinID2,BasinID2);
delta_area(ib(ib>0)) = d2.area_km2(find(ib));
source(ib(ib>0)) = "Edmonds2020";

[ia,ib] = ismember(d1.NienhuisBasinID2,BasinID2);
delta_area(ib(ib>0)) = d1.GeomoprhicArea(find(ib));
source(ib(ib>0)) = "Lammerink2025";

delta_area = delta_area.*1e6; %km2 to m2

% comparison of two methods
%[ia,ib] = ismember(d1.NienhuisBasinID2,d2.BasinID2);
%scatter(d1.GeomoprhicArea(ia),d2.area_km2(ib(ib>0)))

save("GlobalDeltaArea.mat","delta_area","BasinID2","source");