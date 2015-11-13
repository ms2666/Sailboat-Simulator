close all
clearvars -except current wind rel_wind
addpath('../dataCollection')
addpath('../../Simulator-Data')

%%
%   ____            _
%  |  _ \    __ _  | |_    __ _
%  | | | |  / _` | | __|  / _` |
%  | |_| | | (_| | | |_  | (_| |
%  |____/   \__,_|  \__|  \__,_|
%
%% Weather Data
if(~exist('current', 'var'))
    fprintf('Loading current data...')
    current = load('currents_2014.mat');
    fprintf(' Done\n')
end
% if(~exist('wind', 'var'))
%     fprintf('Loading wind data...')
%     wind = load('winds_2014.mat');
%     fprintf(' Done\n')
% end
if(~exist('rel_wind', 'var'))
    fprintf('Loading relative wind data...')
    rel_wind = load('relativeWind_2014.mat');
    fprintf(' Done\n')
end

%% Geography
% initialize land here so we dont have to repeatedly load it
land = shaperead('landareas','UseGeoCoords',true);
rivers = shaperead('worldrivers','UseGeoCoords',true);

%%
%   ____    _                       _           _
%  / ___|  (_)  _ __ ___    _   _  | |   __ _  | |_    ___    _ __
%  \___ \  | | | '_ ` _ \  | | | | | |  / _` | | __|  / _ \  | '__|
%   ___) | | | | | | | | | | |_| | | | | (_| | | |_  | (_) | | |
%  |____/  |_| |_| |_| |_|  \__,_| |_|  \__,_|  \__|  \___/  |_|
%
%   ____                                         _     _
%  |  _ \   _ __    ___    _ __     ___   _ __  | |_  (_)   ___   ___
%  | |_) | | '__|  / _ \  | '_ \   / _ \ | '__| | __| | |  / _ \ / __|
%  |  __/  | |    | (_) | | |_) | |  __/ | |    | |_  | | |  __/ \__ \
%  |_|     |_|     \___/  | .__/   \___| |_|     \__| |_|  \___| |___/
%                         |_|
%
%% Present Time
present_time = datenum('jan-01-2014');

%% Timescale
% units = minutes per step
time_scale_in_hours = 5;
time_scale = time_scale_in_hours*60;

%% Display globe
globe = drawGlobe();
globe.Name = 'Globe';
globe.Selected = 'on';

%% Other options
startColor = [69,255,149]./255;
endColor = [255,60,59]./255;
interColor = [255,232,37]./255;
lineColor = [236,243,253]./255;
animate = true;
debug = false;
shift = false;
numIterations = 1000;

%%
%   ____                    _
%  | __ )    ___     __ _  | |_
%  |  _ \   / _ \   / _` | | __|
%  | |_) | | (_) | | (_| | | |_
%  |____/   \___/   \__,_|  \__|
%
%   ____                                         _     _
%  |  _ \   _ __    ___    _ __     ___   _ __  | |_  (_)   ___   ___
%  | |_) | | '__|  / _ \  | '_ \   / _ \ | '__| | __| | |  / _ \ / __|
%  |  __/  | |    | (_) | | |_) | |  __/ | |    | |_  | | |  __/ \__ \
%  |_|     |_|     \___/  | .__/   \___| |_|     \__| |_|  \___| |___/
%                         |_|
%
%% Present Location
% units = [latitude, longitude]
present_location = [40.7, -74.0];
present_location = [32, -71]; % coast of florida

%% Boat Direction
% units = radians above 0
direction = 0;

%% Import boat's polar plot data
polarData = load('allPolarDiagrams.mat');

%%
%   ____    _                       _           _
%  / ___|  (_)  _ __ ___    _   _  | |   __ _  | |_    ___    _ __
%  \___ \  | | | '_ ` _ \  | | | | | |  / _` | | __|  / _ \  | '__|
%   ___) | | | | | | | | | | |_| | | | | (_| | | |_  | (_) | | |
%  |____/  |_| |_| |_| |_|  \__,_| |_|  \__,_|  \__|  \___/  |_|
%
%
for i = 1:numIterations
    %% debug output
    if debug
        fprintf('Present iteration: %d\n', i);
    end
    
    %% fetch present data
    %     [current_u, current_v] = interpolateEntry(present_location(1), present_location(2), present_time, current);
%     current_u = randn(1) * 20;
%     current_v = randn(1) * 100;
    current_u = 1/sqrt(2);
    current_v = 1/sqrt(2);
    %     [wind_u, wind_v] = interpolateEntry(present_location(1), present_location(2), present_time, wind);
    %     [rel_wind_u, rel_wind_v] = interpolateEntry(present_location(1), present_location(2), present_time, rel_wind);
%     rel_wind_u = randn(1) * 20;
%     rel_wind_v = randn(1) * 100;
    rel_wind_u = 1/sqrt(2);
    rel_wind_v = 1/sqrt(2);
    
    %% update polar plot using relative wind data
    % scale to correct polar plot
    rel_wind_mag = norm([current_u, current_v], 2);
    polar_plot = interpolatePolarPlot(rel_wind_mag , polarData);
    % rotate polar plot
    polar_plot = rotatePolar(polar_plot, rel_wind_u, rel_wind_v);
    
    %% update direction
    direction = get_direction(polar_plot', present_location, present_time, true);
    
    %% calculate next location
    next = next_location(polar_plot, direction, time_scale, present_location, present_time);
    
    %% plot present and next location
    if i == 1
        geoshow(present_location(1),present_location(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',startColor,'marker','o', 'MarkerSize',10)
    else
        geoshow(present_location(1),present_location(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',interColor,'marker','o', 'MarkerSize',2)
    end
    [lttrk, lntrk] = track2('gc', present_location(1), present_location(2), next(1), next(2));
    plotm(lttrk, lntrk, 'LineWidth', 1, 'Color', lineColor)
    
    %% update present_time
    present_time = present_time + time_scale_in_hours / 24;
    
    %% update present_location
    present_location = next;
    
    fprintf('Current iteration: %d\n', i);
    
    if animate
        drawnow
    end
    
    if landmask(present_location(1), present_location(2), 95)
        break;
    end
end
% Plot final point
geoshow(next(1),next(2),'DisplayType','point','markeredgecolor','y','markerfacecolor',endColor,'marker','o', 'MarkerSize',10)