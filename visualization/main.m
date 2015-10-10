%% Current Location
% units = [latitude, longitude]
current_location = [40.7, -74.0];

%% Direction
% units = radians above 0
direction = 0;

%% Timescale
% units = hours per step
time_scale = 24;

%% Generate polar plot
polar_plot = polarDiagram(1);
polar_plot = polar_plot';

%% Get Next Direction
direction = get_direction(polar_plot);