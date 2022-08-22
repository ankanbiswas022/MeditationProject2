function getAndSaveValuesGamma(SubjectIDs,subjectNames,gridType,expDates,protocolName,folderSourceString,nonEEGElectrodes,refType,capType,useCommonBadTrial,BadTrialNameStr)

if ~exist('capType','var') || isempty(capType); capType=  'actiCap64_UOL'; end
if ~exist('useCommonBadTrial','var') || isempty(useCommonBadTrial); useCommonBadTrial=  1; end
if ~exist('BadTrialNameStr','var') || isempty(BadTrialNameStr); BadTrialNameStr=  'v7'; end

if ~exist('refType','var') || isempty(refType)
    refTypes=  {'uniPolar','biPolar','AvgRef'};
else
    refTypes = refType;
end

for isubj = 1:length(SubjectIDs)
    
    if length(SubjectIDs) ~= 1
        clear eegSortedData
    end
    
    subjectName = cell2mat(subjectNames(SubjectIDs(isubj)));
    expDate =  cell2mat(expDates(SubjectIDs(isubj)));
    
    for irefTy = 1:size(refTypes,2)
        refsch = refTypes{irefTy};
        
        disp (refsch);
        if strcmpi (refsch,'AvgRef')
            [AvgRef.analogData,~] = saveAvgRef(folderSourceString,subjectName,gridType,expDate,protocolName,nonEEGElectrodes,BadTrialNameStr);
        end
        
        %extraction folder to load stimResults to identify total number of
        %conditions
        extractFolderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'extractedData');
        %getting stimulus conditions
        
        
        % % Getting stimulus information from Monkeylogic file name

%        if strcmpi (protocolName,'G1')
            DataML = load(fullfile(extractFolderName,'parameterCombinations.mat'));
            paramCombinations = squeeze(DataML.parameterCombinations)
% %             stimResults = DataML.MLTrialRecord.ConditionsPlayed;
% %             MLData = DataML.MLData;
% %             [uniqueConditions,~,stimData] = getSFOriStimInfoFromML(MLData);
% %             StimVals(:,1)= DataML.SFVals;
% %             StimVals(:,2)= DataML.OVals;
%             
            uniqueCond1= DataML.fValsUnique;
            uniqueCond2= DataML.oValsUnique;            
%             
%         else
%             disp('Protocol Name doesnot match')
%             
%         end
%         
%         uniqueCond1 = unique(StimVals(:,1));
%         uniqueCond2 = unique(StimVals(:,2));
%         
%         StimInfo{isubj} = stimData;
        
        %segmented folder for loading lfpinfo
        segfolderName = fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData');
        timeVals= cell2mat(struct2cell(load(fullfile(segfolderName,'LFP','lfpInfo.mat'),'timeVals')));
        Fs = round(1/(timeVals(2)-timeVals(1))); % specifying sampling Rate
        timeRange = [0.25 0.75]; % time Range for stimulus period analysis
        stPos = timeVals >= timeRange(1) & timeVals < timeRange(2);
        bltimeRange = [-0.5 0];
        blPos = timeVals >= bltimeRange(1) & timeVals < bltimeRange(2);
        
        % % loading bad trials/elecs file
        BadTrialFileName = ['badTrials' BadTrialNameStr];
        badTrials{isubj}= load(fullfile(segfolderName,BadTrialFileName));
