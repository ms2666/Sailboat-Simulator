function [ u,v ] = interpolateWind(lat,lon,time)
% time should be a datenum
% interpolate wind
% find corresponding file using linear search
numDaysInFile = 20;
global windDataStorage
startDate = datenum('jan-01-2014');
endDate = datenum('jan-01-2015');
numDays = endDate-startDate;
dateRange = 20;
for day = 1:dateRange:numDays % dateRange should be 20 for the data gathered
    if (time-startDate) < day + 21
        % check if file is loaded in windDataStorage, if its not then load
        % it
        fileIndex = ceil(day/20);
        % the file has not been loaded yet
        if length(windDataStorage(fileIndex).U) == 0
            windFname = sprintf('../dataCollection/windFiles/wind_%d_%d_2014.mat',day,min(day+numDaysInFile+1,numDays));
            windDataStorage(fileIndex) = load(windFname);
        end
        windData = windDataStorage(fileIndex);
        break
    end
end


U = griddedInterpolant({double(windData.f),double(windData.g),windData.t},windData.U);
V = griddedInterpolant({double(windData.f),double(windData.g),windData.t},windData.V);

% lon needs to be in the range 21 to 381
lon = mod(lon,360);
if lon < windData.f(1)
    lon = 360 + lon;
end
% lat needs to be in the range -59.5 to 59.5
if abs(lat) > 59.5
     throw(MException('VerifyOutput:OutOfBounds',sprintf('latitude %d is outside bounds -59.5 to 59.5 (no data outside this)',lat)));
end

u = U({double(lon),double(lat),time});
v = V({double(lon),double(lat),time});





