
folderSourceSring = 'D:\Projects\MeditationProjects\MeditationProject2\data\savedData\subjectWise';
% combine data for the control and advanced meditators:
subjectNameGrouped = getOnlyMatchedSubjects;
% concatenate data for the subjects in a big matrix
dataString = 'PowerDataAllElecs_';
% varStringToCat = 'powerValBL';

powerValStCombinedAdvanced = [];

% 12 different protocols
% 251 power values
% for 64 electrodes

for groupIndex=1:size(subjectNameGrouped,2)    
    for subIndex=1:length(subjectNameGrouped)
        subjectName = subjectNameGrouped{subIndex,groupIndex};
       
        fileNameToLoad = fullfile(folderSourceSring,[dataString subjectName,'.mat']);
        load(fileNameToLoad);
        subjectName
        
        switch groupIndex
            case 1
                powerValStCombinedAdvanced(subIndex,:,:,:) = powerValST;

                checkData = squeeze(powerValST(2,:,:));
                powerValBlCombinedAdvanced(subIndex,:,:,:) = powerValBL;
            case 2
                powerValStCombinedControl(subIndex,:,:,:) = powerValST;
                powerValBlCombinedControl(subIndex,:,:,:) = powerValBL;
                if subIndex==10
                    flag;
                end
        end        
    end    
end

saveFileString = 'GroupedPowerDataPulledAcrossSubjects.mat';
save(fullfile(folderSourceSring,saveFileString),'powerValStCombinedAdvanced','powerValBlCombinedAdvanced','powerValStCombinedControl','powerValBlCombinedControl');