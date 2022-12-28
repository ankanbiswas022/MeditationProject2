% This is the main program used for data segmentation.
% In all protocols, time is divided into 2.5 second long "trials", each
% marked by trial start and trial end digital markers. In three protocols -
% G1, G2 and M2, a stimulus is presented after 1.25 seconds. In the
% remaining trials, nothing happens.

% There are 8 protocols as listed below.
% 1. EO1 (eyes open 1): Duration: 5 minutes.
% 2. EC1 (eyes close 1): Duration: 5 minutes
% 3. G1  (Gamma 1): Duration: 5 minutes. 
% 4. M1  (Meditation 1): Duration: 15 minutes.
% 5. G2 (Gamma 2): Same as G1
% 6. EO2 (eyes open 2): Same as EO1
% 7. EC2 (eyes close 2): Same as EC2
% 8. M2 (Meditation 2): Duration: 15 minutes - same as M1 but with gamma
% protocol running 

function segmentAndSaveData(subjectName,expDate,folderSourceString,FsEye,digitalCodeMismatchFlag)

if ~exist('folderSourceString','var');      folderSourceString=[];        end
if ~exist('FsEye','var');                   FsEye=1000;                   end
if ~exist('digitalCodeMismatchFlag','var'); digitalCodeMismatchFlag=0;                   end

if isempty(folderSourceString)
    folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
end

