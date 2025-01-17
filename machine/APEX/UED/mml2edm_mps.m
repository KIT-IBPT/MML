function mml2edm_mps(Directory)

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\apex\hlc\edm\UED\PowerSupplies
    else
        cd /remote/apex/hlc/edm/UED/PowerSupplies
    end
else
    cd(Directory);
end


WindowLocation = [120 60];
FileName = 'MagnetPowerSupplies.edl';
TitleBar = 'UED Magnet Power Supplies';
GoldenSetpoints = 'Off';
MotifWidget = 'Off';
ChannelLabelWidth = 88;
SP_AM = 'Off';  % Issue with ColumnLabels

XBuffer = 4;
YBuffer = 0;

Setup = {
    'Setpoint',       'Setpoint',    70
    'Monitor',        'Monitor',     70
    'Voltage',        'PS-Volts',    80
    'BulkVoltage',    'B-Volts',     70
    'Leakage',        'Leakage',     70
   %'RampRate',       'RampRate',    70
   %'Ready',          'Rdy',         30
    'Fault',   'Fault',         30
    'On',             'On',          30
    'OnControl',      'OnControl',   70 
   %'BulkOn',         'BOn',         30
   %'BulkControl',    'BulkControl', 80 
   %'Reset',          'Reset',       65
   %'RelatedDisplay', 'More Info',   80
   };

Fields       = Setup(:,1);
ColumnLabels = Setup(:,2);
ColumnWidth  = Setup(:,3);

%'ShellCommand', 'runCaen.sh', ...
%    'RelatedDisplayCommand', 'CaenA36xx.edl', ...

% Start with Solenoid
[xmax, ymax]= mml2edm('Sol', ...
    'FileName', FileName, ...
    'Fields', Fields, ...
    'xStart', XBuffer, ...
    'yStart', 0, ...
    'MoreButton', 'On', ...
    'SP-AM', SP_AM, ...
    'BC_SetAllButton', 'On', ...
    'SP_SetAllButton', 'On', ...
    'ColumnLabels', ColumnLabels, ...
    'ColumnWidth', ColumnWidth, ...
    'ChannelLabelWidth', ChannelLabelWidth, ...
    'WindowLocation', [120 60], ...
    'GoldenSetpoints', GoldenSetpoints, ...
    'MotifWidget', MotifWidget, ...
    'TitleBar', TitleBar);


Families ={
    'Sol1Quad'
    'Sol2Quad'
    'Sol1SQuad'
    'Sol2SQuad'
    'HCM'
    'VCM'
    'Quad'
    'Bend'
    };

for i = 1:length(Families)
    [xmax, ymax]= mml2edm(Families{i}, ...
        'FileName', FileName, ...
        'Fields', Fields, ...
        'Append', ...
        'xStart', XBuffer, ...
        'yStart', ymax+YBuffer, ...
        'MoreButton', 'On', ...
        'SP-AM', SP_AM, ...
        'ColumnLabels', ColumnLabels, ...
        'BC_SetAllButton', 'On', ...
        'SP_SetAllButton', 'On', ...
        'ColumnWidth', ColumnWidth, ...
        'ChannelLabelWidth', ChannelLabelWidth, ...
        'WindowLocation', [120 60], ...
        'GoldenSetpoints', GoldenSetpoints, ...
        'MotifWidget', MotifWidget, ...
        'TitleBar', TitleBar);
end


% Add the Gauss PV   Bell6010:1:MeasFlux
% getpvonline('Bell6010:1:IDN')
% GAUSS/TESLA METER,R1.2;
% getpvonline('Bell6010:1:OPT')
% STD61040405 ,1460264
fid = fopen(FileName, 'r+', 'b');
status = fseek(fid, 0, 'eof');


                
% if  ymax > 1200 %  I'm not sure when the slider appears
%     % To account for a window slider
%     Width  = xmax+30;
%     Height = 1220;
% else
Width  = xmax + 10 + 30;
Height = ymax + 10;
% end

%EDMExitButton(xmax-68, 3, 'FileName', FileName, 'ExitProgram');

Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', Width, 'Height', Height);

cd(DirStart);





function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');




% [x21, y21]= mml2edm('VCM', ...
%     'SP_SetAllButton', 'Off', ...
%     'FileName', FileName, ...
%     'Fields', Fields, ...
%     'RelatedDisplayCommand', 'CaenA36xx.edl', ...
%     'Append', ...
%     'xStart', XBuffer, ...
%     'yStart', y11+YBuffer, ...
%     'ColLabels', 'Off', ...
%     'BC_SetAllButton', 'Off', ...
%     'SP_SetAllButton', 'Off', ...
%     'ColumnWidth', ColumnWidth, ...
%     'ChannelLabelWidth', ChannelLabelWidth, ...
%     'WindowLocation', [120 60], ...
%     'GoldenSetpoints', GoldenSetpoints, ...
%     'MotifWidget', MotifWidget, ...
%     'TitleBar', TitleBar);
% 
% [x31, y31]= mml2edm('MPSol', ...
%     'SP_SetAllButton', 'Off', ...
%     'FileName', FileName, ...
%     'Fields', Fields, ...
%     'RelatedDisplayCommand', 'CaenA36xx.edl', ...
%     'Append', ...
%     'xStart', XBuffer, ...
%     'yStart', y21+YBuffer, ...
%     'ColLabels', 'Off', ...
%     'BC_SetAllButton', 'Off', ...
%     'SP_SetAllButton', 'Off', ...
%     'ColumnWidth', ColumnWidth, ...
%     'ChannelLabelWidth', ChannelLabelWidth, ...
%     'WindowLocation', [120 60], ...
%     'GoldenSetpoints', GoldenSetpoints, ...
%     'MotifWidget', MotifWidget, ...
%     'TitleBar', TitleBar);
% 
% [x41, y41]= mml2edm('Sol', ...
%     'SP_SetAllButton', 'Off', ...
%     'FileName', FileName, ...
%     'Fields', Fields, ...
%     'RelatedDisplayCommand', 'CaenA36xx.edl', ...
%     'Append', ...
%     'xStart', XBuffer, ...
%     'yStart', y31+YBuffer, ...
%     'ColLabels', 'Off', ...
%     'BC_SetAllButton', 'Off', ...
%     'SP_SetAllButton', 'Off', ...
%     'ColumnWidth', ColumnWidth, ...
%     'ChannelLabelWidth', ChannelLabelWidth, ...
%     'WindowLocation', [120 60], ...
%     'GoldenSetpoints', GoldenSetpoints, ...
%     'MotifWidget', MotifWidget, ...
%     'TitleBar', TitleBar);
% 
% 
% xmax = max([x11 x21 x31 x41]);
% ymax = max([y11 y21 y31 y41]);
