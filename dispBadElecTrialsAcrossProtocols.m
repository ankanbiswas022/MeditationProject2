%contains bad trials for 3 segments of m1 and m2


function  [numBadElecs,numBadElecsGroupWise, numBadTrialsWithoutEye, numBadTrialsForEye, numBadTrialsIncEye] =  dispBadElecTrialsAcrossProtocols(subjectName,expDate,folderSourceString,badTrialNameStr,individualSubjectFigureFlag) %working on this
 %working on this

if ~exist('folderSourceString','var');              folderSourceString=[];                          end
if ~exist('badTrialNameStr','var');                 badTrialNameStr='_v5';                          end
if ~exist('individualSubjectFigureFlag','var')      individualSubjectFigureFlag = 0;                end
% if ~exist('badElectrodeRejectionFlag','var');       badElectrodeRejectionFlag=2;                    end
% if ~exist('plotRawTFFlag','var');                   plotRawTFFlag=0;                                end
% if ~exist('refScheme','var');                       refScheme=1;                                    end
% if ~exist('trialAvgFlag','var');                    trialAvgFlag =0;                                end
% if ~exist('saveDataIndividualSubjectsFlag','var');  saveDataIndividualSubjectsFlag=0;               end
% if ~exist('tfFlag','var');                          tfFlag=0;                                       end

if isempty(folderSourceString)
    folderSourceString = 'D:\OneDrive - Indian Institute of Science\Su               pratim\Projects\MeditationProjects\MeditationProject2';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
% capType = 'actiCap64_UOL';


allElectrodeList = 1:64;
numElectrodes = length(allElectrodeList);
protocolNameList = [{'EO1'}     {'EC1'}     {'G1'}      {'M1'}          {'G2'}      {'EO2'}     {'EC2'}     {'M2'}];
protocolTrialNums = [120 120 120 360 120 120 120 360];
segmentNums = [1 1 1 3 1 1 1 3];
colorNames       = [{[0.9 0 0]} {[0 0.9 0]} {[0 0 0.9]} {[0.7 0.7 0.7]} {[0 0 0.3]} {[0.3 0 0]} {[0 0.3 0]} {[0.3 0.3 0.3]}];
numProtocols = length(protocolNameList);

%%%electrode group list
[~,~,~,electrodeGroupList,groupNameList,highPriorityElectrodeNums] = electrodePositionOnGrid(64,'EEG',subjectName,6);
    electrodeGroupList{length(electrodeGroupList)+1} = highPriorityElectrodeNums;
    groupNameList{length(groupNameList)+1} = 'highPriority';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display bad electrodes for all protocols and also generate common bad electrodes
% --- for saving the data this is not required as it is already beaing
% saved when we run the badTrialCode:

% preAllocation

%badTrials:
badTrialsList         = cell(1,numProtocols);
elecWiseBadTrialList  = cell(1,numProtocols);
badEyeTrialsList      = cell(1,numProtocols);
commonBadTrialsIncEye = cell(1,numProtocols);
 
%badElectrodes:
badElecList       = cell(1,numProtocols);
badImpedanceElecs = cell(1,numProtocols);
noisyElecs        = cell(1,numProtocols);
flatPSDElecs      = cell(1,numProtocols);

numBadTrialsPerElec     = [];
numBadElecs             = [];
allBadElecsProtocol     = [];

