% Out put Matrix: (Age Matched subjects)
% 1st and 2nd column: A and C; Male and female combined
% 1-8 rows for male, 9-12 rows for female

function subjectNameGrouped = getOnlyMatchedSubjects

% Male 20-30
subjectNameGrouped{1,1} = '019CKa'; subjectNameGrouped{1,2} = '022SSP'; % A-23, C-22 , C-22'027SM'
% subjectName{2,1} = '';       subjectName{2,2} = '026HM'; % A- , C-26
% subjectName{3,1} = '012GK';  subjectName{3,2} = ''; % A-28, C- 

% Male 30-40
subjectNameGrouped{2,1} = '051RA'; subjectNameGrouped{2,2} = '028HB'; % A-31, C-33
subjectNameGrouped{3,1} = '054MP'; subjectNameGrouped{3,2} = '043AK'; % A-35, C-34
subjectNameGrouped{4,1} = '015RK'; subjectNameGrouped{4,2} = '071GK'; % A-37, C-39

% Male 40-50
% subjectName{7,1} = '038DK'; subjectName{7,2} = ''; % A-41, C-

% subjectNameGrouped{5,1} = '053DR'; subjectNameGrouped{5,2} = '063VK'; % A-43, C-43 % Not taking as some problem in extraction

% subjectName{9,1} = '045SP'; subjectName{9,2} = ''; % A-47, C-
subjectNameGrouped{5,1} = '025RK'; subjectNameGrouped{5,2} = '070TB'; % A-49, C-49

% Male 50-60
% subjectName{11,1} = '035SS'; subjectName{11,2} = ''; % A-49, C-
subjectNameGrouped{6,1} = '010AK'; subjectNameGrouped{6,2} = '069MG'; % A-54, C-55 , A-54'044PN'

% Male 60-70
subjectNameGrouped{7,1} = '046ME'; subjectNameGrouped{7,2} = '068RV'; % A-62, C-61

%% --------------------------------
% Female 20-30
subjectNameGrouped{8,1} = '056PR'; subjectNameGrouped{8,2} = '073SK'; % A-27, C-26

% Female 30-40
% subjectName{2,3} = '052PR'; subjectName{2,4} = ''; % A-31, C-
% subjectName{3,3} = '059MS'; subjectName{3,4} = ''; % A-34, C-
subjectNameGrouped{9,1} = '013AR'; subjectNameGrouped{9,2} = '064PK'; % A-35, C-35


% Female 40-50
subjectNameGrouped{10,1} = '006SR'; subjectNameGrouped{10,2} = '062MT'; % A-41, C-42
subjectNameGrouped{11,1} = '036MS'; subjectNameGrouped{11,2} = '049KK'; % A-47, C-46
subjectNameGrouped{12,1} = '017KG'; subjectNameGrouped{12,2} = '072DK'; % A-49, C-49

% Female 50-60
% subjectName{8,3} = '042VA'; subjectName{8,4} = ''; % A-50, C-
% subjectName{9,3} = '060GV'; subjectName{9,4} = ''; % A-51, C-
% subjectName{10,3} = '050UR'; subjectName{10,4} = ''; % A-53, C-
% subjectName{11,3} = '030SH'; subjectName{11,4} = ''; % A-56, C-


% Female 60-70
% subjectName{12,3} = '008RS'; subjectName{12,4} = ''; % A-64, C-

end
