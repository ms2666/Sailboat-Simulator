% load wind data and split into files of 21 days every 20 days
% filenames are of the form: wind_(startDay)_(endDay)_2014.mat
% 1 indexed days
% wind data set
wind = load('relativeWind_2014.mat');
numDaysInFile = 20;
%%
for start=1:numDaysInFile:length(wind.t)
    sliceU = wind.U(:,:,start:min(start+numDaysInFile+1,end));
    sliceV = wind.V(:,:,start:min(start+numDaysInFile+1,end));
    data = struct();
    sliceU(isnan(sliceU)) = 0;
    sliceV(isnan(sliceV)) = 0;
    data.U = sliceU;
    data.V = sliceV;
    data.f = wind.f;
    data.g = wind.g;
    data.t = wind.t(start:min(start+numDaysInFile+1,end));
    saveFname = sprintf('combinedFiles/combined_%d_%d_2014.mat',start,min(start+numDaysInFile+1,length(wind.t)));
    save(saveFname,'-struct','data');
end