% Central Data saving code for the meditation Subject
% Ankan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the subject list: load the data
sourcePath = 'N:\Projects\MeditationProjects\MeditationProject2\Codes\codesUnderDevelopment\UpdatedPrograms\badSubjectCodes';
fileName   = 'MeditationProjectSubjectListAC.mat';
load(fullfile(sourcePath,fileName),'allMatchedSubjectList');
allSubjectListAC = allMatchedSubjectList(:);
emptyCells  = cellfun(@isempty,allSubjectListAC(:,1));

badSubIndex = find(strcmp(allSubjectListAC,'099SP')); %badSubject
emptyCells(badSubIndex)=1;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wrapping flags and input parameters
sdParams.folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';
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

sdParams.folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';
saveDataDeafultStr ='subjectWise';
if sdParams.biPolarFlag
    saveFolderName = [saveDataDeafultStr 'Bipolar'];
else
    saveFolderName = [saveDataDeafultStr 'Unipolar'];
end
sdParams.saveDataFolder = fullfile(sdParams.folderSourceString,'data','savedData',saveFolderName);
saveFileNameDeafultStr = ['_unipolar_stRange_250_1250' sdParams.badTrialNameStr '.mat'] ;

% Not extracted 46

for i=1:length(saveTheseIndices)
    subjectName = subjectNames{saveTheseIndices(i)};
    disp(['Working on the '  subjectName]);
    expDate = expDates{saveTheseIndices(i)};

    sdParams.saveFileName = [subjectName saveFileNameDeafultStr];
    saveIndividualSubjectDataMeditationProtocolWise(subjectName,expDate,sdParams);
end