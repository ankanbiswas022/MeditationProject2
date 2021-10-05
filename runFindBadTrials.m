% Things to do

% Make Montage of the new ActiCap64
% Save eye data appropriately

% Display bad eye and bad trials in the display plot
% Plot time series of power in alpha and gamma bands

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';

segmentTheseIndices = 1;
gridType = 'EEG';
capType = 'actiCap64';
badElectrodes0 = 65:80;
protocolNameList = [{'EO1'} {'EC1'} {'G1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}];

for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    
    for j=1:length(protocolNameList)
        protocolName = protocolNameList{j}; 
        [badTrials,allBadTrials,badTrialsUnique,badElecs,totalTrials,slopeValsVsFreq] = findBadTrialsWithEEG(subjectName,expDate,protocolName,folderSourceString,gridType,capType,badElectrodes0);
    end
end
