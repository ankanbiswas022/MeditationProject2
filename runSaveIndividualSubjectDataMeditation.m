% run script for calling the 'saveIndividualSubjectDataMeditation' function
% runs for the given Indexes
% currently, we are passing indexes for the gender and age-matached subjects

% runLog:
%------------
% ToDo:
% (1) add saveTF (done)
clear; close all
tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%
% sourcePath = 'N:\Projects\MeditationProjects\MeditationProject2\Codes\codesUnderDevelopment\UpdatedPrograms\badSubjectCodes';
sourcePath = 'D:\Projects\MeditationProjects\MeditationProject2\CommonPrograms\badSubjectCodes';
fileName   = 'MeditationProjectSubjectListAC.mat';
load(fullfile(sourcePath,fileName),'allMatchedSubjectList');
allSubjectListAC = allMatchedSubjectList(:);
emptyCells  = cellfun(@isempty,allSubjectListAC(:,1));

% badSubIndex = find(strcmp(allSubjectListAC,'099SP')); %badSubject
% emptyCells(badSubIndex)=1;

allSubjectListAC(emptyCells) = [];

% Alternatively, we can get this directly from the following:
% Get the Indexes of the matched subject
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
allIndexes=[];
for i=1:length(allSubjectListAC)
    strToFind = allSubjectListAC{i};
    disp(allSubjectListAC{i});
    ind=find(strcmp(strToFind,subjectNames));
    disp(ind);
    allIndexes = [allIndexes ind];
end

allMatchedSubjectIndex = allIndexes';
saveTheseIndices = allMatchedSubjectIndex(1:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%

%% loades subjectName and experiment dates from the subject DataBase
% [subjectNames,expDates] = subjectDatabaseMeditationProject2;
% % loads indexes for the gender and age-matached subjects
% load('D:\Projects\MeditationProjects\MeditationProject2\data\savedData\IndexesForMatchedSubject.mat');
% saveTheseIndices = allIndexes(end);

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
sdParams.removeIndividualUniqueBadTrials=0;
sdParams.removeVisualInspectedElecs = 0;
sdParams.saveDataFlagProtocolwise = 1;

%% save file location
sdParams.folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

saveDataDeafultStr ='subjectWise';

if sdParams.biPolarFlag
    saveDataDeafultStr = [saveDataDeafultStr 'Bipolar'];
    saveFileNameDeafultStr = ['_bipolar_stRange_250_1250' sdParams.badTrialNameStr '.mat'] ;
else
    saveDataDeafultStr = [saveDataDeafultStr 'Unipolar'];
    saveFileNameDeafultStr = ['_unipolar_stRange_250_1250' sdParams.badTrialNameStr '.mat'] ;
end

if sdParams.removeIndividualUniqueBadTrials
    saveFolderName = [saveDataDeafultStr 'BadTrialIndElec'];
else %default foldername
    saveFolderName = [saveDataDeafultStr 'BadTrialComElec'];
end

if sdParams.removeVisualInspectedElecs
    saveFolderName = [saveFolderName 'VisualInspRemoved'];
else
    saveFolderName = [saveFolderName 'VisualInspNotRemoved'];
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
        sdParams.saveFileNameProtocolWise = [subjectName saveFileNameDeafultStr];
        % if ~exist(sdParams.saveFileName,'file')
        saveIndividualSubjectDataMeditation(subjectName,expDate,sdParams);
        % end

    end
    sdParams.elapsedTime = toc;
    disp('All the data saved successfully');
    disp(['It took'  string(sdParams.elapsedTime) ' to run the function']);
    save(sdParams.saveFileName,'sdParams',"-append");
else
    disp("Please check the input parameters carefully before procedding!");
end