% SWLSatNSRRCstepFun.m
% Purpose: 
% 1) Use SWLS of NSRRC to test the functions of TPSA.
% 2) Show you the usage of TPSA package.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 13-Jun-2003
% Updated Date: 01-Mar-2004
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
clear all
global OSIP

% Input arguments of a dynamics system
%display('CanonicalDimensions = 2;');
disp('CanonicalDimensions = 2;');
CanonicalDimensions = 2;
%display('NumberOfCanonicalVariables = 2*CanonicalDimensions;');
disp('NumberOfCanonicalVariables = 2*CanonicalDimensions;');
NumberOfCanonicalVariables = 2*CanonicalDimensions;
%display('NumberOfParameters = 1;');
disp('NumberOfParameters = 1;');
NumberOfParameters = 1;
%display('NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;');
disp('NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;');
NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;
%display('MaximumOrder = 6;');
disp('MaximumOrder = 4;');
MaximumOrder = 4;

% Prepare OSIP, the Nerves of TPSA
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

U = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables);
% U(1) = X = VariableOfTPS(TPS,1);
% U(2) = PX = VariableOfTPS(TPS,2);
% U(3) = Y = VariableOfTPS(TPS,3);
% U(4) = PY = VariableOfTPS(TPS,4);
% U(5) = Delta = VariableOfTPS(TPS,5);

% For the 1.5 GeV TLS Storagr Ring of NSRRC
% From Lorentz force equation, mechanic momentum p = Q*Br > 0.
% p/r = QB, 1/(Br) = Q/p
% Br (T-M) for NSRRC's 1.5 GeV electron Ring.
% Q = -e
Q = -1;
Br = -5.00346;
hs = 0; % (1/r = 0)

