function eValue = getMeanEnergyForAnalysis(mEnergy,freq,freqRange,badFreqPos)

posToAvoid = [find(freq==badFreqPos(1)) find(freq==badFreqPos(2))];

posToAverage = setdiff(intersect(find(freq>=freqRange(1)),find(freq<=freqRange(2))),posToAvoid);
eValue   = sum(mEnergy(posToAverage));
end
