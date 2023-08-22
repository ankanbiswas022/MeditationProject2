
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
% folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

% problamaticSubjectIndex = 53;
% segmentTheseIndices = setdiff(3:66,problamaticSubjectIndex) ; % total list as of 6/9/22

% doing everything for the first 25 subjects:
problamaticSubjectIndex = 53;
segmentTheseIndices = setdiff(3:101,problamaticSubjectIndex) ; % total list as of 6/9/22
% segmentTheseIndices = setdiff(3:66,problamaticSubjectIndex) ; % total list as of 6/9/22

gridType = 'EEG';
nonEEGElectrodes = 65:80;
impedanceTag = '_Impedance_Start';
capType = 'actiCap64_UOL';
saveDataFlag = 1;
badTrialNameStrS = {'_v8_b30d5_cb'}; % with the 5 deg window
% badTrialNameStr = '_d4020_v7_flatPsd'; % check once again, '_d4020_v7_flatPsd';
% badTrialNameStr = '_d4020'; % check once again, '_d4020_v7_flatPsd';
% badTrialNameStrS = {'_d4020_v7'}; % check once again, '_d4020_v7_flatPsd';
displayResultsFlag = 0;
electrodeGroup = ''; % by default, highPriorityElectrodes are used in this case
% checkPeriod = [-1.25 1.25];
checkPeriod = [-1 1.25]; % modifiedCheckPeriod after excluding the initial 250ms which might have lots of bad eye epochs
checkBaselinePeriod = checkPeriod;
badEEGElectrodes = [];

useEyeData =       [1       0       ];
protocolNameList = [{'EO1'} {'EC1'} ];

% useEyeData =       [1       0     1      1      1       0       1     ];
% protocolNameList = [{'EO1'} {'EC1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}];

% useEyeData = 1;
% protocolNameList = {'G1'};
% segmentTheseIndices = 4;
for b = 1:length(badTrialNameStrS)
    badTrialNameStr=badTrialNameStrS{b};
    for i=1:length(segmentTheseIndices)
        subjectName = subjectNames{segmentTheseIndices(i)};
        expDate = expDates{segmentTheseIndices(i)};
        
        for j=1:length(protocolNameList)
            protocolName = protocolNameList{j};
            useEyeDataFlag = useEyeData(j);
            %             findBadTrialsWithEEG_v10(subjectName,expDate,protocolName,folderSourceString,gridType, ...
            %                 badEEGElectrodes,nonEEGElectrodes,impedanceTag,capType,saveDataFlag,badTrialNameStr,displayResultsFlag,electrodeGroup,checkPeriod,checkBaselinePeriod,useEyeData);
            findBadTrialsWithEEG(subjectName,expDate,protocolName,folderSourceString,gridType,badEEGElectrodes,...
    nonEEGElectrodes,impedanceTag,capType,saveDataFlag,badTrialNameStr,displayResultsFlag,electrodeGroup,checkPeriod,checkBaselinePeriod,useEyeDataFlag);

        end
    end
end

