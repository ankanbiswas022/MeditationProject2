% This program extracts information about the visual stimulus directly
% from ML data file
function [uniqueConditions,uniqueVisFileNames,stimData] = getSFOriStimInfoFromML(MLData)

numTrials = length(MLData);

conditionNumbers = zeros(1,numTrials);
visFileNames = cell(1,numTrials);

for i=1:numTrials %reading and getting fileNames which was displayed for all the trials
    x = MLData(i);
    conditionNumbers(i) = x.Condition; %x.BehavioralCodes.CodeNumbers(2);
    a = x.TaskObject.Attribute{2};
    visFileNames{i} = a{2};
end

uniqueConditions = unique(conditionNumbers);
numUniqueConditions = length(uniqueConditions);
uniqueVisFileNames = cell(1,numUniqueConditions);

for i=1:numUniqueConditions
    x = find(uniqueConditions(i)==conditionNumbers);
    
    [~,uniqueVisFileNames{i}] = fileparts(visFileNames{x(1)});
    for j=2:length(x)
        [~,tmp] = fileparts(visFileNames{x(j)});
        if ~isequal(uniqueVisFileNames{i},tmp)
            error('Condition files do not match');
        end
    end
end


SFVals = zeros(1,numUniqueConditions);
OVals = zeros(1,numUniqueConditions);

for i=1:numUniqueConditions
    tmp = uniqueVisFileNames{i};
    fileDetails = strsplit(tmp,'_');
    pat =lettersPattern|  " " ; 

    sfList = split(fileDetails{1, 3},pat);
    SFVals(i) = str2num(sfList{2, 1});
    oriList = split(fileDetails{1, 4},pat);
    OVals(i) = str2num(oriList{2, 1});
end

stimData.SFVals = SFVals;
stimData.OVals = OVals;

end