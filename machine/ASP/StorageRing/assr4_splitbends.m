function assr4(varargin)
% Lattice definition file - generated by dimad2at v1.300000 
%
% Eugene 2004-12-13 Updating the generalised file to realign the family
% names and elements with aspinit. NOTE: aspinit will not work with split
% elements... not without modification of the init file.
%
% Eugene 2005-09-16 Standardise all lattices being used to this. "Custom"
% versions of the lattice files, eg for ML, ID studies etc will take this
% file as a template. The following major changes were made -
%    * All family names in CAPS in line with ALS and SPEAR convention.
%    * Dipole path and gradient updated to reflect numerical studies on
%      measured data. Quadrupole values fitted for a tune of 13.3, 5.2 and
%      zero dispersion given the new dipole gradient fields.
%    * Merged with "aspsr_msrf.m" with independent/individual cavitie(s).
%    * Element positions/lengths should be inline with engineering
%      drawings.
% 
% Eugene 2010-07-08
%  * now we define the RF frequency and this will automatically scale the
%    drift sections to match
%  * Changed the dipole pass method to BndMPoleSymplectic4E2RadPass that
%    correctly tracks off energy particles through the dipole.
%  * added scaling factors.
%
% Eugene 2010-07-27
%  * Plan to make this lattice the standard general lattice for all LOCO
%    fits.
%  * Added IDs into this lattice. Scaling of 'quadDL_2', 'scalek' and
%    'scalem' set by balancing the relative quadrupole strengths between
%    families so that they are the same as in the machine. The sextupole
%    component was scaled so that the modeled chromaticity matches what we
%    measure.


global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3.0134e9;  % Measured by Harris and Kent using resonant depolrasiation July 2010.
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);

arclen = 10.031590015999999;  % length bpm to bpm without the straight sections.
% ringrf = 499.6716341346960e6;
% ringrf = 499.674000e6;
ringrf = 499.675982e6;  % 16/01/2017 ET
C0 = 299792458; 	   % speed of light [m/s]
HarmNumber = 360;
L0 = C0*HarmNumber/ringrf;
halfstraightlength = (L0/14-arclen)/2; (L0 - arclen*14)/14/2;
% L0 = 2.159946602239996e+02;
% L0 = 2.159946602239993e+02; % calculated using findspos %215.9945540689991;% with new dipole path lengths. Designed for 216m.

disp(' ');
fprintf('*** Loading lattice from %s.m ***\n',GLOBVAL.LatticeFile);

% With AT1.3 ringpass and linepass, particles limited by the apperturepass
% will have [x,x',y,y',delta,dl] = [NaN,0,0,0,0,0]. All pass methods will
% check for this and do nothing to particles with these coordinates.
% Ring/linepass will both return particle positions as well as the number
% of turns the particles achieved.
ap  =   aperture('AP',[-16 17 -16 16]*1e2,'AperturePass');

% Quadrupole field extent on one end past the magnet iron length as
% measured by RMIT student Neville. quadDL_2 = 0.005;
% Empirically modified so relative strengths between QFA, QDA and QFB are
% the same as those set on the ring. 
quadDL_2 = 0.0042;
d1	=	drift('D1'	,halfstraightlength,'DriftPass'); % (2.698286 -> to get closer to the design distance of 216m)
d2	=	drift('D2'	,1.900000e-001-quadDL_2,'DriftPass');
d3	=	drift('D3'	,1.650000e-001-quadDL_2,'DriftPass');
d4	=	drift('D4'	,2.750000e-001,'DriftPass');
d5	=	drift('D5'	,1.550000e-001-quadDL_2,'DriftPass');
d6	=	drift('D6'	,4.500000e-001-quadDL_2*2,'DriftPass');

% Modified drifts around BPM sections.
bpm	=	monitor('BPM'	,'IdentityPass');
d1a	=	drift('D1A'	,len(d1)-3.942860e-001,'DriftPass'); % 2.304000e+000
d1b	=	drift('D1B'	,        3.942860e-001,'DriftPass');
d1aa=	drift('D1A'	,len(d1)-0.58,'DriftPass'); % Last bpm
d1bb=	drift('D1B'	,        0.58,'DriftPass');
d4a	=	drift('D4A'	,len(d4)-1.990000e-001,'DriftPass'); % 7.600000e-002
d4b	=	drift('D4B'	,        1.990000e-001,'DriftPass');
d4aa	=	drift('D4AA'	,len(d4)-6.400000e-002,'DriftPass'); % 2.110000e-001
d4bb	=	drift('D4BB'	,        6.400000e-002,'DriftPass');
d2a	=	drift('D2A'	,len(d2)-1.030000e-001,'DriftPass'); % 8.700000e-002
d2b	=	drift('D2B'	,        1.030000e-001,'DriftPass');

