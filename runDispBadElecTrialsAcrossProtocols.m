% to make a summary plot for all subjects
clear; 
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
folderSourceString='D:\Projects\MeditationProjects\MeditationProject2';
%  folderSourceString = 'C:\Users\Srishty\OneDrive - Indian Institute of Science\Documents\supratim\meditationProject';
badElectrodeList=[];
plotRawTFFlag=[];
badTrialNameStr='_d4020_v10';
% badTrialNameStr='_d4020_v8';
badElectrodeRejectionFlag=1;
saveFileFlag = 0;
saveDataIndividualSubjectsFlag = 0; % if the flag is on the script would save the data for the given subject list
individualSubjectFigureFlag = 1;  %the flag for bad trial figure for indiviual subjects 

thresholdTrialVal = 0.75;        %threshold value for rejecting subjects due to bad trials
thresholdElecVal = 0.6;        %threshold value for rejecting subjects due to bad electrodes
% segmentTheseIndices =[3:17 19:28 30:34 36:44 46]; %29 some problem
% segmentTheseIndices = [3:17 19:34 36:44 46] ;
allBadElecs = [];
badElecsGroupWise = [];
badTrialsWithoutEye = [];
badTrialsForEye  = [];
badTrialsIncEye = [];

% segmentTheseIndices = [3:33]; %29 some problem


problamaticSubjectIndex = 53;
segmentTheseIndices = setdiff(3:66,problamaticSubjectIndex) ; % total list as of 6/9/22 
 
% segmentTheseIndices = [3:17 19:34] ;
% segmentTheseIndices = [3:17 19:34] ;
% segmentTheseIndices = [3:17 19:34 34:49] ;
% segmentTheseIndices = [3:17 19:34 34:49 50:52 53:66] ;
% segmentTheseIndices = [50:52 53:66] ; % the new Lot
% segmentTheseIndices = [35:36] ;
% segmentTheseIndices = 23; %29 some problem

for i=1:length(segmentTheseIndices)

    
%     h=figure(segmentTheseIndices(i));
    
    subjectName = subjectNames{segmentTheseIndices(i)};
    expDate = expDates{segmentTheseIndices(i)};
    [allBadElecs(i,:),badElecsGroupWise(i,:,:), badTrialsWithoutEye(i,:), badTrialsForEye(i,:), badTrialsIncEye(i,:)] = dispBadElecTrialsAcrossProtocols(subjectName,expDate,folderSourceString,badTrialNameStr,individualSubjectFigureFlag); %working on this
   
end


%%data for plotting

%%%fixed variables%%%%%%
allElectrodeList = 1:64;
numElectrodes = length(allElectrodeList);
protocolNameList = [{'EO1'}     {'EC1'}     {'G1'}      {'M1'}          {'G2'}      {'EO2'}     {'EC2'}     {'M2'}];
protocolSegNameList =  [{'EO1'}     {'EC1'}     {'G1'}      {'M1(a)'}   {'M1(b)'}      {'M1(c)'}    {'G2'}      {'EO2'}     {'EC2'}     {'M2(a)'}     {'M2(b)'}    {'M2(c)'}];
numProtocols = length(protocolNameList);
numSegmentTrials = 120;
protocolSegSelect = [1 3 7 8]; %[EO1 G1 EO2 G2] for bad trial rejection
[~,~,~,electrodeGroupList,groupNameList,highPriorityElectrodeNums] = electrodePositionOnGrid(64,'EEG',subjectName,6);
    electrodeGroupList{length(electrodeGroupList)+1} = highPriorityElectrodeNums;
    groupNameList{length(groupNameList)+1} = 'highPriority';

 proportionAllBadElecs = allBadElecs./length(allElectrodeList);

 for k=1:length(electrodeGroupList)
     proportionBadElecsGroupWise(:,:,k) = badElecsGroupWise(:,:,k)./length(electrodeGroupList{k});
 end

 
proportionBadTrialsWithoutEye = badTrialsWithoutEye./numSegmentTrials;
proportionBadTrialsForEye = badTrialsForEye./numSegmentTrials;
proportionBadTrialsIncEye = badTrialsIncEye./numSegmentTrials;

thresholdForBadSubjetRejection = [0.1:0.05:1]; % if this proportion of electrodes are bad, then subjeect is rejected
numThreshold = length(thresholdForBadSubjetRejection);

thresholdTrialInd = find(thresholdForBadSubjetRejection==thresholdTrialVal);
thresholdElecInd = find(thresholdForBadSubjetRejection==thresholdElecVal);

