
function [ansTable, keyTable] = getPress(time)

% Waits until user presses any key.

% Don't start until keys are released
while KbCheck end;
ansTime = 100; % large amount of time (I couldn't get NaN to work)
key = NaN;

%20 is an arbitrary number to cover the max number of spaces in the given
%interval. With only 1.2s for any response, having 20+ key presses should
%be impossible. ansTable holds all time points in which a key was pressed.
%keyTable holds which key was pressed.
ansTable = zeros(1,3);
keyTable = cell(1,3);
i = 1;
startTime = GetSecs;
while GetSecs-startTime < time
    [keyIsDown,secs,keyCode] = KbCheck();
    if keyIsDown
        if i <= 3
            kbcheckTime = secs-startTime;
            ansTime = GetSecs-startTime;
            ansTable(1,i) = ansTime;
            key = KbName(keyCode);
            keyTable{1,i} = key;


            fprintf(['\nKey pressed: ', key]);
            fprintf(['\nAnsTime: ', num2str(ansTime)]);
            
            %waits for user to release key
            KbWait([], 1);
            i = i+1;
        else
            sprintf('Error: button mashing');
        end
    end
end


end
