% runSegmentAndSaveData

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';

segmentTheseIndices = 1;
impedanceTag = '_Impedance_end';
for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    segmentAndSaveData(subjectName,expDate,folderSourceString); % Segment data
    getImpedanceDataEEG(subjectName,expDate,folderSourceString,gridType,impedanceTag); % Get Impedance
end

