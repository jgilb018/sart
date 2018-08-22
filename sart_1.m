% 1. Make a centered string of 12 black capital Xs show up on screen.

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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);


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

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

Screen('TextSize', window, 80);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Alpaca', 'center', 'center', black);

% Flip to the screen
Screen('Flip', window);
WaitSecs(.3);

% wait for button press
%KbStrokeWait;

% Draw Xs in the middle of the screen in Courier in black
Screen('TextSize', window, 80);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'XXXXXXXXXXXX', 'center', 'center', black);

% Clear the screen. 
Screen('Flip', window);
% wait for button press
%KbStrokeWait;

WaitSecs(.9);


% Draw Xs in the middle of the screen in Courier in black
Screen('TextSize', window, 80);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Giraffe', 'center', 'center', black);

Screen('Flip', window);
WaitSecs(.3)

% Draw Xs in the middle of the screen in Courier in black
Screen('TextSize', window, 80);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'XXXXXXXXXXXX', 'center', 'center', black);

Screen('Flip', window);
WaitSecs(.9)

sca;

