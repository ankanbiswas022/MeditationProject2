% runSegmentAndSaveData
clear;clc;close all;
% [subjectName,expDate,~,badEEGElectrodes] = AuditoryEEGData;
[subjectName,expDate] = subjectDatabaseMeditationProject2;

gridType = 'EEG';
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';
FsEye = 1000;
nonEEGElectrodes = 65:70;
impedanceTag = 'ImpedanceAtStart';
capType = 'actiCap64_UOL';
% electrodeGroup = 'Temporal';%'Occipital'
electrodeGroup = 'Occipital';
% checkPeriod =[-0.5 1.5];% [-0.5 0.75];
checkPeriod = [-1 1.25];
useEyeData=0;%1
saveDataFlag = 1;
badTrialNameStr = '_v10';
displayResultsFlag =0;
% checkBaselinePeriod = [-0.70 0];
% protocolName = 'GRF_003';%'G1'
protocolName = 'G1';

SegmentIndex =1:28;

for id = 28%1:length(SegmentIndex)
    %segmentAndSaveData(subjectName{SegmentIndex(id)},expDate{SegmentIndex(id)},folderSourceString,FsEye);% Segment data
%     findBadTrialsWithEEG_v10(subjectName{SegmentIndex(id)},expDate{SegmentIndex(id)},protocolName,folderSourceString,gridType,badEEGElectrodes{SegmentIndex(id)},...
%         nonEEGElectrodes,impedanceTag,capType,electrodeGroup,checkPeriod,useEyeData);
        findBadTrialsWithEEG_v10(subjectName{SegmentIndex(id)},expDate{SegmentIndex(id)},protocolName,folderSourceString,gridType,[],...
        nonEEGElectrodes,impedanceTag,capType,electrodeGroup,checkPeriod,useEyeData);
%     sgtitle(id);
end
