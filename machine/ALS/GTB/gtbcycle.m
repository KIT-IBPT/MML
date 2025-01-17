function gtbcycle(varargin)
%GTBCYCLE - Gun to booster ring cycle
%  gbtcycle
%
%  See also getmachineconfig, setmachineconfig, machineconfig




%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%
CMCycleFlag = 1;


% Extra delay
ExtraDelay = 20;


% Input flags
DisplayFlag = 1;
FinalLattice = 'Injection';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Injection')
        FinalLattice = 'Injection';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Production') || strcmpi(varargin{i},'Golden')
        FinalLattice = 'Production';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Present')
        FinalLattice = 'Present';
        varargin(i) = [];
    end
end


% Check for a lattice file input
if length(varargin) >= 1
    if ischar(varargin{1})
        FinalLattice = varargin{1};
        varargin(1) = [];
    end
end

if isempty(FinalLattice)
    DirectoryName = getfamilydata('Directory', 'ConfigData');
    [FinalLattice, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to cycle to', DirectoryName);
    if FinalLattice == 0
        fprintf('   Cycle canceled\n');
        return
    else
        FinalLattice = fullfile(DirectoryName, FinalLattice);
    end
end


% Final lattice
if strcmpi(FinalLattice, 'Present')
    [ConfigSetpoint, ConfigMonitor] = getmachineconfig;
elseif strcmpi(FinalLattice, 'Injection')
    [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
elseif strcmpi(FinalLattice,'Production') || strcmpi(FinalLattice,'Golden')
    [ConfigSetpoint, ConfigMonitor] = getproductionlattice;
else
    [ConfigSetpoint, ConfigMonitor] = machineconfigsort(FinalLattice);
end


HCM  = ConfigSetpoint.HCM.Setpoint;
VCM  = ConfigSetpoint.VCM.Setpoint;
BEND = ConfigSetpoint.BEND.Setpoint;
Q    = ConfigSetpoint.Q.Setpoint;

BENDmin = minpv('BEND');
BENDmax = maxpv('BEND');

Qmin = minpv('Q');
Qmax = maxpv('Q');

HCMmin = minpv('HCM');
HCMmax = maxpv('HCM');

VCMmin = minpv('VCM');
VCMmax = maxpv('VCM');

% Change corrector min to zero (that's what Checker did)???
HCMmin = HCMmin*0;
VCMmin = VCMmin*0;

% Change corrector max to 80% of max???
HCMmax = HCMmax * .8;
VCMmax = VCMmax * .8;

fprintf('   Initalize GTB magnet power supply ramp rates.\n');
setpv('HCM',  'RampRate', 5);
setpv('VCM',  'RampRate', 5);
setpv('Q',    'RampRate', 5);
setpv('BEND', 'RampRate', [2 2 7 20]');


%%%%%%%%%%%%%%%%%%%
% Cycle if online %
%%%%%%%%%%%%%%%%%%%
if strcmpi(getmode('BEND'),'Online')
   try
        fprintf('   Starting a cycle of the Gun, Linac, and LTB magnets.\n');
        
        % Set the correctors
        %setpv(ConfigSetpoint.HCM.Setpoint, 0);
        %setpv(ConfigSetpoint.VCM.Setpoint, 0);
        %setpv(ConfigSetpoint.HCM.Setpoint, -1);
        %setpv(ConfigSetpoint.VCM.Setpoint, -1);
        
        
         % Start at "min"
        fprintf('   Loading the minimum lattice  ...');
        
        if CMCycleFlag
            T_HCM = getramptime('HCM',  HCMmin);
            T_VCM = getramptime('VCM',  VCMmin);
        else
            T_HCM = 0;
            T_VCM = 0;
        end        
        T_Q    = getramptime('Q',    Qmin);
        T_BEND = getramptime('BEND', BENDmin);
        T = max([T_HCM T_VCM T_Q T_BEND]);
        
         % 120 is probably the maximum it needs to be
        if (T+ExtraDelay) > 120
            T = 120 - ExtraDelay;
        end
        
        if CMCycleFlag
            setsp('HCM', HCMmin, [], 0);
            setsp('VCM', VCMmin, [], 0);
        end
        setsp('BEND', BENDmin, [], 0);
        setsp('Q',    Qmin,    [], 0);
        
        fprintf('  Pausing %.1f seconds  ...', T+ExtraDelay); 
        drawnow;
        pause(T+ExtraDelay);
        a = clock; fprintf('  Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        
        
        % Go to max
        fprintf('   Loading the maximum lattice  ...');
        % Since the monitors are flaky and wrong, just make a setpoint change and
        % wait the maximum possible time to for the magnets to reach the setpoint.
        
        if CMCycleFlag
            T_HCM = getramptime('HCM',  HCMmax);
            T_VCM = getramptime('VCM',  VCMmax);
        else
            T_HCM = 0;
            T_VCM = 0;
        end        
        T_Q    = getramptime('Q',    Qmax);
        T_BEND = getramptime('BEND', BENDmax);
        T = max([T_HCM T_VCM T_Q T_BEND]);
        
         % 120 is probably the maximum it needs to be
        if (T+ExtraDelay) > 120
            T = 120 - ExtraDelay;
        end
        
        if CMCycleFlag
            setsp('HCM', HCMmax, [], 0);
            setsp('VCM', VCMmax, [], 0);
        end
        setsp('BEND', BENDmax, [], 0);
        setsp('Q',    Qmax,    [], 0);
        
        fprintf('  Pausing %.1f seconds  ...', T+ExtraDelay); 
        drawnow;
        pause(T+ExtraDelay);
        a = clock; fprintf('  Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        
        
        % Go to final (set everything)
        fprintf('   Loading the injection lattice  ...');
        
        if CMCycleFlag
            T_HCM = getramptime('HCM',  ConfigSetpoint.HCM.Setpoint.Data, ConfigSetpoint.HCM.Setpoint.DeviceList);
            T_VCM = getramptime('VCM',  ConfigSetpoint.VCM.Setpoint.Data, ConfigSetpoint.VCM.Setpoint.DeviceList);
        else
            T_HCM = 0;
            T_VCM = 0;
        end
        T_Q    = getramptime('Q',    ConfigSetpoint.Q.Setpoint.Data,    ConfigSetpoint.Q.Setpoint.DeviceList);
        T_BEND = getramptime('BEND', ConfigSetpoint.BEND.Setpoint.Data, ConfigSetpoint.BEND.Setpoint.DeviceList);
        T = max([T_HCM T_VCM T_Q T_BEND]);
        
        % 120 is probably the maximum it needs to be
        if (T+ExtraDelay) > 120
            T = 120 - ExtraDelay;
        end
        
        setmachineconfig(ConfigSetpoint, 0);
        
        fprintf('  Pausing %.1f seconds  ...', T+ExtraDelay);
        drawnow;
        pause(T+ExtraDelay);
        a = clock; fprintf('  Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        
   catch
       fprintf('\n  **************************\n');
       fprintf(  '  **  GTB Cycle Aborted!  **\n');
       fprintf(  '  **************************\n\n');
       sound tada
       fprintf('\n   %s\n', lasterr);
       %rethrow(lasterror);
   end
        
else
    % Simulator
    setmachineconfig(ConfigSetpoint, 0);
end






% % Go to max
% fprintf('   Loading the maximum lattice   ...');
% % But first go to 80% with Waitflag=-1
% if CMCycleFlag
%     setsp('HCM', HCMmax, [], 0);
%     setsp('VCM', VCMmax, [], 0);
% end
% setsp('BEND', .8*BENDmax, [], 0);
% setsp('Q',    .8*Qmax,    [], 0);
% 
% if CMCycleFlag
%     setsp('HCM', HCMmax, [], -1);
%     setsp('VCM', VCMmax, [], -1);
% end
% setsp('BEND', .8*BENDmax, [], -1);
% setsp('Q',    .8*Qmax,    [], 0);
% 
% % Then go to the max with a delay
% setsp('BEND', BENDmax, [], 0);
% setsp('Q',    Qmax,    [], 0);
% pause(10);
% 
% 
% pause(ExtraDelay);
% a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
% 
% 
% % Start at "min"
% fprintf('   Loading the minimum lattice   ...');
% if CMCycleFlag
%     setsp('HCM',  HCMmin,  [], 0);
%     setsp('VCM',  VCMmin,  [], 0);
% end
% setsp('BEND', BENDmin, [], 0);
% setsp('Q',    Qmin,    [], 0);
% 
% if CMCycleFlag
%     setsp('HCM',  HCMmin,  [], -1);
%     setsp('VCM',  VCMmin,  [], -1);
% end
% setsp('BEND', BENDmin, [], -1);
% setsp('Q',    Qmin,    [], 0);
% 
% pause(ExtraDelay);
% a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
