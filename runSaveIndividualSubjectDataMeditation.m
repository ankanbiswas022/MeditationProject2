
% to make a summary plot for all subjects
clear; close all
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
badTrialNameStr='_d4020_v10';
badElectrodeRejectionFlag = 2; % 1: saves all the electrodes, 2: rejects individual protocolwise 3: rejects common across all protocols

segmentTheseIndices = [3:10]; %29 some problem

for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    saveIndividualSubjectDataMeditation(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag);
end