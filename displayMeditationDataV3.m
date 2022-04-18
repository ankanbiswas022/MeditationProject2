% Displays data collected for the meditation project
% badTrialRejectionFlag: 1: Don't reject badElectrodes, 2: reject badElectrodes for that protocol, 3: Reject badElectrodes of all protocols

% ToDo
% 1. Option to use unipolar or bipolar referencing

function displayMeditationDataV3(subjectName,expDate,folderSourceString,badTrialNameStr,badElectrodeRejectionFlag,plotRawTFFlag,refScheme)

if ~exist('folderSourceString','var');        folderSourceString=[];        end
if ~exist('badElectrodeList','var');          badTrialNameStr='_v5';        end
if ~exist('badElectrodeRejectionFlag','var'); badElectrodeRejectionFlag=2;  end
if ~exist('plotRawTFFlag','var');             plotRawTFFlag=0;              end
if ~exist('refScheme','var');                 refScheme=1;              end

if isempty(folderSourceString)
    folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
capType = 'actiCap64_UOL';

if refScheme == 2
    load(['bipChInfo' capType '.mat']); 
    allElectrodeList = 1:length(bipolarLocs);    
else
    allElectrodeList = 1:64;
end

protocolNameList = [{'EO1'}     {'EC1'}     {'G1'}      {'M1'}          {'G2'}      {'EO2'}     {'EC2'}     {'M2'}];
colorNames       = [{[0.9 0 0]} {[0 0.9 0]} {[0 0 0.9]} {[0.7 0.7 0.7]} {[0 0 0.3]} {[0.3 0 0]} {[0 0.3 0]} {[0.3 0.3 0.3]}];
numProtocols = length(protocolNameList);

comparePSDConditions{1} = [1 6];
comparePSDConditions{2} = [2 7];
comparePSDConditions{3} = [3 5];
comparePSDConditions{4} = [4 8];
numPSDComparisons = length(comparePSDConditions);
comparePSDConditionStr = cell(1,numPSDComparisons);

for i=1:numPSDComparisons
    for s=1:length(comparePSDConditions{i})
        comparePSDConditionStr{i} = cat(2,comparePSDConditionStr{i},protocolNameList{comparePSDConditions{i}(s)});
    end
end

freqList{1} = [8 12];  freqListNames{1} = 'Alpha';
freqList{2} = [20 34]; freqListNames{2} = 'SG';
freqList{3} = [36 66]; freqListNames{3} = 'FG';
numFreqRanges = length(freqList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,~,~,electrodeGroupList,groupNameList,highPriorityElectrodeNums] = electrodePositionOnGrid(1,gridType,[],capType,refScheme);
numGroups = length(electrodeGroupList);
electrodeGroupList{numGroups+1} = highPriorityElectrodeNums;
groupNameList{numGroups+1} = 'highPriority';
numGroups=numGroups+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Set up plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hBadElectrodes = getPlotHandles(1,numProtocols,[0.05 0.875 0.6 0.1],0.01,0.01,1);
hBadElectrodes2 = getPlotHandles(1,4,[0.7 0.875 0.25 0.1],0.01,0.01,1);

