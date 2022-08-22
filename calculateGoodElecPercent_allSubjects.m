% AB, NN @81722

function calculateGoodElecPercent_allSubjects(dataFolderString,extractTheseIndices,gridLayout,color_imageSC,protName)
% this functions does the following:
% 1:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
% capType = 'actiCap64_UOL';
allEegElectrodeIndex = 1:64;
numElectrodes = length(allEegElectrodeIndex);

badTrialString = [{'v5'}, {'d4020_v7'}, {'d4020_v8'}, {'d4020_v9'},{'d4020_v10'}];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iString = 1:length(badTrialString)
    if ~exist('protName','var')
        [totalGoodElec_AllSubs, goodElecPerGroupAllSub,allFlatElecs,groupNameList]= calculateGoodElec(extractTheseIndices,badTrialString{iString},gridType,gridLayout,dataFolderString,allEegElectrodeIndex);
    else
        [totalGoodElec_AllSubs, goodElecPerGroupAllSub,allFlatElecs,groupNameList]= calculateGoodElec(extractTheseIndices,badTrialString{iString},gridType,gridLayout,dataFolderString,allEegElectrodeIndex,protName);
    end
    
    allGoodElec{iString}        = totalGoodElec_AllSubs;
    goodElecPerGroup{iString}   = goodElecPerGroupAllSub;
    allFlatElec{iString}        = allFlatElecs;
end

plotGoodElec(allGoodElec,goodElecPerGroup,allFlatElec,groupNameList,badTrialString,color_imageSC)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Accesory function:
function  [totalGoodElec_AllSubs, goodElecPerGroupAllSub,allFlatElecs,groupNameList]= calculateGoodElec(extractTheseIndices,badTrialString,gridType,gridLayout,dataFolderString,allEegElectrodeIndex,protName)
% calculates the goodElec Perctantage for a perticular protocol:
% this gives total number of good electrode for wach subject
% TD: it could give the electrodes divided by the groups as well

if ~exist('protName','var')
    [subjectNames,expDates,protocolNames,~,~,~] = allProtocolsCRFAttentionEEGv1;
else
    [subjectNames,expDates] = subjectDatabaseMeditationProject2;
    protocolName = protName;
end

for subInd=1:length(extractTheseIndices)
    
    subjectName = subjectNames{extractTheseIndices(subInd)};
    expDate = expDates{extractTheseIndices(subInd)};
    
    if ~exist('protName','var')
        protocolName = protocolNames{extractTheseIndices(subInd)};
    end
    
    
    disp(['Processing Data for Subject: ' subjectName ' & Protocol: ' protocolName] );
    
    % Get bad trials
    folderSegment = fullfile(dataFolderString,'data',subjectName,gridType,expDate,protocolName,'segmentedData/');
    badTrialFile = fullfile(folderSegment,['badTrials_' badTrialString '.mat']);
    [badElecs] = loadBadTrials(badTrialFile); 
    
    badElecrodesIndex = unique([badElecs.badImpedanceElecs;badElecs.noisyElecs;badElecs.flatPSDElecs]);
    flatBadElecs      = badElecs.flatPSDElecs;
    
    allFlatElecs(:,subInd)  =  length(flatBadElecs) ;
    goodElectrodesIndex     = setdiff(allEegElectrodeIndex,badElecrodesIndex);
    totalGoodElec_AllSubs(:,subInd) = length(goodElectrodesIndex);
    
    % Grouping the good electrodes in different catagories:
    numElectrode = length(allEegElectrodeIndex);
    [~,~,~,electrodeGroupList,groupNameList,highPriorityElectrodeNums] = electrodePositionOnGrid(numElectrode,'EEG',[],gridLayout);
    
    for jGroup=1:length(electrodeGroupList)
        goodElecPerGroup = intersect(goodElectrodesIndex,electrodeGroupList{jGroup});
        %       convert NaN cells into empty matrices []
        if isnan(goodElecPerGroup)
            goodElecPerGroup=[];
        end
        goodElecPerGroupAllSub(jGroup,subInd) = length(goodElecPerGroup)/length(electrodeGroupList{jGroup});
    end
end
end

%%

function  [goodElecPercentCurrVer]= plotGoodElec(allgoodElec,goodElecPerGroup,allFlatElec,groupNameList,badTrialString,color_imageSC)
% plots the goodElec Perctantage for a perticular protocol:
f = figure;
f. WindowState = 'maximized';
hPlot1= getPlotHandles(1,2,[0.1 0.6 0.8 0.3],0.05,0.1);
hPlot2 = getPlotHandles(1,5,[0.1 0.1 0.8 0.4],0.05,0.1); linkaxes(hPlot2)

colorStrings = [{'m'},{'r'},{'b'},{'c'},{'k'}];

subIndexS = 1:length(allgoodElec{1});


for badStringInd=1:length(allgoodElec)
    % hPlot1a all good elecs
    stem(hPlot1(1,1),subIndexS,allgoodElec{badStringInd},'color',colorStrings{badStringInd}); axis('tight');
    hold(hPlot1(1,1),'on');
    xlabel(hPlot1(1,1),'Subject Index'); ylabel(hPlot1(1,1),'Total number of Good Electrodes');
    
    % hPlot1,b all flat elecs
    stem(hPlot1(1,2),subIndexS,allFlatElec{badStringInd},'color',colorStrings{badStringInd}); axis('tight');
    hold(hPlot1(1,2),'on');
    xlabel(hPlot1(1,2),'Subject Index'); ylabel(hPlot1(1,2),'Total number of Flat Electrodes');
    
    % hPlot2
    colormap(color_imageSC)
    subplot(hPlot2(1,badStringInd))
    imagesc(goodElecPerGroup{badStringInd});
    yticks(hPlot2(1,badStringInd),[]);
    xlabel(hPlot2(1,badStringInd),'Subject Index');
    title(hPlot2(1,badStringInd),badTrialString{badStringInd});
    
    if badStringInd==1
        subplot(hPlot2(1,badStringInd))
        for iGroup=1:length(groupNameList)
           text(-28,iGroup,groupNameList{iGroup},'FontSize',12);
        end
    end    
    
end

% hPlo2---
subplot(hPlot2(1,5))
c = colorbar;
c.Position(1) = c.Position(1)+0.05 ;

% hPlot1 ----
badTrialString{6}='70% ElecS';
badTrialString{7}='Total ElecS';
yline(hPlot1(1,1),0.7*64,'g'); yline(hPlot1(1,1),64,'r');
legend(hPlot1(1,1),badTrialString,'Location','bestoutside');
legend(hPlot1(1,2),badTrialString,'Location','bestoutside');
xlim(hPlot1(1,1),[0 length(subIndexS)+1]);
xlim(hPlot1(1,2),[0 length(subIndexS)+1]);
sgtitle('Total Number of good Elecs Across subjects');
end

% accessory function for loading specific variables from badTrial file
function [badElecs] = loadBadTrials(badTrialFile) %#ok<*STOUT>
load(badTrialFile);
end
