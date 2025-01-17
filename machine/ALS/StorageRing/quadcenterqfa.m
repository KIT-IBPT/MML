%  Quadrupole Center Measurement
%  (see quadcenter1of3 for details)



%%%%%%%%%%%%%%%%%%%%%
% Make the BPM list %
%%%%%%%%%%%%%%%%%%%%%
BPMFamily = 'BPMx';

RemoveDeviceList = []; 

% BPMDevList = getlist(BPMFamily);
BPMDevList = [
    1     4
    1     7
    2     4
    2     7
    3     4
    3     7
    4     4
    4     7
    5     4
    5     7
    6     4
    6     7
    7     4
    7     7
    8     4
    8     7
    9     4
    9     7
    10    4
    10    7
    11    4
    11    7
    12    4
    12    7
    ];

i = findrowindex(RemoveDeviceList, BPMDevList);
BPMDevList(i,:) = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean out the data directory %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[QUADFamily, QUADDev] = bpm2quad(BPMFamily, BPMDevList(1,:));
q = quadcenterinit(QUADFamily, QUADDev, 1);
DirStart = pwd;
NewDir = 'old';
q.DataDirectory = gotodirectory(q.DataDirectory);
if ~exist(NewDir,'dir')
    mkdir(NewDir);
end
try
    movefile('*.mat', NewDir);
    movefile('quadcenter.log', NewDir);
catch
end
cd(DirStart);



%%%%%%%%%%%%%%%%%%%%%%%%
% Loop on all the BPMs %
%%%%%%%%%%%%%%%%%%%%%%%%
t0 = gettime;
for i = 1:size(BPMDevList,1)
    
    [QUADFamily, QUADDev, DelSpos] = bpm2quad(BPMFamily, BPMDevList(i,:));
    
    % Check how close the BPM is to the quad (should base on phase but I didn't want to assume the AT desk was available)
    if abs(DelSpos) < 1
        fprintf('   %d of %d. BPM(%2d,%d)  %s(%2d,%d)  BPM-to-Quad Distance=%f meters\n', i, size(BPMDevList,1), BPMDevList(i,:), QUADFamily, QUADDev, DelSpos);

        q = quadcenter(QUADFamily, QUADDev, 2);
        
        DCCT = getdcct;    
        if DCCT < 2
            % Redo magnet if the beam dumped
            sound(cos(1:10000));
            fprintf('   Current too low.  Refill and hit return.\n');
            pause;
            fprintf(' \n');
            q = quadcenter(QUADFamily, QUADDev, 2);
            
        elseif DCCT < 35 && i<size(BPMDevList,1)-1
            sound(cos(1:10000));
            fprintf('   Current too low.  Refill and hit return.\n');
            pause;
            fprintf(' \n');
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Move data to new directory by date %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DirStart = pwd;
NewDir = sprintf('%4d-%02d-%02d_%02d-%02d-%02.0f', clock);
cd(q.DataDirectory);
if ~exist(NewDir,'dir')
    try
        mkdir(NewDir);
    catch
    end
end
try
    movefile('*.mat', NewDir);
    fprintf('   Data moved to %s\n', [q.DataDirectory NewDir]);
    try
        movefile('quadcenter.log', NewDir);
    catch
        fprintf('   Error occurred when moving log files to %s\n', [q.DataDirectory NewDir]);
    end
catch
    fprintf('   Error occurred when moving data files to %s\n', [q.DataDirectory NewDir]);
end
cd(DirStart);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print time and wake-up call %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('   Data collection time %f minutes\n', (gettime-t0)/60);
