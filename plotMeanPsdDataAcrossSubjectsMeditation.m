
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
clear
clf

folderSrourceString = 'D:\Projects\MeditationProjects\MeditationProject2\data\savedData\subjectWise';
biPolarFlag=1;
if biPolarFlag==1
    fileName = 'BiPolarGroupedPowerDataPulledAcrossSubjects.mat';
else
    fileName = 'UnipolarGroupedPowerDataPulledAcrossSubjects.mat';
end

load(fullfile(folderSrourceString,fileName));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
capType = 'actiCap64_UOL';

groupIDs = [{'C'} {'A'}];
protocolNameList = [{'EO1'}  {'EC1'}  {'G1'}  {'M1a'}  {'M1b'}  {'M1c'}   {'G2'}  {'EO2'}  {'EC2'}  {'M2a'} {'M2b'} {'M2c'}];
numProtocols = length(protocolNameList);

colorNameGroupsIDs = [{[0 1 0]} {[1 0 0]} {[0 0 1]}];
%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,~,~,electrodeGroupList0,groupNameList0,highPriorityElectrodeNums] = electrodePositionOnGrid(1,gridType,[],capType);
electrodeGroupList0{6} = highPriorityElectrodeNums;
groupNameList0{6} = 'highPriority';
numElecGroups = length(electrodeGroupList0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get plot handles for 6 electrode group and 12 different conditions
gridPos=[0.1 0.1 0.85 0.75];
epA = getPlotHandles(6,12,gridPos);
% linkaxes(epA);
showSEMFlag = 0;
putAxisLabel = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get Data and plot
allMeanPSDs = [];
freqVals=1:251;

% combine Data
powerValStCombined{1}=powerValStCombinedControl;
powerValStCombined{2}=powerValStCombinedAdvanced;

for p=1:numProtocols % Segments: EO1/EC1/........
    for g=1:numElecGroups % Electrode Group
        for group=1:length(groupIDs) %Control and meditators
            
            %setting the displayFlags (there should be better way)
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
            % mean across the selected electrodes in the raw power Domain
            powerValStCombinedThisElecGroup = mean(powerValStCombined{group}(:,:,:,electrodeList),4,'omitnan');
            % log transform the values
            powerValSTCombinedAdvancedLogTransformed = log10(powerValStCombinedThisElecGroup);
            data = squeeze(powerValSTCombinedAdvancedLogTransformed(:,p,:));
            
            plotData(epA(g,p),freqVals,data,colorNameGroupsIDs{group},showSEMFlag,showTitleFlag,protocolNameList{p},putElecGroupName,groupNameList0{g},putAxisLabel)
            %--------------------------------------------------------------------------------------------------
            dataForTest(group,:,:) = data;
            if group==2
                data1 = squeeze(dataForTest(1,:,:));
                data2 = squeeze(dataForTest(2,:,:));
                axesHandle = epA(g,p);
                compareMeansAndShowSignificance(data1,data2,axesHandle)
            end
        end
    end
end


function plotData(hPlot,xs,data,colorName,showSEMFlag,showTitleFlag,titleStr,putElecGroupName,groupName,putAxisLabel)

if ~exist('showSEMFlag','var');     showSEMFlag = 1;                    end

tmp=rgb2hsv(colorName);
tmp2 = [tmp(1) tmp(2)/3 tmp(3)];
colorName2 = hsv2rgb(tmp2); % Same color with more saturation

% mData = squeeze(mean(data,1));
mData = squeeze(median(data,1));

if showSEMFlag
    sData = std(data,[],1)/sqrt(size(data,1));
    xsLong = [xs fliplr(xs)];
    ysLong = [mData+sData fliplr(mData-sData)];
    patch(xsLong,ysLong,colorName2,'EdgeColor','none','parent',hPlot);
end
hold(hPlot,'on');
plot(hPlot,xs,mData,'color',colorName,'linewidth',1.5);
xlim(hPlot,[0 60]);
if showTitleFlag
    title(hPlot,titleStr);
end
if putElecGroupName
    text(-60,-0.75,groupName,'FontSize',14,'Rotation',45,'parent',hPlot);
end

if putAxisLabel
    xlabel(hPlot,'frequency(Hz)','FontSize',12);
    %     ylabel(hPlot,'log_{10}(Power)','FontSize',12);
    ylabel(hPlot,'lg(Power)','FontSize',12);
    %     legend(hPlot,'Con','Med');
    sgtitle('Raw PSD for Meditators vs. Control across different protocols, n=30');
    %     xline(hPlot,24);
end
end


function compareMeansAndShowSignificance(data1,data2,axesHandle)

hPlot = axesHandle;
% set(hPlot,'XTick',[1 3 5 7],'XTickLabel',[1.6 6.25 25 100]);
yLims= getYLims(hPlot); %max(min([0 inf],getYLims(hPlot)),[-inf 1]);

%%%%%%%%%%%%%%%%%%%%%%% compare attIn and attOut %%%%%%%%%%%%%%%%%%%%%%%%%%
dX = 1; dY = diff(yLims)/20;
numDays = 2;
numContrasts = 61;
contrastIndices = 0:numContrasts-1;

if numDays>1
    for i=1:numContrasts
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
        
        patchX = contrastIndices(i)-dX/2;
        patchY = yLims(1)-2*dY;
        patchLocX = [patchX patchX patchX+dX patchX+dX];
        patchLocY = [patchY patchY+dY patchY+dY patchY];
        patch(patchLocX,patchLocY,pColor,'Parent',hPlot,'EdgeColor',pColor);
    end
end
axis(hPlot,[0 numContrasts-1 yLims+[-2*dY 2*dY]]);
legend('off');
% ylabel(hPlot,ylabelStr);
end


% Rescaling functions
function yLims = getYLims(plotHandles)

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
end
