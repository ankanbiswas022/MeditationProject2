% to make a (matrix/contour) plot summarizing the bad trials and electrodes
clear; close all
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
badElectrodeList=[];
plotRawTFFlag=[];
badTrialNameStr='_v5';
badElectrodeRejectionFlag=1;
saveFileFlag = 0;
saveDataIndividualSubjectsFlag = 0; % if the flag is on the script would save the data for the given subject list

segmentTheseIndices = 4;

for i=1:length(segmentTheseIndices)
    
    h=figure(segmentTheseIndices(i));
    
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    
    dispBadElecTrialsAcrossProtocols(subjectName,expDate,folderSourceString,badTrialNameStr); %working on this
    
    if saveFileFlag
        fileName = [subjectName '_DisplayResultsV3' '.fig'];
        fileNameTif = [subjectName '_DisplayResultsV3'];
        h.WindowState = 'maximized';
        saveas(h,fileName);
        print(h,fileNameTif,'-dtiff','-r600');
    end
end
