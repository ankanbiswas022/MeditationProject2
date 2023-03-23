% run script for calling the 'saveIndividualSubjectDataMeditation' function
% runs for the given Indexes
% currently, we are passing indexes for the gender and age-matached subjects  

clear; close all

% loades subjectName and experiment dates from the subject DataBase
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
% loads indexes for the gender and age-matached subjects  
load('D:\Projects\MeditationProjects\MeditationProject2\data\savedData\IndexesForMatchedSubject.mat');
segmentTheseIndices = allIndexes(1:3);

% input parameters
 folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';
saveDataFolder = fullfile(folderSourceString,'data','savedData','subjectWise');
badTrialNameStr = '_v8_b30d5';
badElectrodeRejectionFlag = 2; % 1: saves all the electrodes, 2: rejects individual protocolwise 3: rejects common across all protocols
logTransformFlag = 0; % saves log Transformed PSD if 'on'
saveDataFlag = 0; % if 1, saves the data
eegElectrodeList = 1:64;
freqRange = [0 250];
biPolarFlag = 1;

% for the given Subject indexes calls the 'saveIndividualSubjectDataMeditation' and
% saves the data if the saveFlag is on
for i=1:length(segmentTheseIndices)
    subjectName = subjectNames{segmentTheseIndices(i)};
    
    expDate = expDates{segmentTheseIndices(i)};
    
    if biPolarFlag==1
        fileName = ['BipolarPowerDataAllElecs_' subjectName '.mat'];
    else
        fileName = ['PowerDataAllElecs_' subjectName '.mat'];
    end
    
    saveFileName = fullfile(saveDataFolder,fileName);
    if ~exist(saveFileName,'file')
        saveIndividualSubjectDataMeditation(subjectName,expDate,folderSourceString,eegElectrodeList,badTrialNameStr,badElectrodeRejectionFlag,logTransformFlag,freqRange,saveDataFlag,saveFileName,biPolarFlag);
    end
end