numSeg = 1;
for i=1:numProtocols
    
    badElecPerProtocol=zeros(numElectrodes,1); % initialized with all good trials
    protocolName=protocolNameList{i};
    badFileName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData',['badTrials' badTrialNameStr '.mat']);
    % display bad electrodes
    if exist(badFileName,'file')
        x=load(badFileName);
        
        % getting bad trials
        badTrialsList{i}         = x.badTrials; 
        elecWiseBadTrialList{i}  = x.allBadTrials;
        badEyeTrialsList{i}      = x.badTrialsUnique.badEyeTrials;
        commonBadTrialsIncEye{i} = union(badTrialsList{i},badEyeTrialsList{i});
        
        % getting bad electrodes
        badElecList{i}           = x.badElecs;
        badImpedanceElecs{i}     = x.badElecs.badImpedanceElecs;
        noisyElecs{i}            = x.badElecs.noisyElecs;
        flatPSDElecs{i}          = x.badElecs.flatPSDElecs;   
        allBadElecs{i}           = union(badImpedanceElecs{i},union(noisyElecs{i},flatPSDElecs{i}));
        numBadElecs(i)           = length(allBadElecs{i});
        for j=1:length(electrodeGroupList)
            badElecsGroupWise{i,j} = intersect(allBadElecs{i},electrodeGroupList{j});
            numBadElecsGroupWise(i,j) = length(badElecsGroupWise{i,j});
        end
    end
    
   
        for jk = 1:segmentNums(i)
            numBadTrialsWithoutEye(numSeg) = nnz(badTrialsList{i}>120*(jk-1) & badTrialsList{i}<120*jk + 1);
            numBadTrialsForEye(numSeg) = nnz(badEyeTrialsList{i}>120*(jk-1) & badEyeTrialsList{i}<120*jk + 1);
            numBadTrialsIncEye(numSeg) = nnz(commonBadTrialsIncEye{i}>120*(jk-1) & commonBadTrialsIncEye{i}<120*jk+1);
            numSeg = numSeg +1;
        end
    % assigning 
    badElecPerProtocol(badImpedanceElecs{i}) = 1; 
    badElecPerProtocol(noisyElecs{i}) = 2;
    badElecPerProtocol(flatPSDElecs{i}) = 3;
    
    numBadElecPerProtocol(i) = nnz(badElecPerProtocol);
    allBadElecsProtocol   = [allBadElecsProtocol badElecPerProtocol];
    
    

    for j=1:numElectrodes
        numBadTrialsPerElec(i,j) = length(elecWiseBadTrialList{i}{j})/protocolTrialNums(i);
    end

% two Matrix we have:
 
% numBadTrialsPerElec :mat1

numBadTrialsPerElecAsPerElectrodeGroups = zeros(8,74);
allBadElecsProtocolAsPerElectrodeGroups = zeros(8,74);
numLenghtElectrodeGroups = cellfun(@length,electrodeGroupList);


% numBadTrialsPerElecAsPerElectrodeGroups(:,1:numLenghtElectrodeGroups(1))) = numBadTrialsPerElec(:,electrodeGroupList{1,1});
% numBadTrialsPerElecAsPerElectrodeGroups(:,(numLenghtElectrodeGroups(1)+1):numLenghtElectrodeGroups(1)+numLenghtElectrodeGroups(2))= numBadTrialsPerElec(:,electrodeGroupList{1,2});
% numBadTrialsPerElecAsPerElectrodeGroups(:,(numLenghtElectrodeGroups(1)+1):numLenghtElectrodeGroups(1)+numLenghtElectrodeGroups(2))= numBadTrialsPerElec(:,electrodeGroupList{1,2});






% allBadElecsProtocol mat2
    
    
% badElectrodes.badImpedanceElecs = unique(badElectrodes.badImpedanceElecs);
% badElectrodes.noisyElecs = unique(badElectrodes.noisyElecs);
% badElectrodes.flatPSDElecs = unique(badElectrodes.flatPSDElecs);
%displayBadElecs(hBadElectrodes2(1),subjectName,expDate,protocolName,folderSourceString,gridType,capType,badTrialNameStr,badElectrodes,hBadElectrodes2(2));

end

% numBadTrialsPerElec
startIndex = 1;
startIndexVecOne = [];
endIndex = numLenghtElectrodeGroups(1);
for i=1:length(numLenghtElectrodeGroups)  
    startIndexVecOne = [startIndexVecOne startIndex];
    numBadTrialsPerElecAsPerElectrodeGroups(:,startIndex:endIndex)= numBadTrialsPerElec(:,electrodeGroupList{1,i});
    startIndex = endIndex+1;    
    if i~=length(numLenghtElectrodeGroups)   
        endIndex = endIndex+numLenghtElectrodeGroups(i+1); 
    end
    
end

% allBadElecsProtocol
startIndex = 1;
startIndexVecTwo = [];
endIndex = numLenghtElectrodeGroups(1);
allBadElecsProtocol = allBadElecsProtocol';
for i=1:length(numLenghtElectrodeGroups)
    startIndexVecTwo = [startIndexVecTwo startIndex];
    allBadElecsProtocolAsPerElectrodeGroups(:,startIndex:endIndex)= allBadElecsProtocol(:,electrodeGroupList{1,i});
    startIndex = endIndex+1;    
    if i~=length(numLenghtElectrodeGroups)   
        endIndex = endIndex+numLenghtElectrodeGroups(i+1); 
    end
