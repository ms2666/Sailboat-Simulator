close all

%% Current Location
% units = [latitude, longitude]
current_location = [40.7, -74.0];

%% Direction
% units = radians above 0
direction = 0;

%% Timescale
% units = minutes per step
time_scale = 1;

%% Generate polar plot
polar_plot = polarDiagram(1);
polar_plot = polar_plot';

%% Get Next Direction
direction = get_direction(polar_plot);

%% Get Next Location
% create input struct
in_struct = struct;
in_struct.data = '';
in_struct.polar_plot = polar_plot;
in_struct.direction = direction;
in_struct.time_scale = time_scale;
in_struct.current_location = current_location;

%% Display globe
globe = drawGlobe();
globe.Name = 'Globe';
globe.Selected = 'on';