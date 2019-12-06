function [ machineName, subMachineName, linkFlag, mmlRoot ] = setpathanka( varargin )
%SETPATHANKA Initializes the MATLAB path for using the MML at ANKA
%   [MACHINENAME, SUBMACHINENAME, LINKFLAG, MMLROOT] = SETPATHANKA([SUBMACHINENAME])
%     MACHINENAME: Always 'ANKA'
%     SUBMACHINENAME: 'StorageRing'
%     LINKFLAG: 'LabCA'
%     MMLROOT: Path to MML root directory

    if length(varargin) >= 1
        subMachineName = varargin{1};
    else
        subMachineName = 'StorageRing';
    end
    
    if nargin < 3
        linkFlag = 'LabCA';
    end
    
    machineName = 'ANKA';
    
    if strcmp(subMachineName, 'StorageRing')
        machineType = 'StorageRing';
    else
        error(['Unknown sub-machine: ' subMachineName]);
    end
    
    [machineName, subMachineName, linkFlag, mmlRoot] = setpathmml(machineName, subMachineName, machineType, linkFlag);

end
