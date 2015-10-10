function [next_location] = next_location(in_struct)
% inputs: weather data, polar plot, direction
%         timescale, current location
% output: next location

%% calculate speed in direction given
[i, ~] = knnsearch(in_struct.polar_plot(:, 1), in_struct.direction);
% speed in m/s
speed = in_struct.polar_plot(i, 2);

%% calculate distance travelled
% convert time_scale from minutes to seconds
t = in_struct.time_scale * 60;
dist = speed * t;
% convert to km
dist = dist / 1000;

%% convert distance to degrees moved
dist = km2deg(dist);

%% calculate next point
% convert direction to correct input format
direction = in_struct.direction;
direction = radtodeg(direction);
direction = mod(-1 * direction, 360);

current_location = in_struct.current_location;
next_location = reckon('gc', current_location(1), current_location(2), dist, direction);

end