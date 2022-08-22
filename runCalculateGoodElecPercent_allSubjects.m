
% runFunction for the calculateGoodElecPercent_allSubjects

dataFolderString = 'D:\Projects\MeditationProjects\MeditationProject2';
% extractTheseIndices = 3:18;

% doing everything for the first 25 subjects:
problamaticSubjectIndex = 53;
segmentTheseIndices = setdiff(3:66,problamaticSubjectIndex) ; % total list as of 6/9/22
extractTheseIndices = segmentTheseIndices;

% removeBadEyeTrialFlag
protName = 'G1';
gridLayout = 6; %2
color_imageSC = 'jet';
calculateGoodElecPercent_allSubjects(dataFolderString,extractTheseIndices,gridLayout,color_imageSC,protName);