% Dipoles
% design -> rbend('BEND',1.726000e+000,2.243995e-001,...
%                     1.121997e-001,1.121997e-001,-3.349992e-001,[method]);
% From numerical studies ->   L: 1.72579121675e+000
%                             K: 0.33295132
%                          Sext: 0.01092687
%                           Oct: 0.15166053
dip1	=	rbend('BEND'	,1.72579121675e+000,2.243995e-001,1.121997e-001,1.121997e-001,-0.33295132,'BendLinearPass');
dip2	=	rbend('BEND'	,1.72579121675e+000,2.243995e-001,1.121997e-001,1.121997e-001,-0.33295132,'BendLinearPass');

scalek = 1;    % Quadrupole components scaled to get the relative strengths between the quadrupoles in the model to match with the machine.
scalem = 3.15; % Sextupole component scaled to get model chromaticities to match with measured chromaticities
scalen = 0.0;
thinsext = sextupole('thinsext'	,0,0.0,'ThinMPolePass');
leftdrift_a = drift('leftdrift',0.076,'DriftPass');
leftdrift_b = drift('leftdrift',0.0837626757-len(leftdrift_a),'DriftPass');
rightdrift_b = drift('rightdrift',0.064,'DriftPass');
rightdrift_a = drift('rightdrift',0.0887292346-len(rightdrift_b),'DriftPass');

b_left01 = rbend('b_left01',0.0695312761,0.0001684486,0.0000000000,0.0000000000,-0.0058550750*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.0058550750*scalek 0.0862147892*scalem -1.2289013273*scalen]);
b_left02 = rbend('b_left02',0.0695282915,0.0007117061,0.0000000000,0.0000000000,-0.0239389168*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.0239389168*scalek -0.0583359949*scalem -0.0632750927*scalen]);
b_left03 = rbend('b_left03',0.0695152451,0.0032675350,0.0000000000,0.0000000000,-0.2254325358*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.2254325358*scalek 0.2451727966*scalem -0.1103893288*scalen]);
b_left04 = rbend('b_left04',0.0694679183,0.0087995936,0.0000000000,0.0000000000,-0.4158165694*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.4158165694*scalek -0.1443627022*scalem 0.6681103839*scalen]);
b_left05 = rbend('b_left05',0.0694041758,0.0092692887,0.0000000000,0.0000000000,-0.3298403749*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3298403749*scalek -0.0340207205*scalem 0.3349521492*scalen]);
b_centre01 = rbend('b_centre01',0.2820465390,0.0367531161,0.0000000000,0.0000000000,-0.3315842393*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3315842393*scalek 0.0083655817*scalem 0.2965845308*scalen]);
b_centre02 = rbend('b_centre02',0.2815037989,0.0354072994,0.0000000000,0.0000000000,-0.3306516396*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3306516396*scalek 0.0236710994*scalem -0.2196079070*scalen]);

b_centre03a = rbend('b_centre03',0.07039827720955,0.0349189639*0.2502,0.0000000000,0.0000000000,-0.3300962629*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3300962629*scalek 0.0101400673*scalem -0.5218735605*scalen]);
b_centre03b = rbend('b_centre04',0.16393005016542,0.0349189639*0.5827,0.0000000000,0.0000000000,-0.3300962629*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3300962629*scalek 0.0101400673*scalem -0.5218735605*scalen]);
b_centre03c = rbend('b_centre05',0.04699977442503,0.0349189639*0.1671,0.0000000000,0.0000000000,-0.3300962629*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3300962629*scalek 0.0101400673*scalem -0.5218735605*scalen]);
source_six = marker('source_six','IdentityPass');
source_seven = marker('source_seven','IdentityPass');
b_centre03 = [b_centre03a source_six b_centre03b source_seven b_centre03c];
%b_centre03 = rbend('b_centre03',0.2813281018,0.0349189639,0.0000000000,0.0000000000,-0.3300962629*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3300962629*scalek 0.0101400673 -0.5218735605]);

