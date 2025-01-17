function solamor2
%solamor2 - soleil lattice w/o ID 
% Lattice definition file
% Lattice for SOLEIL: perfect lattice no magnetic errors 
% Compiled by Laurent Nadolski and Amor Nadji
% 09/01/02, ALS
% 28/12/05, Update with new AT 1.3

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 2.75e9; % Ring energy
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);

disp(['** Loading SOLEIL magnet lattice ', mfilename]);

L0 = 354.0967211999983;      % design length [m]
C0 = 2.99792458e8;           % speed of light [m/s]
HarmNumber = 416;

%% Cavity
%              NAME   L     U[V]       f[Hz]          h        method       
CAV = rfcavity('RF' , 0 , 4.0e+6 , HarmNumber*C0/L0, ...
               HarmNumber ,'CavityPass');   

%% Marker and apertures
   SECT1  =  marker('SECT1', 'IdentityPass');
   SECT2  =  marker('SECT2', 'IdentityPass');
   SECT3  =  marker('SECT3', 'IdentityPass');
   SECT4  =  marker('SECT4', 'IdentityPass');
   DEBUT  =  marker('DEBUT', 'IdentityPass');
   FIN    =  marker('FIN', 'IdentityPass');
   
   INJ = aperture('INJ',[-0.035 0.035 -0.0125 0.0125],'AperturePass');
   INJ = aperture('INJ',[-0.035 0.035 -0.125 0.125],'AperturePass');

%% Injection section
PtINJ = marker('PtINJ', 'IdentityPass');
K3 = marker('K3', 'IdentityPass');
K4 = marker('K4', 'IdentityPass');
 
%% BPM   
   BPM    =  marker('BPM', 'IdentityPass');

%% DRIFT SPACES
   SD13= drift('SD13', 3.48255, 'DriftPass');
   SD1 = drift('SD1',  6.00000, 'DriftPass');
   SD1a = drift('SD1a',  1.4125, 'DriftPass');
   SD1b = drift('SD1b',  0.7575, 'DriftPass');
   SD1c = drift('SD1c',  3.002, 'DriftPass');
   SD1d = drift('SD1d',  0.828, 'DriftPass');
   SD2 = drift('SD2',  0.39000, 'DriftPass');
   SD3 = drift('SD3',  0.20000, 'DriftPass');
   SD4 = drift('SD4',  0.39000, 'DriftPass');
   SD14= drift('SD14', 0.59000, 'DriftPass');
   SD5 = drift('SD5',  0.20000, 'DriftPass');
   SD6 = drift('SD6',  0.79000, 'DriftPass');
   SD7 = drift('SD7',  0.44000, 'DriftPass');
   SD8 = drift('SD8',  0.20000, 'DriftPass');
   SD9 = drift('SD9',  0.47634, 'DriftPass');
   SD10= drift('SD10', 0.47000, 'DriftPass');
   SD12= drift('SD12', 0.47000, 'DriftPass');
   SDAC= drift('SDAC', 1.90468, 'DriftPass');
   
%% QUADRUPOLES 
Q1   =  quadrupole('Q1' , 0.32,  -1.18610 , 'StrMPoleSymplectic4RadPass');
Q2   =  quadrupole('Q2' , 0.46,   1.71132 , 'StrMPoleSymplectic4RadPass');
Q3   =  quadrupole('Q3' , 0.32,  -0.71729 , 'StrMPoleSymplectic4RadPass');
Q4   =  quadrupole('Q4' , 0.32,  -1.39423 , 'StrMPoleSymplectic4RadPass');
Q5   =  quadrupole('Q5' , 0.32,   1.89119 , 'StrMPoleSymplectic4RadPass');
Q6   =  quadrupole('Q6' , 0.32,  -1.11831 , 'StrMPoleSymplectic4RadPass');
Q7   =  quadrupole('Q7' , 0.46,   2.21705 , 'StrMPoleSymplectic4RadPass');
Q8   =  quadrupole('Q8' , 0.32,  -1.70205 , 'StrMPoleSymplectic4RadPass');
Q9   =  quadrupole('Q9' , 0.32,  -1.68903 , 'StrMPoleSymplectic4RadPass');
Q10  =  quadrupole('Q10', 0.32,   1.96186 , 'StrMPoleSymplectic4RadPass');


