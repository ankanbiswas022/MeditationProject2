function saveIndividualSubjectDataMeditation(subjectName,expDate,folderSourceString,allElectrodeList,badTrialNameStr,badElectrodeRejectionFlag,logTransformFlag,freqRange,saveDataFlag,saveFileName)
% This function saves the power data for the given subject
%
% Input:
%
% Required: 'subjectName' and 'exprimentDate'
%            loads the extracted data for the given subject
% Optional: Assumes default values if not provided
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2; error('Needs Subject Name and experimetent Date'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Default variables %%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('folderSourceString','var');          folderSourceString=[];          end
if ~exist('allElectrodeList','var');            allElectrodeList = 1:64;        end
if ~exist('badTrialNameStr','var');             badTrialNameStr='_v5';          end
if ~exist('badElectrodeRejectionFlag','var');   badElectrodeRejectionFlag=2;    end
if ~exist('logTransformFlag','var');            logTransformFlag = 0;           end
if ~exist('freqRange','var');                   freqRange = [0 250];            end
if ~exist('saveDataFlag','var');                saveDataFlag = 0;               end
if ~exist('saveFileName','var');                saveFileName=[];                end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';

% We have total 8 protocols. M1 and M2 is segmented to create M1a,M1b,M1c
% and M2a,M2b,M2c respectively. 
segmentNameList = [{'EO1'} {'EC1'} {'G1'} {'M1a'} {'M1b'} {'M1c'} {'G2'} {'EO2'} {'EC2'} {'M2a'} {'M2b'} {'M2c'}];
numSegments = length(segmentNameList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%
badTrialsList = cell(1,numSegments);
badElecList = cell(1,numSegments);
badElectrodes.badImpedanceElecs = [];
badElectrodes.noisyElecs = [];
badElectrodes.flatPSDElecs = [];

for s=1:numSegments
    segmentName=segmentNameList{s};
    % for sub-segments M1a,M1b,M1c, loads the same badTrial file as M1/M2
    if contains(segmentName,'M1')
        segmentName='M1';
    elseif contains(segmentName,'M2')
        segmentName='M2';
    end
    badFileName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,segmentName,'segmentedData',['badTrials' badTrialNameStr '.mat']);
    if exist(badFileName,'file')
        x = load(badFileName);
        % temp saving bad trials and bad elecs per protocol
        badTrialsList{s} = x.badTrials;
        badElecList{s} = x.badElecs;
        badElectrodes.badImpedanceElecs = cat(1,badElectrodes.badImpedanceElecs,x.badElecs.badImpedanceElecs);
        badElectrodes.noisyElecs = cat(1,badElectrodes.noisyElecs,x.badElecs.noisyElecs);
        badElectrodes.flatPSDElecs = cat(1,badElectrodes.flatPSDElecs,x.badElecs.flatPSDElecs);
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
trialIndexesForSubSegments = {(1:120),(121:240),(241:360)};

psdVals = cell(1,numSegments);
meanPSDVals = cell(1,numSegments);
meanPSDValsReshaped = [];
freqVals = cell(1,numSegments);
numGoodElectrodesList = zeros(1,numSegments);

for t=1:numTimeRange    
    timeRange = timeRangeS{t};
    segmentIndex=1; %default segment
    
    for p=1:numSegments
        segmentName = segmentNameList{p};
        trialIndexes = trialIndexesForSubSegments{segmentIndex};         
        
        % for sub-segments M1a,M1b,M1c, we use the same protocol, M1/M2
        if contains(segmentName,'M1')
            segmentName = 'M1';
        elseif contains(segmentName,'M2')
            segmentName = 'M2';
        end
        
        if badElectrodeRejectionFlag==1
            electrodeList = allElectrodeList;
        elseif badElectrodeRejectionFlag==2
            electrodeList = setdiff(allElectrodeList,getAllBadElecs(badElecList{p}));
        elseif badElectrodeRejectionFlag==3
            electrodeList = setdiff(allElectrodeList,getAllBadElecs(badElectrodes));
        end
        numGoodElectrodesList(p) = length(electrodeList);
        badElecIndexThisProtocol = getAllBadElecs(badElecList{p});
        
        % uses local sub-function 'getData' for getting the power data
        if ~isempty(electrodeList)            
            disp(['Extracting data of ''' segmentName ''' segment, for the ''' timeRangeStrings{t} ''' period']);
            disp(['for trials- ' num2str(trialIndexes(1)) ':' num2str(trialIndexes(end))]);
      
            [psdVals{p},freqVals] = getData(subjectName,expDate,segmentName,folderSourceString,gridType,allElectrodeList,freqRange,timeRange,trialIndexes,logTransformFlag);
            
            % removes bad trials, assigns Nans to the bad electrodes and
            % transforms the data to have the following format: protocol x frequencies x electrodes
            meanPSDVals{p} = mean(psdVals{p}(:,:,setdiff(1:size(psdVals{p},3),badTrialsList{p})),3);
            meanPSDVals{p}(badElecIndexThisProtocol,:) = NaN;
            meanPSDValsReshaped(p,:,:) = meanPSDVals{p}';
        end
        
        % conditions for M segments
        % changing 'medSegmentIndex' to select the particular trial-block
        if contains(segmentName,'M') && segmentIndex<4
            segmentIndex = segmentIndex+1;
            if segmentIndex == 4 % switch back to the default value
                segmentIndex = 1;
            end
        end    
    end
    
    % stores the power data in different variables for the 'BL' and 'ST' period
    if t==1
        powerValBL = meanPSDValsReshaped;
    else
        powerValST = meanPSDValsReshaped;
    end
end

if saveDataFlag % save data for the current subject
    disp(['Saving the Power data for ' subjectName]);
    save(saveFileName,'powerValBL','powerValST','freqVals');
end
end % the main function end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sub-functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function allBadElecs = getAllBadElecs(badElectrodes)
% combines different types of bad electrodes
allBadElecs = [badElectrodes.badImpedanceElecs; badElectrodes.noisyElecs; badElectrodes.flatPSDElecs];
end

function [psd,freqVals] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,electrodeList,freqRange,timeRange,trialIndexS,logTransformFlag)

tapers = [1 1];

folderExtract = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'extractedData');
folderSegment = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData');

if ~exist(folderExtract,'file')
    disp([folderExtract ' does not exist']);
    psd = []; freqVals=[];
else
    numElectrodes = length(electrodeList);
    
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
        e = load(fullfile(folderSegment,'LFP',['elec' num2str(electrodeList(i)) '.mat']));
        [psdTMP(i,:,:),freqVals] = mtspectrumc(e.analogData(trialIndexS,goodTimePos)',params); %#ok<AGROW>
    end
    
    if logTransformFlag
        psd = log10(squeeze(mean(psdTMP,1)));
    else
        psd = psdTMP; % passing raw PSD to the main function
    end
end
end