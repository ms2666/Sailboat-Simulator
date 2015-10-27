% create polar plots for each speed from 1:0.5:50

velocityRange = 0:0.5:50;
allDiagrams = zeros(length(velocityRange),2,361);
for v = 1:length(velocityRange)
    diagram = polarDiagram(velocityRange(v));
    allDiagrams(v,:,:) = diagram;
end

save('allPolarDiagrams.mat','allDiagrams');


