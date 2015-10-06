function [] = generateWindFiles()

files = dir('windData/*.nc');
d=datenum('01-jan-1978 00:00:00');

for file = files'
    fname = sprintf('windData/%s',file.name);
    data = struct();
    time = ncread(fname,'time');
    data.U = ncread(fname,'u');
    data.V = ncread(fname,'v');
    data.g = ncread(fname,'lat');
    data.f = ncread(fname,'lon');
    date = d+double(time)/24;
    data.T = repmat(date,size(data.U));
    saveFname = sprintf('windMats/wind_%s.mat',datestr(date,'yyyy_mm_dd'));
    save(saveFname,'-struct','data');
end

