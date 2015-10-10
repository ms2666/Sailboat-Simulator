function[dir] = get_direction(polar_plot)
% inputs: current direction, weather data, 
% polar plot, current location
% output: direction

% options
old_polar_plot = polar_plot;
plotme = true;
randomize = true;

% randomize polar plot
if randomize
    magnitudes = polar_plot(:, 2);
    random_magnitudes = magnitudes(randperm(length(magnitudes)));
    random_polar_plot = [polar_plot(:, 1) random_magnitudes];
    polar_plot = random_polar_plot;
end

[~, i] = max(polar_plot(:, 2));
dir = polar_plot(i, 1);


% display polar plot (optional)
if plotme
    polar(old_polar_plot(:, 1), old_polar_plot(:, 2))
    hold on
    polar(polar_plot(:, 1), polar_plot(:, 2))
    polar([dir, 0], [0.08, 0], 'k')
    hold off
end


end