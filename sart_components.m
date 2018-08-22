% 0: Beginners stuff

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
grey = white / 2;

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

% Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%Type HelloWorld!
Screen('TextSize', window, 70);
DrawFormattedText(window, 'Hello World', 'center', screenYpixels * .25, [1 0 0]);

% Draw text in the middle of the screen in Courier in white
Screen('TextSize', window, 80);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Hello World', 'xCenter', 'yCenter', white);

% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', window, 90);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Hello World', 'center',...
    screenYpixels * 0.75, [0 0 1]);

% Flip to the screen
Screen('Flip', window);

% wait for button press
KbStrokeWait;

% Clear the screen. 
sca;

% 1. Make a centered string of 12 black capital Xs show up on screen.

% 2. Make the Xs appear for 900ms, then disappear.

% 3. Make the name of an animal appear, centered, for 300ms, then switch to
% the string of Xs for 900ms.

% 4. Record the press of a spacebar during these 1200ms.

% 5. Create an array with names of 3 animals, and loop through their names,
% displaying strings of Xs after each presentation of a word.

% 6. Load in the lists of stimuli (animals and words) and loop through the 
% first 3 of each list.

% 7. Loop through 3 random animals and 3 random foods, intermixed.

nontarg = 'animals';
targ = 'foods';

instrux_text = ['For the following task, please press the space bar when you see ', ...
nontarg, ' but NOT when you see ', targ, '\n\nIf you see ', targ, ...
' you should not press any keys.\n\nPress any key to begin the task...'];
sprintf(text)

end_text = 'Thank you!\n\nPlease wait for the experimenter.';