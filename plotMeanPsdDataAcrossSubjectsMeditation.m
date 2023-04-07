%% Working on the code on 5-Apr-23
% changed the order. first all the flags followed by loading the data

%% To Do:-
%-------------------------------------------------------
% add significance within the plot function---
% choose signicance test based on the datType flag
% add appropriate legends
% make the proper alignment for the code

%% ----------------Immedietly-----------------------------
% difference plots with ErrorBar
%   - EO1 substract Individual
%   - EO1 substract common
% combine data for the possible segments

%% data Informations:

function plotMeanPsdDataAcrossSubjectsMeditation(medianFlag,biPolarFlag,removeIndividualUniqueBadTrials)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('medianFlag','var');                          medianFlag=0;                          end
if ~exist('biPolarFlag','var');                         biPolarFlag = 1;                       end
if ~exist('removeIndividualUniqueBadTrials','var');     removeIndividualUniqueBadTrials=0;     end
% close all
% medianFlag = 0;
% biPolarFlag = 1;
% removeIndividualUniqueBadTrials = 0;
%-----------------------------------------------------------------
gridType = 'EEG';
capType = 'actiCap64_UOL';
groupIDs = [{'C'} {'A'}];
protocolNameList = [{'EO1'}  {'EC1'}  {'G1'}  {'M1a'}  {'M1b'}  {'M1c'} {'G2'}  {'EO2'}  {'EC2'}  {'M2a'} {'M2b'} {'M2c'}];
colorNameGroupsIDs = [{[0 1 0]} {[1 0 0]} {[0 0 1]}];

% get plot handles for 6 electrode group and 12 different conditions
gridPos=[0.1 0.1 0.85 0.75];
% figHandle = figure(1);
epA = getPlotHandles(6,12,gridPos);
showSEMFlag = 0;
putAxisLabel = 0;

axisLimAuto = 0;
xLimsRange = [0 120];
yLimsRange = [-2 2];

[~,~,~,electrodeGroupList0,groupNameList0,highPriorityElectrodeNums] = electrodePositionOnGrid(1,gridType,[],capType);
electrodeGroupList0{6} = highPriorityElectrodeNums;
groupNameList0{6} = 'highPriority';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Load data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadFilepath = getFolderName(biPolarFlag,removeIndividualUniqueBadTrials);
data=load(loadFilepath);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% get data Informations:
numGroups     =  length(groupIDs);
numProtocols  =  length(protocolNameList);
numElecGroups =  length(electrodeGroupList0);

numSubjects    = size(data.powerValStCombinedControl,1);
numConditions  = size(data.powerValStCombinedControl,2);
numFrequencies = size(data.powerValStCombinedControl,3);
numElectrodes  = size(data.powerValStCombinedControl,4);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get Data and plot
allMeanPSDs = [];
dataForSignificanceTest = zeros(numGroups,numSubjects,numFrequencies);
freqVals=1:numFrequencies;

% combine Data
powerValStCombined{1}=data.powerValStCombinedControl;
powerValStCombined{2}=data.powerValStCombinedAdvanced;

for p=1:numProtocols % Segments: EO1/EC1/........
    for g=1:numElecGroups % Electrode Group
        for group=1:numGroups %Control and meditators

            % setting the displayFlags (there should be better way)
            if g==1
                showTitleFlag=1;
            else
                showTitleFlag=0;
            end

            if p==1
                putElecGroupName = 1;
                if g==6
                    putAxisLabel = 1;
                end
            else
                putElecGroupName = 0;
                putAxisLabel = 0;
            end

            %------------------------------the main code-------------------------------------------------------------------
            electrodeList = electrodeGroupList0{g};
            % g across the selected electrodes in the raw power Domain
            powerValStCombinedThisElecGroup = mean(powerValStCombined{group}(:,:,:,electrodeList),4,'omitnan');
            % log transform the values
            powerValSTCombinedAdvancedLogTransformed = log10(powerValStCombinedThisElecGroup);
            data = squeeze(powerValSTCombinedAdvancedLogTransformed(:,p,:));

            plotData(epA(g,p),freqVals,data,colorNameGroupsIDs{group},showSEMFlag,showTitleFlag,protocolNameList{p},putElecGroupName,groupNameList0{g},putAxisLabel,xLimsRange,yLimsRange,biPolarFlag,medianFlag,group,groupIDs)

            %-----------------Adding significance to the plot---------------------------------------------------------------------------------
            dataForSignificanceTest(group,:,:) = data;
            if group==2
                axesHandle = epA(g,p);
                powerControl = squeeze(dataForSignificanceTest(1,:,:));
                powerAdvance = squeeze(dataForSignificanceTest(2,:,:));
                compareMeansAndShowSignificance(powerControl,powerAdvance,numFrequencies,axesHandle,xLimsRange,yLimsRange,axisLimAuto)
            end
        end
    end
end
end

%%%%%%%%%%%%%%%%%%%%% Helper Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helper functions:

function plotData(hPlot,xs,data,colorName,showSEMFlag,showTitleFlag,titleStr,putElecGroupName,groupName,putAxisLabel,xLimsRange,yLimsRange,biPolarFlag,medianFlag,group,groupIDs)

if ~exist('showSEMFlag','var');     showSEMFlag = 1;                    end

tmp=rgb2hsv(colorName);
tmp2 = [tmp(1) tmp(2)/3 tmp(3)];
colorName2 = hsv2rgb(tmp2); % Same color with more saturation

