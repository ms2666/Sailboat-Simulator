function polarPlot = interpolatePolarPlot(velocityMagnitude,polarData)


if nargin < 2
    polarData = load('../dataCollection/allPolarDiagrams.mat');
end

velInd = velocityMagnitude*2+1;

[x,y,z] = size(polarData.allDiagrams);
F=griddedInterpolant({1:x,1:y,1:z},polarData.allDiagrams);
polarPlot= F({velInd,1:y,1:z});
polarPlot = squeeze(polarPlot);