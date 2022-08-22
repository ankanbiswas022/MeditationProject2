%% By NN, adapted and modified by AB on 81822

%This function calculates the mean and median percent of bad trials across 64 electrodes for each subject, from v5 v7 v8
%and v9 badTrial versions and plots the summary figure in one figure

function calculateBadTrialPercent_allSubjects_v2(dataFolderString,extractTheseIndices,removeBadEyeTrialFlagS,protName,saveFigureLocation,saveFigureFlag)

gridType = 'EEG';
% badTrialString = [{'v5'}, {'v7'}, {'v8'}, {'v9'}]; % common badTrial strings
badTrialString = [{'v5'}, {'d4020_v7'}, {'d4020_v8'}, {'d4020_v10'}]; % badTrial strings
fontsize = 12;

for iEye=1:length(removeBadEyeTrialFlagS)
    
    removeBadEyeTrialFlag=removeBadEyeTrialFlagS(iEye);
    
    for iString = 1:length(badTrialString)
        if ~exist('protName','var')
            [mu_percentBadTrial_perElec,med_percentBadTrial_perElec,std_percentBadTrial_perElec,percentCommonBadTrials]= calculateBadTrial_Percent(extractTheseIndices,badTrialString{iString},gridType,dataFolderString,removeBadEyeTrialFlag);
        else
            [mu_percentBadTrial_perElec,med_percentBadTrial_perElec,std_percentBadTrial_perElec,percentCommonBadTrials]= calculateBadTrial_Percent(extractTheseIndices,badTrialString{iString},gridType,dataFolderString,removeBadEyeTrialFlag,protName);
        end
        mean_badTrialPercent{iString} =   mu_percentBadTrial_perElec;
        median_badTrialPercent{iString} =   med_percentBadTrial_perElec;
        std_badTrialPercent{iString} =  std_percentBadTrial_perElec;
        commonBadTrial_percent{iString} = percentCommonBadTrials;
    end
    
    
    %creates figure map
    
    mainFig = figure;
    mainFig.WindowState = 'maximized';
    hPlot = getPlotHandles(1,4,[0.1 0.3 0.85 0.4],0.02,0.1);
    
    for iString = 1:length(badTrialString)
        errorbar(hPlot(1,iString),1:length(extractTheseIndices), mean_badTrialPercent{iString},std_badTrialPercent{iString} ,'b*-','linewidth',2);
        hold(hPlot(1,iString),'on');
        plot(hPlot(1,iString),1:length(extractTheseIndices),median_badTrialPercent{iString},'c.--','linewidth',2);
        plot(hPlot(1,iString),1:length(extractTheseIndices),commonBadTrial_percent{iString},'m+--','linewidth',2);
        yline(hPlot(1,iString),mean(commonBadTrial_percent{iString}),'g');
        ylim(hPlot(1,iString),[0 1]);
        xlim(hPlot(1,iString),[0 length(extractTheseIndices)]);
        title(hPlot(1,iString),badTrialString{iString});
        
        if iString==1
            ylabel(hPlot(1,iString),'Proportion of bad trials');
            xlabel(hPlot(1,iString),'Subject Number');
        else
            yticks(hPlot(1,iString),[]);
        end
    end
    
    legend(hPlot(1,4),'Mean of bad trials removed from each electrode individually','Median of bad trials removed from each electrode individually','Common bad trials','Mean Common Bad Trial across Subjects','location',[0.785 0.78 0.1 0.1]);
    
    if removeBadEyeTrialFlag==1
        title_str_eye = 'Bad Eye Trials Included';
    else
        title_str_eye = 'Bad Eye Trials Not Included';
    end
    
    if exist('protName','var')
        sgtitle([protName ' -- Proportion of Bad Trials in v5 v7 v8 and v10 version for all Subjects -- ' title_str_eye],'fontsize',fontsize+4,'FontWeight','Bold');
    else
        sgtitle(['Proportion of Bad Trials in v5 v7 v8 and v10 version for all Subjects -- ' title_str_eye],'fontsize',fontsize+4,'FontWeight','Bold');
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing axis properties of the figures:
    set(findobj(gcf,'type','axes'),'box','off'...
        ,'fontsize',fontsize...
        ,'FontWeight','Bold'...
        ,'TickDir','out'...
        ,'TickLength',[0.02 0.02]...
        ,'linewidth',1.2...
        ,'xcolor',[0 0 0]...
        ,'ycolor',[0 0 0]...
        );
    
    set(findall(gcf, 'Type', 'Line'),'LineWidth',2);
    set(findall(gcf, 'Type', 'errorbar'),'LineWidth',1.2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if saveFigureFlag
        saveFolder = saveFigureLocation;
        figName2 = fullfile(saveFolder,['badTrialPropAllVer_' strrep(title_str_eye,' ','')]);
        saveas(mainFig,[figName2 '.fig']);
        print(mainFig,[figName2 '.tif'],'-dtiff','-r300');
    end
    
end %eye
end % function

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Accesories functions

function [mu_percentBadTrial_perElec,med_percentBadTrial_perElec,std_percentBadTrial_perElec,percentCommonBadTrials]= calculateBadTrial_Percent(extractTheseIndices,badTrialString,gridType,dataFolderString,removeBadEyeTrialFlag,protName)

if ~exist('protName','var')
    %give subjectDataBase
    [subjectNames,expDates,protocolNames,~,~,~] = allProtocolsCRFAttentionEEGv1;
else
    [subjectNames,expDates] = subjectDatabaseMeditationProject2;
    protocolName = protName;
end

mu_percentBadTrial_perElec=[]; med_percentBadTrial_perElec=[]; std_percentBadTrial_perElec=[]; percentCommonBadTrials=[];

for i = 1:length(extractTheseIndices)
    subjectName = subjectNames{extractTheseIndices(i)};
    expDate = expDates{extractTheseIndices(i)};
    
    if ~exist('protName','var')
        protocolName = protocolNames{extractTheseIndices(i)};
    end
    
    disp(['Processing Data for Subject: ' subjectName ' & Protocol: ' protocolName] );
    
    % Get bad trials
    folderSegment = fullfile(dataFolderString,'data',subjectName,gridType,expDate,protocolName,'segmentedData/');
    badTrialFile = fullfile(folderSegment,['badTrials_' badTrialString '.mat']);
    
    [allBadTrials,commonBadTrials,totalTrials,badElecs,badTrialsUnique] = loadBadTrials(badTrialFile);
    badElecrodes = unique([badElecs.badImpedanceElecs;badElecs.noisyElecs;badElecs.flatPSDElecs]);
    
    percentBadTrial_perElec=[];
    for iElec= 1:length(allBadTrials)
        %convert NaN cells into empty matrices []
        if isnan(allBadTrials{iElec})
            allBadTrials{iElec}=[];
        end
        %saves badTrials for each electrode which will/will not take bad eye trials into account depending on the flag
        if removeBadEyeTrialFlag ==1
            badTrialPerSubject{iElec} = union(allBadTrials{iElec},badTrialsUnique.badEyeTrials);
            commonBadTrials = union(commonBadTrials,badTrialsUnique.badEyeTrials);
        else
            badTrialPerSubject{iElec} = allBadTrials{iElec};
        end
        percentBadTrial_perElec = [percentBadTrial_perElec  length(badTrialPerSubject{iElec})/totalTrials]; % percent bad trials in each electrode
    end
    mu_percentBadTrial_perElec  = [mu_percentBadTrial_perElec mean(percentBadTrial_perElec)];     % mean bad trial across elec for all subjects
    med_percentBadTrial_perElec = [med_percentBadTrial_perElec  median(percentBadTrial_perElec)]; % median bad trial across elec for all subjects
    std_percentBadTrial_perElec = [std_percentBadTrial_perElec std(percentBadTrial_perElec)];     % std of bad trial across elec for all subjects
    percentCommonBadTrials      = [percentCommonBadTrials (length(commonBadTrials)/totalTrials)]; % common badTrials for all subjects
end
end

% accessory function for loading specific variables from badTrial file
function [allBadTrials,badTrials,totalTrials,badElecs,badTrialsUnique] = loadBadTrials(badTrialFile) %#ok<*STOUT>
load(badTrialFile);
end