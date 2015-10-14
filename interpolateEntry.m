function [u,v] = interpolateEntry(lat,lon,time,data)

% lat = 72;
% lon = 50;
% time = 7.3563e+05;

if nargin < 4
    data = load('dataCollection/.mat');
end

lats = data.g;
lons = data.f;
times = data.t(:,1);

latind = (lat-lats(1))/(lats(2)-lats(1));
lonind = (lon-lons(1))/(lons(2)-lons(1));
tind = (time-times(1))/(times(2)-times(1));
u = interp3(data.U,latind,lonind,tind);
v = interp3(data.V,latind,lonind,tind);
