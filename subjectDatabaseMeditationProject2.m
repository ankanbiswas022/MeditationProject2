function [subjectNames,expDates] = subjectDatabaseMeditationProject2

% classifying the subjects accordingly
% goodsubject list (based on Gamma)
% goodsubject list criterion
% 
i=1; subjectNames{i} = '001K'; expDates{i} = '300921'; 
i=2; subjectNames{i} = '002S'; expDates{i} = '081021'; 
%---------------------------------------------------------------------------------------------------
i=3; subjectNames{i} = '003S'; expDates{i} = '221021';   % new trial duraration of 2.5 s (extracted)
%---------------------------------------------------------------------------------------------------
i=4; subjectNames{i} = '004P';  expDates{i}  = '050122'; %(extracted)
i=5; subjectNames{i} = '006SR'; expDates{i}  = '070122'; %(extracted)
i=6; subjectNames{i} = '007CG';  expDates{i} = '070122'; %(extracted)
i=7; subjectNames{i} = '008RS';  expDates{i} = '100122'; 
%---------------------------------------------------------------------------------------------------
i=8; subjectNames{i} = '009UA';  expDates{i} = '100122'; % 
i=9; subjectNames{i} = '010AK';  expDates{i} = '110122'; %
i=10; subjectNames{i} = '011GP';  expDates{i} = '130122';
i=11; subjectNames{i} = '012GK';  expDates{i} = '140122';
i=12; subjectNames{i} = '013AR';  expDates{i} = '280122';
i=13; subjectNames{i} = '014PT';  expDates{i} = '010222';
% i=14; subjectNames{i} = '003testSA';  expDates{i} = '030222';
% i=15; subjectNames{i} = '004testSA';  expDates{i} = '030222';
% i=16; subjectNames{i} = '004testSA';  expDates{i} = '030222';
i=14; subjectNames{i} = '015RK';      expDates{i} = '040222';  % 
i=15; subjectNames{i} = '016RS';      expDates{i} = '070222';  % 
i=16; subjectNames{i} = '017KG';      expDates{i} = '110222';  % 
%-----------------
i=17; subjectNames{i} = '018BS';      expDates{i} = '160222';  % 
%------------------------------------------short duration
i=18; subjectNames{i} = '019CK';      expDates{i} = '230222';  % Have shorter duration go to CKa for full duration., []]**********
%------------------------------------------------------------------------------------------------------------------------------------------
i=19; subjectNames{i} = '020SG';      expDates{i} = '260222';  % 
%-----------------------------------------------------------------------------------------------------
i=20; subjectNames{i} = '021PB';      expDates{i} = '120322';  %
i=21; subjectNames{i} = '022SSP';     expDates{i} = '150322';  % 
i=22; subjectNames{i} = '023PM';      expDates{i} = '230322';  % 
%-------------------------------------------------
i=23; subjectNames{i} = '024SK';      expDates{i} = '240322';  % Special case: G2 ran for 180 trials, should be 120 trials, check again
%----------------------------------------------------------------------------
i=24; subjectNames{i} = '025RK';      expDates{i} = '250322';  % 
i=25; subjectNames{i} = '026HM';      expDates{i} = '300322';  % 
i=26; subjectNames{i} = '027SM';      expDates{i} = '310322';  % 
%-----------------------------------------------------------------------------------------------------
i=27; subjectNames{i} = '019CKa';     expDates{i} = '030422';  % 
i=28; subjectNames{i} = '028HB';      expDates{i} = '050422';  % 
i=29; subjectNames{i} = '029KV';      expDates{i} = '060422';  % (till this done) %badTrail is also done till this
%-----------------------------------------------------------------------------------------------------
i=30; subjectNames{i} = '030SH';      expDates{i} = '090422';  % (Extracting on 060522)
i=31; subjectNames{i} = '031BK';      expDates{i} = '090422';  % 
i=32; subjectNames{i} = '032KG';      expDates{i} = '110422';  % 
i=33; subjectNames{i} = '033PJ';      expDates{i} = '120422';  % no
i=34; subjectNames{i} = '034TG';      expDates{i} = '130422';  % 
i=35; subjectNames{i} = '035SS';      expDates{i} = '160422';  % Error in EC2, 105 line, check again (6/9/22), line 106, fixed this, 7:33,150622
i=36; subjectNames{i} = '036MS';      expDates{i} = '160422';  % 
i=37; subjectNames{i} = '037VL';      expDates{i} = '250422';  % ----------------------------------
i=38; subjectNames{i} = '038DK';      expDates{i} = '270422';  % 
i=39; subjectNames{i} = '039RJ';      expDates{i} = '300422';  % 
i=40; subjectNames{i} = '040VS';      expDates{i} = '030522';  % 
i=41; subjectNames{i} = '041AG';      expDates{i} = '030522';  % 
%------------------------------------------------------------------------
i=42; subjectNames{i} = '042VA';      expDates{i} = '070522';  % updated the dates
i=43; subjectNames{i} = '043AK';      expDates{i} = '070522';  % 
i=44; subjectNames{i} = '044PN';      expDates{i} = '090522';  % 
%-------------------------------------------------------------------------
i=45; subjectNames{i} = '045SP';      expDates{i} = '100522';  % 
% ----------------------------------------------------------------- 
i=46; subjectNames{i} = '046ME';      expDates{i} = '110522';  % 
i=47; subjectNames{i} = '047HA';      expDates{i} = '210522';  % 
i=48; subjectNames{i} = '048RU';      expDates{i} = '280522';  % bhv2 file is not there, not extracted; this is the subject wheere only impedance data we have for one set only; extract again for impedance values, made dummy Impedance values
i=49; subjectNames{i} = '049KK';      expDates{i} = '020622';  % 43 to 46 extracting on 6/9/22

% i=43; subjectNames{i} = '002testAB';  expDates{i} = '310522';  % test
% i=28; subjectNames{i} = '029KV';      expDates{i} = '060422';  % (till this done)
%-----------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------
i=50; subjectNames{i} = '050UR';      expDates{i} = '050722';  %
i=51; subjectNames{i} = '051RA';      expDates{i} = '090722';  %
i=52; subjectNames{i} = '052PR';      expDates{i} = '090722';  %
i=53; subjectNames{i} = '053DR';      expDates{i} = '100722';  % problem might be there
i=54; subjectNames{i} = '054MP';      expDates{i} = '100722';  %
i=55; subjectNames{i} = '055AD';      expDates{i} = '150722';  %
i=56; subjectNames{i} = '056PR';      expDates{i} = '160722';  %
i=57; subjectNames{i} = '057SP';      expDates{i} = '160722';  %
i=58; subjectNames{i} = '058PP';      expDates{i} = '190722';  %
i=59; subjectNames{i} = '059MS';      expDates{i} = '210722';  %
i=60; subjectNames{i} = '060GV';      expDates{i} = '220722';  %
%------------------------------------------------------------------------------
i=61; subjectNames{i} = '061AV';      expDates{i} = '220722';  %
i=62; subjectNames{i} = '062MT';      expDates{i} = '260722';  %
i=63; subjectNames{i} = '063VK';      expDates{i} = '260722';  %
%------------------------------------------------------------------------------
i=64; subjectNames{i} = '064PK';      expDates{i} = '290722';  %
i=65; subjectNames{i} = '065DG';      expDates{i} = '300722';  %
%------------------------------------------------------------------------------
i=66; subjectNames{i} = '066SG';      expDates{i} = '010822';  %
end