
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
% folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

segmentTheseIndices = 28;
gridType = 'EEG';
nonEEGElectrodes = 65:80;
impedanceTag = '_Impedance_Start'; 
capType = 'actiCap64_UOL';
saveDataFlag = 1;
badTrialNameStr = '_v5';
displayResultsFlag = 0;
electrodeGroup = ''; % by default, highPriorityElectrodes are used in this case
checkPeriod = [-1.25 1.25];
checkBaselinePeriod = [-1 0];

useEyeData =       [1       0       1      1      1      1       0       1     ];
protocolNameList = [{'EO1'} {'EC1'} {'G1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}];

for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    
    for j=1:length(protocolNameList)
        protocolName = protocolNameList{j}; 
        findBadTrialsWithEEG(subjectName,expDate,protocolName,folderSourceString,gridType,[],nonEEGElectrodes,impedanceTag,capType,...
            saveDataFlag,badTrialNameStr,displayResultsFlag,electrodeGroup,checkPeriod,checkBaselinePeriod,useEyeData(j));
    end
end