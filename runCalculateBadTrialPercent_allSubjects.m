
dataFolderString ='D:\Projects\MeditationProjects\MeditationProject2'; %give folder path to access the processed data

%give indices of subjects
% extractTheseIndices= 3:26;

% doing everything for the first 25 subjects:
problamaticSubjectIndex = 53;
segmentTheseIndices = setdiff(3:66,problamaticSubjectIndex) ; % total list as of 6/9/22
extractTheseIndices = segmentTheseIndices;
% give flag to remove bad eye trials
removeBadEyeTrialFlag =[0,1];

saveFigureLocation = 'D:\Projects\MeditationProjects\MeditationProject2\Results\badTrialPercentage\percentage';
saveFigureFlag = 1;

protName ='G1';

% the main function to display and save the figure in the specified
% location

calculateBadTrialPercent_allSubjects_v2(dataFolderString,extractTheseIndices,removeBadEyeTrialFlag,protName,saveFigureLocation,saveFigureFlag);