gridType = 'EEG';
protocolNameList = [{'EC1'} {'G1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}];
% protocolNameList = [ {'EO2'} {'EC2'} {'M2'} ];
% protocolNameList = {'EC2'};

timeStartFromBaseLine = -1.25; deltaT = 2.5;

trialStartCode = 9; trialEndCode = 18; 
if digitalCodeMismatchFlag
    trialEndCodeExeption=2;
end

for i=1:length(protocolNameList)
    protocolName = protocolNameList{i};
    
    % Get Digital events from BrainProducts (BP)
    folderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName);
    folderExtract = fullfile(folderName,'extractedData');
    folderSave = fullfile(folderName,'segmentedData','eyeData');

    % fix the position of the occurence of the trialStartCOdes as well    

    [digitalTimeStamps,digitalEvents]=extractDigitalDataBrainProducts(subjectName,expDate,protocolName,folderSourceString,gridType,0);
    
    % errofix@AB
    %check whther the first code is 9 or not;
    if ~isequal(digitalEvents(1),trialStartCode)
        disp('The first event is not the trial start code in BP');
    elseif strcmp(protocolName(1),'G') 
        % this works only for G2 where we have five codes for each trial
        trialStartPositions=1:5:5*120;
        trialStartTimesListBP = digitalTimeStamps(trialStartPositions);
    elseif strcmp(protocolName,'M2')
        trialStartPositions=1:5:5*360;
        trialStartTimesListBP = digitalTimeStamps(trialStartPositions);
    else
        trialStartTimesListBP = digitalTimeStamps(digitalEvents==trialStartCode);
    end

%     trialStartTimesListBP = digitalTimeStamps(trialStartPositions);
    trialEndTimesListBP = digitalTimeStamps(digitalEvents==trialEndCode | digitalEvents==trialEndCodeExeption);
    
    % Get data from ML
    fileNameML = fullfile(folderSourceString,'data','rawData',[subjectName expDate],[subjectName expDate protocolName '.bhv2']);
    if isfile(fileNameML)
        [MLData,MLConfig,MLTrialRecord] = mlread(fileNameML);
        numTrials = length(MLData);
        goodStimTimesML = []; % Same sequence constructed using ML data. Used for comparison
        if numTrials ~= length(trialStartTimesListBP)
            error('Number of trials in ML do not match with number of start trial codes in BP');
        end
    else % exeptional case, when we dont have the .bhv2 file from the Monkeylogic
        numTrials = find(digitalEvents==9); % marker 9 denotes the trial start
    end    
    
    goodStimTimes = []; % This is a long sequence of epoch times around which data segments are cut
%     goodStimTimesML = []; % Same sequence constructed using ML data. Used for comparison
    goodStimCodeNums = [];
    
    eyeRawData = [];
    eyeRawGazeData = [];
    eyeDataDegX = [];
    eyeDataDegY = [];    
    
    for j=1:numTrials
        trialStartTimeBP = trialStartTimesListBP(j); % Start of trial as per BP timeline
        trialEndTimeBP   = trialEndTimesListBP(j);   % End of trial as per BP timeline
        
        if isfile(fileNameML); MLDataThisTrial = MLData(j); end
        
        if strcmp(protocolName(1),'E') || strcmp(protocolName,'M1') % for EO, EC and M1 protocols

            if isfile(fileNameML)
                trialStartTimeML = MLDataThisTrial.BehavioralCodes.CodeTimes((MLDataThisTrial.BehavioralCodes.CodeNumbers==trialStartCode)); % in milliseconds
                goodStimTimeThisTrial = (trialStartTimeML/1000) - timeStartFromBaseLine; % Relative to this trial (in seconds)
            else % exeptional case, when we dont have the .bhv2 file from the Monkeylogic 
                goodStimTimeThisTrial = 0; % in the next step, we would add some average time                
            end
            
            goodStimTimes = cat(2,goodStimTimes,trialStartTimeBP + goodStimTimeThisTrial); % in seconds
            goodStimTimesML = cat(2,goodStimTimesML,MLDataThisTrial.AbsoluteTrialStartTime/1000 + goodStimTimeThisTrial); % in seconds
            
        elseif strcmp(protocolName(1),'G') || strcmp(protocolName,'M2') % for G1, G2 and M2 protocols

            % ML
            codeTimesThisTrialML = MLDataThisTrial.BehavioralCodes.CodeTimes;
            codesNumbersThisTrialML = MLDataThisTrial.BehavioralCodes.CodeNumbers;
            
            % BP
            eventPosThisTrial = intersect(find(digitalTimeStamps>=trialStartTimeBP),find(digitalTimeStamps<=trialEndTimeBP));
            digitalTimeStampsThisTrial = digitalTimeStamps(eventPosThisTrial);
            digitalEventsThisTrial = digitalEvents(eventPosThisTrial);
            
            % The events should match
            if ~isequal(digitalEventsThisTrial(:),codesNumbersThisTrialML(:))
                disp('Code numbers do not match');
                % errorfix@Ankan if they dont match then 3rd marker is made
                % the same as on ML
                digitalEventsThisTrial(3)=codesNumbersThisTrialML(3);
            end
            
            goodStimPosThisTrial = getGoodStimPosGammaProtocol(digitalEventsThisTrial);
            goodStimTimeThisTrial = codeTimesThisTrialML(goodStimPosThisTrial)/1000; % Relative to this trial (in seconds)
            
            goodStimTimes = cat(2,goodStimTimes,digitalTimeStampsThisTrial(goodStimPosThisTrial)); % in seconds, directly from the BP digital stream
            goodStimTimesML = cat(2,goodStimTimesML,MLDataThisTrial.AbsoluteTrialStartTime/1000 + goodStimTimeThisTrial');
        end
        
        % Get and Align eye data (RawData)
        eyeRawDataThisTrial = getEyeDataThisTrial(MLDataThisTrial.AnalogData.Eye,goodStimTimeThisTrial,timeStartFromBaseLine,deltaT,FsEye);
        eyeRawData = cat(1,eyeRawData,eyeRawDataThisTrial);
        % Get and Align eye data(GazeData)
 
        eyeGazeDataThisTrial = getEyeDataThisTrial(MLDataThisTrial.AnalogData.EyeExtra,goodStimTimeThisTrial,timeStartFromBaseLine,deltaT,FsEye);
        eyeRawGazeData = cat(1,eyeRawGazeData,eyeGazeDataThisTrial);
        % Convert the Gaze date to degrees
        [eyeDataDegXThisTrial,eyeDataDegYThisTrial] = convertEyeDataPix2DegML(squeeze(eyeGazeDataThisTrial));
        eyeDataDegX =  cat(1,eyeDataDegX,eyeDataDegXThisTrial'); eyeDataDegY = cat(1,eyeDataDegY,eyeDataDegYThisTrial');
%         figure(10);
%         scatter(eyeDataDegX,eyeDataDegY); hold on
    end
    
    compareBPWithML(goodStimTimes,goodStimTimesML);
    eyeRangeMS = (timeStartFromBaseLine + [0 deltaT])*1000;     
    
    % generating the parameter combinations
    conditionsArray = MLTrialRecord.ConditionsPlayed;    
    %getStimResultsML(folderExtract,conditionsArray); 
    getStimResultsML_Meditation(MLData,folderExtract,conditionsArray,protocolName);
    goodStimNums = 1:length(conditionsArray);
    getDisplayCombinationsGRF(folderExtract,goodStimNums); % Generates parameterCombinations
    
    % Save useful data in folderExtract
    makeDirectory(folderExtract);
    save(fullfile(folderExtract,'goodStimCodeNums.mat'),'goodStimCodeNums','goodStimTimes');
    save(fullfile(folderExtract,'MLInfo.mat'),'MLConfig','MLTrialRecord');
    save(fullfile(folderExtract,'EyeData.mat'),'eyeRawData','eyeRawGazeData','eyeRangeMS','FsEye');
    % Save segmented data
    getEEGDataBrainProducts(subjectName,expDate,protocolName,folderSourceString,gridType,goodStimTimes,timeStartFromBaseLine,deltaT);
    % Save eye data in segmentedData(ML)
    makeDirectory(folderSave);
    save(fullfile(folderSave,'eyeDataDeg.mat'),'eyeDataDegX','eyeDataDegY');    
end
end
function goodStimPos = getGoodStimPosGammaProtocol(digitalEvents)
goodCodeNums = 21:28; % Stim codes

goodStimPos = [];
for i=1:length(digitalEvents)
    if ~isempty(intersect(digitalEvents(i),goodCodeNums))
        goodStimPos = cat(2,goodStimPos,i);
    end
end
end
function compareBPWithML(goodStimTimes,goodStimTimesML)

dTBP = diff(goodStimTimes);
dTML = diff(goodStimTimesML);
maxD = 1000*max(abs(dTBP-dTML));

maxTol = 35; % Must be within this limit

if maxD>maxTol
    plot(dTBP,'b'); hold on; plot(dTML,'r');
    error(['max difference in timing: ' num2str(maxD) 'exceeds maxTolerence of ' num2str(maxTol) ' ms']);
else
    disp(['max difference in relative timing: ' num2str(maxD) ' ms']);
end
end
function eyeDataThisTrial = getEyeDataThisTrial(eyeDataML,goodStimTimesThisTrial,timeStartFromBaseLine,epochDur,FsEye)

maxEyePos = size(eyeDataML,1);
numSamplesToUse = round(epochDur*FsEye);
xsEye = (1:maxEyePos)/FsEye;

for k=1:length(goodStimTimesThisTrial)
    
    if (goodStimTimesThisTrial(k)+timeStartFromBaseLine)<xsEye(1) % this fixes a error if startTime is very low, startPos becomes empty
        startPos=1;
    else        
        startPos = find(xsEye<(goodStimTimesThisTrial(k)+timeStartFromBaseLine), 1, 'last' );
    end
    
    if (startPos+numSamplesToUse)<=maxEyePos
        eyeDataThisTrial(k,:,:) = eyeDataML(startPos + (1:numSamplesToUse),:); %#ok<*AGROW> 
    else
        disp('Trial aborted before time... ');
        posShort = (startPos+1):maxEyePos;
        posRemaining = numSamplesToUse-length(posShort);
        for m=1:2
            eyeDataThisTrial(k,:,m) = [eyeDataML(posShort,m); zeros(posRemaining,1)];
        end
    end
end
end