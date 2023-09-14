% Readme:
% Topoplot MasterCode:
% Idea is to save the following data for individual subjects
% alphaPow - [12x64] % sgPower  - [12x64] % sfPower  - [12x64]
% which we could then pull and average
%--------------------------------------------------------------------------------------------------------------------
% Provide the flags for getting the appropriate folderName to load the data
biPolarFlag                     = 0;
removeVisualInspectedElecs      = 0;
changeInPowerFlag               = 0;
removeIndividualUniqueBadTrials = 1;

% New functionalities:
groupAndSaveTopoPlotData = 0;
saveAverageTopoplot      = 0;
dispMeanTopolplot        = 0;

loadFolderpath     = getFolderNameMeditation(biPolarFlag,removeIndividualUniqueBadTrials,removeVisualInspectedElecs);
folderSourceSring  = loadFolderpath;
disp(['We are loading the data from the following location:'  newline  loadFolderpath]);

if biPolarFlag==1
    dataString    = 'BipolarPowerDataAllElecs_' ;
    numElectrodes = 114;
else
    dataString    = 'PowerDataAllElecs_' ;
    numElectrodes = 64;
end

% declaring the variables for which we would save the data
alphaTopoPowerVal = [];
slowGTopoPowerVal = [];
fastGTopoPowerVal = [];

% desired freqRanges:
freqList{1} = [8 12];  freqListNames{1} = 'Alpha';
freqList{2} = [20 34]; freqListNames{2} = 'SG';
freqList{3} = [36 66]; freqListNames{3} = 'FG';
numFreqRanges = length(freqList);

% loads indexes for the gender and age-matached subjects
[subjectNames,expDates] = subjectDatabaseMeditationProject2;
load('D:\Projects\MeditationProjects\MeditationProject2\data\savedData\IndexesForMatchedSubject.mat');
saveTheseIndices = allIndexes(1:end);

% segementList:
% segmentNameList = [{'EO1'} {'EC1'} {'G1'} {'M1a'} {'M1b'} {'M1c'} {'G2'} {'EO2'} {'EC2'} {'M2a'} {'M2b'} {'M2c'}];
segmentNameList = [{'EO1'} {'EC1'} {'G1'} {'M1'} {'G2'} {'EO2'} {'EC2'} {'M2'}];
numSegments = length(segmentNameList);

for i=1:length(saveTheseIndices) % for each subject
    subjectName = subjectNames{saveTheseIndices(i)};
    fileNameToLoad = fullfile(folderSourceSring,[dataString subjectName,'.mat']);
    load(fileNameToLoad);

    %----------------------------------------------------
    disp(['Working on the '  subjectName]);
    expDate = expDates{saveTheseIndices(i)};

    %% ----------------------------------------------------
    % Reorder the PowerAgain
    % Combining the power for M1.a, M1.b and M1.c and same for M2 as well.

    powerValST_Mod        = zeros(8,251,64);

    powerValST_M1         = squeeze(mean(powerValST(4:6,:,:),1));
    powerValST_M2         = squeeze(mean(powerValST(10:12,:,:),1));

    powerValST_Mod(4,:,:) = powerValST_M1;
    powerValST_Mod(8,:,:) = powerValST_M2;

    powerValST_Mod(1:3,:,:) = powerValST(1:3,:,:); % direct assignment
    powerValST_Mod(5:7,:,:) = powerValST(7:9,:,:);

