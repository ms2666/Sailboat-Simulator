function [u,v] = interpolateEntry(lat,lon,time,data)

% lat = 72;
% lon = 50;
% time = 7.3563e+05;

if nargin < 4
    data = load('dataCollection/currents_2014.mat');
end

lats = data.g;
lons = data.f;
times = data.t(:,1);
if lon < lons(1)
    lon = 360+lon;
end
latind = double((lat-lats(1))/(lats(2)-lats(1)));
lonind = double((lon-lons(1))/(lons(2)-lons(1)));
tind = double((time-times(1))/(times(2)-times(1)));
u = interp3(data.U,latind,lonind,tind);
v = interp3(data.V,latind,lonind,tind);

end