% Out put Matrix: (Age Matched subjects)
% 1st and 2nd column: A and C; Male and female combined
% 1-13 rows for male(n=113), 14-24 rows for female(n=11)
% Updated on 16th December, assuming all the sujects are good

function subjectNameGrouped = getOnlyMatchedSubjects

% Male 20-29 (2 matched, 1 A26, 1 A30 required)
subjectNameGrouped{1,1} = '019CKa'; 	subjectNameGrouped{1,2} = '022SSP'; %  A-23,   C-22 , %[C-22 '027SM']
% subjectNameGrouped{2,1} = '*';     	subjectNameGrouped{2,2} = '026HM';  % *A-26 ,  C-26
subjectNameGrouped{2,1} = '012GK';     subjectNameGrouped{2,2} = '093AK';  %  A-28 ,  C-28
% subjectNameGrouped{4,1} = '*';  		subjectNameGrouped{4,2} = '075AD';  % *A-30,   C-29 

% Male 30-39 (4 matched, 1 with +/-2)
subjectNameGrouped{3,1} = '051RA'; subjectNameGrouped{3,2} = '092KB'; % A-31, C-31
subjectNameGrouped{4,1} = '090AV'; subjectNameGrouped{4,2} = '028HB'; % A-32, C-33
subjectNameGrouped{5,1} = '054MP'; subjectNameGrouped{5,2} = '043AK'; % A-35, C-34
subjectNameGrouped{6,1} = '015RK'; subjectNameGrouped{6,2} = '071GK'; % A-37, C-39

% Male 40-44 (2 matched)
subjectNameGrouped{7,1}  = '038DK';   subjectNameGrouped{7,2} = '077LK';  % A-41, C-40 
% subjectNameGrouped{8,1}  = '053DR';   subjectNameGrouped{8,2} = '063VK';
% % A-43, C-43 % problem with the 053DR extraction; #problemFlag@AB

% Male 45-49 (2 matched)
subjectNameGrouped{8,1}  = '045SP';   subjectNameGrouped{8,2} = '078BM'; % A-47, C-48
subjectNameGrouped{9,1} = '025RK';  subjectNameGrouped{9,2} = '070TB'; % A-49, C-49

% Male 50-59 (2 matched, 1 C54 required)
subjectNameGrouped{10,1} = '035SS'; subjectNameGrouped{10,2} = '080RP'; % A-50, C-50; %%#problemFlag@AB: lots of bad electrode in 035SS, when bad electrode across protocols are combined
subjectNameGrouped{11,1} = '010AK'; subjectNameGrouped{11,2} = '069MG'; % A-54, C-55
% subjectNameGrouped{13,1} = '044PN'; subjectNameGrouped{13,2} = '*'; 	  % A-54, C-

% Male 60-65 (1 matched, 1 A61 required)
subjectNameGrouped{12,1} = '046ME'; subjectNameGrouped{12,2} = '068RV'; % A-62, C-61
% subjectNameGrouped{15,1} = ''; 	 subjectNameGrouped{15,2} = '085BM'; % A-61, C-61

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Females
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Female 20-29 (2 matched; 1 A23 required)
subjectNameGrouped{13,1} = '031BK'; subjectNameGrouped{13,2} = '081SN'; % A-24, C-23
subjectNameGrouped{14,1} = '056PR'; subjectNameGrouped{14,2} = '073SK'; % A-27, C-26
% subjectNameGrouped{3,3} = '*'; 	subjectNameGrouped{3,4} = '086AB'; % *A-28, C-28

% Female 30-39 (3 matched, 1 C34 required)
subjectNameGrouped{15,1} = '052PR'; subjectNameGrouped{15,2} = '087KR'; % A-31,  C-31, %[C-31 '082MS']
% subjectNameGrouped{5,3} = '059MS'; subjectNameGrouped{5,4} = '*'; 	% A-34, *C-34
subjectNameGrouped{16,1} = '013AR'; subjectNameGrouped{16,2} = '064PK'; % A-35,  C-35 
subjectNameGrouped{17,1} = '074KS'; subjectNameGrouped{17,2} = '084AK'; % A-36,  C-37

% Female 40-44 (1 matched,  required A42)
% *Note: This change was made based on the subject availability 
subjectNameGrouped{18,1} = '006SR'; subjectNameGrouped{18,2} = '088SP'; %  A-40, C-39
% subjectNameGrouped{9,3} = '*'; 	subjectNameGrouped{9,4} = '062MT'; % *A-42, C-42

% Female 45-49  (2 matched)
subjectNameGrouped{19,1}  = '036MS';  subjectNameGrouped{19,2}  = '049KK';  % A-47, C-46
subjectNameGrouped{20,1}  = '017KG';  subjectNameGrouped{20,2} = '072DK';  % A-49, C-49

% Female 50-59 (2 matched, 2 required C50, C51)
% subjectNameGrouped{12,3} = '042VA'; subjectNameGrouped{12,4} = '*C-50'; % A-50, *C-50
% subjectNameGrouped{13,3} = '060GV'; subjectNameGrouped{13,4} = '*C-51'; % A-51, *C-51
subjectNameGrouped{21,1} = '050UR'; subjectNameGrouped{21,2} = '083SP'; % A-53,  C-53
subjectNameGrouped{22,1} = '030SH'; subjectNameGrouped{22,2} = '076BH'; % A-56,  C-56

% Female 60-65 (1 matched with +/-2)
subjectNameGrouped{23,1} = '089AB'; subjectNameGrouped{23,2} = '079SG'; % A-64, C-62
% subjectNameGrouped{16,3} = '008RS'; subjectNameGrouped{16,4} = '*C64';  % A-64, *C-64

end
