function [] = generateOceanCurrentFiles()

% times is the day since 1/1/2014
d=datenum('01-jan-2014 00:00:00');
times = ncread('oceanData/ocean2014.nc', 'time');

lat = ncread('oceanData/ocean2014.nc','lat');
lon = ncread('oceanData/ocean2014.nc','lon');
u = ncread('oceanData/ocean2014.nc','u');
v = ncread('oceanData/ocean2014.nc','v');



for tind=1:length(times)
    date = d+double(times(tind));
    us = u(:,:,tind);
    vs = v(:,:,tind);
    data = struct();
    data.U = us;
    data.V = vs;
    data.g = lat;
    data.f = lon;
    data.T = repmat(date,size(us));
    fname = sprintf('oceanMats/ocean_%s.mat',datestr(date,'yyyy_mm_dd'));
    save(fname,'-struct','data');
end


