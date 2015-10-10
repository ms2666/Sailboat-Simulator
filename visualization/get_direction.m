function[dir] = get_direction(polar_plot, debug)
% inputs: current direction, weather data,
% polar plot, current location
% output: direction

%% options
old_polar_plot = polar_plot;
plotme = false;
randomize = false;
shift = false;

if nargin < 2
    debug = false;
end

%% randomize polar plot
if randomize
    magnitudes = polar_plot(:, 2);
    random_magnitudes = magnitudes(randperm(length(magnitudes)));
    random_polar_plot = [polar_plot(:, 1) random_magnitudes];
    polar_plot = random_polar_plot;
end

%% randomly shift circularly
if shift
    magnitudes = polar_plot(:, 2);
    shifted_magnitudes = circshift(magnitudes, randi([0 length(magnitudes)], 1, 1));
    shifted_polar_plot = [polar_plot(:, 1) shifted_magnitudes];
    polar_plot = shifted_polar_plot;
end

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