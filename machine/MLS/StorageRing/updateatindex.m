function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded


% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);


AO = getao;


% BPM
try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end

try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    AO.QF.AT.ATType = 'QUAD';
    AO.QF.AT.ATIndex = buildatindex(AO.QF.FamilyName, Indices.QF);
    AO.QF.Position = findspos(THERING, AO.QF.AT.ATIndex(:,1))';

    AO.QD.AT.ATType = 'QUAD';
    AO.QD.AT.ATIndex = buildatindex(AO.QD.FamilyName, Indices.QD);
    AO.QD.Position = findspos(THERING, AO.QD.AT.ATIndex(:,1))';

    AO.QFA.AT.ATType = 'QUAD';
    AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFA.Position = findspos(THERING, AO.QFA.AT.ATIndex(:,1))';

    AO.CQS.AT.ATType = 'SKEWQUAD';
    AO.CQS.AT.ATIndex = buildatindex(AO.CQS.FamilyName, Indices.S1([2 3 6 7]));
    AO.CQS.Position = findspos(THERING, AO.CQS.AT.ATIndex(:,1))';
catch
    warning('Quadrupole family not found in the model.');
end


% SEXTUPOLES
try
    % S1 or SF
    AO.S1.AT.ATType = 'SEXT';
    AO.S1.AT.ATIndex = buildatindex(AO.S1.FamilyName, Indices.S1);
    AO.S1.Position = findspos(THERING, AO.S1.AT.ATIndex(:,1))';

    % S2 or SD
    AO.S2.AT.ATType = 'SEXT';
    AO.S2.AT.ATIndex = buildatindex(AO.S2.FamilyName, Indices.S2);
    AO.S2.Position = findspos(THERING, AO.S2.AT.ATIndex(:,1))';

    % S3 or HSD
    AO.S3.AT.ATType = 'SEXT';
    AO.S3.AT.ATIndex = buildatindex(AO.S3.FamilyName, Indices.S3);
    AO.S3.Position = findspos(THERING, AO.S3.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end


% OCTUPOLES
try
    AO.OCTU.AT.ATType = 'OCTU';
    AO.OCTU.AT.ATIndex = buildatindex(AO.OCTU.FamilyName, Indices.OCTU);
    AO.OCTU.Position = findspos(THERING, AO.OCTU.AT.ATIndex(:,1))';
catch
    warning('Octupole families not found in the model.');
end


% BEND
try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND(:));
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end


% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end


setao(AO);



% Set TwissData at the start of the storage ring
try   
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [8.836590663250137 2.559675839386921]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0.693102990510825 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end

