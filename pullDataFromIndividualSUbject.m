
% get the subjectList
[subjectNameS,expDateS] = subjectDatabaseMeditationProject2;
folderString = 'D:\Projects\MeditationProjects\MeditationProject2\data\savedData';
folderSourceString = 'D:\Projects\MeditationProjects\MeditationProject2';
subIndexes = 3:26;
% subIndexes = 11:26;
protocolName = 'G1';
% datatypeStringS = {'_v5Decimated', '_v5Decimated_IndividualBadTrial'};
datatypeStringS = {'_d4020_v9Decimated', '_d4020_v9Decimated_IndividualBadTrial'};

gridType = 'EEG';
badTrialNameStr='_d4020_v9';

%load the data
freqRanges(1,:) = [20 34]; % slow gamma
freqRanges(2,:) = [36 66]; % fast gamma
freqRanges(3,:) = [20 66]; % slow+ fast gamma
freqRanges(4,:) = [70 150];% high gamma

for dType = 1:2    
    for iref=1:2
        iSub=1;
        for i = subIndexes            
            subjectName = subjectNameS{i};
            expDate = expDateS{i};
            disp (['Processing Data for Subject ' subjectName ' and ExpDate ' num2str(expDate)]);
            datatypeString = datatypeStringS{dType}; % hardCoded            
            %load the data
            load(fullfile(folderString,protocolName,[subjectName expDate datatypeString '.mat']));     
            %load the bad data File
             badFileName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData',['badTrials' badTrialNameStr '.mat']);  
             x=load(badFileName);
             
             badElectrodes{iSub}= unique(vertcat(x.badElecs.badImpedanceElecs,x.badElecs.noisyElecs,x.badElecs.flatPSDElecs));
             % variables of Interest: powBl and powST            
            psdST = squeeze(mean(mean(PowSt{iref},2,'omitnan'),3,'omitnan')); %
            psdBL = squeeze(mean(mean(PowBl{iref},2,'omitnan'),3,'omitnan')); %
            freqVals = FreqVals{1}{1};            
            badFreqPos = [50 100];
            for iElec = 1:size(psdST,1)
                for iFreqRange=1:length(freqRanges)                    
                    powerValsBL{iFreqRange}(iSub,iElec) = getMeanEnergyForAnalysis(psdBL(iElec,:),freqVals,freqRanges(iFreqRange,:),badFreqPos);
                    powerValsST{iFreqRange}(iSub,iElec) = getMeanEnergyForAnalysis(psdST(iElec,:),freqVals,freqRanges(iFreqRange,:),badFreqPos);
                    diffPowerVals{iFreqRange}(iSub,iElec) = 10*(log10(powerValsST{iFreqRange}(iSub,iElec))-log10(powerValsBL{iFreqRange}(iSub,iElec)));  
                   
                end
            end
            iSub= iSub+1;
        end
        diffPowerValsAllSubjects{dType}{iref}= diffPowerVals;
    end    
end
% 
fileNameForSave = fullfile(folderString,'analyzedDataV2','PowerVals_topoPlotData_v9.mat');
save(fileNameForSave,'diffPowerValsAllSubjects','freqRanges','badElectrodes');
