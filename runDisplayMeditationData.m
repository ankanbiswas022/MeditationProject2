% subjectName='008RS';
% expDate='100122';
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
badElectrodeList=[];
plotRawTFFlag=[];
badTrialNameStr='_v5'; 
badElectrodeRejectionFlag=2;

% displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag)

segmentTheseIndices = 16;

for i=1:length(segmentTheseIndices)
    h=figure(segmentTheseIndices(i));
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
%     displayMeditationDataV1(subjectName,expDate,folderSourceString,badTrialNameStr,plotRawTFFlag); %first version
%     displayMeditationDataV2(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag);
    displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag); %working on this
    
%     displayMeditationData(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag) %working on this
%     fileName = [subjectName '_DisplayResultsV1' '.fig'];     fileNamejpeg = [subjectName '_DisplayResultsV1' '.tif'];
%     saveas(h,fileName);
%     saveas(h,fileNamejpeg);
end