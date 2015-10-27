function [] = combineDataSets(windData,airData)
% combine current and wind data


lats = windData.g;
lons = windData.f;
times = windData.t(:,1);
interU = zeros(size(windData.U));
interV = zeros(size(windData.V));
for latInd=1:length(windData.g);
    for lonInd = 1:length(windData.f)
        for tInd = 1:length(windData.t)
            [u,v] = interpolateEntry(lats(latInd),lons(lonInd),times(tInd),airData);
            interU(lonInd,latInd,tInd) = u;
            interV(lonInd,latInd,tInd) = v;
        end
    end
end

data = struct();
data.U = windData.U - interU;
data.V = windData.V - interV;
data.g = lats;
data.f = lons;
data.t = times;
fname = 'combined_2014.mat';
save(fname,'-v7.3','-struct','data');