%%
    %-------------saved data structure---------------------------------------
    rawMeanAlphaThisElec = zeros(numSegments,numElectrodes);
    rawMeanSlowGThisElec = zeros(numSegments,numElectrodes);
    rawMeanFastGThisElec = zeros(numSegments,numElectrodes);

    for s=1:numSegments % for each protocol
        psdDataThisProtocol = squeeze(powerValST_Mod(s,:,:))';
        for e=1:numElectrodes % for each electrode
            if changeInPowerFlag
                % BLmeanAlphaThisElec   = log10(mean(psdDataThisElecGoodTrials(alphaPos),1));
                % BLmeanSGThisElec      = log10(mean(psdDataThisElecGoodTrials(sgPos),1));
                % BLmeanFGThisElec      = log10(mean(psdDataThisElecGoodTrials(fgPos),1));
            else
                BLmeanAlphaThisElec = [];
                BLmeanSGThisElec    = [];
                BLmeanFGThisElec    = [];
            end

            psdDataThisElecGoodTrials = squeeze(psdDataThisProtocol(e,:));
            %           psdDataThisElecGoodTrials = mean(psdDataThisElec(:,setdiff(1:size(psdDataThisElec,2),badTrialsList{i})),2);

            % and calculating the alpha and gammaPower in that segment.
            alphaPos = intersect(find(freqVals>=freqList{1}(1)),find(freqVals<=freqList{1}(2)));
            sgPos    = intersect(find(freqVals>=freqList{2}(1)),find(freqVals<=freqList{2}(2)));
            fgPos    = intersect(find(freqVals>=freqList{3}(1)),find(freqVals<=freqList{3}(2)));
            fgPos    = fgPos(fgPos~=(find(freqVals==50)));

            meanAlphaThisElec = log10(mean(psdDataThisElecGoodTrials(alphaPos),2,"omitnan"));
            meanSGThisElec    = log10(mean(psdDataThisElecGoodTrials(sgPos),2,"omitnan"));
            meanFGThisElec    = log10(mean(psdDataThisElecGoodTrials(fgPos),2,"omitnan"));

            if changeInPowerFlag
                chMeanAlphaAllElec(s,e)  = 10*(meanAlphaThisElec - BLmeanAlphaThisElec);
                chMeanSlowGAllElec(s,e)  = 10*(meanSGThisElec    - BLmeanSGThisElec);
                chMeanFastGAllElec(s,e)  = 10*(meanFGThisElec    - BLmeanFGThisElec);
            else
                rawMeanAlphaThisElec(s,e)  = meanAlphaThisElec;
                rawMeanSlowGThisElec(s,e)  = meanSGThisElec;
                rawMeanFastGThisElec(s,e)  = meanFGThisElec;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%% Plotting topoplot%%%%%%%%%%%%%%%%%%%%%%%%%%

    if dispMeanTopolplot
        mainFig=figure(2);
        mainFig.WindowState = 'Maximized';
        hTopo=getPlotHandles(3,12,[0.1 0.1 0.85 0.7],0.03,0.01); % note: flipping to get the correct index for for the plot
        for topoindex=1:3
            for si=1:numSegments
                % thre cases:
                switch topoindex
                    case 1
                        dataforTopoplot = rawMeanAlphaThisElec(si,:);
                    case 2
                        dataforTopoplot = rawMeanSlowGThisElec(si,:);
                    case 3
                        dataforTopoplot = rawMeanFastGThisElec(si,:);
                end

                % dataforTopoplot = rawMeanSlowGThisElec(si,:);
                capType = 'actiCap64_UOL';
                montagePath = 'D:\Programs\ProgramsMAP\Montages\Layouts\actiCap64_UOL';
                chLocs{1} = load(fullfile(montagePath,'actiCap64_UOL.mat'));
                x = load([capType 'Labels.mat']); montageLabels = x.montageLabels(:,2);
                x = load([capType '.mat']);       montageChanlocs = x.chanlocs;
                refTypeString   = {'UniPolar'};
                freqRangeString = {'Alpha','Slow Gamma','Fast Gamma'};

                chLoc = chLocs{1}.chanlocs;
                axes(hTopo(topoindex,si));
                topoplot(dataforTopoplot,chLoc,'electrodes','on'); colormap('jet');
                clim([-0.5 0.5]);
                title(segmentNameList{si});
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%% End: Plotting topoplot%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clf
end