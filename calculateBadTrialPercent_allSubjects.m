%calculate percetage of bad trials in v5, v7, v8 and v9 version

gridType = 'EEG';
%give indices of subjects

%extractTheseIndices = [3:18];

% protocolNames = {'G1'};

%give folderSourceString

%folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';


%give subjectDataBase
%[subjectNames,expDates] = subjectDatabaseMeditationProject2;

removeBadEyeTrialsFlag =1; %give flag for removing bad eye trials



BadTrials_v5 = [];  %allBadTrials for 64 elecs
BadTrials_v7_TGPeriod = []; %allBadTrials for 64 elecs
percentCommonBadTrials_v5=[];
percentCommonBadTrials_v7=[];

mu_percentBadTrial_perElec_v5 =[];
mu_percentBadTrial_perElec_v7 = [];

med_percentBadTrial_perElec_v5 = []; %median bad trial across elec for all subjects
med_percentBadTrial_perElec_v7 = [];

std_percentBadTrial_perElec_v5 = [];
std_percentBadTrial_perElec_v7 = [];

for i=1:length(extractTheseIndices)
    
    subjectName = subjectNames{extractTheseIndices(i)};
    expDate = expDates{extractTheseIndices(i)};
    protocolName = 'G1';
    
    disp(['Processing Data for Subject: ' subjectName ' & Protocol: ' protocolName] );
    
    % Get bad trials
    folderSegment = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData/');
    badTrialFile_v5 = fullfile(folderSegment,'badTrials_v5.mat');
    badTrialFile_v7_TGPeriod = fullfile(folderSegment,'badTrials_d4020_v7');
    
    [badTrials_v7_TGPeriod,commonBadTrials_v7,~,badTrialsUnique_v7_TGPeriod] = loadBadTrials(badTrialFile_v7_TGPeriod);
    [badTrials_v5,commonBadTrials_v5,totalTrials,badTrialsUnique_v5] = loadBadTrials(badTrialFile_v5);
    
    percentBadTrial_perElec_v5 =[]; percentBadTrial_perElec_v7=[];
    for iElec= 1:length(badTrials_v5)
        if removeBadEyeTrialsFlag ==1
            badTrialPerSubject_v5{iElec} = union(badTrials_v5{iElec},badTrialsUnique_v5.badEyeTrials);
            badTrialPerSubject_v7_TGPeriod{iElec} = union(badTrials_v7_TGPeriod{iElec},badTrialsUnique_v7_TGPeriod.badEyeTrials);
        else
            badTrialPerSubject_v5{iElec} = badTrials_v5{iElec};
            badTrialPerSubject_v7_TGPeriod{iElec} = badTrials_v7_TGPeriod{iElec};
        end
        
        
        percentBadTrial_perElec_v5 = [percentBadTrial_perElec_v5  length(badTrialPerSubject_v5{iElec})/totalTrials];
        percentBadTrial_perElec_v7 = [percentBadTrial_perElec_v7 length(badTrialPerSubject_v7_TGPeriod{iElec})/totalTrials];
        
        
        
        
    end
    
    mu_percentBadTrial_perElec_v5 = [mu_percentBadTrial_perElec_v5 mean(percentBadTrial_perElec_v5)]; %mean bad trial across elec for all subjects
    mu_percentBadTrial_perElec_v7 = [mu_percentBadTrial_perElec_v7  mean(percentBadTrial_perElec_v7 )];
    
    med_percentBadTrial_perElec_v5 = [med_percentBadTrial_perElec_v5  median(percentBadTrial_perElec_v5)]; %median bad trial across elec for all subjects
    med_percentBadTrial_perElec_v7 = [med_percentBadTrial_perElec_v7 median(percentBadTrial_perElec_v7)];
    
    std_percentBadTrial_perElec_v5 = [std_percentBadTrial_perElec_v5 std(percentBadTrial_perElec_v5)]; %std of bad trial across elec for all subject
    std_percentBadTrial_perElec_v7 = [std_percentBadTrial_perElec_v7 std(percentBadTrial_perElec_v7)];
    
    
    
    percentCommonBadTrials_v5= [percentCommonBadTrials_v5 (length(commonBadTrials_v5)/totalTrials)]; %common badTrials for all subject
    percentCommonBadTrials_v7= [percentCommonBadTrials_v7 (length(commonBadTrials_v7)/totalTrials)];
    
    
    
    
    
end

%plot figure map

f = figure;
f. WindowState = 'maximized';subplot(2,2,1)
errorbar(1:length(percentCommonBadTrials_v5),mu_percentBadTrial_perElec_v5 , std_percentBadTrial_perElec_v5 ,'b*-','linewidth',2);
hold on;
plot(1:length(percentCommonBadTrials_v5),med_percentBadTrial_perElec_v5,'c.--','linewidth',2);
plot(1:length(percentCommonBadTrials_v5),percentCommonBadTrials_v5,'m+--','linewidth',2);
ylim([0 1]);
xlim([0 26]);
title('- v5');
xlabel('Subject Number');
ylabel('Proportion of bad trials');

subplot(2,2,2)
errorbar(1:length(percentCommonBadTrials_v7),mu_percentBadTrial_perElec_v7, std_percentBadTrial_perElec_v7,'b*-','linewidth',2);
hold on;
plot(1:length(percentCommonBadTrials_v5),med_percentBadTrial_perElec_v7,'c.--','linewidth',2);
plot(1:length(percentCommonBadTrials_v5),percentCommonBadTrials_v7,'m+--','linewidth',2);
ylim([0 1]);xlim([0 26]);
title('- v7');
xlabel('Subject Number');
ylabel('Proportion of bad trials');
legend ('Mean of bad trials removed from each electrode individually','Median of bad trials removed from each electrode individually','Common bad trials')

function [allBadTrials,badTrials,badElecs,totalTrials,badTrialsUnique] = loadBadTrials(badTrialFile) %#ok<*STOUT>
load(badTrialFile);
end