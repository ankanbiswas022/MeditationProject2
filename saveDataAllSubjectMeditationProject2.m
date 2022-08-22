
% save the data for plotting the topoplot:

% to make a summary plot for all subjects
clear; close all
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
% folderSourceString = 'C:\Users\Srishty\OneDrive - Indian Institute of Science\Documents\supratim\meditationProject';
badElectrodeList=[];
plotRawTFFlag=[];
% badTrialNameStr='_v5';
% badTrialNameStr='_d4020_v7';
badTrialNameStrS = {'_d4020_v8','_d4020_v9'};
badElectrodeRejectionFlag=1;
saveFileFlag = 0;
saveDataIndividualSubjectsFlag = 0; % if the flag is on the script would save the data for the given subject list
individualSubjectFigureFlag = 0;  %the flag for bad trial figure for indiviual subjects

% segmentTheseIndices =[3:17 19:28 30:34 36:44 46]; %29 some problem
% segmentTheseIndices = [3:17 19:34 36:44 46] ;
allBadElecs = [];
badElecsGroupWise = [];

% segmentTheseIndices = [3,4,5]; %29 some problem
% segmentTheseIndices = [24]; %29 some problem
% segmentTheseIndices = 3; %29 some problem
SubjectIDs =[3:52 54:66];
% SubjectIDs =[3:10];
protocolName ='G1';
gridType = 'EEG';
refType = [];
capType = [];
nonEEGElectrodes = [65:70];
useCommonBadTrials = [0 1];

for b=1:length(badTrialNameStrS)
    badTrialNameStr=badTrialNameStrS{b};
    for i=1:length(SubjectIDs)
        for j = 1:length(useCommonBadTrials)
            %     h=figure(segmentTheseIndices(i));
            SubjectID = SubjectIDs(i);
            useCommonBadTrial = useCommonBadTrials(j);
            %     subjectName = subjectNames{segmentTheseIndices(i)};
            %     expDate = expDates{segmentTheseIndices(i)};
            %
            getAndSaveValuesGamma(SubjectID,subjectNames,gridType,expDates,protocolName,folderSourceString,nonEEGElectrodes,refType,capType,useCommonBadTrial,badTrialNameStr)
        end
    end
end