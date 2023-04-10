clear; close all

[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString      ='D:\Projects\MeditationProjects\MeditationProject2';

badElectrodeList = [];
plotRawTFFlag    = [];

saveFileFlag     = 0;
refScheme        = 1; % 2 for bipolar
timeAvgFlag      = 1;
tfFlag           = 1;

segmentTheseIndices = 3;
badTrialNameStr     ='_v8_b30d5';
saveDataIndividualSubjectsFlag = 0; % if the flag is on the script would save the data for the given subject list
badElectrodeRejectionFlag      = 1; % 1: Don't reject badElectrodes, 
                                    % 2: reject badElectrodes for that protocol,
                                    % 3: Reject badElectrodes common across all the protocols
for i=1:length(segmentTheseIndices)
    if ~saveDataIndividualSubjectsFlag
        h=figure(segmentTheseIndices(i)+1);
    end
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)}; 
    displayMeditationDataV3(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag,refScheme,timeAvgFlag,saveDataIndividualSubjectsFlag,tfFlag); %working on this
 
    if saveFileFlag
        set(h,'outerPosition',[0 0 1 1],'unit','normalized')
        fileName = [subjectName '_DisplayResultsV3' '.fig'];
        fileNameTif = [subjectName '_DisplayResultsV3'];
        h.WindowState = 'maximized';
        saveas(h,fileName);
        print(h,fileNameTif,'-dtiff','-r600');
    end
end