function [next] = next_location(polar_plot, dir, time_scale, current_location, current_time)
% inputs: weather data, polar plot, direction
%         timescale, current location
% output: next location

%% debug?
debug = false;

%% assign speed_factor
% this is arbitrary for now
speed_factor = 50;

%% calculate speed in direction given
% TODO: regenerate polar plot using V_{a/w}
% polar_plot = polarDiagram(v_{a/w})
% ===== remove me =========
% polar_plot = polarDiagram(10);
% =========================
[i, ~] = knnsearch(polar_plot(:, 1), dir);
% speed in m/s
speed = speed_factor*polar_plot(i, 2);
% TODO: add velocity of water to calculate velocity of boat
% speed = speed + v_water
if debug
    fprintf('speed in inputted direction is %f m/s.\n', speed);
end

%% calculate distance travelled
% convert time_scale from minutes to seconds
t = time_scale * 60;
dist = speed * t;
if debug
    fprintf('distance travelled in %d seconds is %f meters.\n', t, dist);
end
% convert to km
dist = dist / 1000;
if debug
    fprintf('distance in km is %.2f.\n', dist);
end

%% convert distance to degrees moved
dist = km2deg(dist);
if debug
    fprintf('distance in degrees travelled is %f.\n', dist);
end

%% calculate next point
% convert direction to correct input format
dir = radtodeg(dir);
dir = mod(-1 * dir, 360);

current = current_location;
next = reckon('gc', current(1), current(2), dist, dir);

if landmask(next(1), next(2))
    next = current_location;
end
end