function injection
%ALBA-25 example lattice definition file
% Created 11/21/99
%

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'a25_injection';
FAMLIST = cell(0);

disp('   Loading ALBA lattice in a25_injection. Version 0.9, including injection elements');

AP = aperture('AP', [-0.036, 0.036, -0.01, 0.01],'AperturePass');


% Cavity
L0 =  268.800296;	% design length  [m]
C0 =   299792458; 	% speed of light [m/s]
HarmNumber = 448;
CAV	= rfcavity('CAV1' , 0 , 3.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');


L_ID     =    drift('L_ID', 3.985,'DriftPass');
D11      =    drift('D11' ,0.17,'DriftPass');
D12      =    drift('D12', 0.150,'DriftPass');
D13      =    drift('D13' , 0.150,'DriftPass');
D14      =    drift('D14', 0.375,'DriftPass');
D15      =    drift('D15',0.260 ,'DriftPass');
D21      =    drift('D21',0.26 ,'DriftPass');
D22      =    drift('D22',0.15 ,'DriftPass');
D23      =    drift('D23',0.375 ,'DriftPass');
D24      =    drift('D24',0.15 ,'DriftPass');
D25      =    drift('D25',0.165  ,'DriftPass');
D26      =    drift('D26',0.470 ,'DriftPass');
D28      =    drift('D28',0.26 ,'DriftPass');
D31      =    drift('D31',0.260 ,'DriftPass');
D32      =    drift('D32',0.37  ,'DriftPass');
D33      =    drift('D33',0.175 ,'DriftPass');
D34      =    drift('D34',0.15 ,'DriftPass');
D41      =    drift('D41',0.26 ,'DriftPass');
D42      =    drift('D42',0.54 ,'DriftPass');
D43      =    drift('D43',0.165 ,'DriftPass');
S_ID     =    drift('S_ID',1.30 ,'DriftPass');
M_ID     =    drift('M_ID', 2.096767,'DriftPass');
DSX      =    drift('DSX', 0.075000,'DriftPass');
DSXA     =    drift('DSXA', 0.110000,'DriftPass');

LKICK = 0.7;
LI1= 0.65;
LI2 = 0.72;
LI3= 3.985 - LI1- LI2 -2*LKICK;
L_IA     = drift('L_IA', LI1+LKICK/2,'DriftPass');
L_IB     = drift('L_IB', LI2+LKICK,'DriftPass');
L_IC     = drift('L_IC', LI3+LKICK/2  ,'DriftPass');

QD1 =    quadrupole('QD1',  0.23, -1.773389,'StrMPoleSymplectic4Pass');
QD2 =    quadrupole('QD2',  0.29, -1.877886,'StrMPoleSymplectic4Pass');
QD3 =    quadrupole('QD3',  0.29, -1.849889,'StrMPoleSymplectic4Pass');

QF1 =    quadrupole('QF1',  0.29,  1.511189,'StrMPoleSymplectic4Pass');
QF2 =    quadrupole('QF2',  0.29,  1.901567,'StrMPoleSymplectic4Pass');
QF3 =    quadrupole('QF3',  0.29,  1.54970, 'StrMPoleSymplectic4Pass');
QF4 =    quadrupole('QF4',  0.23,  1.492441,'StrMPoleSymplectic4Pass');
QF5 =    quadrupole('QF5',  0.31,  1.794343,'StrMPoleSymplectic4Pass');
QF6 =    quadrupole('QF6',  0.53,  2.078492,'StrMPoleSymplectic4Pass');
QF7 =    quadrupole('QF7',  0.53,  2.028150,'StrMPoleSymplectic4Pass');
QF8 =    quadrupole('QF8',  0.31,  2.008579,'StrMPoleSymplectic4Pass');

% Fitted values to produce normalized chromaticities 0,0

md1=-3.79202/0.15;
md2=-4.12417/0.15;
md3=-4.40757/0.15;
md4=-5.905520/0.22;
md5=-4.4666/0.15;
mf1=2.25116/0.15;
mf2=5.9091/0.22;
mf3=5.937840/0.22;
mf4=3.05743/0.15;
CS=1;
SD1    = sextupole('SD1' ,0.15/2, CS*md1 ,'StrMPoleSymplectic4Pass');
SD2    = sextupole('SD2' ,0.15/2, CS*md2 ,'StrMPoleSymplectic4Pass');
SD3    = sextupole('SD3' ,0.15/2, CS*md3 ,'StrMPoleSymplectic4Pass');
SD4    = sextupole('SD4' ,0.22/2, CS*md4 ,'StrMPoleSymplectic4Pass');
SD5    = sextupole('SD5' ,0.15/2, CS*md5 ,'StrMPoleSymplectic4Pass');
SF1    = sextupole('SF1' ,0.15/2, CS*mf1 ,'StrMPoleSymplectic4Pass');
SF2    = sextupole('SF2' ,0.22/2, CS*mf2 ,'StrMPoleSymplectic4Pass');
SF3    = sextupole('SF3' ,0.22/2, CS*mf3 ,'StrMPoleSymplectic4Pass');
SF4    = sextupole('SF4' ,0.15/2, CS*mf4 ,'StrMPoleSymplectic4Pass');

bangle = 2*pi/32;

BEND = sbend ('BEND', 1.383684, bangle, bangle/2, bangle/2,...
                 -0.565618, 'BndMPoleSymplectic4Pass');

cor = corrector('COR', 0, [0 0],'CorrectorPass');
BPM  =  marker('BPM','IdentityPass');
sm = marker('SM' ,'IdentityPass');
ip = marker ('ip','IdentityPass');
ik    = corrector('IK' ,0, [0 0],'CorrectorPass');

% Begin Lattice
hcm = [cor];
cSD1 = [SD1 hcm SD1];
cSD2 = [SD2  SD2];
cSD3 = [SD3  SD3];
cSD4 = [SD4 hcm SD4];
cSD5 = [SD5  SD5];
cSF1 = [SF1 hcm SF1];
cSF2 = [SF2 hcm SF2];
cSF3 = [SF3 hcm SF3];
cSF4 = [SF4 hcm SF4];



BLOCK1  = [L_ID BPM QD1 D11 QF1 D12 cSF1 D13 QF2 D14 BPM cSD1 D15];
BLOCK1ia  = [ip L_IA ik L_IB ik  L_IC BPM QD1 D11 QF1 D12 cSF1 D13 QF2 D14 BPM cSD1 D15];
BLOCK1ib  = [L_IA ik L_IB ik  L_IC BPM QD1 D11 QF1 D12 cSF1 D13 QF2 D14 BPM cSD1 D15];
BLOCK2  = [D21 cSD2 D22 QF3 D23 QF4 D24 cSF2 BPM D25 QF5 D26 cSD3 D28];
BLOCK31 = [D31 cSD4 BPM D32 QF6 D33 cSF3 D34 QD2 BPM M_ID];
BLOCK32 = [M_ID BPM QD3 D34 cSF3 D33 QF7 BPM D32 cSD4 D31];
BLOCK4  = [D41 cSD5 D42 QF8 D43 BPM cSF4 S_ID];


SECTOR1 =  [ ...
    sm BLOCK1ia BEND BLOCK2 BEND ...
    BLOCK31 BLOCK32 BEND, BLOCK4 reverse(BLOCK4)  BEND...
    reverse(BLOCK32) BLOCK32 BEND BLOCK4 reverse(BLOCK4) BEND ...
    reverse(BLOCK32) reverse(BLOCK31) BEND reverse(BLOCK2) BEND ...
    reverse(BLOCK1) sm];

SECTOR2 =  [ ...
    sm BLOCK1 BEND BLOCK2 BEND ...
    BLOCK31 BLOCK32 BEND, BLOCK4 reverse(BLOCK4)  BEND...
    reverse(BLOCK32) BLOCK32 BEND BLOCK4 reverse(BLOCK4) BEND ...
    reverse(BLOCK32) reverse(BLOCK31) BEND reverse(BLOCK2) BEND ...
    reverse(BLOCK1) sm];

SECTOR3 =  [ ...
    sm BLOCK1 BEND BLOCK2 BEND ...
    BLOCK31 BLOCK32 BEND, BLOCK4 reverse(BLOCK4)  BEND...
    reverse(BLOCK32) BLOCK32 BEND BLOCK4 reverse(BLOCK4) BEND ...
    reverse(BLOCK32) reverse(BLOCK31) BEND reverse(BLOCK2) BEND ...
    reverse(BLOCK1) sm];

SECTOR4 =  [ ...
    sm BLOCK1 BEND BLOCK2 BEND ...
    BLOCK31 BLOCK32 BEND, BLOCK4 reverse(BLOCK4)  BEND...
    reverse(BLOCK32) BLOCK32 BEND BLOCK4 reverse(BLOCK4) BEND ...
    reverse(BLOCK32) reverse(BLOCK31) BEND reverse(BLOCK2) BEND ...
    reverse(BLOCK1ib) sm];

MACHINE = [  SECTOR4 SECTOR1 SECTOR2 CAV SECTOR3 ];

buildlat(MACHINE);
disp('Hello')
% Compute total length and RF frequency
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   Model ring circumference is %.6f meters\n', L0_tot)
fprintf('   Model RF frequency is %.6f MHz\n', HarmNumber*C0/L0_tot/1e6)


clear global FAMLIST
%clear global GLOBVAL when GWig... has been changed.

%evalin('caller','global THERING FAMLIST GLOBVAL');








