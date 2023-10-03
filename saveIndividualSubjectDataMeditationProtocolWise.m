function saveIndividualSubjectDataMeditationProtocolWise(subjectName,expDate,sdParams)
% This function saves the power data for the given subject
%
% Input:
%
% Required: 'subjectName' and 'exprimentDate'
%            loads the extracted data for the given subject
% Optional: Assumes default value s if not provided
%             'folderSourceString','allElectrodeList','badTrialNameStr','badElectrodeRejectionFlag',
%             'logTransformFlag','freqRange','saveDataFlag' and
%             'saveFileName'
%
% Protocols Details:
%   15 minute M1 and M2 protocols were segmented into three 5 minute sub-segments consisting with 120
%   trials each sub-segments sharing the same badElectrodes and bad-trials
%
% Extra notes for segmenting M1/M2 protocols:
%        Segmentation of M1/M2 protocol could be done in two ways, one is by
%        looping through the original 8 protocols and having additional three
%        loops for three different sub-segments.
%        Or, by incorporating the sub-segments in the original protocols
%        list and changing the trial index accordingly. Importantly, while loading,
%        we need to load the original data file for M1/M2.
%        Here, we are taking the second approach.
%
% Other Assignments:
%   NaN values are assigned to the power values of the bad electrodes
%
% Output (saved) data format
%   12*251*64 (protocol x frequencies x electrodes) for individual subject
%
% Uses two local sub-functions
%   'getAllBadElecs' combines all types of bad electrodes
%   'getData' gets the power data
%-----------------------------------------------------------------------------------------
% Updates on 28/03/23:
% Remove the remove the bad trials (from individual electrodes)
% adding flag remove bad trils from individual electrodes!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Unwarpping input paramters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folderSourceString              = sdParams.folderSourceString;
saveDataFolder                  = sdParams.saveDataFolder;
saveFileName                    = sdParams.saveFileName;

