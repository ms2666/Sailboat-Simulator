close all

%% Current Location
% units = [latitude, longitude]
current_location = [40.7, -74.0];

%% Timescale
% units = minutes per step
time_scale = 500;

% generate polar plot
polar_plot = polarDiagram(1);
polar_plot = polar_plot';
old_polar_plot = polar_plot;
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
disp(radtodeg(dir))

plotme = true;
% display polar plot (optional)
if plotme
    polar(old_polar_plot(:, 1), old_polar_plot(:, 2))
    hold on
    polar(polar_plot(:, 1), polar_plot(:, 2))
    polar([dir, 0], [0.08, 0])
    hold off
end

%% calculate speed in direction given
[i, ~] = knnsearch(polar_plot(:, 1), dir);
% speed in m/s
speed = polar_plot(i, 2);

%% calculate distance travelled
% convert time_scale from minutes to seconds
t = time_scale * 60;
dist = speed * t;
% convert to km
dist = dist / 1000;

%% convert distance to degrees moved
dist = km2deg(dist);

%% calculate next point
% convert direction to correct input format
dir = radtodeg(dir);
dir = mod(-1 * dir, 360);
disp((dir))

current = current_location;
next = reckon('gc', current(1), current(2), dist, dir);
