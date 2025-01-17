function [Data]=get_dpsc_current_waveforms_cond(varargin)
% function [Data]=get_dpsc_current_waveforms_cond(varargin)

% Swap table is not necessary anymore with Eric Norum's new EPICS interface
%setpv('BR1:B:SWAP_TABLE',1);
% pause(0.5);
[BENDwave,timestamp]=lcaGet('BR1:B:RAMPI_COND',0,'int32');
timevecBEND=(0:(length(BENDwave)-1))/97720*16;
Data.Data(:,1)=125*(BENDwave*10/2^23)*1.23395+19.35;
Data.Timevec=timevecBEND;

Data.TimeStep=16/97720;
Data.TimeStamp(1)=timestamp;

%setpv('BR1:QF:SWAP_TABLE',1);
% pause(0.5);
[QFwave,timestamp]=lcaGet('BR1:QF:RAMPI_COND',0,'int32');
Data.Data(:,2)=60*(QFwave*10/2^23)*1.2275+9.37;
Data.TimeStamp(2)=timestamp;

%setpv('BR1:QD:SWAP_TABLE',1);
% pause(0.5);
[QDwave,timestamp]=lcaGet('BR1:QD:RAMPI_COND',0,'int32');
Data.Data(:,3)=60*(QDwave*10/2^23)*1.228+9.25;
Data.TimeStamp(3)=timestamp;
