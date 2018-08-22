function [Window, Rect] = MMTinitializeScreen

screenNumber = 1; % 0 = main monitor, 1 = second monitor
S.textColor = 0;                                  % black text
                           
[Window, Rect] = Screen('OpenWindow',screenNumber, S.textColor); % open the window

% Set fonts
Screen('TextFont',Window,'Times');      % font type (Times New Roman)
Screen('TextSize',Window,36);           % font size (36pt)
Screen('FillRect', Window, 255);          % screen color (0 = black, 1 = white)

HideCursor;                             % Remember to type ShowCursor later

