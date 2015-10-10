function[] = get_direction()
% inputs: current direction, weather data, 
% polar plot, current location
% output: direction

% generate polar plot
polar_plot = polarDiagram(10);
polar_plot = polar_plot';
polar(polar_plot(:, 1), polar_plot(:, 2))


end