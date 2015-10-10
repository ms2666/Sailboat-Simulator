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
% while (sum(current ~= next) > 0)
%     direction = get_direction(polar_plot);
%     current = next;
%     geoshow(current(1),current(2),'DisplayType','point','markeredgecolor','y','markerfacecolor','y','marker','o')
%     next = next_location(polar_plot, direction, time_scale, current, land, rivers);
% end

%% a dumber simulate path
for i = 1:1000
    direction = get_direction(polar_plot);
    current = next;
    geoshow(current(1),current(2),'DisplayType','point','markeredgecolor','y','markerfacecolor','y','marker','o')
    next = next_location(polar_plot, direction, time_scale, current, land, rivers);
    [lttrk, lntrk] = track([current; next]);
    plotm(lttrk, lntrk, 'r', 'LineWidth', 3)
    drawnow
end
