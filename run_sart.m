function [table1Keys, table2Keys] = run_sart(subid)

%PsychDebugWindowConfiguration % for testing
Screen('Preference', 'SkipSyncTests', 2);

% clear workspace and screen
sca;
close all;

%hide cursor
%HideCursor();
 
% call default settings
PsychDefaultSetup(2);

% get screen numbers
screens = Screen('Screens');

% draw max
screenNumber = min(screens);

% define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

grey = (white+black)/2;

% open screen with grey window 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Set the blend funciton for the screenf
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

animalTable = readtable('/Users/annakhazenzon/Documents/PAM/tasks/sart/stim/animal_stims.csv');
foodTable = readtable('/Users/annakhazenzon/Documents/PAM/tasks/sart/stim/food_stims.csv');

%animalList and foodList both have 160 elements
animalList = animalTable{:, 1};
foodList = foodTable{:, 1};

maxNumTrials = 225; % number of trials in a set
listLength = 45; % total length of the test list

%table(list) of random stimulus names that were chosen during each trial
pracStimNames = cell(maxNumTrials,1);

%table(list) of random stimuli that were chosen during each trial (animal or food)
pracTypes = cell(maxNumTrials,1);

%list of trial number labels
pracTrialNumbers = zeros(maxNumTrials, 1);

%table(list) of response times during stimulus
pracTable1Ans = cell(maxNumTrials,1);

%table(list) of which key was pressed by time during stimulus
pracTable1Keys = cell(maxNumTrials,1);

%table(list) of response times during stimulus
pracTable2Ans = cell(maxNumTrials,1);

%keys table(list) of which key was pressed by time during stimulus screen of 'Xs'
pracTable2Keys = cell(maxNumTrials,1);

%table of fastest times for each trial
pracFastestTimes = zeros(maxNumTrials,1);

%list of whether the response was correct
pracAccs = cell(maxNumTrials, 1);

targetNum = rand(1,1);
if targetNum < .5
    nontarg = 'animals';
    targ = 'foods';
else
    nontarg = 'foods';
    targ = 'animals';
end

Screen('TextSize', window, 18);
Screen('TextFont', window, 'Arial');

instrux_text = ['For the following task, please press the space bar when you see ', ...
upper(nontarg), ' but NOT when you see ', upper(targ), '.\n\nIf you see ', targ, ...
' you should not press any keys.\n\nPress any key to begin practice trials...'];
DrawFormattedText(window, instrux_text, 'center', 'center', black);
Screen('Flip', window);
KbWait([], 2);

%start eyelink recording
Eyelink('StartRecording');
WaitSecs(1);
%%%%%%%%%%%%%%%%%%%%%%% PRACTICE TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:10
    
    correct = false; %sets the correct counter to false
    pracTrialNumbers(i) = i;

    randNum = rand(1,1) * 159; %  creates an integer 0-159 (since rand 0 <= num  <= 1)
    rowNum = round(randNum) + 1;    % creates an integer between 1 and 160   

    if strcmp(targ, 'animals')
        DrawFormattedText(window, foodList{rowNum,1}, 'center', 'center', black);
        pracTypes{i,1} = 'food';
        pracStimNames{i,1} = foodList{rowNum,1};
    else
        DrawFormattedText(window, animalList{rowNum,1}, 'center', 'center', black);
        pracTypes{i,1} = 'animal';
        pracStimNames{i,1} = animalList{rowNum,1};
    end
    
    % Flip the stimulus word on
    Screen('Flip', window);
    [ansTable1, keyTable1] = getPress(.3); %checks for a keypress for .3 seconds

    %adds the results of the tables from getPress into the master list
    pracTable1Ans{i,1} = ansTable1;
    pracTable1Keys{i,1} = [keyTable1{:}];
    if ansTable1(1,1) > 0
        correct = true;
    end
    
    % .3 changed to 3 to make testing easier
 
    % Draw Xs in the middle of the screen 
    DrawFormattedText(window, 'XXXXXXXXXXXX', 'center', 'center', black);


    % Leave the screen of 'X's up for .9 seconds 
    Screen('Flip', window);
    %if ansTime == 100 % no key pressed during stimulus
    [ansTable2, keyTable2] = getPress(.9); % wait again for a key press
    
    %adds .3 to results in 2nd table to account for no press during
    %stimulus
    j = 1;
    while ansTable2(1,j) ~= 0
        ansTable2(1,j) = ansTable2(1,j) + .3;
        j = j+1;
    end
    
    pracTable2Ans{i,1} = ansTable2;
    pracTable2Keys{i,1} = [keyTable2{:}];
    if ansTable2(1,1) > 0
        correct = true;
    end
    
    %prints out the fastest time during a stimulus
    fastestTime = NaN;
    if ansTable1(1,1) ~= 0
        fprintf('\nThe 1st recorded RT was %.2f', ansTable1(1,1));
        fastestTime = ansTable1(1,1);
    elseif ansTable2(1,1) ~= 0
        fprintf('\nThe 2nd recorded RT was %.2f', ansTable2(1,1));
        fastestTime = ansTable2(1,1);
    else
        fprintf('\nNo response recorded');
    end   
    
    if correct == true
        pracAccs{i,1} = 'correct';
    else
        pracAccs{i,1} = 'wrong';
    end
    %records fastest time
    pracFastestTimes(i) = fastestTime;
