% runSegmentAndSaveData

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
% networkDriveLocation = 'N:\Projects\MeditationProjects\MeditationProject2' ;
% subjectDataBaseFileName = fullfile(networkDriveLocation,'SubjectInformation','subjectDatabaseMeditationProject2.m');
% [subjectNames,expDates] = load(subjectDataBaseFileName);

% folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

segmentTheseIndices = 52;
gridType = 'EEG'; 
capType = 'actiCap64_2019';
impedanceTag = '_Impedance_Start'; 
displayFlag = 1;
FsEye = 1000;

for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    subjectNameStr=['Extracting Subject No.' subjectName];
    disp(subjectNameStr);
    expDate = expDates{segmentTheseIndices(i)};
    segmentAndSaveData(subjectName,expDate,folderSourceString,FsEye); % Segment data
    getImpedanceDataEEG(subjectName,expDate,folderSourceString,gridType,impedanceTag,displayFlag,capType); % Get Impedance
end