
function     dispBadElecTrialsAcrossProtocols(subjectName,expDate,folderSourceString,badTrialNameStr) %working on this
 %working on this

if ~exist('folderSourceString','var');              folderSourceString=[];                          end
if ~exist('badElectrodeList','var');                badTrialNameStr='_v5';                          end
% if ~exist('badElectrodeRejectionFlag','var');       badElectrodeRejectionFlag=2;                    end
% if ~exist('plotRawTFFlag','var');                   plotRawTFFlag=0;                                end
% if ~exist('refScheme','var');                       refScheme=1;                                    end
% if ~exist('trialAvgFlag','var');                    trialAvgFlag =0;                                end
% if ~exist('saveDataIndividualSubjectsFlag','var');  saveDataIndividualSubjectsFlag=0;               end
% if ~exist('tfFlag','var');                          tfFlag=0;                                       end

if isempty(folderSourceString)
    folderSourceString = 'D:\OneDrive - Indian Institute of Science\Supratim\Projects\MeditationProjects\MeditationProject2';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridType = 'EEG';
% capType = 'actiCap64_UOL';


allElectrodeList = 1:64;
numElectrodes = length(allElectrodeList);
protocolNameList = [{'EO1'}     {'EC1'}     {'G1'}      {'M1'}          {'G2'}      {'EO2'}     {'EC2'}     {'M2'}];
protocolTrialNums = [120 120 120 360 120 120 120 360];
colorNames       = [{[0.9 0 0]} {[0 0.9 0]} {[0 0 0.9]} {[0.7 0.7 0.7]} {[0 0 0.3]} {[0.3 0 0]} {[0 0.3 0]} {[0.3 0.3 0.3]}];
numProtocols = length(protocolNameList);


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
numbadTrialsPerElec     = [];

allBadElecsProtocol = [];

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
    end
    
    numBadTrialsForEyePerProtocol(i) = length(badEyeTrialsList{i});
    numBadTrialsIncEyePerProtocol(i) = length(commonBadTrialsIncEye{i});
    
    % assignging 
    badElecPerProtocol(badImpedanceElecs{i}) = 1; 
    badElecPerProtocol(noisyElecs{i}) = 2;
    badElecPerProtocol(flatPSDElecs{i}) = 3;
    
    numBadElecPerProtocol(i) = nnz(badElecPerProtocol);
    allBadElecsProtocol = [allBadElecsProtocol badElecPerProtocol];
    

    for j=1:numElectrodes
        numbadTrialsPerElec(i,j) = length(elecWiseBadTrialList{i}{j})/protocolTrialNums(i);
    end

 
% badElectrodes.badImpedanceElecs = unique(badElectrodes.badImpedanceElecs);
% badElectrodes.noisyElecs = unique(badElectrodes.noisyElecs);
% badElectrodes.flatPSDElecs = unique(badElectrodes.flatPSDElecs);
%displayBadElecs(hBadElectrodes2(1),subjectName,expDate,protocolName,folderSourceString,gridType,capType,badTrialNameStr,badElectrodes,hBadElectrodes2(2));

end

%------------------plot Bad elctrodes
myColorMap = [zeros(256,2),linspace(0,1,256)'];
colormap(jet);
% subplot(2,1,1);
pos1 = [0.1 0.55 0.6 0.4];
hNumBadTrialsPerElec = subplot('Position',pos1);
imagesc(hNumBadTrialsPerElec,numbadTrialsPerElec); ylabel('Protocol No'); % xlabel('Electrode Index');
hc=colorbar; hc.Label.String='Proportion of Bad Electrode'; hNumBadTrialsPerElec.CLim=[0 0.5];

pos2 = [0.75 0.55 0.21 0.4];
hNumBadElecPerProcotol = subplot('Position',pos2);
% totalBadElectrodesAcrossProtocol = sum(allBadElecsProtocol,1);
stem(hNumBadElecPerProcotol,1:numProtocols,numBadTrialsIncEyePerProtocol./protocolTrialNums,'color',[0.5 0.5 0.5]); axis('tight'); hold on
stem(hNumBadElecPerProcotol,1:numProtocols,numBadTrialsForEyePerProtocol./protocolTrialNums,'color',[0.8 0.0 0.0]); axis('tight'); 
xlabel(hNumBadElecPerProcotol,'Protocol No'); ylabel('Proportion of Bad Electrode');
view([90 -90]); 
set(hNumBadElecPerProcotol, 'XDir','reverse');
xlim(hNumBadElecPerProcotol,[0.5 8.5]); ylim(hNumBadElecPerProcotol,[0 1]); 
legend(hNumBadElecPerProcotol,'Bad Trials inc Bad Eye Trial', 'Only Bad Eye Trial','location','best');

pos3 = [0.1 0.1 0.6 0.4];
hAllBadElecsPerProtocol = subplot('Position',pos3);
imagesc(allBadElecsProtocol');
colorbar;
ylabel('Protocol No'); xlabel('Electrode Index');
hc1=colorbar; hc1.Label.String='Proportion of Bad Electrode'; hAllBadElecsPerProtocol.CLim=[0 3];

pos4 = [0.75 0.1 0.21 0.4];
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



