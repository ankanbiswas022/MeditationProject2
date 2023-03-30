% run script for calling the 'saveIndividualSubjectDataMeditation' function
% runs for the given Indexes
% currently, we are passing indexes for the gender and age-matached subjects

% runLog:
%------------
% ToDo:
% (1) add saveTF

clear; close all
tic
%% loades subjectName and experiment dates from the subject DataBase
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
% loads indexes for the gender and age-matached subjects
load('D:\Projects\MeditationProjects\MeditationProject2\data\savedData\IndexesForMatchedSubject.mat');
saveTheseIndices = allIndexes(1:end);

%% wrapping flags and input parameters
sdParams.subjectNames = subjectNames;
sdParams.expDates = expDates;
sdParams.saveTheseIndices = saveTheseIndices;
sdParams.badTrialNameStr = '_v8_b30d5';
sdParams.badElectrodeRejectionFlag = 2; % 1: saves all the electrodes, 2: rejects individual protocolwise 3: rejects common across all protocols
sdParams.logTransformFlag = 0; % saves log Transformed PSD if 'on'
sdParams.saveDataFlag = 1; % if 1, saves the data
sdParams.eegElectrodeList = 1:64;
sdParams.freqRange = [0 250];
sdParams.biPolarFlag = 0;
sdParams.removeIndividualUniqueBadTrials=1;


%% save file location
sdParams.folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

saveDataDeafultStr ='subjectWise';

if sdParams.biPolarFlag
    saveDataDeafultStr = [saveDataDeafultStr 'Bipolar'];
else
    saveDataDeafultStr = [saveDataDeafultStr 'Unipolar'];
end

if sdParams.removeIndividualUniqueBadTrials
    saveFolderName = [saveDataDeafultStr 'BadTrialIndElec'];
else %default foldername
    saveFolderName = [saveDataDeafultStr 'BadTrialComElec'];
end

sdParams.saveDataFolder = fullfile(sdParams.folderSourceString,'data','savedData',saveFolderName);

% if the saveData folder does not exist make it:
if ~isfolder(sdParams.saveDataFolder)
    disp('Making the saveData folder');
    mkdir(sdParams.saveDataFolder);
end

%% display the parameters and check for it:
disp(sdParams);
reply = input('Have you checked all the flags? Y/N [Y]: ', 's');
if isempty(reply)
    reply = 'N';
end
if reply=='Y'
    sdParams.check = 1;
    for i=1:length(saveTheseIndices)
        subjectName = subjectNames{saveTheseIndices(i)};
        disp(['Working on the '  subjectName]);
        expDate = expDates{saveTheseIndices(i)};
        if sdParams.biPolarFlag==1
            fileName = ['BipolarPowerDataAllElecs_' subjectName '.mat'];
        else
            fileName = ['PowerDataAllElecs_' subjectName '.mat'];
        end
        sdParams.saveFileName = fullfile(sdParams.saveDataFolder,fileName);
        if ~exist(sdParams.saveFileName,'file')
             saveIndividualSubjectDataMeditation(subjectName,expDate,sdParams);
        end
    end
    sdParams.elapsedTime = toc;
    disp('All the data saved successfully');
    disp(['It took'  string(sdParams.elapsedTime) ' to run the function']);
    save(sdParams.saveFileName,'sdParams',"-append");
else
    disp("Please check the input parameters carefully before procedding!");
end