%% SEXTUPOLES for xix=0.4 and xi_y=1.4
F = 1e8;
Finv = 1/F;

S1  =  sextupole('S1' , Finv,  1.71919*F, 'StrMPoleSymplectic4RadPass');
S2  =  sextupole('S2' , Finv, -4.10456*F, 'StrMPoleSymplectic4RadPass');
S3  =  sextupole('S3' , Finv, -2.16938*F, 'StrMPoleSymplectic4RadPass');
S4  =  sextupole('S4' , Finv,  3.60465*F, 'StrMPoleSymplectic4RadPass');
S5  =  sextupole('S5' , Finv, -3.69821*F, 'StrMPoleSymplectic4RadPass');
S6  =  sextupole('S6' , Finv,  3.24667*F, 'StrMPoleSymplectic4RadPass');
S7  =  sextupole('S7' , Finv, -5.00352*F, 'StrMPoleSymplectic4RadPass');
S8  =  sextupole('S8' , Finv,  4.19372*F, 'StrMPoleSymplectic4RadPass');
S9  =  sextupole('S9' , Finv, -2.97623*F, 'StrMPoleSymplectic4RadPass');
S10 =  sextupole('S10', Finv,  1.86108*F, 'StrMPoleSymplectic4RadPass');


%% Slow feedback correctors
% HCOR =  corrector('HCOR',0.0,[0 0],'CorrectorPass');
% VCOR =  corrector('VCOR',0.0,[0 0],'CorrectorPass');
% COR = [HCOR VCOR];
COR =  corrector('COR',0.0,[0 0],'CorrectorPass');

%% Fast feedback correctors
% FHCOR =  corrector('FHCOR',0.0,[0 0],'CorrectorPass');
% FVCOR =  corrector('FVCOR',0.0,[0 0],'CorrectorPass');
% FCOR = [FHCOR,FVCOR];
FCOR =  corrector('FCOR',0.0,[0 0],'CorrectorPass');


SX1   = [S1  COR];
SX2   = [S2  COR];
SX3   = [S3  COR];
SX4   = [S4  COR];
SX5   = [S5  COR];
SX6   = [S6  COR];
SX7   = [S7  COR];
SX8   = [S8  COR];
SX9   = [S9  COR];
SX10  = [S10 COR];

%% DIPOLES 
BEND  =  rbend('BEND'  , 1.05243,  ...
            0.19635, 0.098175, 0.098175, 0.0,'BndMPoleSymplectic4RadPass');
      
%% Lattice
% Superperiods  

SUP1  = [  ... 
 SD1a   PtINJ   SD1b    K3    SD1c   K4     SD1d         ...
 BPM    FCOR    Q1     SD2    SX1   SD3     Q2  ...
 BPM     SD14   Q3      SD5    SX2    SD6   BEND    SD7     Q4  ...
 SD8     SX3    BPM     SD9    Q5     SD12  SX4     BPM  ...   
 SD10    Q5     SD9     BPM    SX3    SD8   Q4      SD7     BEND    SD7  ...
 Q6      SD5    SX5     SD4    BPM    Q7    SD3     SX6          ...
 SD2     Q8     FCOR    BPM    SD13   SD13  BPM     FCOR    ...  
 Q8      SD2    SX8     SD3    Q7     BPM   SD4     SX7          ...
 SD5     Q6     SD7     BEND   SD7    Q9    SD8     SX9     BPM  ...
 SD9     Q10    SD8     SX10   FCOR   BPM   SDAC    SDAC ...  
 BPM     FCOR   SX10    SD8    Q10    SD9   BPM     SX9  ...
 SD8     Q9     SD7     BEND   SD7    Q6    SD5     SX7       ...
 SD4     BPM    Q7      SD3    SX8    SD2   Q8      FCOR    BPM     ...
 SD13    SD13   BPM     FCOR   Q8     SD2   SX8      ...
 SD3     Q7     BPM     SD4    SX7    SD5   Q6      SD7     BEND...
 SD7     Q9     SD8     SX9    BPM    SD9   Q10     SD8     SX10 ...
 FCOR    BPM    SDAC    SDAC   BPM    FCOR    SX10    ...
 SD8     Q10    SD9     BPM    SX9    SD8   Q9      SD7  ...
 BEND    SD7    Q6      SD5    SX7    SD4   BPM     Q7      SD3  ...
 SX8     SD2    Q8      FCOR   BPM    SD13  SD13    BPM ...
 FCOR     Q8     SD2     SX6    SD3    Q7    BPM     SD4  ...   
 SX5     SD5    Q6      SD7    BEND   SD7   Q4      SD8     SX3  ...
 BPM     SD9    Q5      SD10   BPM    SX4   SD12    Q5  ...
 SD9     BPM    SX3     SD8    Q4     SD7   BEND    SD6     SX2         ...
 SD5     Q3     SD14    BPM    Q2     SD3   SX1     SD2     Q1  ...
 FCOR    BPM     SD1  ];