%         allTrials = 1:1:length(stimResults);
        %goodTrials = setdiff(allTrials,union(badTrials{irefTy}{isubj}.badTrials,badTrials{irefTy}{isubj}.badTrialsUnique.badEyeTrials));% removing bad trials from goodTrials
        
        
        %% loading  data
        clear eegData
        disp(subjectName); disp('ERP');
        
        if strcmpi(refsch,'biPolar')
            bipolarLocs = load(fullfile("D:\Programs\ProgramsMAP\Montages\Layouts\"+capType+"\bipChInfo"+capType));
            numChannelsStored = length(bipolarLocs.bipolarLocs);
            eegChannelsStored = 1:1:numChannelsStored;
            
        else
            analogChannelsStored= cell2mat(struct2cell(load(fullfile(segfolderName,'LFP','lfpInfo.mat'),'analogChannelsStored')));
            eegChannelsStored = setdiff(analogChannelsStored,nonEEGElectrodes);
            numChannelsStored = length(eegChannelsStored) ;
        end
        
        
        %eegData =zeros(numChannelsStored,length(goodTrials),length(t));% (Electrode,Trials,Samples) %loading only good trials
        
        hW1 = waitbar(0,'collecting data...');
        for idat=1:numChannelsStored
            if strcmpi(refsch,'uniPolar')
                iElec = eegChannelsStored(idat);
                waitbar((idat-1)/numChannelsStored,hW1,['collecting data from electrode: ' num2str(iElec) ' of ' num2str(numChannelsStored)]);
                
                clear x; x = load(fullfile(segfolderName,'LFP',['elec' num2str(iElec) '.mat'])); % Load EEG Data
                eegElectrodeLabels{irefTy}{isubj,iElec} = x.analogInfo.labels; % #ok<AGROW>
                
            elseif strcmpi(refsch,'biPolar')
                iElec1 = bipolarLocs.bipolarLocs(idat,1);
                iElec2 = bipolarLocs.bipolarLocs(idat,2);
                waitbar((idat-1)/numChannelsStored,hW1,['collecting data from electrode: ' num2str(idat) ' of ' num2str(length(bipolarLocs.bipolarLocs))]);
                
                clear y; y = load(fullfile(segfolderName,'LFP',['elec' num2str(iElec1) '.mat'])); % Load EEG Data
                clear z; z = load(fullfile(segfolderName,'LFP',['elec' num2str(iElec2) '.mat'])); % Load EEG Data
                
                x.analogData = y.analogData-z.analogData;
                
                eegElectrodeLabels{irefTy}{isubj,idat} = (y.analogInfo.labels+"-"+z.analogInfo.labels);
                
            else
                iElec = eegChannelsStored(idat);
                waitbar((idat-1)/numChannelsStored,hW1,['collecting data from electrode: ' num2str(iElec) ' of ' num2str(numChannelsStored)]);
                clear m; m = load(fullfile(segfolderName,'LFP',['elec' num2str(iElec) '.mat'])); % Load EEG Data
                eegElectrodeLabels{irefTy}{isubj,iElec} = m.analogInfo.labels; % #ok<AGROW>
                
                % Generate/load AvgRef file
                %avgRefFile = fullfile(segfolderName,'LFP',['AvgRef.mat']);
                
                %                 if exist(avgRefFile,'file')
                %                     AvgRef = load(avgRefFile);
                %                 else
                %                 end
                
                x.analogData = m.analogData-AvgRef.analogData;
            end
            
            %eegData(idat,:,:) = x.analogData(goodTrials,:); % #ok<AGROW>
            
            % sorting EEG Data condition wise
            for iCond1 = 1:length(uniqueCond1)
                for iCond2 = 1:length(uniqueCond2)
%                     icond = DataML.parameterCombinations  ==uniqueCond1(iCond1)&StimVals(:,2)==uniqueCond2(iCond2);
                    trialNums = paramCombinations{iCond1,iCond2};%find(stimResults == uniqueConditions(icond));
                    if useCommonBadTrial == 0
                        if strcmpi(refsch,'biPolar')
                            combinedBadTrials = union(badTrials{isubj}.allBadTrials{1,iElec1},badTrials{isubj}.allBadTrials{1,iElec2});
                            trialNums = setdiff(trialNums,union(combinedBadTrials,badTrials{isubj}.badTrialsUnique.badEyeTrials));
                        else
                            trialNums = setdiff(trialNums,union(badTrials{isubj}.allBadTrials{1,idat},badTrials{isubj}.badTrialsUnique.badEyeTrials));
                        end
                    else
                        trialNums = setdiff(trialNums,union(badTrials{isubj}.badTrials,badTrials{isubj}.badTrialsUnique.badEyeTrials));
                    end
                    eegSortedData{irefTy}{isubj,iCond1,iCond2,idat}= x.analogData(trialNums,:);
                    %eegSortedData{irefTy}{isubj,iCond1,iCond2}(idat,:,:) = x.analogData(trialNums,:);
                end
            end
            
        end
        close(hW1);
        
        
        %params
        movingwin = [0.25 0.025];
        params.tapers   = [1 1];
        params.pad      = -1;
        params.Fs       = Fs;
        params.trialave = 0;
        params.fpass = [0 500];
        %%
        disp('PSD');
        hW2 = waitbar(0,'collecting PSD data...');
        % PSD Data
        for jElec = 1:numChannelsStored
            waitbar((jElec-1)/numChannelsStored,hW2,['collecting PSD data from electrode: ' num2str(jElec) ' of ' num2str(numChannelsStored)]);
            for iCond1 = 1:length(uniqueCond1)
                for iCond2 = 1:length(uniqueCond2)
                    %                     [PowDatast,Fst]=mtspectrumc(squeeze(eegSortedData{irefTy}{isubj,iCond1,iCond2}(jElec,:,stPos))',params);
                    %                     [PowDatabl,Fbl]=mtspectrumc(squeeze(eegSortedData{irefTy}{isubj,iCond1,iCond2}(jElec,:,blPos))',params);
                    [PowDatast,Fst]=mtspectrumc(squeeze(eegSortedData{irefTy}{isubj,iCond1,iCond2,jElec}(:,stPos))',params);
                    [PowDatabl,Fbl]=mtspectrumc(squeeze(eegSortedData{irefTy}{isubj,iCond1,iCond2,jElec}(:,blPos))',params);
                    PowSt{irefTy}(isubj,iCond1,iCond2,jElec,:) = (mean(PowDatast,2));
                    PowBl{irefTy}(isubj,iCond1,iCond2,jElec,:) = (mean(PowDatabl,2));
                end
            end
        end
        close(hW2);
        
        if isequal(Fst,Fbl)
            FreqVals{irefTy}{isubj}= Fst;
        else
            disp('Freq Vals not equal')
        end
        
        
        % TF Data
        %%
        disp('TF');
        hW3 = waitbar(0,'collecting TF data...');
        
        for jElec = 1:numChannelsStored
            waitbar((jElec-1)/numChannelsStored,hW3,['collecting TF data from electrode: ' num2str(jElec) ' of ' num2str(numChannelsStored)]);
            for iCond1 = 1:length(uniqueCond1)
                for iCond2 = 1:length(uniqueCond2)
                    [TFPowDatast,TimeSt,FreqSt]=mtspecgramc(squeeze(eegSortedData{irefTy}{isubj,iCond1,iCond2,jElec}(:,:))',movingwin,params);
                    TFPowerStim{irefTy}(isubj,iCond1,iCond2,jElec,:,:) = mean(TFPowDatast,3);%averaging across trials
                    TimeValsTF{irefTy}{isubj} = TimeSt+timeVals(1)-1/Fs;
                    basePosTF{irefTy}{isubj}  = intersect(find(TimeValsTF{irefTy}{isubj}>=bltimeRange(1)),find(TimeValsTF{irefTy}{isubj}<bltimeRange(2)));
                end
            end
        end
        close(hW3);
        
        FreqValsTF{irefTy}{isubj}= FreqSt;
    end
end

saveFolderName = 'savedData';
saveFolderDestinationString = fullfile(folderSourceString,'data',saveFolderName,protocolName);
makeDirectory (saveFolderDestinationString);
if length(SubjectIDs) == 1
    if useCommonBadTrial == 1
        FileName = [subjectName expDate BadTrialNameStr 'Decimated.mat'];
    else
        FileName = [subjectName expDate BadTrialNameStr 'Decimated_IndividualBadTrial.mat'];
    end
    disp (['Saving  File ' FileName])
    save(fullfile(saveFolderDestinationString,FileName),'eegSortedData','timeVals','PowSt','PowBl','FreqVals','TFPowerStim','basePosTF','FreqValsTF','TimeValsTF','badTrials','eegElectrodeLabels','-v7.3');
    
else
    Subids = num2str(SubjectIDs);
    if useCommonBadTrial == 1
        FileName = ['SubjectIds ' Subids BadTrialNameStr 'Decimated.mat'];
    else
        FileName = ['SubjectIds ' Subids BadTrialNameStr 'Decimated_IndividualBadTrial.mat'];
    end
    disp (['Saving  File ' FileName])
    save(fullfile(saveFolderDestinationString,FileName),'PowSt','PowBl','FreqVals','TFPowerStim','FreqValsTF','TimeValsTF','basePosTF','badTrials','eegElectrodeLabels','-v7.3');
end

end