% runSegmentAndSaveData

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
% folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

segmentTheseIndices = 3;
gridType='EEG'; 
capType = 'actiCap64_2019';
impedanceTag = '_Impedance_start'; 
displayFlag=1;
saveEyeDataMtype = 3; % 1-only rawData, 2-only gazeData, 3-both raw and gazeData
FsEye = 1000;

for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    segmentAndSaveData(subjectName,expDate,folderSourceString,saveEyeDataMtype,FsEye); % Segment data
    getImpedanceDataEEG(subjectName,expDate,folderSourceString,gridType,impedanceTag,displayFlag,capType); % Get Impedance
end