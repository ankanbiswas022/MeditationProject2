% this function extracts the power data for each subject
% and saves individual subjectwise

% Notes:
% M1 and M2 was broken into three 5 minute segments consiting of 120 trials
% but all the sub-segments share the same badElectrodes

% saving the data
% assign NaN values to the empty electrode list
% reshaping the psdvals to save in the format
% of 12*251*64 (protocol x freQuencies x electrodes) for a single subject

% input data:
% each Subject's extracted data

% output Data Structure:
% 12*251*64 (protocol x freQuencies x electrodes) for a single subject
%----------------------------------------------------------------------------------------------------

function saveIndividualSubjectDataMeditation(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag)

if ~exist('folderSourceString','var');              folderSourceString=[];                          end
if ~exist('badElectrodeList','var');                badTrialNameStr='_v5';                          end
if ~exist('badElectrodeRejectionFlag','var'); badElectrodeRejectionFlag=2;  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
% capType = 'actiCap64_2019';
capType = 'actiCap64_UOL';

protocolNameList = [{'EO1'}  {'EC1'}  {'G1'}  {'M1a'}  {'M1b'}  {'M1c'}   {'G2'}  {'EO2'}  {'EC2'}  {'M2a'} {'M2b'} {'M2c'}];
numProtocols = length(protocolNameList);

% display bad electrodes for all protocols and also generate common bad electrodes
badTrialsList = cell(1,numProtocols);
badElecList = cell(1,numProtocols);
badElectrodes.badImpedanceElecs = [];
badElectrodes.noisyElecs = [];
badElectrodes.flatPSDElecs = [];

for p=1:numProtocols
    protocolName=protocolNameList{p};
    
    if contains(protocolName,'M1')
        protocolName='M1';
    elseif contains(protocolName,'M2')
        protocolName='M2';
    end
    
    badFileName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData',['badTrials' badTrialNameStr '.mat']);
    if exist(badFileName,'file')
        x=load(badFileName);
        % temp saving bad trials and bad elecs per protocol
        badTrialsList{p}=x.badTrials;
        badElecList{p} = x.badElecs;
        badElectrodes.badImpedanceElecs = cat(1,badElectrodes.badImpedanceElecs,x.badElecs.badImpedanceElecs);
        badElectrodes.noisyElecs = cat(1,badElectrodes.noisyElecs,x.badElecs.noisyElecs);
        badElectrodes.flatPSDElecs = cat(1,badElectrodes.flatPSDElecs,x.badElecs.flatPSDElecs);
    else
        badTrialsList{p}=[];
        badElecList{p} = [];
    end
end

% common bad elecs across all the protocols
badElectrodes.badImpedanceElecs = unique(badElectrodes.badImpedanceElecs);
badElectrodes.noisyElecs = unique(badElectrodes.noisyElecs);
badElectrodes.flatPSDElecs = unique(badElectrodes.flatPSDElecs);

% get data across protocols:

freqPoints = 251;
allElectrodeList = 1:64;

timeRangeStrings = {'BL','ST'};
numTimeRange = length(timeRangeStrings);

timeRangeS = {[-1 0],[0.25 1.25]};
numAllElectrodes = length(allElectrodeList);

trialIndexesForMedSubSeg = {(1:120),(121:240),(241:360)};
% numMedSubSegments = length(trialIndexesForMedSubSeg);

psdVals = cell(1,numProtocols);
meanPSDVals = cell(1,numProtocols);
meanPSDValsReshaped = zeros(numProtocols,freqPoints,numAllElectrodes);
freqVals = cell(1,numProtocols);
numGoodElectrodesList = zeros(1,numProtocols);

for t=1:numTimeRange
    timeRange = timeRangeS{t};
    
    s=1;
    trialIndexS = trialIndexesForMedSubSeg{s};
    for p=1:numProtocols
        protocolName = protocolNameList{p};
        disp(['Extracting the data for ' protocolName ' :' timeRangeStrings{t}]);
        if contains(protocolName,'M1')
            protocolName='M1';
        elseif contains(protocolName,'M2')
            protocolName='M2';
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
        
        if ~isempty(electrodeList)
            disp(['for trials. ' num2str(trialIndexS(1)) ':' num2str(trialIndexS(end))]);
            [psdVals{p},freqVals{p}] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,allElectrodeList,timeRange,trialIndexS);
            %-----saving the data
            meanPSDVals{p} = mean(psdVals{p}(:,:,setdiff(1:size(psdVals{p},3),badTrialsList{p})),3);
            meanPSDVals{p}(badElecIndexThisProtocol,:)=NaN;
            meanPSDValsFlipped =  meanPSDVals{p}';
            meanPSDValsReshaped(p,:,:) = meanPSDValsFlipped;
        end
        
        %-- conditions for M segements
        if contains(protocolName,'M') && s<4
            s=s+1;
            if s<4
                trialIndexS = trialIndexesForMedSubSeg{s};
            end
        end
        if s==4 % back to Normal
            s=1;
            trialIndexS = trialIndexesForMedSubSeg{s};            
        end
    end
    
    if t==1
        powerValBL = meanPSDValsReshaped;
    else
        powerValST = meanPSDValsReshaped;
    end
end

% save data for the subject
saveDataFolder = fullfile(folderSourceString,'data','savedData','subjectWise');
fileName = ['PowerDataAllElecs_' subjectName '.mat'];
saveFileName = fullfile(saveDataFolder,fileName);
disp(['Saving the Power data for ' subjectName]);
save(saveFileName,'powerValBL','powerValST','freqVals');

end % the main function end

function allBadElecs = getAllBadElecs(badElectrodes)
allBadElecs = [badElectrodes.badImpedanceElecs; badElectrodes.noisyElecs; badElectrodes.flatPSDElecs];
end

function [psd,freqVals] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,electrodeList,timeRange,trialIndexS)

% timeRange = [0.25 1.25];
tapers = [1 1];
freqRange = [0 250];

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
    
    % Set up multitaper
    params.tapers   = tapers;
    params.pad      = -1;
    params.Fs       = Fs;
    params.fpass    = freqRange;
    params.trialave = 0;
    
    for i=1:numElectrodes
        e = load(fullfile(folderSegment,'LFP',['elec' num2str(electrodeList(i)) '.mat']));
        [psdTMP(i,:,:),freqVals] = mtspectrumc(e.analogData(trialIndexS,goodTimePos)',params); %#ok<AGROW>
    end
    %     psd = log10(squeeze(mean(psdTMP,1)));
    psd = psdTMP;
end
end