goodSubjects = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsFrontal = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsHighPriority = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsCommon = zeros(numThreshold,length(segmentTheseIndices));

goodSubjectsTrialsWithoutEye = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsTrialsEye = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsTrialsWithEye = zeros(numThreshold,length(segmentTheseIndices));

goodSubjectsTrialsWithoutEyeSelecProt = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsTrialsEyeSelecProt = zeros(numThreshold,length(segmentTheseIndices));
goodSubjectsTrialsWithEyeSelecProt = zeros(numThreshold,length(segmentTheseIndices));


 for m = 1:numThreshold
     for i=1:length(segmentTheseIndices)
         if isempty(find(proportionAllBadElecs(i,:)>thresholdForBadSubjetRejection(m)))
            goodSubjects(m,i) = 1;
         end

         if isempty(find(proportionBadElecsGroupWise(i,:,4)>thresholdForBadSubjetRejection(m)))
            goodSubjectsFrontal(m,i) = 1;
         end

         if isempty(find(proportionBadElecsGroupWise(i,:,6)>thresholdForBadSubjetRejection(m)))
            goodSubjectsHighPriority(m,i) = 1;
         end

         if isempty(find(proportionBadElecsGroupWise(i,:,6)>thresholdForBadSubjetRejection(m))) && isempty(find(proportionBadElecsGroupWise(i,:,6)>thresholdForBadSubjetRejection(m)))% isempty(find(proportionAllBadElecs(i,:)>thresholdForBadSubjetRejection(m))) &&
            goodSubjectsCommon(m,i) = 1;
         end

          if isempty(find(proportionBadTrialsWithoutEye(i,:)>thresholdForBadSubjetRejection(m)))
            goodSubjectsTrialsWithoutEye(m,i) = 1;
          end

          if isempty(find(proportionBadTrialsForEye(i,:)>thresholdForBadSubjetRejection(m)))
            goodSubjectsTrialsEye(m,i) = 1;
          end

          if isempty(find(proportionBadTrialsIncEye(i,:)>thresholdForBadSubjetRejection(m)))
            goodSubjectsTrialsWithEye(m,i) = 1;
          end

          if isempty(find(proportionBadTrialsWithoutEye(i,protocolSegSelect)>thresholdForBadSubjetRejection(m)))
            goodSubjectsTrialsWithoutEyeSelecProt(m,i) = 1;
          end

          if isempty(find(proportionBadTrialsForEye(i,protocolSegSelect)>thresholdForBadSubjetRejection(m)))
            goodSubjectsTrialsEyeSelecProt(m,i) = 1;
          end

          if isempty(find(proportionBadTrialsIncEye(i,protocolSegSelect)>thresholdForBadSubjetRejection(m)))
            goodSubjectsTrialsWithEyeSelecProt(m,i) = 1;
          end
     end
 end

 numGoodSubjects = sum(goodSubjects,2);
 numGoodSubjectsFrontal = sum(goodSubjectsFrontal,2);
 numGoodSubjectsHighPriority = sum(goodSubjectsHighPriority,2);
 numGoodSubjectsCommon = sum(goodSubjectsCommon,2);

numGoodSubjectsWithoutEye = sum(goodSubjectsTrialsWithoutEye,2);
numGoodSubjectsEye = sum(goodSubjectsTrialsEye,2);
numGoodSubjectsWithEye = sum(goodSubjectsTrialsWithEye,2);

numGoodSubjectsWithoutEyeSelecProt = sum(goodSubjectsTrialsWithoutEyeSelecProt,2);
numGoodSubjectsEyeSelecProt = sum(goodSubjectsTrialsEyeSelecProt,2);
numGoodSubjectsWithEyeSelecProt = sum(goodSubjectsTrialsWithEyeSelecProt,2);

badSubIndexElec = segmentTheseIndices(find(goodSubjectsCommon(thresholdElecInd,:)==0));
badSubIndexTrial = segmentTheseIndices(find(goodSubjectsTrialsWithEyeSelecProt(thresholdTrialInd,:)==0));

disp(badSubIndexElec);
disp(badSubIndexTrial);
 
 %%%%%%%%%%%%%%figure for bad Electrodes across subjects %%%%%%%%%%
 figure