% mData = squeeze(mean(data,1));
if medianFlag
    mData = squeeze(median(data,1,'omitnan'));
else
    mData = squeeze(mean(data,1,'omitnan'));
end

if showSEMFlag
    if medianFlag
        getLoc = @(g)(squeeze(median(g,1),'omitnan'));
        bootStat = bootstrp(1000,getLoc,data);
        sData = std(bootStat);
    else
        sData = std(data,[],1,'omitnan')/sqrt(size(data,1));
    end
    xsLong = [xs fliplr(xs)];
    ysLong = [mData+sData fliplr(mData-sData)];
    patch(xsLong,ysLong,colorName2,'EdgeColor','none','parent',hPlot);
end
hold(hPlot,'on');

if putAxisLabel
    plot(hPlot,xs,mData,'color',colorName,'linewidth',1.5,'displayname',groupIDs{group});
    %     legend(hPlot,{'C'});
else
    plot(hPlot,xs,mData,'color',colorName,'linewidth',1.5);
end

xlim(hPlot,xLimsRange);
ylim(hPlot,yLimsRange);
if showTitleFlag
    title(hPlot,titleStr);
end
if putElecGroupName
    text(-80,-0.75,groupName,'FontSize',14,'Rotation',45,'parent',hPlot);
end

if putAxisLabel
    xlabel(hPlot,'frequency(Hz)','FontSize',12);
    %     ylabel(hPlot,'log_{10}(Power)','FontSize',12);
    ylabel(hPlot,'lg(Power)','FontSize',12);
    %     legend(hPlot,'Con','Med');
    if biPolarFlag
        sgtitle('Bipolar: Raw PSD for Meditators vs. Control across different protocols, n=30');
        %     xline(hPlot,24);
    else
        sgtitle('UniPolar: Raw PSD for Meditators vs. Control across different protocols, n=30');
    end
end
end


function compareMeansAndShowSignificance(data1,data2,numFrequencies,axesHandle,xLimsRange,yLimsRange,axisLimAuto)

hPlot = axesHandle;
% set(hPlot,'XTick',[1 3 5 7],'XTickLabel',[1.6 6.25 25 100]);
yLims= getYLims(hPlot,yLimsRange,axisLimAuto); %max(min([0 inf],getYLims(hPlot)),[-inf 1]);

%%%%%%%%%%%%%%%%%%%%%%% compare attIn and attOut %%%%%%%%%%%%%%%%%%%%%%%%%%
dX = 1; dY = diff(yLims)/20;
numDays = 2;
freqIndices = 0:numFrequencies-1;
if numDays>1
    for i=1:numFrequencies
        %         [~,p] = ttest2(data1(:,i),data2(:,i));    % for paired sample (parametric)
        [p] = signrank(data1(:,i),data2(:,i));              % for paired sample (non-parametric)
        %         [p] = ranksum(data1(:,11),data2(:,10))    % for non-paired assumtion
        %                                                     or two independent unequal-sized samples.)
        %         if p<0.05/numContrasts
        %             pColor = 'r';

        if p<0.05
            pColor = 'r';
        else
            pColor = 'w';
        end

        patchX = freqIndices(i)-dX/2;
        patchY = yLims(1)-2*dY;
        patchLocX = [patchX patchX patchX+dX patchX+dX];
        patchLocY = [patchY patchY+dY patchY+dY patchY];
        patch(patchLocX,patchLocY,pColor,'Parent',hPlot,'EdgeColor',pColor);
    end
end
axis(hPlot,[0 numFrequencies-1 yLims+[-2*dY 2*dY]]);
set(hPlot,'xlim',xLimsRange);
legend('off');
% ylabel(hPlot,ylabelStr);
end


% Rescaling functions
function yLims = getYLims(plotHandles,yLimsRange,axisLimAuto)

if axisLimAuto
    [numRows,numCols] = size(plotHandles);
    % Initialize
    yMin = inf;
    yMax = -inf;

    for row=1:numRows
        for column=1:numCols
            % get positions
            axis(plotHandles(row,column),'tight');
            tmpAxisVals = axis(plotHandles(row,column));
            if tmpAxisVals(3) < yMin
                yMin = tmpAxisVals(3);
            end
            if tmpAxisVals(4) > yMax
                yMax = tmpAxisVals(4);
            end
        end
    end
    yLims = [yMin yMax];
else
    yLims = [yLimsRange(1) yLimsRange(2)];
end

end

function loadFilepath= getFolderName(biPolarFlag,removeIndividualUniqueBadTrials)
sdParams.folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';

saveDataDeafultStr ='subjectWise';

if biPolarFlag
    saveDataDeafultStr = [saveDataDeafultStr 'Bipolar'];
    fileName = 'BiPolarGroupedPowerDataPulledAcrossSubjects.mat';
else
    saveDataDeafultStr = [saveDataDeafultStr 'Unipolar'];
    fileName = 'UnipolarGroupedPowerDataPulledAcrossSubjects.mat';
end

if removeIndividualUniqueBadTrials
    saveFolderName = [saveDataDeafultStr 'BadTrialIndElec'];
else
    saveFolderName = [saveDataDeafultStr 'BadTrialComElec'];
end

loadFilepath = fullfile(sdParams.folderSourceString,'data','savedData','subjectWiseDataMaster',saveFolderName,fileName);
end


