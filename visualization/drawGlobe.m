function [f] = drawGlobe()

%% Set up figure
f = figure('Renderer','opengl', 'visible', 'off');
axesm('globe')
axis equal off
view(3)
shading interp
lighting flat

camlight('headlight')
% camlight left
material metal

%% Lower the samplefactor, the higher the resolution
samplefactor = 50;
[Z, zleg] = etopo('/Volumes/Macintosh Extension/Documents Extension/GitHub/Sailboat-Data/Topology', samplefactor);
geoshow(Z,zleg,'DisplayType','texturemap')

%% dark color first, then light color
cmapsea  = interpColor([5 32 144]/255, [50 155 255]/255);
cmapland = interpColor([0 118 68]/255, [146 82 16]/255);
demcmap(Z, 32, cmapsea', cmapland')

%% plots outlines
land = shaperead('landareas','UseGeoCoords',true);
plotm([land.Lat],[land.Lon],'Color','black')
rivers = shaperead('worldrivers','UseGeoCoords',true);
plotm([rivers.Lat],[rivers.Lon],'Color','blue')

function [output] = interpColor(a, b)
    space = 10;
    output = zeros(3, space);
    increment = (b - a) / (space - 1);
    for i = 1:space
        output(:, i) = a + increment * (i - 1);
    end
end

%% Rotate shape
% n = 20;
% camorbit(10,0,'data',[0 -10 0])
% 
% for index=1:n
%     camorbit(5,0,'data',[0 0 1])
%     M(index) = getframe;
% end

% set visibility
set(f, 'visible', 'on')

% movie(M, 5, 10)

end