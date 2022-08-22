function [analogData,goodChannels] = saveAvgRef(folderSourceString,subjectName,gridType,expDate,protocolName,nonEEGElectrodes,BadTrialNameStr)

folderName = string(fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName));
folderExtract = fullfile(folderName,'extractedData');
folderSegment = fullfile(folderName,'segmentedData');
folderLFP = fullfile(folderSegment,'LFP');

% loading badtrial file
% Get bad trials
fileName = ['badTrials' BadTrialNameStr '.mat'];
badTrialFile = fullfile(folderSegment,fileName);
if ~exist(badTrialFile,'file')
    disp('Bad trial file does not exist...');
    badTrials=[];
else
    badTrials = load(badTrialFile);
end

allTrials = 1:1:badTrials.totalTrials ;
allbadTrials = union(badTrials.badTrials,badTrials.badTrialsUnique.badEyeTrials);
%disp([num2str(length(allbadTrials)) ' bad trials']);

%getting bad Elecs
allbadElecs= unique([badTrials.badElecs.badImpedanceElecs;badTrials.badElecs.flatPSDElecs;badTrials.badElecs.declaredBadElectrodes;badTrials.badElecs.noisyElecs]);

x = load(fullfile(folderLFP,'lfpInfo.mat'));
AllElectrode=setdiff(sort(x.analogChannelsStored),nonEEGElectrodes);
goodChannels = setdiff(AllElectrode,allbadElecs);


all_elec_Data = [];
for i = 1:length(goodChannels)%elecs
    clear ElectrodeData 
    ElectrodeData = load(fullfile(folderLFP, ['elec' num2str(goodChannels(i)) '.mat']));
    ElectrodeData.analogData(allbadTrials,:) = NaN;  
    all_elec_Data(i,:,:) = ElectrodeData.analogData;
end

analogData= squeeze(mean(all_elec_Data,1,'omitNaN'));% average across good electrodes
analogData(allbadTrials,:)= 0;
savefileName = '\AvgRef.mat';
save(fullfile(folderLFP,savefileName),'analogData','goodChannels');
end