SUP2  = [  ... 
SD1     BPM    FCOR    Q1     SD2    SX1   SD3     Q2  ...
 BPM     SD14   Q3      SD5    SX2    SD6   BEND    SD7     Q4  ...
 SD8     SX3    BPM     SD9    Q5     SD12  SX4     BPM  ...   
 SD10    Q5     SD9     BPM    SX3    SD8   Q4      SD7     BEND    SD7  ...
 Q6      SD5    SX5     SD4    BPM    Q7    SD3     SX6          ...
 SD2     Q8     FCOR    BPM    SD13   SD13  BPM     FCOR    ...  
 Q8      SD2    SX8     SD3    Q7     BPM   SD4     SX7          ...
 SD5     Q6     SD7     BEND   SD7    Q9    SD8     SX9     BPM  ...
 SD9     Q10    SD8     SX10   FCOR   BPM   SDAC    SDAC ...  
 BPM     FCOR   SX10    SD8    Q10    SD9   BPM     SX9  ...
 SD8     Q9     SD7     BEND   SD7    Q6    SD5     SX7       ...
 SD4     BPM    Q7      SD3    SX8    SD2   Q8      FCOR    BPM     ...
 SD13    SD13   BPM     FCOR   Q8     SD2   SX8      ...
 SD3     Q7     BPM     SD4    SX7    SD5   Q6      SD7     BEND...
 SD7     Q9     SD8     SX9    BPM    SD9   Q10     SD8     SX10 ...
 FCOR    BPM    SDAC    SDAC   BPM    FCOR    SX10    ...
 SD8     Q10    SD9     BPM    SX9    SD8   Q9      SD7  ...
 BEND    SD7    Q6      SD5    SX7    SD4   BPM     Q7      SD3  ...
 SX8     SD2    Q8      FCOR   BPM    SD13  SD13    BPM ...
 FCOR     Q8     SD2     SX6    SD3    Q7    BPM     SD4  ...   
 SX5     SD5    Q6      SD7    BEND   SD7   Q4      SD8     SX3  ...
 BPM     SD9    Q5      SD10   BPM    SX4   SD12    Q5  ...
 SD9     BPM    SX3     SD8    Q4     SD7   BEND    SD6     SX2         ...
 SD5     Q3     SD14    BPM    Q2     SD3   SX1     SD2     Q1  ...
 FCOR    BPM     SD1  ];

