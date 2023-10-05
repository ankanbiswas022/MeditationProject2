function MeditationFigure2()

% Meditation figure 2
% Power changes during the EC1 and M1 protocol; Control Vs Meditators
% by Ankan on 15th September'2023
% NeuroOscillations Lab, CNS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -----------Starting Point------------ %%%%%%%%%%%%%%%%%%%%%%%
clf
clear
figHandle = figure(1);

gridPos=[0.1 0.1 0.85 0.75];
epA = getPlotHandles(1,2,gridPos,0.06,0.06,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 0th: Base Plot Structure which need to be filled in %%%%%%%%%%%%%%%%%%%%%%

% sgtitle('mean Power during the first Gamma Protocol (G1) : n=30');
title(epA(1,1),'raw Power during EC1:Occipital');
xlabel(epA(1,1),'frequency(Hz)','FontSize',12)
ylabel(epA(1,1),'log_{10}(Power)','FontSize',12);
hold(epA(1,1),'on');

title(epA(1,2),'raw Power during M1:Occipital');
xlabel(epA(1,2),'frequency(Hz)','FontSize',12)
hold(epA(1,2),'on');

% title(epA(1,3),'\Delta Power');
% xlabel(epA(1,3),'frequency(Hz)','FontSize',12)
% ylabel(epA(1,3),'dB','FontSize',12);
% hold(epA(1,3),'on');

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

%%%%%%%%%%%***********************************************************

g=1; % Electrode Group % Occipital


p=2; % Segments: EC1........

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
group=1; %Control and meditators
%------------------------------the main code-------------------------------------------------------------------
electrodeList = electrodeGroupList0{g};
% g across the selected electrodes in the raw power Domain
powerValBlCombinedThisElecGroup = mean(powerValBlCombined{group}(:,:,:,electrodeList),4,'omitnan');
powerValStCombinedThisElecGroup = mean(powerValStCombined{group}(:,:,:,electrodeList),4,'omitnan');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stacking both stimulus and baseline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%period%%%%%%%%%%%%%%%%%%%%%%%%%%%%
powerValBlCombineControl = (powerValBlCombinedThisElecGroup+powerValStCombinedThisElecGroup)/2;
% log transform the values
powerValBlCombinedThisGroupLogTransformed = log10(powerValBlCombineControl);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stacking both stimulus and baseline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%period%%%%%%%%%%%%%%%%%%%%%%%%%%%%
powerValBlCombineControl = (powerValBlCombinedThisElecGroup+powerValStCombinedThisElecGroup)/2;
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
xLimsRange = [0 100];
yLimsRangeRaw = [-2 3];
xLimsRangeDelta = [0 100];
yLimsRangeDelta = [-2 2.5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.a: Comparing Baseline gamma power between control and advanced %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(epA(1,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
plot(epA(1,1),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
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
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',epA(1,1));
    plot(epA(1,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});

    sData = std(dataBlAdvanced,[],1,'omitnan')/sqrt(size(dataBlAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValBlAdvanced+sData fliplr(meanAcrossSubjectsPowerValBlAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',epA(1,1));

    plot(epA(1,1),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(epA(1,1),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end

xlim(epA(1,1),xLimsRange); ylim(epA(1,1),yLimsRangeRaw); 
% text(epA(1,1),60,1,'Slow Gamma:20-34 Hz','Color',[0 0.5 0.5]);

xline(epA(1,1),8,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(epA(1,1),12,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(epA(1,1),20,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(epA(1,1),34,'--','Color',[0 0 0.8],'linewidth',1.5);
% compareMeansAndShowSignificance(dataBlControl,dataBlAdvanced,length(freqVals),epA(1,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
compareMeansAndShowSignificance(dataBlAdvanced,dataBlControl,length(freqVals),epA(1,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
legend(epA(1,1),'Control','Meditators');
hold(epA(1,1),'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%% M1 segment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 

p=4; % Segments: M1........

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
group=1; %Control and meditators
%------------------------------the main code-------------------------------------------------------------------
electrodeList = electrodeGroupList0{g};
% g across the selected electrodes in the raw power Domain
powerValBlCombinedThisElecGroup = mean(powerValBlCombined{group}(:,:,:,electrodeList),4,'omitnan');
powerValStCombinedThisElecGroup = mean(powerValStCombined{group}(:,:,:,electrodeList),4,'omitnan');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stacking both stimulus and baseline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%period%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: First combining across baseline and stimulus
% Secong: Avarsgaing across M1.a, M1.b, M1.c 
% And assinging this to 4th M1.a segment which would have the pulled
% average data now
powerValBlCombineControl = (powerValBlCombinedThisElecGroup+powerValStCombinedThisElecGroup)/2;
powerValST_M1         = mean(powerValBlCombineControl(:,4:6,:),2,"omitnan");
powerValBlCombineControl(:,4,:)=powerValST_M1;

% log transform the values
powerValBlCombinedThisGroupLogTransformed = log10(powerValBlCombineControl);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stacking both stimulus and baseline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%period%%%%%%%%%%%%%%%%%%%%%%%%%%%%
powerValBlCombineControl = (powerValBlCombinedThisElecGroup+powerValStCombinedThisElecGroup)/2;
powerValST_M1         = mean(powerValBlCombineControl(:,4:6,:),2,"omitnan");
powerValBlCombineControl(:,4,:)=powerValST_M1;


% log transform the values
powerValBlCombinedThisGroupLogTransformed = log10(powerValBlCombineControl);
powerValStCombinedThisGroupLogTransformed = log10(powerValStCombinedThisElecGroup);
% sequeeze
dataBlAdvanced = squeeze(powerValBlCombinedThisGroupLogTransformed(:,p,:)); %-squeeze(powerValBlCombinedThisGroupLogTransformed(:,p,:));
dataStAdvanced = squeeze(powerValStCombinedThisGroupLogTransformed(:,p,:)); %dataDeltaPowerControl = 10*(dataStControl-dataBlControl);

dataDeltaPowerAdvanced = 10*(dataStAdvanced-dataBlAdvanced);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mean across the subjects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanAcrossSubjectsPowerValBlAdvanced = mean(dataBlAdvanced,1,"omitnan"); %meanAcrossSubjectsPowerValBlCombinedThisGroupLogTransformed
meanAcrossSubjectsPowerValStAdvanced = mean(dataStAdvanced,1,"omitnan"); %meanAcrossSubjectsPowerValSTCombinedThisGroupLogTransformed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a. Individuel Baseline Across Subject %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2nd: Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axisLimAuto = 0;
xLimsRange = [0 100];
yLimsRangeRaw = [-2 3];
xLimsRangeDelta = [0 100];
yLimsRangeDelta = [-2 2.5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot 1.a: Comparing Baseline gamma power between control and advanced %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(epA(1,2),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
plot(epA(1,2),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
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
    patch(xsLong,ysLong,colorName2Control,'EdgeColor','none','parent',epA(1,2));
    plot(epA(1,2),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});

    sData = std(dataBlAdvanced,[],1,'omitnan')/sqrt(size(dataBlAdvanced,1));
    xsLong = [freqVals fliplr(freqVals)];
    ysLong = [meanAcrossSubjectsPowerValBlAdvanced+sData fliplr(meanAcrossSubjectsPowerValBlAdvanced-sData)];
    patch(xsLong,ysLong,colorName2Advanced,'EdgeColor','none','parent',epA(1,2));

    plot(epA(1,2),freqVals,meanAcrossSubjectsPowerValBlControl,'color',colorNameGroupsIDs{1},'linewidth',2,'displayname',groupIDs{group});
    plot(epA(1,2),freqVals,meanAcrossSubjectsPowerValBlAdvanced,'color',colorNameGroupsIDs{2},'linewidth',2,'displayname',groupIDs{group});
end

xlim(epA(1,2),xLimsRange); ylim(epA(1,2),yLimsRangeRaw); 
% text(epA(1,1),60,1,'Slow Gamma:20-34 Hz','Color',[0 0.5 0.5]);

xline(epA(1,2),8,'--','Color',[0 0.5 0.5],'linewidth',1.5);
xline(epA(1,2),12,'--','Color',[0 0.5 0.5],'linewidth',1.5);

xline(epA(1,2),20,'--','Color',[0 0 0.8],'linewidth',1.5);
xline(epA(1,2),34,'--','Color',[0 0 0.8],'linewidth',1.5);
% compareMeansAndShowSignificance(dataBlControl,dataBlAdvanced,length(freqVals),epA(1,1),xLimsRange,yLimsRangeRaw,axisLimAuto);
compareMeansAndShowSignificance(dataBlAdvanced,dataBlControl,length(freqVals),epA(1,2),xLimsRange,yLimsRangeRaw,axisLimAuto);
% legend(epA(1,2),'Control','Meditators');
hold(epA(1,2),'off');



%%----------------------------------------
%%




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