b_centre04 = rbend('b_centre06',0.2814996751,0.0353946664,0.0000000000,0.0000000000,-0.3302155286*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3302155286*scalek 0.0236248098*scalem -0.2148826863*scalen]);
b_centre05 = rbend('b_centre07',0.2820380879,0.0367421671,0.0000000000,0.0000000000,-0.3312220213*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3312220213*scalek 0.0103909753*scalem 0.2969171603*scalen]);
b_right01 = rbend('b_right01',0.0694014448,0.0092683157,0.0000000000,0.0000000000,-0.3292611055*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3292611055*scalek -0.0291322494*scalem 0.3681905186*scalen]);
b_right02 = rbend('b_right02',0.0694650575,0.0090036557,0.0000000000,0.0000000000,-0.3961176951*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.3961176951*scalek -0.1539214712*scalem 0.9528854933*scalen]);
b_right03 = rbend('b_right03',0.0695141539,0.0037120061,0.0000000000,0.0000000000,-0.2701751814*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.2701751814*scalek 0.3742213022*scalem 0.7022676128*scalen]);
b_right04 = rbend('b_right04',0.0695280819,0.0007962279,0.0000000000,0.0000000000,-0.0288159660*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.0288159660*scalek -0.0571472318*scalem 0.2460706289*scalen]);
b_right05 = rbend('b_right05',0.0695312501,0.0001902235,0.0000000000,0.0000000000,-0.0028161106*scalek,'BndMPoleSymplectic4E2Pass',[0 0 0 0],[0 -0.0028161106*scalek -0.1077402629*scalem 0.7697020810*scalen]);


dipole_arc = [leftdrift_a bpm leftdrift_b b_left01 b_left02 b_left03 b_left04 ...
       b_left05 thinsext b_centre01 b_centre02 b_centre03 b_centre04 ...
       b_centre05 thinsext b_right01 b_right02 b_right03 b_right04 ...
       b_right05 rightdrift_a bpm rightdrift_b];

% To match split dipole values from numerical studies (SBENDS)
% tune of 13.29, 5.216 and 0 dispersion in straights.
qfa	=	quadrupole('QFA'	,3.550000e-001 + quadDL_2*2, 1.725375769247917,'StrMPoleSymplectic4Pass');
qda	=	quadrupole('QDA'	,1.800000e-001 + quadDL_2*2,-1.025712814328698,'StrMPoleSymplectic4Pass');
qfb	=	quadrupole('QFB'	,3.550000e-001 + quadDL_2*2, 1.508192835147978,'StrMPoleSymplectic4Pass');

% Sextupoles with built in correctors. Corrector settings given by kick
% angle in radians. ([1 1] chromaticity with zero dispersion)
sfa	=	sextcorr('SFA'	,2.000000e-001, 1.400000e+001,[0 0],'StrCorrMPoleSymplectic4Pass');
sda	=	sextcorr('SDA'	,2.000000e-001,-1.400000e+001,[0 0],'StrCorrMPoleSymplectic4Pass');
sdb	=	sextcorr('SDB'	,2.000000e-001,-7.158624455551593,[0 0],'StrCorrMPoleSymplectic4Pass');
sfb	=	sextcorr('SFB'	,2.000000e-001, 7.327438689781832,[0 0],'StrCorrMPoleSymplectic4Pass');

% 
id = marker('ID','Matrix66Pass');
L = 0;
Kx = 0; Ky = 0; Kxy = 0; Kyx = 0;
FAMLIST{id}.ElemData.M66 = [1   L   0   0   0   0;
                            Kx  1   Kxy 0   0   0;
                            0   0   1   L   0   0;
                            0   0   Ky  1   0   0;
                            Kyx 0   0   0   1   0;
                            0   0   0   0   0   1]; 

% id = corrector('ID',0,[0 0],'CorrectorPass');

% RF cavity and the corresponding straight used to position the cavity.
% 4.996540652069698e+008 old freq for 216m for 216.0004 its different. Also
% we are using ThinCavities therefore the drifts have to be set
% accordingly.
cav_single = rfcavity('RF' ,0.0,3.00e+006,ringrf,HarmNumber,'DriftPass'); 
cav        = rfcavity('RF' ,0.0,0.75e+006,ringrf,HarmNumber,'DriftPass');
% drifts around the rf cavities and space between them
d1ar1    =   drift('D1AR1'	,len(d1a)-len(cav_single)/2  ,'DriftPass'); % for just 1 cavity
drf      =	 drift('DRF'    ,0.45                        ,'DriftPass'); % space between cavities
d1ar4	 =	 drift('D1AR4'	,len(d1a)-len(cav)-len(drf)/2,'DriftPass'); % for 4 cavities
cav_pair = [cav drf cav];
dRF1 = drift('dRF1'	,len(d1)-2.55  ,'DriftPass');
dRF2 = drift('dRF2'	,2.55/3  ,'DriftPass');

