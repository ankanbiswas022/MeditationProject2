% run script for calling the 'saveIndividualSubjectDataMeditation' function
% runs for the given Indexes
% currently, we are passing indexes for the gender and age-matached subjects  

clear; close all

% loades subjectName and experiment dates from the subject DataBase
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
% loads indexes for the gender and age-matached subjects  
load('D:\Projects\MeditationProjects\MeditationProject2\data\savedData\IndexesForMatchedSubject.mat');
segmentTheseIndices = allIndexes;

% input parameters
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';
saveDataFolder = fullfile(folderSourceString,'data','savedData','subjectWise');
badTrialNameStr = '_d4020_v10';
badElectrodeRejectionFlag = 2; % 1: saves all the electrodes, 2: rejects individual protocolwise 3: rejects common across all protocols
logTransformFlag = 0; % saves log Transformed PSD if 'on'
saveDataFlag = 1; % if 1, saves the data
eegElectrodeList = 1:64;
freqRange = [0 250];

% for the given Subject indexes calls the 'saveIndividualSubjectDataMeditation' and
% saves the data if the saveFlag is on
for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    fileName = ['PowerDataAllElecs_' subjectName '.mat'];
    saveFileName = fullfile(saveDataFolder,fileName);
    if ~exist(saveFileName,'file')
        saveIndividualSubjectDataMeditation(subjectName,expDate,folderSourceString,eegElectrodeList,badTrialNameStr,badElectrodeRejectionFlag,logTransformFlag,freqRange,saveDataFlag,saveFileName);
    end
end