function [ machineName, subMachineName, linkFlag, mmlRoot ] = setpathkara( varargin )
%SETPATHKARA Initializes the MATLAB path for using the MML at KARA
%   [MACHINENAME, SUBMACHINENAME, LINKFLAG, MMLROOT] = SETPATHKARA([SUBMACHINENAME])
%     MACHINENAME: Always 'KARA'
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
    
    machineName = 'KARA';
    
    if strcmp(subMachineName, 'StorageRing')
        machineType = 'StorageRing';
    else
        error(['Unknown sub-machine: ' subMachineName]);
    end
    
    [machineName, subMachineName, linkFlag, mmlRoot] = setpathmml(machineName, subMachineName, machineType, linkFlag);

end
