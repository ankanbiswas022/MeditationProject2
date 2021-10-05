% This is the main program used for data segmentation.
% Data is segmented in 1 second segments. In conditions in which gamma
% stimulus is presented (G1, G2 and M2), stimulus is presented for 750 ms,
% and data is analyzed between 250-750 ms (500 ms duration). For remaining
% protocols, we simply segment the data in consecutive 1-second bins.

% There are 9 protocols as listed below.
% 1. EO1 (eyes open 1): Duration: 5 minutes. We take segments separated by 1 seconds (300 segments).
% 2. EC1 (eyes close 1): Duration: 5 minutes. We take segments separated by 1 seconds (300 segments).
% 3. G1  (Gamma 1): Duration: 5 minutes. Each trial consists of 8 stimuli
% of 750 ms with ITI of 1.5 seconds (7.5 seconds total). They are presented
% continuously for 5 mins (40 trials; 320 stimuli). 1 second interval starting from
% onset of each stimulus is saved (320 segments).
% 4. M1  (Meditation 1): Duration: 15 minutes. We take segments separated by 1 seconds (1500 segments).
% 5. G2 (Gamma 2): Same as G1
% 6. IAT (Implicit association task): Duration: 15 minutes: For now, this is not analyzed
% 7. EO2 (eyes open 2): Same as EO1
% 8. EC2 (eyes close 2): Same as EC2
% 9. M2 (Meditation 2): Same as Meditation 1 but with the Gamma protocol
% running 3 times back-to-back. Total: 320*3 = 960 stimuli

function segmentAndSaveData(subjectName,expDate,folderSourceString)

if ~exist('folderSourceString','var');    folderSourceString=[];        end

if isempty(folderSourceString)
    folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
end

gridType = 'EEG';
%protocolNameList = [{'EO1'} {'EC1'} {'G1'} {'M1'} {'G2'} {'IAT'} {'EO2'} {'EC2'} {'M2'}];
protocolNameList = [{'EO1'} {'EC1'} {'G1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}]; % IAT not considered for now
timeStartFromBaseLine = 0; deltaT = 1;

trialStartCode = 9;
trialEndCode = 18;

for i=1:length(protocolNameList)
    protocolName = protocolNameList{i};
    
    % Get Digital events from BrainProducts (BP)
    folderExtract = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'extractedData');
    [digitalTimeStamps,digitalEvents]=extractDigitalDataBrainProducts(subjectName,expDate,protocolName,folderSourceString,gridType,0);
    trialStartTimesListBP = digitalTimeStamps(digitalEvents==trialStartCode);
    trialEndTimesListBP = digitalTimeStamps(digitalEvents==trialEndCode);
    
    % Get data from ML
    fileNameML = fullfile(folderSourceString,'data','rawData',[subjectName expDate],[subjectName expDate protocolName '.bhv2']);
    [MLData,MLConfig,MLTrialRecord] = mlread(fileNameML);
    
    numTrials = length(MLData);
    if numTrials ~= length(trialStartTimesListBP)
        error('Number of trials in ML do not match with number of start trial codes in BP');
    end
    
    goodStimTimes = []; % This is a long sequence of epoch times around which data segments are cut
    goodStimTimesML = []; % Same sequence constructed using ML data. Used for comparison
    goodStimCodeNums = [];
    
    eyeData = [];
    
    for j=1:numTrials
        trialStartTimeBP = trialStartTimesListBP(j); % Start of trial as per BP timeline
        trialEndTimeBP = trialEndTimesListBP(j); % End of trial as per BP timeline
        MLDataThisTrial = MLData(j);
        
        if strcmp(protocolName(1),'E') || strcmp(protocolName,'M1') % for EO, EC and M1 protocols

            trialStartTimeML = MLDataThisTrial.BehavioralCodes.CodeTimes((MLDataThisTrial.BehavioralCodes.CodeNumbers==trialStartCode)); % in milliseconds
            trialEndTimeML = MLDataThisTrial.BehavioralCodes.CodeTimes((MLDataThisTrial.BehavioralCodes.CodeNumbers==trialEndCode)); % in milliseconds
            
            numEpochsToUse = floor((trialEndTimeML-trialStartTimeML)/1000);
            goodStimTimesThisTrial = (trialStartTimeML/1000)+(0:numEpochsToUse-1); % Relative to this trial (in seconds)
            
            goodStimTimes = cat(2,goodStimTimes,trialStartTimeBP + goodStimTimesThisTrial); % in seconds
            goodStimTimesML = cat(2,goodStimTimesML,MLDataThisTrial.AbsoluteTrialStartTime/1000 + goodStimTimesThisTrial); % in seconds
            
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
                error('Code numbers do not match');
            end
            
            goodStimPosThisTrial = getGoodStimPosGammaProtocol(digitalEventsThisTrial);
            goodStimTimesThisTrial = codeTimesThisTrialML(goodStimPosThisTrial)/1000; % Relative to this trial (in seconds)
            
            goodStimTimes = cat(2,goodStimTimes,digitalTimeStampsThisTrial(goodStimPosThisTrial)); % in seconds, directly from the BP digital stream
            goodStimTimesML = cat(2,goodStimTimesML,MLDataThisTrial.AbsoluteTrialStartTime/1000 + goodStimTimesThisTrial'); 
        end
        
        % Get and Align eye data
        eyeDataThisTrial = getEyeDataThisTrial(MLDataThisTrial.AnalogData.Eye,goodStimTimesThisTrial); 
        eyeData = cat(1,eyeData,eyeDataThisTrial);
    end
    
    compareBPWithML(goodStimTimes,goodStimTimesML);
    
    % Save useful data in folderExtract
    makeDirectory(folderExtract);
    save(fullfile(folderExtract,'goodStimCodeNums.mat'),'goodStimCodeNums','goodStimTimes');
    save(fullfile(folderExtract,'MLInfo.mat'),'MLConfig','MLTrialRecord');
    save(fullfile(folderExtract,'EyeData.mat'),'eyeData');
    
    % Save segmented data
    getEEGDataBrainProducts(subjectName,expDate,protocolName,folderSourceString,gridType,goodStimTimes,timeStartFromBaseLine,deltaT);
end
end
function goodStimPos = getGoodStimPosGammaProtocol(digitalEvents)
goodCodeNums = 22:29; % Stim codes

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

maxTol = 5; % Must be within 5 ms
if maxD>maxTol
    plot(dTBP,'b'); hold on; plot(dTML,'r');
    error(['max difference in timing: ' num2str(maxD) 'exceeds maxTolerence of ' num2str(maxTol) ' ms']);
else
    disp(['max difference in relative timing: ' num2str(maxD) ' ms']);
end
end
function eyeDataThisTrial = getEyeDataThisTrial(eyeDataML,goodStimTimesThisTrial)
% This assumes that eye data is sampled at 1000 Hz. Needs to be modified for
% general case.

maxEyePos = size(eyeDataML,1);
for k=1:length(goodStimTimesThisTrial)
    pos = round(goodStimTimesThisTrial(k)*1000) + (1:750);
    if max(pos)<=maxEyePos
        eyeDataThisTrial(k,:,:) = eyeDataML(pos,:); %#ok<*AGROW> 
    else
        disp('Trial aborted before time... ');
        posShort = round(goodStimTimesThisTrial(k)*1000):maxEyePos;
        posRemaining = 750-length(posShort);
        for m=1:2
            eyeDataThisTrial(k,:,m) = [eyeDataML(posShort,m); zeros(posRemaining,1)];
        end
    end
end
end