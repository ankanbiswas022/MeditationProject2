% to make a summary plot for all subjects
clear; close all
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
% folderSourceString = 'C:\Users\Srishty\OneDrive - Indian Institute of Science\Documents\supratim\meditationProject';
badElectrodeList=[];
plotRawTFFlag=[];
badTrialNameStr='_d4020_v10';
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
segmentTheseIndices = [3:10]; %29 some problem

for i=1:length(segmentTheseIndices)
    
    h=figure(segmentTheseIndices(i));
    
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    
    [allBadElecs(i,:),badElecsGroupWise(i,:,:)] = dispBadElecTrialsAcrossProtocols(subjectName,expDate,folderSourceString,badTrialNameStr,individualSubjectFigureFlag); %working on this
   
end


% %%data for plotting
% 
% %%%fixed variables%%%%%%
% allElectrodeList = 1:64;
% numElectrodes = length(allElectrodeList);
% protocolNameList = [{'EO1'}     {'EC1'}     {'G1'}      {'M1'}          {'G2'}      {'EO2'}     {'EC2'}     {'M2'}];
% numProtocols = length(protocolNameList);
% 
% [~,~,~,electrodeGroupList,groupNameList,highPriorityElectrodeNums] = electrodePositionOnGrid(64,'EEG',subjectName,6);
%     electrodeGroupList{length(electrodeGroupList)+1} = highPriorityElectrodeNums;
%     groupNameList{length(groupNameList)+1} = 'highPriority';
% 
%  proportionAllBadElecs = allBadElecs./length(allElectrodeList);
% 
%  for k=1:length(electrodeGroupList)
%      proportionBadElecsGroupWise(:,:,k) = badElecsGroupWise(:,:,k)./length(electrodeGroupList{k});
%  end
% 
% for j=1:numProtocols
%     subplot(3,4,j)
%     stem(segmentTheseIndices,proportionAllBadElecs(:,j),'color',[0.5 0.5 0.5]); axis('tight'); hold on
%     stem(segmentTheseIndices,proportionBadElecsGroupWise(:,j,6),'color',[0.8 0 0]); axis('tight'); hold on %high priority
%     stem(segmentTheseIndices,proportionBadElecsGroupWise(:,j,4),'color',[0 0.8 0]); axis('tight'); hold on %frontal
%     yline(0.3,'--');
%     xlim([1 segmentTheseIndices(end)+1]); ylim([0 1]);
%     title(protocolNameList{j});
%     if j==4
%         legend('All','High Priority','Frontal','location','best');
%     elseif j==5
%         xlabel('Subject Index');  ylabel('Proportion of Bad Electrode');
%     end
% end
% 
% sgtitle('Bad Electrodes across Subjects','FontSize',18);
% 
% thresholdForBadSubjetRejection = [0.1:0.1:1]; % if this proportion of electrodes are bad, then subjeect is rejected
% numThreshold = length(thresholdForBadSubjetRejection);
% goodSubjects = zeros(numThreshold,length(segmentTheseIndices));
% goodSubjectsFrontal = zeros(numThreshold,length(segmentTheseIndices));
% goodSubjectsHighPriority = zeros(numThreshold,length(segmentTheseIndices));
% goodSubjectsCommon = zeros(numThreshold,length(segmentTheseIndices));
% 
%  for m = 1:numThreshold
%      for i=1:length(segmentTheseIndices)
%          if isempty(find(proportionAllBadElecs(i,:)>thresholdForBadSubjetRejection(m)))
%             goodSubjects(m,i) = 1;
%          end
% 
%          if isempty(find(proportionBadElecsGroupWise(i,:,4)>thresholdForBadSubjetRejection(m)))
%             goodSubjectsFrontal(m,i) = 1;
%          end
% 
%          if isempty(find(proportionBadElecsGroupWise(i,:,6)>thresholdForBadSubjetRejection(m)))
%             goodSubjectsHighPriority(m,i) = 1;
%          end
% 
%          if isempty(find(proportionBadElecsGroupWise(i,:,6)>thresholdForBadSubjetRejection(m))) && isempty(find(proportionBadElecsGroupWise(i,:,6)>thresholdForBadSubjetRejection(m)))% isempty(find(proportionAllBadElecs(i,:)>thresholdForBadSubjetRejection(m))) &&
%             goodSubjectsCommon(m,i) = 1;
%          end
%      end
%  end
% 
%  numGoodSubjects = sum(goodSubjects,2);
%  numGoodSubjectsFrontal = sum(goodSubjectsFrontal,2);
%  numGoodSubjectsHighPriority = sum(goodSubjectsHighPriority,2);
%  numGoodSubjectsCommon = sum(goodSubjectsCommon,2);
% 
% h1= subplot(3,4,9);
% plot(thresholdForBadSubjetRejection,numGoodSubjects);
% xline(0.5,'--');
% xlabel('threshold');
% ylabel('No. of good subjects');
% title('All Electrodes');
% 
% h2 = subplot(3,4,10);
% plot(thresholdForBadSubjetRejection,numGoodSubjectsFrontal);
% xline(0.5,'--');
% xlabel('threshold');
% title('Frontal');
% 
% h3 = subplot(3,4,11);
% plot(thresholdForBadSubjetRejection,numGoodSubjectsHighPriority);
% xline(0.5,'--');
% xlabel('threshold');
% title('High Priority');
% 
% h4 = subplot(3,4,12);
% plot(thresholdForBadSubjetRejection,numGoodSubjectsCommon);
% xline(0.5,'--');
% xlabel('threshold');
% title('Frontal + HighPriority');
% 
% linkaxes([h1 h2 h3 h4]);
% ylim([0 length(segmentTheseIndices)+1]);