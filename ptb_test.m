PsychDebugWindowConfiguration
Screen('Preference', 'SkipSyncTests', 2);

% clear workspace and screen
sca;
close all;
clearvars;

% call default settings
PsychDefaultSetup(2);

% get screen numbers
screens = Screen('Screens');

% draw max
screenNumber = min(screens);


% define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% make grey
grey = white / 2

% open screen with grey window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);


% get size of window screen in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

% Query the inter-frame-interval. 
ifi = Screen('GetFlipInterval', window);

% Refresh rate
hertz = FrameRate(window);

% Queries display in mm
[width, height] = Screen('DisplaySize', screenNumber);

% Get max coded luminance level
maxLum = Screen('ColorRange', window);

% wait for button press
KbStrokeWait;

% Clear the screen. 
sca;