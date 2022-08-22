% plot topoplots: AB, NN @ 081722
% for running this follow the following steps:

% 1. Process the raw data and save the analzyed power data for the individual subject
% 2. Pull the data for all the subjects in a matrix

% Notes:----------------------------------------------------------------------------------------------------
% common and individual: first one is Individual, ssecond one is Common
% for each refType: uniPolar and bipolar
% for each frequencyRange
% average across all the subjects

close all

saveFigFlag = 1;
folderSourceString  = 'D:\Projects\MeditationProjects\MeditationProject2\data\savedData\analyzedDataV2';
% badTrialStringS     = [{'v5'}, {'d4020_v7'}, {'d4020_v8'}, {'d4020_v9'}];
badTrialStringS     = {'_v5', '_v7', '_v8', '_v9'};
fileSourceName      = 'PowerVals_topoPlotData';
gridLayout          = 6;
nonEEGElectrodes    = 65:70;

folderPathToSave    ='D:\Projects\MeditationProjects\MeditationProject2\Results\badTrialPercentage\topoPlots';

% loading cap Details for the topoplot
capType = 'actiCap64_UOL';
montagePath = 'D:\Programs\ProgramsMAP\Montages\Layouts\actiCap64_UOL';
chLocs{1} = load(fullfile(montagePath,'actiCap64_UOL.mat'));
chLocs{2} = load(fullfile(montagePath,'bipolarChanlocsActiCap64_UOL.mat'));

x = load([capType 'Labels.mat']); montageLabels = x.montageLabels(:,2);
x = load([capType '.mat']);       montageChanlocs = x.chanlocs;

%-----------------------------------------------------------------------------

% numSubjects= size(diffPowerValsAllSubjects{1}{1}{1},1);
numSubjects     = 15;
refTypeString   = {'UniPolar','BiPolar'};
freqRangeString = {'Slow Gamma','Fast Gamma','Slow+Fast Gamma','High Gamma'};


for iString = 1:length(badTrialStringS)
    
    fileNameToLoad = [fileSourceName badTrialStringS{iString} '.mat'];
    load(fullfile(folderSourceString,fileNameToLoad));
    titleString{1}  = ['-CommonBadTrials ' badTrialStringS{iString}];
    titleString{2}  = ['-IndividualBadTrials ' badTrialStringS{iString}];
    
    for dType=1:2
        
        mainFig=figure(dType);
        mainFig.WindowState = 'Maximized';
        subPlot=getPlotHandles(2,4,[0.1 0.1 0.85 0.7],0.03,0.01);
 
        for iref=1:2
            switch iref
                case 1; chLoc = chLocs{iref}.chanlocs;
                case 2; chLoc = chLocs{iref}.eloc;
            end
            for iFreqrange=1:4
                for iSub =1:numSubjects
                    if ~isempty(badElectrodes{iSub})
                        % making the bad Electrodes as NaN
                        diffPowerValsAllSubjects{dType}{iref}{iFreqrange}(iSub,badElectrodes{iSub})=NaN;
                    end
                end
                % average across
                diffPowerMeanAcrossSubjects = mean(diffPowerValsAllSubjects{dType}{iref}{iFreqrange},1,'omitnan');
                
%                 mainFig;
                subplot(subPlot(iref,iFreqrange));
                %             text(-0.3,0.5,'test','fontSize',16);
                topoplot(diffPowerMeanAcrossSubjects,chLoc,'electrodes','on'); colormap('jet');
                caxis([-1.5 1.5]);
                
                if iFreqrange == 1
                    text(-1,0,refTypeString{iref},'fontSize',16);
                end
                
                if iFreqrange == 4 % changing colorBar position
                    c = colorbar;
                    c.Position(1) = c.Position(1)+0.07;
                end
                
                if iref==1
                    title(freqRangeString{iFreqrange},'FontSize',12);
                end
            end
        end
        sgtitle(titleString{dType});
        % save Figures
        if saveFigFlag
            saveFolder = folderPathToSave;
            figName2 = fullfile(saveFolder,['Topoplot_AllSub' badTrialStringS{iString} titleString{dType}]);
            saveas(mainFig,[figName2 '.fig']);
            print(mainFig,[figName2 '.tif'],'-dtiff','-r300');
        end
    end
    close all % closes the current figures after saving
end


