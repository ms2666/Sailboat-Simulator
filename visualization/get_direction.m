function[dir] = get_direction(polar_plot, debug, current_location, current_time)
% inputs: current direction, weather data,
% polar plot, current location
% output: direction

%% options
plotme = false;

if nargin < 2
    debug = false;
end

%% Logic goes here ==========

% ===========================


%% calculate new direction by maximizing polar plot velocity
[~, i] = max(polar_plot(:, 2));
dir = polar_plot(i, 1);

%% debug?
if debug
    fprintf('new direction: %f\n', dir);
end

%% display polar plot (optional)
if plotme
    f = figure;
    f.Name = 'Polar plot of Sailboat';
    polar(old_polar_plot(:, 1), old_polar_plot(:, 2));
    hold on
    polar(polar_plot(:, 1), polar_plot(:, 2))
    polar([dir, 0], [0.08, 0], 'k')
    hold off
end


end