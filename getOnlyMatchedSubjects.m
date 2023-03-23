% Out put Matrix: (Age Matched subjects)
% 1st and 2nd column: A and C; Male and female combined
% 1-13 rows for male(n=113), 14-24 rows for female(n=11)
% Updated on 16th December, assuming all the sujects are good

function subjectNameGrouped = getOnlyMatchedSubjects

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Males
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Male 20-29 (5 matched)
subjectNameGrouped{1,1} = '019CKa';    subjectNameGrouped{1,2} = '022SSP'; %  A-23,   C-22 , %[C-22 '027SM']
subjectNameGrouped{2,1} = '096MS';     subjectNameGrouped{2,2} = '026HM';  %  A-26 ,  C-26
subjectNameGrouped{3,1} = '040VS';     subjectNameGrouped{3,2} = '100UK';  %  A-27 ,  C-28 (*In)
subjectNameGrouped{4,1} = '012GK';     subjectNameGrouped{4,2} = '093AK';  %  A-28 ,  C-28
subjectNameGrouped{5,1} = '095KM';     subjectNameGrouped{5,2} = '075AD';  %  A-30,   C-29 

% Male 30-39 (5 matched (1 with +/-2))
subjectNameGrouped{6,1}  = '051RA';  subjectNameGrouped{6,2}  = '092KB';  % A-31, C-31
subjectNameGrouped{7,1}  = '090AV';  subjectNameGrouped{7,2}  = '028HB';  % A-32, C-33
subjectNameGrouped{8,1}  = '054MP';  subjectNameGrouped{8,2}  = '043AK';  % A-35, C-34
subjectNameGrouped{9,1}  = '038DK';  subjectNameGrouped{9,2}  = '098GS';  % A-36, C-35
subjectNameGrouped{10,1} = '015RK';  subjectNameGrouped{10,2} = '071GK'; % A-37, C-39

% Male 40-44 (1 matched)
% subjectNameGrouped{10,1} = '*';         subjectNameGrouped{10,2} = '077LK';  % A-, C-40 
subjectNameGrouped{11,1} = '041AG';  subjectNameGrouped{11,2} = '077LK';    % A-41, C-40 (*In)
% subjectNameGrouped{12,1} =  '*';     subjectNameGrouped{12,2} = '003S';     % A-42, C-42 (*In)
% subjectNameGrouped{11,1} = '053DR'; subjectNameGrouped{11,2} = '063VK';      % A-43, C-43 (*Out)

% Male 45-49 (2 matched)
subjectNameGrouped{12,1} = '045SP';  subjectNameGrouped{12,2} = '078BM'; % A-47, C-48
subjectNameGrouped{13,1} = '025RK';  subjectNameGrouped{13,2} = '070TB'; % A-49, C-49

% Male 50-59 (3 matched)
% subjectNameGrouped{14,1} = '035SS'; subjectNameGrouped{14,2} = '080RP'; % A-50, C-50 (*Out)
subjectNameGrouped{14,1} = '035SS'; subjectNameGrouped{14,2} = '048RU';   % A-50, C-51 (*In)
subjectNameGrouped{15,1} = '010AK'; subjectNameGrouped{15,2} = '069MG';   % A-54, C-55
subjectNameGrouped{16,1} = '044PN'; subjectNameGrouped{16,2} = '101PB'; 	    % A-54, C-54 (*)

% Male 60-65 (1 matched, 1 A61 required)
subjectNameGrouped{17,1} = '046ME'; subjectNameGrouped{17,2} = '068RV';   % A-62, C-61
% subjectNameGrouped{19,1} = '*'; 	 subjectNameGrouped{19,2} = '085BM';   % A-61, C-61 (*)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Females
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Female 20-29 (2 matched; 1 A23 required)
subjectNameGrouped{18,1} = '031BK'; subjectNameGrouped{18,2} = '081SN'; % A-24, C-23
subjectNameGrouped{19,1} = '056PR'; subjectNameGrouped{19,2} = '073SK'; % A-27, C-26
% subjectNameGrouped{20,1} = '*'; 	subjectNameGrouped{3,2} = '086AB'; % *A-28, C-28

% Female 30-39 (4 matched)
subjectNameGrouped{20,1} = '052PR'; subjectNameGrouped{20,2} = '087KR'; % A-31,  C-31, %[C-31 '082MS']
subjectNameGrouped{21,1} = '059MS'; subjectNameGrouped{21,2} = '102AS'; % A-34,  C-34
subjectNameGrouped{22,1} = '013AR'; subjectNameGrouped{22,2} = '064PK'; % A-35,  C-35 
subjectNameGrouped{23,1} = '074KS'; subjectNameGrouped{23,2} = '084AK'; % A-36,  C-37

% Female 40-44 (1 matched,  required A42)
% *Note: This change was made based on the subject availability 
subjectNameGrouped{24,1} = '006SR'; subjectNameGrouped{24,2} = '088SP'; % A-40, C-39
% subjectNameGrouped{25,1} = '*'; 	subjectNameGrouped{25,2} = '062MT'; % A-42, C-42

% Female 45-49  (2 matched)
subjectNameGrouped{25,1}  = '036MS';  subjectNameGrouped{25,2}  = '049KK';  % A-47, C-46
subjectNameGrouped{26,1}  = '017KG';  subjectNameGrouped{26,2} = '072DK';   % A-49, C-49

% Female 50-59 (4 matched)
% subjectNameGrouped{27,1} = '042VA'; subjectNameGrouped{27,2} = '099SP'; % A-50, C-50
subjectNameGrouped{27,1} = '060GV'; subjectNameGrouped{27,2} = '097SV'; % A-51, C-51
subjectNameGrouped{28,1} = '050UR'; subjectNameGrouped{28,2} = '083SP'; % A-53, C-53
subjectNameGrouped{29,1} = '030SH'; subjectNameGrouped{29,2} = '076BH'; % A-56, C-56

% Female 60-65 (1 matched with +/-2)
subjectNameGrouped{30,1} = '089AB'; subjectNameGrouped{30,2} = '079SG'; % A-64, C-62
% subjectNameGrouped{33,1} = '008RS'; subjectNameGrouped{33,2} = '*';     % A-64, *C-64
% subjectNameGrouped{34,1} = '024SK'; subjectNameGrouped{34,2} = '*';     % A-64, *C-64 (*In)
end