end

% returns practice results to a text file
pracData = table(pracTrialNumbers, pracStimNames, pracTypes, pracTable1Ans, pracTable1Keys, pracTable2Ans, pracTable2Keys, pracFastestTimes, pracAccs);
writetable(pracData, ['sart_prac_', subid], '', 'text');
    
%%%%%%%%%%%%%%%%%%%%%%%%%% ACTUAL TRIALS%%%%%%%%%%%%%%%%%%%%%%%%%%%%

instrux_text2 = ['You have completed the practice trials. You will now begin the real experiment.\n\nRemember, please press the space bar when you see ', ...
upper(nontarg), ' but NOT when you see ', upper(targ), '\n\nIf you see ', targ, ...
' you should not press any keys.\n\nPress any key to begin the task...'];
DrawFormattedText(window, instrux_text2, 'center', 'center', black);
Screen('Flip', window);
KbWait([], 2);

%delay before start
WaitSecs(1);

for sets=0:1
    
    % Making testList of 45 words to use for trial
    m = 1; % counter for 5
    o = 6; % counter for 40
    testList = cell(listLength,2); % row1 - stimulus name; row2 - # of occurrences
    if strcmp(targ, 'foods')
        % pick 5 random foods and 40 random animals
        while m <= 5
            randNum = rand(1,1) * 159; %  creates an integer 0-159 (since rand 0 <= num  <= 1)
            rowNum = round(randNum) + 1;    % creates an integer between 1 and 160
            inList = false;
            for n=1:5
                if strcmp(foodList{rowNum,1}, testList{n,1}) % food is already in new list
                    inList = true;
                    break;
                end
            end
            if inList == false % food isn't in list. Adds it to the list
                testList{m,1} = foodList{rowNum,1}; 
                m = m+1;
            end
        end

        while o <= listLength
            randNum = rand(1,1) * 159; %  creates an integer 0-159 (since rand 0 <= num  <= 1)
            rowNum = round(randNum) + 1;    % creates an integer between 1 and 160
            inList = false;
            for n=6:o
                if strcmp(animalList{rowNum,1}, testList{n,1}) % animal is already in new list
                    inList = true;
                    break;
                end
            end
            if inList == false % animal isn't in new list. Adds it to new list
                testList{o,1} = animalList{rowNum,1}; 
                o = o+1;
            end
        end


    % picks 5 random animals and 40 random foods
    else
        while m <= 5
            randNum = rand(1,1) * 159; %  creates an integer 0-159 (since rand 0 <= num  <= 1)
            rowNum = round(randNum) + 1;    % creates an integer between 1 and 160
            inList = false;
            for n=1:5
                if strcmp(animalList{rowNum,1}, testList{n,1}) % animal is already in new list
                    inList = true;
                    break;
                end
            end
            if inList == false % animal isn't in list. Adds it to the list
                testList{m,1} = animalList{rowNum,1}; 
                m = m+1;
            end
        end

        while o <= listLength
            randNum = rand(1,1) * 159; %  creates an integer 0-159 (since rand 0 <= num  <= 1)
            rowNum = round(randNum) + 1;    % creates an integer between 1 and 160
            inList = false;
            for n=6:o
                if strcmp(foodList{rowNum,1}, testList{n,1}) % food is already in new list
                    inList = true;
                    break;
                end
            end
            if inList == false % food isn't in new list. Adds it to new list
                testList{o,1} = foodList{rowNum,1}; 
                o = o+1;
            end
        end
    end

    %table(list) of random stimuli name that was chosen during each trial
    stimNames = cell(maxNumTrials,1);

    %table(list) of random stimuli that was chosen during each trial (animal or food)
    types = cell(maxNumTrials,1);

    %list of trial number labels
    trialNumbers = zeros(maxNumTrials, 1);

    %table(list) of response times during stimulus
    table1Ans = cell(maxNumTrials,1);

    %table(list) of which key was pressed by time during stimulus
    table1Keys = cell(maxNumTrials,1);

    %table(list) of response times during stimulus
    table2Ans = cell(maxNumTrials,1);

    %keys table(list) of which key was pressed by time during stimulus screen of 'Xs'
    table2Keys = cell(maxNumTrials,1);

    %table of fastest times for each trial
    fastestTimes = zeros(maxNumTrials,1);
    
    %list of whether the response was correct
    accs = cell(maxNumTrials, 1);

    for count=0:4
        % set all counters = 0
        for i=1:numel(testList)
            testList{i,2} = 0;
        end

        k = 1;
        while k<=listLength
            
      
            %Gets the correct trial number
            trialNumbers(k + count*listLength) = k + count*listLength + sets*maxNumTrials;
            
            % accuracy tracker
            pressed = false;
            correct = false;

            randNum = rand(1,1) * (listLength-1); %  creates an integer 0-44 (since rand 0 <= num  <= 1)
            indexNum = round(randNum) + 1;    % creates an integer between 1 and 45   

            if testList{indexNum,2} == 0 % tests if word has been displayed yet
                DrawFormattedText(window, testList{indexNum,1}, 'center', 'center', black);

                % Flip the stimulus word on
                Screen('Flip', window);
                [ansTable1, keyTable1] = getPress(.005); %checks for a keypress for .3 seconds
                
                % response recorded
                if ansTable1(1,1) > 0
                    pressed = true;
                end

                % Draw Xs in the middle of the screen 
                DrawFormattedText(window, 'XXXXXXXXXXXX', 'center', 'center', black);

                % Leave the screen of 'X's up for .9 seconds 
                Screen('Flip', window);
                %if ansTime == 100 % no key pressed during stimulus
                [ansTable2, keyTable2] = getPress(.005); % wait again for a key press
                
                %response recorded
                if ansTable2(1,1) > 0
                    pressed = true;
                end

                %adds .3 to results in 2nd table to account for stimulus
                l = 1;
                while ansTable2(1,l) ~= 0
                    ansTable2(1,l) = ansTable2(1,l) + .3;
                    l = l+1;
                end

                %adds the results of the tables from getPress into the master list
                table1Ans{(k + count*listLength),1} = ansTable1;
                table1Keys{(k + count*listLength),1} = [keyTable1{:}];
                table2Ans{(k + count*listLength),1} = ansTable2;
                table2Keys{(k + count*listLength),1} = [keyTable2{:}];
               

                %prints out the fastest time during a stimulus
                fastestTime = NaN;
                if ansTable1(1,1) ~= 0
                    fprintf('\nThe recorded RT was1 %d', ansTable1(1,1));
                    fastestTime = ansTable1(1,1);
                elseif ansTable2(1,1) ~= 0
                    fprintf('\nThe recorded RT was2 %d', ansTable2(1,1));
                    fastestTime = ansTable2(1,1);
                else
                    fprintf('\nNo response recorded');
                end   

                %records fastest time
                fastestTimes(k + count*listLength) = fastestTime;
                stimName = testList{indexNum,1};
                stimNames{k + count*listLength,1} = stimName; 
                
                % switches item in test list to having been used
                testList{indexNum,2} = 1;
                
                % target pressed correctly
                if pressed == true && indexNum > 5
                    correct = true;
                
                % nontarget not pressed correctly
                elseif pressed == false && indexNum <= 5
                    correct = true;
                end
                
                % animal is selected from a predominately food list
                if strcmp(targ,'animals') && (indexNum <= 5)
                   types{k + count*listLength, 1} = 'animal';
                
                % animal is selected from a predominately animal list
                elseif strcmp(targ,'foods') && (indexNum > 5)
                   types{k + count*listLength ,1} = 'animal';

                else
                   types{k + count*listLength,1} = 'food';               
                end
                 
                if correct == true
                    accs{(k + count*listLength),1} = 'correct';
                else
                    accs{(k + count*listLength),1} = 'wrong';
                end

                k = k+1;
                
             end
        end
    end
    if sets == 0
        % data from the first set
        data1 = table(trialNumbers, stimNames, types, table1Ans, table1Keys, table2Ans, table2Keys, fastestTimes, accs);
    else
        %data from the second set
        data2 = table(trialNumbers, stimNames, types, table1Ans, table1Keys, table2Ans, table2Keys, fastestTimes, accs);
    end
    4r
end

%stop recording
Eyelink('StopRecording');

allData = vertcat(data1, data2); %concatenates the data from both sets
writetable(allData, ['sart_', subid], '', 'text');
end_text = 'Thank you!\n\nPlease wait for the experimenter.';
DrawFormattedText(window, end_text, 'center', 'center', black);
Screen('Flip', window);
KbWait([], 2);

sca;


    
    
    
    