for j=1:numProtocols
    subplot(3,4,j)
    stem(segmentTheseIndices,proportionAllBadElecs(:,j),'color',[0.5 0.5 0.5]); axis('tight'); hold on
    stem(segmentTheseIndices,proportionBadElecsGroupWise(:,j,6),'color',[0.8 0 0]); axis('tight'); hold on %high priority
    stem(segmentTheseIndices,proportionBadElecsGroupWise(:,j,4),'color',[0 0.8 0]); axis('tight'); hold on %frontal
    yline(0.3,'--');
    xlim([1 segmentTheseIndices(end)+1]); ylim([0 1]);
    title(protocolNameList{j});
    if j==4
        legend('All','High Priority','Frontal','location','best');
    elseif j==5
        xlabel('Subject Index');  ylabel('Proportion of Bad Electrode');
    end
end

sgtitle(['Bad Electrodes across Subjects' ':' badTrialNameStr],'FontSize',18);


h1= subplot(3,4,9);
plot(thresholdForBadSubjetRejection,numGoodSubjects);
xline(0.5,'--');
xlabel('threshold');
ylabel('No. of good subjects');
title('All Electrodes');

h2 = subplot(3,4,10);
plot(thresholdForBadSubjetRejection,numGoodSubjectsFrontal);
xline(0.5,'--');
xlabel('threshold');
title('Frontal');

h3 = subplot(3,4,11);
plot(thresholdForBadSubjetRejection,numGoodSubjectsHighPriority);
xline(0.5,'--');
xlabel('threshold');
title('High Priority');

h4 = subplot(3,4,12);
plot(thresholdForBadSubjetRejection,numGoodSubjectsCommon);
xline(0.5,'--');
xlabel('threshold');
title('Frontal + HighPriority');
text(1.3,20,subjectNames(badSubIndexElec),'HorizontalAlignment','right','FontSize',14,'Color','red')

linkaxes([h1 h2 h3 h4]);
ylim([0 length(segmentTheseIndices)+1]);


%%%%%%%%%%%%%%%%%for bad Trials across subjects %%%%%%%%%%%%%%%%
figure();
for j=1:12
    subplot(4,4,j)
    stem(segmentTheseIndices,proportionBadTrialsWithoutEye(:,j),'color',[0.5 0.5 0.5]); axis('tight'); hold on
    stem(segmentTheseIndices,proportionBadTrialsForEye(:,j),'color',[0.8 0 0]); axis('tight'); hold on 
    stem(segmentTheseIndices,proportionBadTrialsIncEye(:,j),'color',[0 0.8 0]); axis('tight'); hold on 
    yline(0.75,'--');
    xlim([1 segmentTheseIndices(end)+1]); ylim([0 1]);
    title(protocolSegNameList{j});
    if mod(j,4) == 1
         ylabel('Bad Trials');
    end
    
        
    if j>8
        xlabel('Subject Index'); 
    end
end
legend('Bad Trials Without Eye','Bad Eye Trials','Bad Trials Including Eye','Position',[0.87 0.9 0.1 0.07]);
sgtitle(['Bad Trials across Subjects' ':' badTrialNameStr],'FontSize',18);

h1= subplot(4,3,10);
plot(thresholdForBadSubjetRejection,numGoodSubjectsWithoutEye); hold on;
plot(thresholdForBadSubjetRejection,numGoodSubjectsWithoutEyeSelecProt);
xline(0.75,'--');
xlabel('threshold');
ylabel('No. of good subjects');
title('Without Eye');

h2= subplot(4,3,11);
plot(thresholdForBadSubjetRejection,numGoodSubjectsEye); hold on;
plot(thresholdForBadSubjetRejection,numGoodSubjectsEyeSelecProt);
xline(0.75,'--');
xlabel('threshold');
%ylabel('No. of good subjects');
title('Eye Trials');

h3= subplot(4,3,12);
plot(thresholdForBadSubjetRejection,numGoodSubjectsWithEye); hold on;
plot(thresholdForBadSubjetRejection,numGoodSubjectsWithEyeSelecProt);
xline(0.75,'--');
xlabel('threshold');
%ylabel('No. of good subjects');
title('With Eye');
legend('All Protocols','EO1,EO2,G1,G2','Position',[0.87 0.01 .1 0.07]);
% annotation('textbox',[0 0.2 0.1 0.2],'String','for All Protocols','FitBoxToText','on');
% annotation('textbox',[0 0.1 0.1 0.2],'String','For EO1, G1, EO2, G2','FitBoxToText','on');
 linkaxes([h1 h2 h3]);
ylim([0 length(segmentTheseIndices)+1]);
text(1.3,65,subjectNames(badSubIndexTrial),'HorizontalAlignment','right','FontSize',14,'Color','red');

%for finding indices of subjects with more than certain threshold
% thresh = 0.5;
% indexBad = find(goodSubjects(thresh*10:10, :)==0);
% indexBadSubject = segmentTheseIndices(indexBad);