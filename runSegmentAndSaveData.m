% runSegmentAndSaveData

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

segmentTheseIndices = 3;
gridType='EEG';
impedanceTag = '_Impedance_end';
saveEyeDataMtype = 3; % 1-only rawData, 2-only gazeData, 3-both raw and gazeData
for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    segmentAndSaveData(subjectName,expDate,folderSourceString,saveEyeDataMtype); % Segment data
    getImpedanceDataEEG(subjectName,expDate,folderSourceString,gridType,impedanceTag); % Get Impedance
end