% subjectName='008RS';
% expDate='100122';
clear; close all

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
badElectrodeList=[];
plotRawTFFlag=[];
badTrialNameStr='_v5'; 
badElectrodeRejectionFlag=1;
saveFileFlag = 1;
refScheme = 1; % 2 for bipolar
saveDataIndividualSubjectsFlag = 0; % if the flag is on the script would save the data for the given subject list
% this could not have been included in the segmentAndSaveData because
timeAvgFlag = 1; 
tfFlag = 1; 
% --------------------------------------------------------------------

% displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag)

% segmentTheseIndices = [3:17 19:25];
segmentTheseIndices = 13;

for i=1:length(segmentTheseIndices)
    if ~saveDataIndividualSubjectsFlag     
        h=figure(segmentTheseIndices(i)+1); 
    end
    
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    %     displayMeditationDataV1(subjectName,expDate,folderSourceString,badTrialNameStr,plotRawTFFlag); %first version
    %     displayMeditationDataV2(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag);
    %     displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag); %working on this
    displayMeditationDataV3(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag,refScheme,timeAvgFlag,saveDataIndividualSubjectsFlag,tfFlag); %working on this
%     savePowerDataMeditation(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag,refScheme,saveDataIndividualSubjectsFlag)
    %     displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag) %working on this
        
%     set(h,'outerPosition',[0 0 1 1],'unit','normalized')
if saveFileFlag
    fileName = [subjectName '_DisplayResultsV3' '.fig'];    
    fileNameTif = [subjectName '_DisplayResultsV3'];
    h.WindowState = 'maximized';
    saveas(h,fileName);
    print(h,fileNameTif,'-dtiff','-r600');
end
end