% Kickers and the associated drifts to position them. (to be checked)
kick1	=	corrector('KICK'	,0.000000e+000,[0.000000e+000 0.0],'CorrectorPass');
kick2	=	corrector('KICK'	,0.000000e+000,[0.000000e+000 0.0],'CorrectorPass');
kick3	=	corrector('KICK'	,0.000000e+000,[0.000000e+000 0.0],'CorrectorPass');
kick4	=	corrector('KICK'	,0.000000e+000,[0.000000e+000 0.0],'CorrectorPass');
%fast feedback kicks
ffbh	=	corrector('FFBH'	,0.000000e+000,[0.000000e+000 0.0],'CorrectorPass');
ffbv    =   corrector('FFBV'    ,0.000000e+000,[0.000000e+000 0.0],'CorrectorPass');
% Drift spaces to replace D1A for the upstream kickers, ie kickers 1 and 3.
% d1ak2_up=	drift('D1AK2_UP'	,0.779 - len(d1b),'DriftPass');
d1ak2_up=	drift('D1AK2_UP'	,0.779 - len(d1b),'DriftPass');
d1ak1_up=	drift('D1AK1_UP'	,len(d1a) - len(d1ak2_up),'DriftPass');
% Drift spaces to replace D1A for the downstream kickers, ie kickers 2 and 4.
d1ak2_do=	drift('D1AK2_DO'	,1.073 - len(d1bb),'DriftPass');
d1ak1_do=	drift('D1AK1_DO'	,len(d1aa) - len(d1ak2_do),'DriftPass');


% Define the position of the bpm. bpm1d1 represents BPM number 1 in the D1
% straight and bpm5d4 represents BPM number 5 in straight d4. bpm7dk and
% bpm7dr repreents BPM number 7 in either the kicker stright or RF
% straight.
bpm1d1 = [ d1a bpm d1b ];
bpm1d1k = inline(['['  num2str(d1ak1_up) ' '  'kicker '  num2str(d1ak2_up) ' '  num2str(bpm) ' '  num2str(d1b) ' '  ']' ], 'kicker'); % Kicker
bpm1d1r1 = [ d1ar1 bpm d1b ]; % RF 1 cavity
%bpm1d1r4 = [ d1ar4 bpm d1b ]; % RF 4 cavity
bpm2d4 = [ d4a bpm d4b ];
bpm3d4 = [ d4aa bpm d4bb ];
bpm4d2 = [ d2a bpm d2b ];
bpm5d4 = [ bpm2d4 ];
bpm6d4 = [ bpm3d4 ];
bpm7d1 = [ d1bb bpm d1aa ];
bpm7d1k = inline(['['  num2str(d1bb) ' '  num2str(bpm) ' '  num2str(d1ak2_do) ' '  'kicker '  num2str(d1ak1_do) ' '  ']' ], 'kicker'); % Kicker
bpm7d1r1 = [ d1b bpm d1ar1 ];  % RF 1 cavity
%bpm7d1r4 = [ d1b bpm d1ar4 ];  % RF 4 cavity
bpm1d1RF = [ dRF1 bpm dRF2 cav dRF2 cav dRF2 ];

d1ffb = [];
bpm7d1ffb = [ d1b bpm d1ffb ]; %fast feedback kicker

% Arrange the elements onto the girders and use markers to define the
% sections for misalignment studies.
g1m1 = marker('g1m1','IdentityPass');
g1m2 = marker('g1m2','IdentityPass');
g2m1 = marker('g2m1','IdentityPass');
g2m2 = marker('g2m2','IdentityPass');
% girder1 = [ g1m1 sfa hcor sfa d2 qfa d3 sda vcor sda g1m2];
% girder2 = [ g2m1 sdb vcor sdb d5 qda d6 qfb d2 sfb hcor sfb bpm4d2 qfb d6 qda d5 sdb vcor sdb g2m2];
% girder3 = [ g1m1 sda vcor sda d3 qfa d2 sfa hcor sfa g1m2];
girder1 = [ g1m1 sfa d2 qfa d3 sda g1m2];
girder2 = [ g2m1 sdb d5 qda d6 qfb d2 sfb bpm4d2 qfb d6 qda d5 sdb g2m2];
girder3 = [ g1m1 sda d3 qfa d2 sfa g1m2];


