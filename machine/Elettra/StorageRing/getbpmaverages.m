function [N, T] = getbpmaverages(DeviceList)
%GETBPMAVERAGES - Gets the BPM averages
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0


Mode = getfamilydata(gethbpmfamily, 'Monitor', 'Mode'); 

if strcmpi(Mode,'Simulator')
    
    N = 1;
    T = 0;
    
else

    N = 10;
    T = 2.5;

end