hTF = getPlotHandles(numGroups,numProtocols,[0.05 0.35 0.6 0.5],0.01,0.01,1);
hPSD  = getPlotHandles(numGroups,numPSDComparisons,[0.7 0.35 0.25 0.5],0.01,0.01,1);
hTopo = getPlotHandles(numFreqRanges,numProtocols,[0.05 0.05 0.6 0.25],0.01,0.01,1);
hPowerVsTime = getPlotHandles(numFreqRanges,1,[0.7 0.05 0.25 0.25],0.01,0.01,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Ranges for plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colormap jet;
freqRangeHz = [0 60];

if plotRawTFFlag
    cLims = [-3 3];
else
    %     cLims = [-1.5 1.5];
    cLims = [-15 15];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display bad electrodes for all protocols and also generate common bad electrodes
badTrialsList = cell(1,numProtocols);
badElecList = cell(1,numProtocols);
badElectrodes.badImpedanceElecs = [];
badElectrodes.noisyElecs = [];
badElectrodes.flatPSDElecs = [];

for i=1:numProtocols
    protocolName=protocolNameList{i};
    badFileName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData',['badTrials' badTrialNameStr '.mat']);
    % display bad electrodes
    if exist(badFileName,'file')
        x=load(badFileName);
        badTrialsList{i}=x.badTrials;
        badElecList{i} = x.badElecs;
        badElectrodes.badImpedanceElecs = cat(1,badElectrodes.badImpedanceElecs,x.badElecs.badImpedanceElecs);
        badElectrodes.noisyElecs = cat(1,badElectrodes.noisyElecs,x.badElecs.noisyElecs);
        badElectrodes.flatPSDElecs = cat(1,badElectrodes.flatPSDElecs,x.badElecs.flatPSDElecs);
        displayBadElecs(hBadElectrodes(i),subjectName,expDate,protocolName,folderSourceString,gridType,capType,badTrialNameStr);
        title(hBadElectrodes(i),protocolNameList{i},'color',colorNames{i});
    else
        badTrialsList{i}=[];
        badElecList{i} = [];
    end
end

badElectrodes.badImpedanceElecs = unique(badElectrodes.badImpedanceElecs);
badElectrodes.noisyElecs = unique(badElectrodes.noisyElecs);
badElectrodes.flatPSDElecs = unique(badElectrodes.flatPSDElecs);
displayBadElecs(hBadElectrodes2(1),subjectName,expDate,protocolName,folderSourceString,gridType,capType,badTrialNameStr,badElectrodes,hBadElectrodes2(2));

% displayElectrodeGroups
showElectrodeGroups(hBadElectrodes2(3:4),capType,electrodeGroupList,groupNameList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Data
for g=1:numGroups %for all the different groups of the electrode
    
    disp(['Working on group: ' groupNameList{g}]);
    
    % Get Data
    psdVals = cell(1,numProtocols);
    freqVals = cell(1,numProtocols);
    meanPSDVals = cell(1,numProtocols);
    
    % commenting unnecessary variables
    %     tfPower{i} = cell(1,numProtocols);
    %     timeValsTF{i} = cell(1,numProtocols);
    %     freqValsTF{i} = cell(1,numProtocols);
    %
    %     meanAlpha = cell(1,numProtocols);
    %     meanSG = cell(1,numProtocols);
    %     meanFG = cell(1,numProtocols);
    %
    %     indVec = cell(1,numProtocols); %initializing with numProtocols (as of now)
    
    %%
    meanAlphaCurrSeg = zeros(8,5);
    meanSGCurrSeg    = zeros(8,5);
    meanFGCurrSeg    = zeros(8,5);
    
    
    numGoodElectrodesList = zeros(1,numProtocols);
    
    for i=1:numProtocols  %% getting the data
        
        % removing the bad electrodes
        if badElectrodeRejectionFlag==1
            electrodeList = electrodeGroupList{g};
        elseif badElectrodeRejectionFlag==2
            electrodeList = setdiff(electrodeGroupList{g},getAllBadElecs(badElecList{i}));
        elseif badElectrodeRejectionFlag==3
            electrodeList = setdiff(electrodeGroupList{g},getAllBadElecs(badElectrodes));
        end
        numGoodElectrodesList(i) = length(electrodeList);
        
        if ~isempty(electrodeList)
            protocolName = protocolNameList{i};
            [psdVals{i},freqVals{i},psdAcrossElc] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,electrodeList,refScheme,capType);
            
            meanPSDVals{i} = mean(psdVals{i}(:,setdiff(1:size(psdVals{i},2),badTrialsList{i})),2);      % psd across good trials
            %             meanTFVals{i}  = mean(tfPower{i}(:,:,setdiff(1:size(tfPower{i},2),badTrialsList{i})),3);  % removing the bad trials
            
            %%
            alphaPos = intersect(find(freqVals{1}>=freqList{1}(1)),find(freqVals{1}<=freqList{1}(2)));
            sgPos    = intersect(find(freqVals{1}>=freqList{2}(1)),find(freqVals{1}<=freqList{2}(2)));
            fgPos    = intersect(find(freqVals{1}>=freqList{3}(1)),find(freqVals{1}<=freqList{3}(2)));
            fgPos=fgPos(fgPos~=(find(freqVals{1}==50)));
            
            if g==6 %only for the highPriority ones
                meanPSDValsCurrSeg=cell(1,5);
                %             meanAlphaCurrSeg=cell(8,5); %have to be initiated way before
                %             meanSGCurrSeg=cell(8,5);
                %             meanFGCurrSeg=cell(8,5);
                startInd=1;
                jump=23;
                endPoint=size(psdVals{i},2)/24;
                for s=1:endPoint
                    %                     bl = repmat(meanPSDVals{1},1,numTrials); % including all the trials
                    meanPSDValsCurrSeg{s} = mean(psdVals{i}(:,setdiff(startInd:startInd+jump,badTrialsList{i})),2);
                    meanAlphaCurrSeg(i,s)   = log10(mean(meanPSDValsCurrSeg{s}(alphaPos),1));
                    meanSGCurrSeg(i,s)      = log10(mean(meanPSDValsCurrSeg{s}(sgPos),1));
                    meanFGCurrSeg(i,s)      = log10(mean(meanPSDValsCurrSeg{s}(fgPos),1));
                    startInd = 24+startInd;
                end
            end
            
            %%
            %             timeValsTFadj = timeVec(end)+timeValsTF{1};
            %             timeVec = [timeVec timeValsTFadj];
            
            %             if i>1
            %                indVec{i} = length(timeValsTF{1})*(i-1)+1:(length(timeValsTF{1})*i);
            %             else
            %                indVec{i} = 1:length(timeValsTF{1});
            %             end
        end
    end
    
    timeVecIni=1;
    
    for i=1:numProtocols  %% plotting
        
        if i==4||i==8
            Increment=15;
        else
            Increment=5;
        end
        
        % Time-frequency plots
        if ~isempty(psdVals{i})
            numTrials = size(psdVals{i},2);
            if plotRawTFFlag
                pcolor(hTF(g,i),1:numTrials,freqVals{i},(psdVals{i}));
            else
                bl = repmat(meanPSDVals{1},1,numTrials); % including all the trials
                pcolor(hTF(g,i),1:numTrials,freqVals{i},10*(log10((psdVals{i}))-log10(bl)));
            end
            
            shading(hTF(g,i),'interp');
            caxis(hTF(g,i),cLims);
            ylim(hTF(g,i),freqRangeHz);
            
            hold(hTF(g,i),'on');
            if ~isempty(badTrialsList{i})
                plot(hTF(g,i),badTrialsList{i},freqRangeHz(2)-1,'k.');
                text(1,freqRangeHz(2)-5,['N=' num2str(numGoodElectrodesList(i))],'parent',hTF(g,i));
            else
                text(1,freqRangeHz(2)-5,['N=' num2str(numGoodElectrodesList(i))],'parent',hTF(g,i));
            end
        end
        
        if (i==1 && g<numGroups)
            set(hTF(g,i),'XTickLabel',[]); % only remove x label
        elseif (i>1 && g<numGroups)
            set(hTF(g,i),'XTickLabel',[],'YTickLabel',[]);
        elseif (i>1 && g==numGroups)
            set(hTF(g,i),'YTickLabel',[]); % only remove y label
        end
        
        if g==6
            % plot the power vs time for alpha,sg and fg
            timeVec=timeVecIni:(timeVecIni+(Increment-1));
            plot(hPowerVsTime(1),timeVec,10*(nonzeros(meanAlphaCurrSeg(i,:))-repmat(mean(nonzeros(meanAlphaCurrSeg(1,:))),length(nonzeros(meanAlphaCurrSeg(i,:))),1)),'-o','MarkerSize',6,'MarkerFaceColor',colorNames{i},'MarkerEdgeColor',colorNames{i},'color',colorNames{i});
            set(hPowerVsTime(1),'XTickLabel',[]); hold(hPowerVsTime(1),'on');
            
            plot(hPowerVsTime(2),timeVec,10*(nonzeros(meanSGCurrSeg(i,:))-repmat(mean(nonzeros(meanSGCurrSeg(1,:))),length(nonzeros(meanSGCurrSeg(i,:))),1)),'-o','MarkerSize',6,'MarkerFaceColor',colorNames{i},'MarkerEdgeColor',colorNames{i},'color',colorNames{i});
            set(hPowerVsTime(2),'XTickLabel',[]); hold(hPowerVsTime(2),'on');
            
            plot(hPowerVsTime(3),timeVec,10*(nonzeros(meanFGCurrSeg(i,:))-repmat(mean(nonzeros(meanFGCurrSeg(1,:))),length(nonzeros(meanFGCurrSeg(i,:))),1)),'-o','MarkerSize',6,'MarkerFaceColor',colorNames{i},'MarkerEdgeColor',colorNames{i},'color',colorNames{i});
            %             plot(hPowerVsTime(2),cat(1,meanSG{:}));     set(hPowerVsTime(2),'XTickLabel',[]);
            %             plot(hPowerVsTime(3),cat(1,meanFG{:}));
            
            % plot the power vs trial plot
        end
        timeVecIni=timeVecIni+Increment;
    end
    
    %     if g==6
    %         timeVec =1:60;
    %         baseLinePSDAlpha = repmat(mean(nonzeros(meanAlphaCurrSeg(1,:))),size(meanAlphaCurrSeg,1),1));
    %         diffPSDalpha = 10*(meanAlphaCurrSeg-baseLinePSDAlpha);
    %
    %         baseLinePSDsg = repmat(meanSGCurrSeg(1,:),size(meanSGCurrSeg,1),1);
    %         diffPSDsg = 10*(meanSGCurrSeg-baseLinePSDsg);
    %
    %         baseLinePSDfg = repmat(meanFGCurrSeg(1,:),size(meanFGCurrSeg,1),1);
    %         diffPSDfg = 10*(meanFGCurrSeg-baseLinePSDfg);
    %
    %         plot(hPowerVsTime(1),timeVec,reshape(diffPSDalpha',[],1),'-','LineStyle','--','Color',colorNames{i});
    %         plot(hPowerVsTime(2),timeVec,reshape(diffPSDsg',[],1),'-','LineStyle','--','Color',colorNames{i});
    %         plot(hPowerVsTime(3),timeVec,reshape(diffPSDfg',[],1),'-','LineStyle','--','Color',colorNames{i});
    %     end
    
    ylabel(hTF(g,1),groupNameList{g});
    xlabel(hPowerVsTime(3),'Time(min)');
%     ylabel(hPowerVsTime(1),'Alpha'); hold(hPowerVsTime(3),'on')
%     ylabel(hPowerVsTime(2),'Slow gamma'); hold(hPowerVsTime(3),'on')
    ylabel(hPowerVsTime(3),'Power'); hold(hPowerVsTime(3),'on');
    
    % meanPSD Plots
    for i = 1:numPSDComparisons
        for s=1:length(comparePSDConditions{i})
            conditionNum = comparePSDConditions{i}(s);
            if plotRawTFFlag
                plot(hPSD(g,i),freqVals{conditionNum},meanPSDVals{conditionNum},'color',colorNames{conditionNum});
            else
%                 bl = repmat(meanPSDVals{1},1,numTrials); % including all the trials
                plot(hPSD(g,i),freqVals{conditionNum},10*(log10(meanPSDVals{conditionNum})-log10(meanPSDVals{1})),'color',colorNames{conditionNum});
            end
            hold(hPSD(g,i),'on');
        end
        
        if ~plotRawTFFlag
            plot(hPSD(g,i),freqVals{conditionNum},zeros(1,length(freqVals{conditionNum})),'k--');
        end
        
        xlim(hPSD(g,i),freqRangeHz);
        ylim(hPSD(g,i),cLims);
        if g<numGroups
            set(hPSD(g,i),'XTickLabel',[]);
        end
        
        if g==1
            title(hPSD(g,i),comparePSDConditionStr{i});
        end
        
        
    end
    
end

for i=1:numProtocols
    xlabel(hTF(numGroups,i),'TrialNum');
end

%% topolot

%step 1: get the data for topoplot
psdAcrossElcAccProtocol = cell(1,numProtocols);

for i=1:numProtocols   
    protocolName = protocolNameList{i};
    [psd,freqVals,psdAcrossElc] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,allElectrodeList,refScheme,capType);   
    psdAcrossElcAccProtocol{i}= psdAcrossElc;
    flag=10;    
end

numElectrodes = length(allElectrodeList);
alphaPos = intersect(find(freqVals>=freqList{1}(1)),find(freqVals<=freqList{1}(2)));
sgPos    = intersect(find(freqVals>=freqList{2}(1)),find(freqVals<=freqList{2}(2)));
fgPos    = intersect(find(freqVals>=freqList{3}(1)),find(freqVals<=freqList{3}(2)));
fgPos    = fgPos(fgPos~=(find(freqVals==50)));

for i=1:numProtocols
    psdDataThisProtocol = psdAcrossElcAccProtocol{i};
    chMeanAlphaThisElec=[];
    chMeanSGThisElec =[];
    chMeanFGThisElec = [];
    noseDir = '+X';
    
    for e=1:numElectrodes
        psdDataThisElec = squeeze(psdDataThisProtocol(e,:,:));
        psdDataThisElecGoodTrials = mean(psdDataThisElec(:,setdiff(1:size(psdDataThisElec,2),badTrialsList{i})),2);
        if i==1
            BLmeanAlphaThisElec   = log10(mean(psdDataThisElecGoodTrials(alphaPos),1));
            BLmeanSGThisElec      = log10(mean(psdDataThisElecGoodTrials(sgPos),1));
            BLmeanFGThisElec      = log10(mean(psdDataThisElecGoodTrials(fgPos),1));
            
            meanAlphaThisElec = BLmeanAlphaThisElec ;
            meanSGThisElec  =  BLmeanSGThisElec;
            meanFGThisElec =   BLmeanFGThisElec;
        else
            meanAlphaThisElec   = log10(mean(psdDataThisElecGoodTrials(alphaPos),1));
            meanSGThisElec      = log10(mean(psdDataThisElecGoodTrials(sgPos),1));
            meanFGThisElec      = log10(mean(psdDataThisElecGoodTrials(fgPos),1));
        end
        chMeanAlphaThisElec(e,1) = 10*(meanAlphaThisElec-BLmeanAlphaThisElec) ;
        chMeanSGThisElec(e,1) = 10*(meanSGThisElec- BLmeanSGThisElec) ;
        chMeanFGThisElec(e,1) = 10*(meanFGThisElec - BLmeanFGThisElec) ;
               
    end
    
    % plot topoplot
    x = load([capType 'Labels.mat']); montageLabels = x.montageLabels(:,2);
    x = load([capType '.mat']); montageChanlocs = x.chanlocs;
    axes(hTopo(1,i)); topoplot(chMeanAlphaThisElec,montageChanlocs); caxis([-15 15]);
    axes(hTopo(2,i));topoplot(chMeanSGThisElec,montageChanlocs); caxis([-15 15]);
    axes(hTopo(3,i));topoplot(chMeanFGThisElec,montageChanlocs); caxis([-15 15]);
end


end

function [psd,freqVals,psdAcrossElc] = getData(subjectName,expDate,protocolName,folderSourceString,gridType,electrodeList,refScheme,capType)

% if ~exist('TFFlag','var') || isempty(TFFlag); TFFlag= 1; end

timeRange = [0.25 1.25];
tapers = [1 1];
freqRange = [0 100];

folderExtract = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'extractedData');
folderSegment = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData');

if ~exist(folderExtract,'file')
    disp([folderExtract ' does not exist']);
    psd = []; freqVals=[];
else
    numElectrodes = length(electrodeList);
    
    t = load(fullfile(folderSegment,'LFP','lfpInfo.mat'));
    timeVals = t.timeVals;
    Fs = round(1/(timeVals(2)-timeVals(1)));
    goodTimePos = find(timeVals>=timeRange(1),1) + (1:round(Fs*diff(timeRange)));
    
    % Set up multitaper
    params.tapers   = tapers;
    params.pad      = -1;
    params.Fs       = Fs;
    params.fpass    = freqRange;
    %     if TFFlag;      params.trialave = 1;     else;     params.trialave = 0;     end
    % Parameters for TF
    %    tfPowerTMP = [];
    %    timeValsTF = [];
    %    freqValsTF = [];
    %    winSize = 0.25;
    %    winStep = 0.025; %4Hz resolution
    %    movingwin = [winSize winStep];
    
    for i=1:numElectrodes
        if refScheme==2
           load(['bipChInfo' capType '.mat']); %loads the bipolar unipolar list to the workspace.
           % find the corresponding unipolar electrodes 
           analogElecs = bipolarLocs(electrodeList(i),:);           
           % load the .mat lfp file for the two electrode
           e1 = load(fullfile(folderSegment,'LFP',['elec' num2str(analogElecs(1)) '.mat']));
           e2 = load(fullfile(folderSegment,'LFP',['elec' num2str(analogElecs(2)) '.mat']));           
           % substract and put this in the e 
           e.analogData = e1.analogData-e2.analogData; %updated e for the bipolar
        else
           e = load(fullfile(folderSegment,'LFP',['elec' num2str(electrodeList(i)) '.mat']));
        end                
        params.trialave = 0;
        [psdTMP(i,:,:),freqVals] = mtspectrumc(e.analogData(:,goodTimePos)',params); %#ok<AGROW>
        %         [psdTMP(i,:,:),freqVals] = mtspectrumc(e.analogData(:,goodTimePos)',params); %#ok<AGROW>
        % If TFFlag is ON;
        %        if TFFlag
        %            params.trialave = 0;
        %            [tfPowerTMP(i,:,:,:),timeValsTF0,freqValsTF] = mtspecgramc(e.analogData(:,goodTimePos)',movingwin,params);
        %            timeValsTF = timeValsTF0 + timeRange(1);
        %        end
    end
    
    psd = squeeze(mean(psdTMP,1)); %across Electrode pds
    psdAcrossElc = psdTMP;
    
    %     psd = log10(squeeze(mean(psdTMP,1)));  % avergage across electrode, then taking log (SR)
    %     psd = mean(log10(psdTMP),1);  %
    %     tfPower = squeeze(mean(tfPowerTMP,1));
end
end
function displayBadElecs(hBadElectrodes,subjectName,expDate,protocolName,folderSourceString,gridType,capType,badTrialNameStr,badElectrodes,hStats)

if ~exist('gridType','var');        gridType = 'EEG';                   end
if ~exist('capType','var');         capType = 'actiCap64_2019';         end
if ~exist('badTrialNameStr','var'); badTrialNameStr = '_v5';            end
if ~exist('badElectrodes','var');   badElectrodes = [];                 end
if ~exist('hStats','var');          hStats = [];                        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folderSegment = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData');
badTrialsInfo = load(fullfile(folderSegment,['badTrials' badTrialNameStr '.mat']));

%%%%%%%%%%%%%%%%%%%%%% Compare with Montage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = load([capType 'Labels.mat']); montageLabels = x.montageLabels(:,2);
x = load([capType '.mat']); montageChanlocs = x.chanlocs;

if ~isfield(badTrialsInfo,'eegElectrodeLabels') % Check if the labels match with the save labels, if these labels have been saved
    disp('Electrode labels not specified in badTrials file. Taking from Montage...');
else
    if ~isequal(montageLabels(:),badTrialsInfo.eegElectrodeLabels(:))
        error('Montage labels do not match with channel labels in badTrials');
    else
        disp('Montage labels match with channel labels in badTrials');
    end
end

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Topoplot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(hBadElectrodes);
electrodeSize = 5;
numElectrodes = length(montageLabels);

for i=1:numElectrodes
    %    label = num2str(i); %[num2str(i) '-' montageLabels{i}];
    montageChanlocs(i).labels = ' ';
end

% If you specify these, they override the existing ones
badImpedanceElectrodeColor = 'r';
noisyElectrodeColor = 'm';
flatPSDElectrodeColor = 'b';
if isempty(badElectrodes)
    badImpedanceElectrodes = badTrialsInfo.badElecs.badImpedanceElecs;
    noisyElectrodes = badTrialsInfo.badElecs.noisyElecs;
    flatPSDElectrodes = badTrialsInfo.badElecs.flatPSDElecs;
else
    badImpedanceElectrodes = badElectrodes.badImpedanceElecs;
    noisyElectrodes = badElectrodes.noisyElecs;
    flatPSDElectrodes = badElectrodes.flatPSDElecs;
end

topoplot(zeros(1,numElectrodes),montageChanlocs,'electrodes','on','style','map','emarker2',{badImpedanceElectrodes,'o',badImpedanceElectrodeColor,electrodeSize});
topoplot(zeros(1,numElectrodes),montageChanlocs,'electrodes','on','style','map','emarker2',{noisyElectrodes,'o',noisyElectrodeColor,electrodeSize});
topoplot(zeros(1,numElectrodes),montageChanlocs,'electrodes','on','style','map','emarker2',{flatPSDElectrodes,'o',flatPSDElectrodeColor,electrodeSize});
%topoplot(zeros(1,numElectrodes),montageChanlocs,'electrodes','on','style','map','emarker2',{highPriorityElectrodeList,'o',highPriorityElectrodeColor,electrodeSize});
topoplot([],montageChanlocs,'electrodes','labels','style','blank');

if ~isempty(hStats)
    axes(hStats)
    set(hStats,'visible','off');
    text(0.05,0.9,'bad Impedance','color',badImpedanceElectrodeColor);
    text(0.05,0.75,num2str(badImpedanceElectrodes(:)'),'color',badImpedanceElectrodeColor);
    
    text(0.05,0.6,'Noisy','color',noisyElectrodeColor);
    text(0.05,0.45,num2str(noisyElectrodes(:)'),'color',noisyElectrodeColor);
    
    text(0.05,0.3,'FlatPSD','color',flatPSDElectrodeColor);
    text(0.05,0.15,num2str(flatPSDElectrodes(:)'),'color',flatPSDElectrodeColor);
    
end
end
function allBadElecs = getAllBadElecs(badElectrodes)
allBadElecs = [badElectrodes.badImpedanceElecs; badElectrodes.noisyElecs; badElectrodes.flatPSDElecs];
end
function showElectrodeGroups(hPlots,capType,electrodeGroupList,groupNameList)

if ~exist('capType','var');         capType = 'actiCap64_2019';         end

%%%%%%%%%%%%%%%%%%%%%% Compare with Montage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = load([capType 'Labels.mat']); montageLabels = x.montageLabels(:,2);
x = load([capType '.mat']); montageChanlocs = x.chanlocs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Topoplot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(hPlots(1));
electrodeSize = 5;
numElectrodes = length(montageLabels);

for i=1:numElectrodes
    montageChanlocs(i).labels = ' ';
end

numElectrodeGroups = length(electrodeGroupList);
electrodeGroupColorList = jet(numElectrodeGroups);

for i=1:numElectrodeGroups
    topoplot(zeros(1,numElectrodes),montageChanlocs,'electrodes','on','style','map','emarker2',{electrodeGroupList{i},'o',electrodeGroupColorList(i,:),electrodeSize});
end
topoplot([],montageChanlocs,'electrodes','labels','style','blank');

axes(hPlots(2))
set(hPlots(2),'visible','off');
for i=1:numElectrodeGroups
    text(0.05,0.9-0.15*(i-1),groupNameList{i},'color',electrodeGroupColorList(i,:),'unit','normalized');
end

end