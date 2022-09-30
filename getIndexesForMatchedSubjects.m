
% other than the subject Name, we need experiment dates
% find indexes fot the specified list:
% what we have:

subjectNameGrouped = getOnlyMatchedSubjects;
[subjectNames,expDates] = subjectDatabaseMeditationProject2;

subjectNameGrouped = sort(subjectNameGrouped(:))';

allIndexes=[];
for i=1:length(subjectNameGrouped)
    strToFind = subjectNameGrouped{i};
    disp(subjectNameGrouped{i});
    ind=find(strcmp(strToFind,subjectNames));
    disp(ind);
    allIndexes = [allIndexes ind];
end

disp('All the indexes for the grouped subjets are as follows:')
allIndexes

folderSource = 'D:\Projects\MeditationProjects\MeditationProject2\data\savedData';
fileName = 'IndexesForMatchedSubject.mat';
fileName = fullfile(folderSource,fileName);
save(fileName,'allIndexes');