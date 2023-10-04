function MeditationFigure1()

% Meditation figure 1
% Power changes during the Gamma protocol; Control Vs Meditators
% by Ankan on 15th September'2023
% NeuroOscillations Lab, CNS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -----------Starting Point------------ %%%%%%%%%%%%%%%%%%%%%%%
clf
clear
figHandle = figure(1);

% psd figures:
gridPos=[0.35 0.1 0.6 0.75];
ePsd = getPlotHandles(1,3,gridPos,0.05,0.005,0);

% topoplot
%getPlotHandles(numRows,numCols,gridPos,gapX,gapY,removeLabels)
gridPos=[0.1 0.1 0.2 0.75];
eTopo = getPlotHandles(2,1,gridPos,0.05,0.05,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 0th: Base Plot Structure which need to be filled in %%%%%%%%%%%%%%%%%%%%%%

sgtitle('mean Power during the first Gamma Protocol (G1) : n=30');
title(ePsd(1,1),'raw Power during BaseLine');
xlabel(ePsd(1,1),'frequency(Hz)','FontSize',12)
ylabel(ePsd(1,1),'log_{10}(Power)','FontSize',12);
hold(ePsd(1,1),'on');

title(ePsd(1,2),'raw Power during Stimulus');
xlabel(ePsd(1,2),'frequency(Hz)','FontSize',12)
hold(ePsd(1,2),'on');

title(ePsd(1,3),'\Delta Power');
xlabel(ePsd(1,3),'frequency(Hz)','FontSize',12)
ylabel(ePsd(1,3),'dB','FontSize',12);
hold(ePsd(1,3),'on');

% title(epA(1,4),'\Delta Power  (Individual Baseline Across Subjects)');
% xlabel(epA(1,4),'frequency(Hz)','FontSize',12)
% ylabel(epA(1,4),'dB','FontSize',12);
% hold(epA(1,4),'on');


% title(epA(1,4),'\Delta Power'); % BarPlot summarizing the chnage
% xlabel(epA(1,4),'frequency(Hz)','FontSize',12)
% ylabel(epA(1,4),'dB','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1st: Get the relevant data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Without visual inspected one; unipolar results we would do

if ~exist('medianFlag','var');                          medianFlag = 0;                        end
if ~exist('biPolarFlag','var');                         biPolarFlag = 0;                       end
if ~exist('removeIndividualUniqueBadTrials','var');     removeIndividualUniqueBadTrials = 0;   end
if ~exist('showSignificanceFlag','var');                showSignificanceFlag = 1;              end
if ~exist('showSEMFlag','var');                         showSEMFlag = 0;                       end
if ~exist('showDeltaPsdFlag','var');                    showDeltaPsdFlag = 0;                  end
if ~exist('showRawPsdFlag','var');                      showRawPsdFlag = 1;                    end

% common starters:
gridType = 'EEG';
capType = 'actiCap64_UOL';
groupIDs = [{'C'} {'A'}]; 
numGroups     =  length(groupIDs);
protocolNameList = [{'EO1'}  {'EC1'}  {'G1'}  {'M1a'}  {'M1b'}  {'M1c'} ...
    {'G2'}  {'EO2'}  {'EC2'}  {'M2a'} {'M2b'} {'M2c'}];
colorNameGroupsIDs = [{[0 1 0]} {[1 0 0]} {[0 0 1]}];


removeVisualInspElecs = 0;
computeDeltaPsdFlag=1;
loadFilepath = getFolderName(biPolarFlag,removeIndividualUniqueBadTrials,removeVisualInspElecs);


% electrodeGroups:
[~,~,~,electrodeGroupList0,groupNameList0,highPriorityElectrodeNums] = electrodePositionOnGrid(1,gridType,[],capType);
electrodeGroupList0{6} = highPriorityElectrodeNums;
groupNameList0{6} = 'highPriority';

% loading the file:
if isfile(loadFilepath)
    disp('file exists; loading data');
    data=load(loadFilepath);
else
    error('file dont exist; save the relevant data');
end

% combine Data
powerValStCombined{1}=data.powerValStCombinedControl;
powerValStCombined{2}=data.powerValStCombinedAdvanced;

powerValBlCombined{1}=data.powerValBlCombinedControl;
powerValBlCombined{2}=data.powerValBlCombinedAdvanced;

numFrequencies = size(data.powerValStCombinedControl,3);
freqVals=0:(numFrequencies-1);

g=6; % Electrode Group % High Priority
p=3; % Segments: G1........

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
group=1; %Control and meditators
%------------------------------the main code-------------------------------------------------------------------
electrodeList = electrodeGroupList0{g};
% g across the selected electrodes in the raw power Domain
powerValBlCombinedThisElecGroup = mean(powerValBlCombined{group}(:,:,:,electrodeList),4,'omitnan');
powerValStCombinedThisElecGroup = mean(powerValStCombined{group}(:,:,:,electrodeList),4,'omitnan');
% log transform the values
powerValBlCombinedThisGroupLogTransformed = log10(powerValBlCombinedThisElecGroup);
powerValStCombinedThisGroupLogTransformed = log10(powerValStCombinedThisElecGroup);
% sequeeze
dataBlControl = squeeze(powerValBlCombinedThisGroupLogTransformed(:,p,:)); %-squeeze(powerValBlCombinedThisGroupLogTransformed(:,p,:));
dataStControl = squeeze(powerValStCombinedThisGroupLogTransformed(:,p,:)); %

dataDeltaPowerControl = 10*(dataStControl-dataBlControl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mean across the subjects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanAcrossSubjectsPowerValBlControl = mean(dataBlControl,1,"omitnan"); %meanAcrossSubjectsPowerValBlCombinedThisGroupLogTransformed
meanAcrossSubjectsPowerValStControl = mean(dataStControl,1,"omitnan"); %meanAcrossSubjectsPowerValSTCombinedThisGroupLogTransformed

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Advanced %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
group=2; %Control and meditators
%------------------------------the main code-------------------------------------------------------------------
electrodeList = electrodeGroupList0{g};
% g across the selected electrodes in the raw power Domain
powerValBlCombinedThisElecGroup = mean(powerValBlCombined{group}(:,:,:,electrodeList),4,'omitnan');
powerValStCombinedThisElecGroup = mean(powerValStCombined{group}(:,:,:,electrodeList),4,'omitnan');
% log transform the values
powerValBlCombinedThisGroupLogTransformed = log10(powerValBlCombinedThisElecGroup);
powerValStCombinedThisGroupLogTransformed = log10(powerValStCombinedThisElecGroup);
% sequeeze
dataBlAdvanced = squeeze(powerValBlCombinedThisGroupLogTransformed(:,p,:)); %-squeeze(powerValBlCombinedThisGroupLogTransformed(:,p,:));
dataStAdvanced = squeeze(powerValStCombinedThisGroupLogTransformed(:,p,:)); %dataDeltaPowerControl = 10*(dataStControl-dataBlControl);

dataDeltaPowerAdvanced = 10*(dataStAdvanced-dataBlAdvanced);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mean across the subjects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanAcrossSubjectsPowerValBlAdvanced = mean(dataBlAdvanced,1,"omitnan"); %meanAcrossSubjectsPowerValBlCombinedThisGroupLogTransformed
meanAcrossSubjectsPowerValStAdvanced = mean(dataStAdvanced,1,"omitnan"); %meanAcrossSubjectsPowerValSTCombinedThisGroupLogTransformed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% deltaPower  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a. CommonBaseline Across Subject %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaPowerControl  = 10*(meanAcrossSubjectsPowerValStControl-meanAcrossSubjectsPowerValBlControl);
deltaPowerAdvanced = 10*(meanAcrossSubjectsPowerValStAdvanced-meanAcrossSubjectsPowerValBlAdvanced);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% b. Individual Across Subject %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaPowerControlIndividual  =  mean(dataDeltaPowerControl,1,"omitnan");
deltaPowerAdvancedIndividual =  mean(dataDeltaPowerAdvanced,1,"omitnan");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a. Individuel Baseline Across Subject %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2nd: Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axisLimAuto = 0;
xLimsRange = [0 150];
yLimsRangeRaw = [-2 2.5];
xLimsRangeDelta = [0 100];
yLimsRangeDelta = [-2 2.5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.a: Comparing Baseline gamma power between control and advanced %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(ePsd(1,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
plot(ePsd(1,1),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
showSEMFlag =1;
tmp=rgb2hsv(colorNameGroupsIDs{1});
tmp2 = [tmp(1) tmp(2)/3 tmp(3)];
colorName2Control = hsv2rgb(tmp2); % Same color with more saturation

tmp=rgb2hsv(colorNameGroupsIDs{2});
tmp2 = [tmp(1) tmp(2)/3 tmp(3)];
colorName2Advanced = hsv2rgb(tmp2); % Same color with more saturation

if showSEMFlag    
    sData = std(dataBlControl,[],1,'omitnan')/sqrt(size(dataBlControl,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValBlControl+sData fliplr(meanAcrossSubjectsPowerValBlControl-sData)];
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',ePsd(1,1));
    plot(ePsd(1,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});

    sData = std(dataBlAdvanced,[],1,'omitnan')/sqrt(size(dataBlAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValBlAdvanced+sData fliplr(meanAcrossSubjectsPowerValBlAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',ePsd(1,1));

    plot(ePsd(1,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(ePsd(1,1),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end

xlim(ePsd(1,1),xLimsRange); ylim(ePsd(1,1),yLimsRangeRaw); 
text(ePsd(1,1),60,1,'Slow Gamma:20-34 Hz','Color',[0 0.5 0.5]);

xline(ePsd(1,1),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(ePsd(1,1),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(ePsd(1,1),36,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(ePsd(1,1),66,'--','Color',[0 0 0.8],'linewidth',1.5);
% compareMeansAndShowSignificance(dataBlControl,dataBlAdvanced,length(freqVals),epA(1,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
compareMeansAndShowSignificance(dataBlAdvanced,dataBlControl,length(freqVals),ePsd(1,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
legend(ePsd(1,1),'Control','Meditators');
hold(ePsd(1,1),'off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.b: Comparing Stimulus gamma power between control and advanced %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(ePsd(1,2),freqVals,meanAcrossSubjectsPowerValStControl,'color',colorNameGroupsIDs{1},'linewidth',1.5,'displayname',groupIDs{group});
xlim(ePsd(1,2),xLimsRange); ylim(ePsd(1,2),yLimsRangeRaw); 
plot(ePsd(1,2),freqVals,meanAcrossSubjectsPowerValStAdvanced,'color',colorNameGroupsIDs{2},'linewidth',1.5,'displayname',groupIDs{group});
xlim(ePsd(1,2),xLimsRange); ylim(ePsd(1,2),yLimsRangeRaw); 

xline(ePsd(1,2),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(ePsd(1,2),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(ePsd(1,2),36,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(ePsd(1,2),66,'--','Color',[0 0 0.8],'linewidth',1.5);
% compareMeansAndShowSignificance(dataStControl,dataStAdvanced,length(freqVals),epA(1,2),xLimsRange,yLimsRangeRaw,axisLimAuto);
compareMeansAndShowSignificance(dataStAdvanced,dataStControl,length(freqVals),ePsd(1,2),xLimsRange,yLimsRangeRaw,axisLimAuto);

if showSEMFlag
    sData = std(dataStControl,[],1,'omitnan')/sqrt(size(dataStControl,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValStControl+sData fliplr(meanAcrossSubjectsPowerValStControl-sData)];
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',ePsd(1,2));

    sData = std(dataStAdvanced,[],1,'omitnan')/sqrt(size(dataStAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValStAdvanced+sData fliplr(meanAcrossSubjectsPowerValStAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',ePsd(1,2));

    plot(ePsd(1,2),freqVals,meanAcrossSubjectsPowerValStControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(ePsd(1,2),freqVals,meanAcrossSubjectsPowerValStAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end

hold(ePsd(1,2),'off');

%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.c: Comparing delta gamma power between control and advanced (commonBaselineAcrossSubjects)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(ePsd(1,3),freqVals,deltaPowerControl,'color',colorNameGroupsIDs{1},'linewidth',1.5,'displayname',groupIDs{group});
plot(ePsd(1,3),freqVals,deltaPowerAdvanced,'color',colorNameGroupsIDs{2},'linewidth',1.5,'displayname',groupIDs{group});
xlim(ePsd(1,3),xLimsRangeDelta); ylim(ePsd(1,3),yLimsRangeDelta); 

xline(ePsd(1,3),0,'--');
xline(ePsd(1,3),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(ePsd(1,3),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(ePsd(1,3),36,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(ePsd(1,3),66,'--','Color',[0 0 0.8],'linewidth',1.5);

% compareMeansAndShowSignificance(dataDeltaPowerControl,dataDeltaPowerAdvanced,length(freqVals),epA(1,3),xLimsRangeDelta,yLimsRangeDelta,axisLimAuto);
compareMeansAndShowSignificance(dataDeltaPowerAdvanced,dataDeltaPowerControl,length(freqVals),ePsd(1,3),xLimsRangeDelta,yLimsRangeDelta,axisLimAuto);

if showSEMFlag
    sData = std(dataDeltaPowerControl,[],1,'omitnan')/sqrt(size(dataDeltaPowerControl,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [deltaPowerControl+sData fliplr(deltaPowerControl-sData)];
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',ePsd(1,3));

    sData = std(dataDeltaPowerAdvanced,[],1,'omitnan')/sqrt(size(dataDeltaPowerAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [deltaPowerAdvanced+sData fliplr(deltaPowerAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',ePsd(1,3));

    plot(ePsd(1,3),freqVals,deltaPowerControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(ePsd(1,3),freqVals,deltaPowerAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end



%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.d: Comparing delta gamma power between control and advanced (IndividuelBaselineAcrossSubjects)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot(epA(1,4),freqVals,deltaPowerControlIndividual,'color',colorNameGroupsIDs{1},'linewidth',1.5,'displayname',groupIDs{group});
% plot(epA(1,4),freqVals,deltaPowerAdvancedIndividual,'color',colorNameGroupsIDs{2},'linewidth',1.5,'displayname',groupIDs{group});
% xlim(epA(1,4),xLimsRangeDelta); ylim(epA(1,4),yLimsRangeDelta); 
% 
% xline(epA(1,4),0,'--');
% xline(epA(1,4),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
% xline(epA(1,4),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);
% 
% xline(epA(1,4),36,'--','Color',[0 0 0.8],'linewidth',1.5);
% xline(epA(1,4),66,'--','Color',[0 0 0.8],'linewidth',1.5);
% 
% compareMeansAndShowSignificance(dataDeltaPowerControl,dataDeltaPowerAdvanced,length(freqVals),epA(1,4),xLimsRangeDelta,yLimsRangeDelta,axisLimAuto);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
commonPlotChnage = 1;
if commonPlotChnage
fontsize =12;  
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

SavePlot = 0;
if SavePlot
 % Get the current figure handle.
  fh = gcf;

  % Set the resolution of the figure.
  set(fh, 'Renderer', 'opengl', 'Resolution', 600);

  % Export the figure to a TIF file.
  exportgraphics(fh, fileName, 'Format', 'tiff');
end
end % Main Function ends here



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Start:Associated functions(Make them independent to run online) %%%%%%%%%%%%%%%%%%%%%%%%












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End:Associated functions(Make them independent to run online) %%%%%%%%%%%%%%%%%%%%%%%%
