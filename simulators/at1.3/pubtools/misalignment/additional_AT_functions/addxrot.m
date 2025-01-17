function addxrot(elemindex, theta)
% ADDSROT increments the rotation obout the 's' axis (along the direction
% of particle motion) by an amount THETA in units of radians. ELEMINDEX is
% the index/indices of elements in THERING that are affected by this
% roataion. Clockwise rotation
%
% See also ADDSROT, ADDYROT

global THERING

numelems = length(elemindex);

if numelems ~= length(theta)
    error('ELEMINDEX and THETA must have the same number of elements');
end

T = tan(theta);

for i = 1:numelems
    elemlen = THERING{elemindex(i)}.Length;
    % Get current total translation from element
    curr_T1 = THERING{elemindex(i)}.T1;
    curr_T2 = THERING{elemindex(i)}.T2;
    % Add y translation and kick to particle coordiante to simulate
    % rotation of element about x-axis.
    THERING{elemindex(i)}.T1(3) = curr_T1(3) - elemlen*0.5*T(i);
    THERING{elemindex(i)}.T1(4) = curr_T1(4) + theta(i);
    THERING{elemindex(i)}.T2(3) = curr_T2(3) + elemlen*0.5*T(i);
    THERING{elemindex(i)}.T2(4) = curr_T2(4) - theta(i);
end