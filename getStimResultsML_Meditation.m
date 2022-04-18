function getStimResultsML_Meditation(MLData,folderExtract,conditionsArray,protocolName)

dummyList = zeros(1,length(conditionsArray));
if contains(protocolName,{'G1','G2','M2'})
    [~,~,stimData] = getSFOriStimInfoFromML(MLData);    
    for ilen = 1:length(conditionsArray)
        trialID =conditionsArray(ilen);
        SfList(ilen) = stimData.SFVals(trialID);
        OriList(ilen) = stimData.OVals(trialID);
    end    
    dummyList = zeros(1,length(conditionsArray));
    stimResults.azimuth = dummyList;
    stimResults.elevation = dummyList;
    stimResults.contrast = dummyList;
    stimResults.temporalFrequency = dummyList;
    stimResults.radius = dummyList;
    stimResults.sigma = dummyList;
    stimResults.orientation = OriList;
    stimResults.spatialFrequency = SfList;
    stimResults.side = 0;    
else
    stimResults.azimuth = dummyList;
    stimResults.elevation = dummyList;
    stimResults.contrast = dummyList;
    stimResults.temporalFrequency = dummyList;
    stimResults.radius = dummyList;
    stimResults.sigma = dummyList;
    stimResults.orientation = ones(1,length(conditionsArray));
    stimResults.spatialFrequency = dummyList;
    stimResults.side = 0;
end
save(fullfile(folderExtract,'stimResults.mat'),'stimResults');
end