% Arrange the girders into the different cell arrangements.
unit_cel = [ bpm1d1 girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1 ];
% Kickers in cells 1 and 14
celkick14 = [ bpm1d1k(kick1) girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1k(kick2) ];
celkick01 = [ bpm1d1k(kick3) girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1k(kick4) ];
% Shorten the straights in cells 6, 7 and 8 to put in the rf
% 4 RF cavities

celrf06_4 = [ bpm1d1RF girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1 ];
celrf07_4 = [ bpm1d1RF girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1 ];
%celrf06_4 = [ bpm1d1   girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1r4 ];
%celrf07_4 = [ bpm1d1r4 girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1r4 ];
%celrf08_4 = [ bpm1d1r4 girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1   ];

% Single RF cavity
celrf06_1 = [ bpm1d1   girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1r1 ];
celrf07_1 = [ bpm1d1r1 girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1   ];
%diagnostic straight with fast feedback kicker
celffb10_1 = [ bpm1d1 girder1 dipole_arc girder2 dipole_arc girder3 bpm7d1ffb ]; %includes fast feedback kicker

% Shift sector
shift1 = quadrupole('SHIFT1'	,0, 0,'QuadLinearPass');
shift2 = quadrupole('SHIFT2'	,0, 0,'QuadLinearPass');

% Definition of the types of rings
kickring    = [ ap celkick01 unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel celkick14];
% cavity1ring = [ ap celrf06_1 cav_single celrf07_1 unit_cel  unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel ];
% cavity4ring = [ ap celrf06_4 cav_pair   celrf07_4 cav_pair celrf08_4 unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel ];
cavity1ring = [ ap id celkick01 id unit_cel id unit_cel id unit_cel id unit_cel id celrf06_1 id cav_single id celrf07_1 id unit_cel id unit_cel id unit_cel id unit_cel id unit_cel id unit_cel id celkick14];
cavity4ring = [ ap id celkick01 id unit_cel id unit_cel id unit_cel id unit_cel id celrf06_4 id celrf07_4 id unit_cel id unit_cel id unit_cel id unit_cel id unit_cel id unit_cel id celkick14];

%cavity4ring = [ ap celkick01 unit_cel unit_cel unit_cel unit_cel celrf06_4 cav_pair   celrf07_4 cav_pair celrf08_4 unit_cel unit_cel unit_cel unit_cel unit_cel celkick14];

% Ring starting with the RF
fullring_startwithRF = [ ap cav_single celrf07_1 unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel celkick14 celkick01 unit_cel unit_cel unit_cel unit_cel celrf06_1 ];
% Ring with no RF and no Kickers
ring        = [ ap unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel ];
% Ring starting in straight 14 rather than straight 1, outside of the kick orbit.
fullring    = [ ap celkick14 celkick01 unit_cel unit_cel unit_cel unit_cel celrf06_1 cav_single celrf07_1 unit_cel unit_cel unit_cel unit_cel unit_cel unit_cel ];
% fast feedback kicker included:
ffbring     = [ ap celkick01 unit_cel unit_cel unit_cel unit_cel celrf06_1 cav_single celrf07_1 unit_cel unit_cel celffb10_1 unit_cel unit_cel unit_cel celkick14];

% Choose which lattice to load else load "fullring" as the default.
if nargin > 0
    fprintf('Using lattice : %s \n', varargin{1});
    eval(['buildlat(' varargin{1} ');']);
else
    % Default lattice to load
    fprintf('Using default lattice : cavity4ring\n');
    buildlat(cavity4ring);
end

% Make the variables THERING and GLOBVAL available to the caller's
% workspace.
evalin('caller','global THERING GLOBVAL');
disp('** Done **');

% New AT 1.3 does not require FAMLIST and is fazing out GLOBVAL
clear global FAMLIST

setenergymodel(3);

% Internal function used to return the length of a defined element.
function res = len(id)
global FAMLIST
res = FAMLIST{id}.ElemData.Length;