% Get the data of SWLS in the 1.5 GeV TLS storage ring of NSRRC
CurrentOfMainPS = 260; DataOfID = IDofNSRRC(TPS,'SWLS',CurrentOfMainPS);
Si = 1.5425; % The location of SWLS in TLS storage ring.
%Si = 0;
Sf = Si+DataOfID.L;
% Define the launching condition of reference orbit Uc(1:5) (double-array)
%Uc = zeros(1,OSIP.NumberOfVariables);
Uc(1) = TPS;
Uc(2) = TPS;
Uc(3) = TPS;
Uc(4) = TPS;
Uc(5) = U(5);
U0 = Uc;
%% At s = Si, referred to the reference orbit
%% (Xc,X'c,Yc,Y'c,Delta)_Si = (0,0,0,0,0)_Si,
%% Vector potential is required to be continuous at Si,
%% and each interface of pole-to-pole.
s = Si;
sShift = Si+0.5*DataOfID.L;
ss = s-sShift;
Cuts = 5;
k = 0;
j = Cuts;
[Em,Ep] = StepFuncPoleCheck(TPS,DataOfID,Cuts,k,j);
if Em == Ep
    [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
else
    [Axm,Aym,Asm,Bxm,Bym,Bsm] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
    [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Ep*DataOfID.Amplitude);
    [dAx,dAy,dAs] = StepFuncShift(TPS,Axm,Aym,Asm,Ax,Ay,As);
    Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
end
i = 1; Sc(i) = s; Xc(i) = Uc(1); Yc(i) = Uc(3);
t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
dAxSc(i) = dAx;

NumberOfFullPole = DataOfID.NumberOfPoles-2*DataOfID.M;
Ds = DataOfID.PoleWidth/Cuts;
HalfDs = 0.5*Ds;
for k=1:DataOfID.NumberOfPoles
    deltaS = (k-1)*DataOfID.PoleWidth;
    for j=1:Cuts
         s = Si+deltaS+(j-1)*Ds;
         ss = s-sShift;
         % Dift
         [H,dUds] = Hamiltonian(TPS,Br,hs,Ax,Ay,As,Uc);
         Uc(1) = Uc(1)+dUds(1)*HalfDs;
         Uc(3) = Uc(3)+dUds(3)*HalfDs;
         sm = s+HalfDs;
         ss = sm-sShift;
         [Em,Ep] = StepFuncPoleCheck(TPS,DataOfID,Cuts,k,j);
         [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
         % Kick
         [H,dUds] = Hamiltonian(TPS,Br,hs,Ax,Ay,As,Uc);
         Uc(2) = Uc(2)+dUds(2)*HalfDs;
         Uc(4) = Uc(4)+dUds(4)*HalfDs;
         [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
         i = i+1; Sc(i) = sm; Xc(i) = Uc(1); Yc(i) = Uc(3);
         t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
         t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
         dAxSc(i) = dAx;
         [Hs,dU0ds] = Hamiltonian(TPS,Br,hs,Ax,Ay,As,Uc);
         [H,dUds] = Hamiltonian(TPS,Br,hs,Ax,Ay,As,Uc);
         Uc(2) = Uc(2)+dUds(2)*HalfDs;
         Uc(4) = Uc(4)+dUds(4)*HalfDs;
         [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
         % Drift
         [H,dUds] = Hamiltonian(TPS,Br,hs,Ax,Ay,As,Uc);
         Uc(1) = Uc(1)+dUds(1)*HalfDs;
         Uc(3) = Uc(3)+dUds(3)*HalfDs;
         if j ~= Cuts
             s = s+Ds;
             ss = s-sShift;
             [Em,Ep] = StepFuncPoleCheck(TPS,DataOfID,Cuts,k,j);
             if Em ~= Ep
                 disp('ERROR');
             else
                 [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
                 Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
                 i = i+1; Sc(i) = s; Xc(i) = Uc(1); Yc(i) = Uc(3);
                 t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
                 t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
                 dAxSc(i) = dAx;
             end
             
    
         end

         H0 = HomogeneousTPS(Hs,0); % this part can be ignored without loss 
         H1 = HomogeneousTPS(Hs,1); % Lorentz force for calculation of the reference orbit
         H2 = HomogeneousTPS(Hs,2); % Linear tranfer matrix
         Hs = Hs-H0-H1;
         H = -Ds*Hs;
         h = -Ds*H2;
         f = -Ds*(Hs-H2);

        if (k == 1) & (j == 1)
            sl = TPS2SymplecticLie(H);
        else
            sl = SymplecticLieIntegrator(sl,H);
        end
    end
    % j == Cuts
    s = Si+k*DataOfID.PoleWidth;
    ss = s-sShift;
    [Em,Ep] = StepFuncPoleCheck(TPS,DataOfID,Cuts,k,j);
    if Em == Ep
         [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
    else
         [Axm,Aym,Asm,Bxm,Bym,Bsm] = StepFuncVP(TPS,DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,DataOfID,ss,Uc,Ep*DataOfID.Amplitude);
         [ddAx,ddAy,ddAs] = StepFuncShift(TPS,Axm,Aym,Asm,Ax,Ay,As);
         dAx = dAx+ddAx; dAy = dAy+ddAy; dAs = dAs+ddAs;
    end
    if k == DataOfID.M
         dAx = 0; dAy = 0; dAs = 0;
    end
    if k == DataOfID.NumberOfPoles
         dAx = 0; dAy = 0; dAs = 0;
    end
    Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
    i = i+1; Sc(i) = s; Xc(i) = Uc(1); Yc(i) = Uc(3);
    t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
    t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
    dAxSc(i) = dAx;
end
dl = SymplecticLie2DepritLie(TPS,sl);
disp('dl.R'), dl.R
disp('dl.f'), dl.f

% Calculate the effective focusing strength of SWLS field roll-off in x-direction.
% cosh(sqrt(k)*L) = dl.R(1,1) = dl.R(2,2)
% sinh(sqrt(k)*L)/sqrt(k) = dl.R(1,2); sinh(sqrt(k)*L)*sqrt(k) = dl.R(2,1)
R = dl.R;
L = DataOfID.L;
xKeff1 = acosh(R(1,1))/L;
xKeff1 = xKeff1^2
xKeff2 = acosh(R(2,2))/L;
xKeff2 = xKeff2^2
xKeff3 = asinh(sqrt(R(1,2)*R(2,1)))/L;
xKeff3 = xKeff3^2
% xKeff = 0.0284
yKeff1 = acos(R(3,3))/L;
yKeff1 = yKeff1^2
yKeff2 = acos(R(4,4))/L;
yKeff2 = yKeff2^2
yKeff3 = asin(sqrt(-R(3,4)*R(4,3)))/L;
yKeff3 = yKeff3^2
% yKeff = 0.5690

% <sin(k*s)*sin(k*s)> = <cos(k*s)*cos(k*s)> = 0.5
% DataOfID.Amplitude = DataOfID.PeakField/DataOfID.ks
% Effective K = 0.3529
display('Effective K value')
EffectiveK = 0.5*DataOfID.PeakField^2/(Br^2)*(1+2*1/4)/3

%set(gca,'FontName','Times');
%set(gca,'FontSize',14); % Default 12
%xlabel('S (Meter)');

%ylabel('Ax');
plot(Sc,AxSc,'b-x');
display('Pause > Please press Enter for continue') 
pause
plot(Sc,dAxSc,'k-x');
display('Pause > Please press Enter for continue') 
pause
%ylabel('Xc');
plot(Sc,Xc,'k-*');
display('Pause > Please press Enter for continue') 
pause
%ylabel('By');
plot(Sc,BySc,'r-o');