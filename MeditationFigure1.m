function MeditationFigure1()

% Meditation figure 1
% Power changes during the Gamma protocol; Control Vs Meditators
% by Ankan on 15th September'2023
% NeuroOscillations Lab, CNS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -----------Starting Point------------ %%%%%%%%%%%%%%%%%%%%%%%
clf
clear
figHandle = figure(2);

% psd figures: G1 and G2
gridPos=[0.4 0.1 0.56 0.75];
ePsd = getPlotHandles(2,3,gridPos,0.05,0.05,0);

% topoplot:
%getPlotHandles(numRows,numCols,gridPos,gapX,gapY,removeLabels)
gridPos=[0.1 0.1 0.22 0.8];
eTopo = getPlotHandles(2,2,gridPos,0.05,0.1,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 0th: Base Plot Structure which need to be filled in %%%%%%%%%%%%%%%%%%%%%%

% Text: G1 and G2
% Define the text properties
textString   = {'G1','G2'};
textPosition = [0.03, 0.7];  % Normalized position [x, y] of the text
fontSize     = 20;
textColor    = 'Black';

% Add the text to the figure
annotation('textbox', [textPosition(1), textPosition(2), 0, 0], 'String', textString(1), 'FontSize', fontSize, 'Color', textColor, 'FitBoxToText', 'on', 'EdgeColor', 'none');
annotation('textbox', [textPosition(1), textPosition(2)-0.42, 0, 0], 'String', textString(2), 'FontSize', fontSize, 'Color', textColor, 'FitBoxToText', 'on', 'EdgeColor', 'none');
% annotation('textbox', [textPosition, 0.1, 0.1], 'String', textString, 'FontSize', fontSize, 'Color', textColor, 'EdgeColor', 'none');


% Part A: Psds: Few things are hardCoded
sgtitle('Power changes during the Gamma Protocol (G1 and G2) : n=30');
title(ePsd(1,1),'raw Power during BaseLine');
xlabel(ePsd(2,1),'frequency(Hz)','FontSize',12)
ylabel(ePsd(2,1),'log_{10}(Power)','FontSize',12);
hold(ePsd(1,1),'on'); hold(ePsd(2,1),'on');

title(ePsd(1,2),'raw Power during Stimulus');
xlabel(ePsd(2,2),'frequency(Hz)','FontSize',12)
hold(ePsd(1,2),'on'); hold(ePsd(2,2),'on');

title(ePsd(1,3),'\Delta Power');
xlabel(ePsd(2,3),'frequency(Hz)','FontSize',12)
ylabel(ePsd(1,3),'dB','FontSize',12);
hold(ePsd(1,3),'on'); hold(ePsd(2,3),'on');

% Part B: Topoplots
title(eTopo(1,1),'C');
title(eTopo(1,2),'A');
hold(eTopo(1,1),'on'); hold(ePsd(2,1),'on');


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

elecGroup=6; % Electrode Group % High Priority
pList=[3,7]; % Segments: G1 and G2



%% Now this part repeats and plots:


for g=1:2
    p=pList(g);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control Topoplot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% for tooplot we want first average of all the raw power across all the
% subjects:

% Data structure: 30x64x251 for each control and meditation for each
% baseline and stimulus epoch
% Then we get the 30x64xselectedFreq (depends on alpha, SG and FG)
% (follow whatver was fone befire)

% predefined variables for the topoplot: captypes and noseDir
noseDir = '+X';
capType = 'actiCap64_UOL';
montagePath = 'D:\Programs\ProgramsMAP\Montages\Layouts\actiCap64_UOL';
chLocs{1} = load(fullfile(montagePath,'actiCap64_UOL.mat'));
freqList{1} = [8 12];  freqListNames{1} = 'Alpha';
freqList{2} = [20 34]; freqListNames{2} = 'SG';
freqList{3} = [36 66]; freqListNames{3} = 'FG';
numFreqRanges = length(freqVals);

% and calculating the alpha and gammaPower in that segment.
alphaPos = intersect(find(freqVals>=freqList{1}(1)),find(freqVals<=freqList{1}(2)));
sgPos    = intersect(find(freqVals>=freqList{2}(1)),find(freqVals<=freqList{2}(2)));
fgPos    = intersect(find(freqVals>=freqList{3}(1)),find(freqVals<=freqList{3}(2)));
fgPos    = fgPos(fgPos~=(find(freqVals==50)));

% making the data for the topoplot:

% Control:
logMeanAlphaDataAllSubStimControl = log10(squeeze(mean(squeeze(data.powerValStCombinedControl(:,p,sgPos,:)),2,"omitnan")));
logMeanAlphaDataAllSubBaseControl = log10(squeeze(mean(squeeze(data.powerValBlCombinedControl(:,p,sgPos,:)),2,"omitnan")));
diffPowerAllSubGammaControl = 10*(logMeanAlphaDataAllSubStimControl-logMeanAlphaDataAllSubBaseControl);
meanDeltaPowerAllSubSlowGammaControl=mean(diffPowerAllSubGammaControl,1,"omitnan");

subplot(eTopo(g,1));
topoplot(meanDeltaPowerAllSubSlowGammaControl,chLocs{1,1}.chanlocs,'electrodes','off');
colormap('jet');
clim([-1 1]);
c=colorbar;
c.Position(1) = c.Position(1)+0.030;

% Advance:
logMeanAlphaDataAllSubStimAdvanced = log10(squeeze(mean(squeeze(data.powerValStCombinedAdvanced(:,p,sgPos,:)),2,"omitnan")));
logMeanAlphaDataAllSubBaseAdvanced = log10(squeeze(mean(squeeze(data.powerValBlCombinedAdvanced(:,p,sgPos,:)),2,"omitnan")));
diffPowerAllSubGammaAdvanced = 10*(logMeanAlphaDataAllSubStimAdvanced-logMeanAlphaDataAllSubBaseAdvanced);
meanDeltaPowerAllSubSlowGammaAdvanced=mean(diffPowerAllSubGammaAdvanced,1,"omitnan");

subplot(eTopo(g,2));
topoplot(meanDeltaPowerAllSubSlowGammaAdvanced,chLocs{1,1}.chanlocs,'electrodes','off');
colormap('jet');
clim([-1 1]);
c=colorbar;
c.Position(1) = c.Position(1)+0.030;


% diffPowerMeanAcrossSubjects=
% topoplot_murty(diffPowerMeanAcrossSubjects,chLoc,'electrodes','off','style','blank','drawaxis','off','nosedir',noseDir,'emarkercolors',diffPowerMeanAcrossSubjects,'emarkersize',5);



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
group=1; %Control and meditators
%------------------------------the main code-------------------------------------------------------------------
electrodeList = electrodeGroupList0{elecGroup};
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
electrodeList = electrodeGroupList0{elecGroup};
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
plot(ePsd(g,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
plot(ePsd(g,1),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
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
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',ePsd(g,1));
    plot(ePsd(g,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});

    sData = std(dataBlAdvanced,[],1,'omitnan')/sqrt(size(dataBlAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValBlAdvanced+sData fliplr(meanAcrossSubjectsPowerValBlAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',ePsd(g,1));

    plot(ePsd(g,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(ePsd(g,1),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end

xlim(ePsd(g,1),xLimsRange); ylim(ePsd(g,1),yLimsRangeRaw);
text(ePsd(g,1),60,1,'Slow Gamma:20-34 Hz','Color',[0 0.5 0.5]);

xline(ePsd(g,1),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(ePsd(g,1),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(ePsd(g,1),36,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(ePsd(g,1),66,'--','Color',[0 0 0.8],'linewidth',1.5);
% compareMeansAndShowSignificance(dataBlControl,dataBlAdvanced,length(freqVals),epA(1,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
compareMeansAndShowSignificance(dataBlAdvanced,dataBlControl,length(freqVals),ePsd(g,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
legend(ePsd(g,1),'Control','Meditators');
hold(ePsd(g,1),'off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.b: Comparing Stimulus gamma power between control and advanced %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(ePsd(g,2),freqVals,meanAcrossSubjectsPowerValStControl,'color',colorNameGroupsIDs{1},'linewidth',1.5,'displayname',groupIDs{group});
xlim(ePsd(g,2),xLimsRange); ylim(ePsd(g,2),yLimsRangeRaw);
plot(ePsd(g,2),freqVals,meanAcrossSubjectsPowerValStAdvanced,'color',colorNameGroupsIDs{2},'linewidth',1.5,'displayname',groupIDs{group});
xlim(ePsd(g,2),xLimsRange); ylim(ePsd(g,2),yLimsRangeRaw);

xline(ePsd(g,2),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(ePsd(g,2),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(ePsd(g,2),36,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(ePsd(g,2),66,'--','Color',[0 0 0.8],'linewidth',1.5);
% compareMeansAndShowSignificance(dataStControl,dataStAdvanced,length(freqVals),epA(1,2),xLimsRange,yLimsRangeRaw,axisLimAuto);
compareMeansAndShowSignificance(dataStAdvanced,dataStControl,length(freqVals),ePsd(g,2),xLimsRange,yLimsRangeRaw,axisLimAuto);

if showSEMFlag
    sData = std(dataStControl,[],1,'omitnan')/sqrt(size(dataStControl,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValStControl+sData fliplr(meanAcrossSubjectsPowerValStControl-sData)];
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',ePsd(g,2));

    sData = std(dataStAdvanced,[],1,'omitnan')/sqrt(size(dataStAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValStAdvanced+sData fliplr(meanAcrossSubjectsPowerValStAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',ePsd(g,2));

    plot(ePsd(g,2),freqVals,meanAcrossSubjectsPowerValStControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(ePsd(g,2),freqVals,meanAcrossSubjectsPowerValStAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end

hold(ePsd(g,2),'off');

%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.c: Comparing delta gamma power between control and advanced (commonBaselineAcrossSubjects)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(ePsd(g,3),freqVals,deltaPowerControl,'color',colorNameGroupsIDs{1},'linewidth',1.5,'displayname',groupIDs{group});
plot(ePsd(g,3),freqVals,deltaPowerAdvanced,'color',colorNameGroupsIDs{2},'linewidth',1.5,'displayname',groupIDs{group});
xlim(ePsd(g,3),xLimsRangeDelta); ylim(ePsd(g,3),yLimsRangeDelta);

xline(ePsd(g,3),0,'--');
xline(ePsd(g,3),20,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(ePsd(g,3),34,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(ePsd(g,3),36,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(ePsd(g,3),66,'--','Color',[0 0 0.8],'linewidth',1.5);

% compareMeansAndShowSignificance(dataDeltaPowerControl,dataDeltaPowerAdvanced,length(freqVals),epA(1,3),xLimsRangeDelta,yLimsRangeDelta,axisLimAuto);
compareMeansAndShowSignificance(dataDeltaPowerAdvanced,dataDeltaPowerControl,length(freqVals),ePsd(g,3),xLimsRangeDelta,yLimsRangeDelta,axisLimAuto);

if showSEMFlag
    sData = std(dataDeltaPowerControl,[],1,'omitnan')/sqrt(size(dataDeltaPowerControl,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [deltaPowerControl+sData fliplr(deltaPowerControl-sData)];
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',ePsd(g,3));

    sData = std(dataDeltaPowerAdvanced,[],1,'omitnan')/sqrt(size(dataDeltaPowerAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [deltaPowerAdvanced+sData fliplr(deltaPowerAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',ePsd(g,3));

    plot(ePsd(g,3),freqVals,deltaPowerControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(ePsd(g,3),freqVals,deltaPowerAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
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

savePlot = 0;
if savePlot
    % Get the current figure handle.
    fh = gcf;

    % Set the resolution of the figure.
    set(fh, 'Renderer', 'opengl', 'Resolution', 600);

    % Export the figure to a TIF file.
    exportgraphics(fh, fileName, 'Format', 'tiff');
end

end % here it loops for different groups
end % Main Function ends here



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Start:Associated functions(Make them independent to run online) %%%%%%%%%%%%%%%%%%%%%%%%












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End:Associated functions(Make them independent to run online) %%%%%%%%%%%%%%%%%%%%%%%%