badTrialNameStr                 = sdParams.badTrialNameStr;
badElectrodeRejectionFlag       = sdParams.badElectrodeRejectionFlag ; % 1: saves all the electrodes, 2: rejects individual protocolwise 3: rejects common across all protocols
logTransformFlag                = sdParams.logTransformFlag; % saves log Transformed PSD if 'on'
saveDataFlag                    = sdParams.saveDataFlag; % if 1, saves the data
% eegElectrodeList              = sdParams.eegElectrodeList;
freqRange                       = sdParams.freqRange;
biPolarFlag                     = sdParams.biPolarFlag;
removeDeclaredflatPSDElecS      = sdParams.removeVisualInspectedElecs;
removeIndividualUniqueBadTrials = sdParams.removeIndividualUniqueBadTrials;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2; error('Needs Subject Name and experimetent Date'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Default variables %%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('folderSourceString','var');              folderSourceString=[];              end
if ~exist('allElectrodeList','var');                allElectrodeList = 1:64;            end
if ~exist('badTrialNameStr','var');                 badTrialNameStr='_v5';              end
if ~exist('badElectrodeRejectionFlag','var');       badElectrodeRejectionFlag=2;        end
if ~exist('logTransformFlag','var');                logTransformFlag = 0;               end
if ~exist('freqRange','var');                       freqRange = [0 250];                end
if ~exist('saveDataFlag','var');                    saveDataFlag = 0;                   end
if ~exist('saveFileName','var');                    saveFileName=[];                    end
if ~exist('biPolarFlag','var');                     biPolarFlag=0;                      end
if ~exist('removeIndividualUniqueBadTrials','var'); removeIndividualUniqueBadTrials=0;  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
% removeIndividualUniqueBadTrials=1;

% We have total 8 protocols. M1 and M2 is segmented to create M1a,M1b,M1c
% and M2a,M2b,M2c respectively.
segmentNameList = [{'EO1'} {'EC1'} {'G1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}];
% segmentNameList = [{'EO1'} {'EC1'} {'G1'}];
numSegments = length(segmentNameList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%
badTrialsList = cell(1,numSegments);
badElecList = cell(1,numSegments);
badElectrodes.badImpedanceElecs = [];
badElectrodes.noisyElecs = [];
badElectrodes.flatPSDElecs = [];
badElectrodes.declaredflatPSDElecs = [];

for s=1:numSegments
    segmentName=segmentNameList{s};

    badFileName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,segmentName,'segmentedData',['badTrials' badTrialNameStr '.mat']);
    if exist(badFileName,'file')
        x = load(badFileName);
        % temp saving bad trials and bad elecs per protocol
        allBadTrialsList{s} = x.allBadTrials; %1.1c: getting badtrials unique to the electrode
        badTrialsList{s} = x.badTrials;
        badElecList{s}   = x.badElecs;

        badElectrodes.badImpedanceElecs = cat(1,badElectrodes.badImpedanceElecs,x.badElecs.badImpedanceElecs);
        badElectrodes.noisyElecs = cat(1,badElectrodes.noisyElecs,x.badElecs.noisyElecs);
        badElectrodes.flatPSDElecs = cat(1,badElectrodes.flatPSDElecs,x.badElecs.flatPSDElecs);
        if removeDeclaredflatPSDElecS
            badElectrodes.declaredflatPSDElecs = cat(1,badElectrodes.declaredflatPSDElecs,x.badElecs.declaredflatPSDElectrodes);
        end
    else
        badTrialsList{s} = [];
        badElecList{s} = [];
    end
end

% common bad elecs across all the protocols
badElectrodes.badImpedanceElecs = unique(badElectrodes.badImpedanceElecs);
badElectrodes.noisyElecs = unique(badElectrodes.noisyElecs);
badElectrodes.flatPSDElecs = unique(badElectrodes.flatPSDElecs);

% get data across protocols:

timeRangeStrings = {'BL','ST'};
numTimeRange = length(timeRangeStrings);

timeRangeS = {[-1 0],[0.25 1.25]}; % baseLine and stimulus timePeriods
trialIndexesForSubSegments = {(1:120),(121:240),(241:360),(1:360)};

psdVals = cell(1,numSegments);
meanPSDVals = cell(1,numSegments);
meanPSDValsReshaped = [];
freqVals = cell(1,numSegments);
numGoodElectrodesList = zeros(1,numSegments);

for p=1:numSegments

    for t=1:numTimeRange
        timeRange = timeRangeS{t};

        if p==4||p==8
            segmentIndex=4;
        else
            segmentIndex=1; %default segment
        end

        segmentName = segmentNameList{p};
        trialIndexes = trialIndexesForSubSegments{segmentIndex};

        if badElectrodeRejectionFlag==1
            electrodeList = allElectrodeList;
        elseif badElectrodeRejectionFlag==2
            electrodeList = setdiff(allElectrodeList,getAllBadElecs(badElecList{p},removeDeclaredflatPSDElecS));
        elseif badElectrodeRejectionFlag==3
            electrodeList = setdiff(allElectrodeList,getAllBadElecs(badElectrodes,removeDeclaredflatPSDElecS));
        end
        numGoodElectrodesList(p) = length(electrodeList);
        badElecIndexThisProtocol = getAllBadElecs(badElecList{p},removeDeclaredflatPSDElecS);

        % uses local sub-function 'getData' for getting the power data
        if ~isempty(electrodeList)
            disp(['Extracting data of ''' segmentName ''' segment, for the ''' timeRangeStrings{t} ''' period']);
            disp(['for trials- ' num2str(trialIndexes(1)) ':' num2str(trialIndexes(end))]);

            % getting the mean data across trials
            [meanPSDVals{p},freqVals,numGoodTrials,timeVals] = getData(subjectName,expDate,segmentName,folderSourceString,gridType,allElectrodeList,freqRange,timeRange,trialIndexes,logTransformFlag,biPolarFlag,removeIndividualUniqueBadTrials,allBadTrialsList{p},badTrialsList{p});

            % assigning the electrodes as NaN
            meanPSDVals{p}(badElecIndexThisProtocol,:) = NaN;
            meanPSDValsReshaped(p,:,:) = meanPSDVals{p}';
        end

        % stores the power data in different variables for the 'BL' and 'ST' period
        if t==1
            blPowerVsFreqTopo = meanPSDVals{p}';
        else
            stPowerVsFreqTopo = meanPSDVals{p}';
        end
    end
    if saveDataFlag % save data for the current subject
        disp(['Saving the Power data for ' subjectName ' for ' segmentName]);
        dirName = fullfile(saveDataFolder,segmentName);
        if ~exist(dirName, 'dir')
            mkdir(dirName);
        end
        fileNameToSave = fullfile(saveDataFolder,segmentName,saveFileName);
        save(fileNameToSave,'blPowerVsFreqTopo','stPowerVsFreqTopo','freqVals',"timeVals","numGoodTrials");
    end
end


end % the main function end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sub-functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function allBadElecs = getAllBadElecs(badElectrodes,removeDeclaredflatPSDElecS)
% combines different types of bad electrodes
if removeDeclaredflatPSDElecS
    allBadElecs = [badElectrodes.badImpedanceElecs; badElectrodes.noisyElecs; badElectrodes.flatPSDElecs; badElectrodes.declaredflatPSDElectrodes];
else
    allBadElecs = [badElectrodes.badImpedanceElecs; badElectrodes.noisyElecs; badElectrodes.flatPSDElecs];
end
end

function [meanPSDVals,freqVals,numGoodTrials,timeVals] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,electrodeList,freqRange,timeRange,trialIndexS,logTransformFlag,biPolarFlag,removeIndividualUniqueBadTrials,allBadTrialsListElecWise,badTrialsList)
% get the mean PSD values for each individual subjects
if biPolarFlag==1
    capType=  'actiCap64_UOL';
    bipolarLocs = load(fullfile("D:\Programs\ProgramsMAP\Montages\Layouts\"+capType+"\bipChInfo"+capType));
    numElectrodes = length(bipolarLocs.bipolarLocs);
    electrodeList = 1:numElectrodes;
else
    numElectrodes = length(electrodeList);
end

tapers = [1 1];

folderExtract = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'extractedData');
folderSegment = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData');

if ~exist(folderExtract,'file')
    disp([folderExtract ' does not exist']);
    psd = []; freqVals=[];
else
    t = load(fullfile(folderSegment,'LFP','lfpInfo.mat'));
    timeVals = t.timeVals;
    Fs = round(1/(timeVals(2)-timeVals(1)));
    goodTimePos = find(timeVals>=timeRange(1),1) + (1:round(Fs*diff(timeRange)));

    % Sets up multitaper
    params.tapers   = tapers;
    params.pad      = -1;
    params.Fs       = Fs;
    params.fpass    = freqRange;
    params.trialave = 0;

    for i=1:numElectrodes
        if biPolarFlag==1
            analogElecs = bipolarLocs.bipolarLocs(electrodeList(i),:);
            % load the .mat lfp file for the two electrode
            % rejection can happen at this level itself,
            e1 = load(fullfile(folderSegment,'LFP',['elec' num2str(analogElecs(1)) '.mat']));
            e2 = load(fullfile(folderSegment,'LFP',['elec' num2str(analogElecs(2)) '.mat']));

            % substract and put this in the e
            e.analogData = e1.analogData-e2.analogData; %updated e for the bipolar
        else
            e = load(fullfile(folderSegment,'LFP',['elec' num2str(electrodeList(i)) '.mat']));
        end
        [psdTMP(i,:,:),freqVals] = mtspectrumc(e.analogData(trialIndexS,goodTimePos)',params); %#ok<AGROW>
    end

    if logTransformFlag
        psd = log10(squeeze(mean(psdTMP,1)));
    else
        psd = psdTMP; % passing raw PSD to the main function
    end

    % removes bad trials, assigns Nans to the bad electrodes and
    % transforms the data to have the following format: protocol x frequencies x electrodes
    if removeIndividualUniqueBadTrials
        if biPolarFlag
            badTrialsFirstElec = allBadTrialsListElecWise{analogElecs(1)};
            badTrialsSecondElec = allBadTrialsListElecWise{analogElecs(2)};
            commonBadTrials = union(badTrialsFirstElec,badTrialsSecondElec);
        else
            commonBadTrials = allBadTrialsListElecWise{i};
        end
        meanPSDVals = mean(psd(:,:,setdiff(1:size(psd,3),commonBadTrials)),3); % dont remove the bad trials as it has already been removed.
    else
        meanPSDVals = mean(psd(:,:,setdiff(1:size(psd,3),badTrialsList)),3);
        numGoodTrials = length(setdiff(1:size(psd,3),badTrialsList));
    end
end
end