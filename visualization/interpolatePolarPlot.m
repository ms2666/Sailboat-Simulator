function polarPlot = interpolatePolarPlot(velocityMagnitude,polarData)


if nargin < 2
    data = load('../dataCollection/allPolarDiagrams.mat');
end

velInd = velocityMagnitude*2+1;