SUP3  = [  ... 
SD1     BPM    FCOR    Q1     SD2    SX1   SD3     Q2  ...
 BPM     SD14   Q3      SD5    SX2    SD6   BEND    SD7     Q4  ...
 SD8     SX3    BPM     SD9    Q5     SD12  SX4     BPM  ...   
 SD10    Q5     SD9     BPM    SX3    SD8   Q4      SD7     BEND    SD7  ...
 Q6      SD5    SX5     SD4    BPM    Q7    SD3     SX6          ...
 SD2     Q8     FCOR    BPM    SD13   SD13  BPM     FCOR    ...  
 Q8      SD2    SX8     SD3    Q7     BPM   SD4     SX7          ...
 SD5     Q6     SD7     BEND   SD7    Q9    SD8     SX9     BPM  ...
 SD9     Q10    SD8     SX10   FCOR   BPM   SDAC    SDAC ...  
 BPM     FCOR   SX10    SD8    Q10    SD9   BPM     SX9  ...
 SD8     Q9     SD7     BEND   SD7    Q6    SD5     SX7       ...
 SD4     BPM    Q7      SD3    SX8    SD2   Q8      FCOR    BPM     ...
 SD13    SD13   BPM     FCOR   Q8     SD2   SX8      ...
 SD3     Q7     BPM     SD4    SX7    SD5   Q6      SD7     BEND...
 SD7     Q9     SD8     SX9    BPM    SD9   Q10     SD8     SX10 ...
 FCOR    BPM    SDAC    SDAC   BPM    FCOR    SX10    ...
 SD8     Q10    SD9     BPM    SX9    SD8   Q9      SD7  ...
 BEND    SD7    Q6      SD5    SX7    SD4   BPM     Q7      SD3  ...
 SX8     SD2    Q8      FCOR   BPM    SD13  SD13    BPM ...
 FCOR     Q8     SD2     SX6    SD3    Q7    BPM     SD4  ...   
 SX5     SD5    Q6      SD7    BEND   SD7   Q4      SD8     SX3  ...
 BPM     SD9    Q5      SD10   BPM    SX4   SD12    Q5  ...
 SD9     BPM    SX3     SD8    Q4     SD7   BEND    SD6     SX2         ...
 SD5     Q3     SD14    BPM    Q2     SD3   SX1     SD2     Q1  ...
 FCOR    BPM     SD1  ];

SUP4  = [  ... 
SD1     BPM    FCOR    Q1     SD2    SX1   SD3     Q2  ...
 BPM     SD14   Q3      SD5    SX2    SD6   BEND    SD7     Q4  ...
 SD8     SX3    BPM     SD9    Q5     SD12  SX4     BPM  ...   
 SD10    Q5     SD9     BPM    SX3    SD8   Q4      SD7     BEND    SD7  ...
 Q6      SD5    SX5     SD4    BPM    Q7    SD3     SX6          ...
 SD2     Q8     FCOR    BPM    SD13   SD13  BPM     FCOR    ...  
 Q8      SD2    SX8     SD3    Q7     BPM   SD4     SX7          ...
 SD5     Q6     SD7     BEND   SD7    Q9    SD8     SX9     BPM  ...
 SD9     Q10    SD8     SX10   FCOR   BPM   SDAC    SDAC ...  
 BPM     FCOR   SX10    SD8    Q10    SD9   BPM     SX9  ...
 SD8     Q9     SD7     BEND   SD7    Q6    SD5     SX7       ...
 SD4     BPM    Q7      SD3    SX8    SD2   Q8      FCOR    BPM     ...
 SD13    SD13   BPM     FCOR   Q8     SD2   SX8      ...
 SD3     Q7     BPM     SD4    SX7    SD5   Q6      SD7     BEND...
 SD7     Q9     SD8     SX9    BPM    SD9   Q10     SD8     SX10 ...
 FCOR    BPM    SDAC    SDAC   BPM    FCOR    SX10    ...
 SD8     Q10    SD9     BPM    SX9    SD8   Q9      SD7  ...
 BEND    SD7    Q6      SD5    SX7    SD4   BPM     Q7      SD3  ...
 SX8     SD2    Q8      FCOR   BPM    SD13  SD13    BPM ...
 FCOR     Q8     SD2     SX6    SD3    Q7    BPM     SD4  ...   
 SX5     SD5    Q6      SD7    BEND   SD7   Q4      SD8     SX3  ...
 BPM     SD9    Q5      SD10   BPM    SX4   SD12    Q5  ...
 SD9     BPM    SX3     SD8    Q4     SD7   BEND    SD6     SX2         ...
 SD5     Q3     SD14    BPM    Q2     SD3   SX1     SD2     Q1  ...
 FCOR   BPM     SD1  ];

 
ELIST = [DEBUT INJ SECT1 SUP1 SECT2 SUP2 SECT3 SUP3 SECT4 SUP4 CAV FIN];
%ELIST = [DEBUT INJ SECT1 SUP1 SECT2 SUP2 SECT3 SUP3 SECT4 SUP4 FIN];

buildlat(ELIST);

% Set all magnets to same energy
THERING = setcellstruct(THERING,'Energy',1:length(THERING),GLOBVAL.E0); 

evalin('caller','global THERING FAMLIST GLOBVAL');

atsummary;

if nargout
    varargout{1} = THERING;
end