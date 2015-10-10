close all

%% Current Location
% units = [latitude, longitude]
current = [40.7, -74.0];
current = [32, -71]; % coast of florida

%% Direction
% units = radians above 0
direction = 0;

%% Geography
% initialize land here so we dont have to constantly do it
land = shaperead('landareas','UseGeoCoords',true);
rivers = shaperead('worldrivers','UseGeoCoords',true);


%% Timescale
% units = minutes per step
time_scale_in_hours = 1;
time_scale = time_scale_in_hours*60;

%% Generate polar plot
polar_plot = polarDiagram(1);
polar_plot = polar_plot';

%% Get Next Direction
direction = get_direction(polar_plot);

%% Get Next Location
% create input struct
next = next_location(polar_plot, direction, time_scale, current, land, rivers);

%% Display globe
globe = drawGlobe();
globe.Name = 'Globe';
globe.Selected = 'on';

%% Simulate path
% some options
startColor = [69,255,149]./255;
endColor = [255,60,59]./255;
interColor = [255,232,37]./255;
lineColor = [236,243,253]./255;
animate = true;
debug = true;
shift = false;

% start simulation
geoshow(current(1),current(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',startColor,'marker','o', 'MarkerSize',10)
for i = 1:1000
    if debug
        fprintf('Current iteration: %d\n', i);
    end
    
    % update polar plot
    if shift
        magnitudes = polar_plot(:, 2);
        shifted_magnitudes = circshift(magnitudes, randi([0 length(magnitudes)], 1, 1));
        shifted_polar_plot = [polar_plot(:, 1) shifted_magnitudes];
        polar_plot = shifted_polar_plot;
    end
    % update direction
    direction = get_direction(polar_plot);
    % plot line between current and next
    [lttrk, lntrk] = track2('gc', current(1), current(2), next(1), next(2));
    plotm(lttrk, lntrk, 'LineWidth', 1, 'Color', lineColor)
    
    % update current location
    current = next;
    % plot current location
    geoshow(current(1),current(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',interColor,'marker','o', 'MarkerSize',2)
    % calculate next point
    next = next_location(polar_plot, direction, time_scale, current, land, rivers);
    
    if animate
        drawnow
    end
    
    if sum(next == current) > 0
        break;
    end
end
geoshow(next(1),next(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',endColor,'marker','o', 'MarkerSize',10)
[lttrk, lntrk] = track2('gc', current(1), current(2), next(1), next(2));
plotm(lttrk, lntrk, 'LineWidth', 1, 'Color', lineColor)
