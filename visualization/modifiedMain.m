clearvars -except windDataStorage combinedDataStorage
addpath('../dataCollection');

%%
numFiles = length(dir('../dataCollection/windFiles/*.mat'));
global windDataStorage
global combinedDataStorage
windDataStorage = repmat(struct('U',[],'V',[],'f',[],'g',[],'t',[]),numFiles,1);
combinedDataStorage = repmat(struct('U',[],'V',[],'f',[],'g',[],'t',[]),numFiles,1);
%% Present Location
% units = [latitude, longitude]
present_location = [40.7, -74.0];
present_location = [32, -71]; % coast of florida

%% Present Time
present_time = datenum('jan-01-2014');

%% Weather Data
if(~exist('current', 'var'))
    current = load('currents_2014.mat');
end
% if(~exist('wind', 'var'))
%     wind = load('winds_2014.mat');
% end
% if(~exist('rel_wind', 'var'))
%     rel_wind = load('relativeWind_2014.mat');
% end

%% Direction
% units = radians above 0
direction = 0;

%% Geography
% initialize land here so we dont have to constantly do it
land = shaperead('landareas','UseGeoCoords',true);
rivers = shaperead('worldrivers','UseGeoCoords',true);


%% Timescale
% units = minutes per step
time_scale_in_hours = 5;
time_scale = time_scale_in_hours*60;

%% Generate polar plot
polar_plot = polarDiagram(1);
polar_plot = polar_plot';

%% Get Next Direction
direction = get_direction(polar_plot, present_location, present_time);

%% Get Next Location
% create input struct
next = next_location(polar_plot, direction, time_scale, present_location, present_time);

%% Display globe
globe = drawGlobe();
globe.Name = 'Globe';
globe.Selected = 'on';

%% Simulate path
% some options
startColor = [69,255,149]./255;
endColor = [255,60,59]./255;
interColor = [255,232,37]./255;
lineColor = [236,243,253]./255;
animate = true;
debug = false;
shift = false;

% start simulation
geoshow(present_location(1),present_location(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',startColor,'marker','o', 'MarkerSize',10)
for i = 1:1000
    if debug
        fprintf('Current iteration: %d\n', i);
    end
    
    % update polar plot at each time stamp
    present_current = interpolateEntry(present_location(1), present_location(2), present_time, current);
    
    % update direction
    direction = get_direction(polar_plot, present_location, present_time);
    % plot line between current and next
    [lttrk, lntrk] = track2('gc', present_location(1), present_location(2), next(1), next(2));
    plotm(lttrk, lntrk, 'LineWidth', 1, 'Color', lineColor)
    
    % update current location
    present_location = next;
    % plot current location
    geoshow(present_location(1),present_location(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',interColor,'marker','o', 'MarkerSize',2)
    % calculate next point
    next = next_location(polar_plot, direction, time_scale, present_location, present_time);
    % calculate next value for present_time
    present_time = present_time + time_scale_in_hours / 24;
    disp(datestr(present_time))
    
    if animate
        drawnow
    end
    
    if sum(next == present_location) > 0
        break;
    end
end
geoshow(next(1),next(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',endColor,'marker','o', 'MarkerSize',10)
[lttrk, lntrk] = track2('gc', present_location(1), present_location(2), next(1), next(2));
plotm(lttrk, lntrk, 'LineWidth', 1, 'Color', lineColor)
