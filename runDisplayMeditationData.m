% subjectName='008RS';
% expDate='100122';
clear; close all

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
badElectrodeList=[];
plotRawTFFlag=[];
badTrialNameStr='_v5'; 
badElectrodeRejectionFlag=1;
saveFileFlag = 0;

% displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag)

segmentTheseIndices = 13;

for i=1:length(segmentTheseIndices)
    h=figure(segmentTheseIndices(i));
    
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    %     displayMeditationDataV1(subjectName,expDate,folderSourceString,badTrialNameStr,plotRawTFFlag); %first version
    %     displayMeditationDataV2(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag);
    %     displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag); %working on this
    displayMeditationDataV3(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag); %working on this
    %     displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag) %working on this
        
%     set(h,'outerPosition',[0 0 1 1],'unit','normalized')
if saveFileFlag
    fileName = [subjectName '_DisplayResultsV1' '.fig'];    
    fileNameTif = [subjectName '_DisplayResultsV1'];
    saveas(h,fileName);
    print(h,fileNameTif,'-dtiff','-r600');
end
end