end


if individualSubjectFigureFlag
%------------------plot Bad elctrodes
    myColorMap = [zeros(256,2),linspace(0,1,256)'];
    colormap(jet);
    % subplot(2,1,1);
    pos1 = [0.1 0.55 0.6 0.4];
    hNumBadTrialsPerElec = subplot('Position',pos1);
    imagesc(hNumBadTrialsPerElec,numBadTrialsPerElecAsPerElectrodeGroups); ylabel('Protocol No'); % xlabel('Electrode Index');
    arrayfun(@(a)xline(a,'--','color','red','lineWidth',2),startIndexVecOne(2:end));
    hc=colorbar; hc.Label.String='Proportion of Bad Trials'; %hNumBadTrialsPerElec.CLim=[0 0.5];
    text(3,-0.00001,groupNameList{1},'Color','Blue','FontSize',14);
    text(12,-0.00001,groupNameList{2},'Color','Red','FontSize',14);
    text(28,-0.00001,groupNameList{3},'Color','Blue','FontSize',14);
    text(45,-0.00001,groupNameList{4},'Color','Red','FontSize',14);
    text(56,-0.00001,groupNameList{5},'Color','Blue','FontSize',14);
    text(66,-0.00001,groupNameList{6},'Color','Red','FontSize',14);
    
    
    pos2 = [0.75 0.55 0.21 0.4];
    hNumBadElecPerProcotol = subplot('Position',pos2);
    % totalBadElectrodesAcrossProtocol = sum(allBadElecsProtocol,1);
    numSegMod = numSeg-1; trialNumPerSeg = 120; 
    stem(hNumBadElecPerProcotol,1:numSegMod,numBadTrialsIncEye./trialNumPerSeg,'color',[0.5 0.5 0.5]); axis('tight'); hold on
    stem(hNumBadElecPerProcotol,1:numSegMod,numBadTrialsForEye./trialNumPerSeg,'color',[0.8 0.0 0.0]); axis('tight'); 
    xlabel(hNumBadElecPerProcotol,'Protocol No'); ylabel('Proportion of Bad Trials');
    view([90 -90]); 
    set(hNumBadElecPerProcotol, 'XDir','reverse');
    xlim(hNumBadElecPerProcotol,[0.5 8.5]); ylim(hNumBadElecPerProcotol,[0 1]); 
    legend(hNumBadElecPerProcotol,'Bad Trials inc Bad Eye Trial', 'Only Bad Eye Trial','location','best');
    
    pos3 = [0.1 0.1 0.6 0.4];
    hAllBadElecsPerProtocol = subplot('Position',pos3);
    imagesc(allBadElecsProtocolAsPerElectrodeGroups);
    colorbar;
    arrayfun(@(a)xline(a,'--','color','red','lineWidth',2),startIndexVecTwo(2:end));
    ylabel('Protocol No'); xlabel('Electrode Index');
    hc1=colorbar; hc1.Label.String='Proportion of Bad Electrode'; hAllBadElecsPerProtocol.CLim=[0 3];
    text(-12,1,'Good','Color','Blue','FontSize',14);
    text(-12,2,'badImpedance','Color','Cyan','FontSize',14);
    text(-12,3,'noisyElecs','Color','Yellow','FontSize',14);
    text(-12,4,'flatPSDElecs','Color','Red','FontSize',14);
    
    pos4 = [0.75 0.1 0.21 0.38];
    subplot('Position',pos4);
    % totalBadElectrodesAcrossProtocol = sum(allBadElecsProtocol,1);
    stem(1:numProtocols,numBadElecPerProtocol,'color',[0.5 0.5 0.5]); axis('tight');
    view([90 -90]); 
    set(gca, 'XDir','reverse');
    xlim([0.5 8.5]);
    ylabel('Total Bad Electrode');
    xlabel('Protocol No');
    % h2 = getPlotHandles(1,1,[0.05 0.43 0.3 0.1]);
end

end



