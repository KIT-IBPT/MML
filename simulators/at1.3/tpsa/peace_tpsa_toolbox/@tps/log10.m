function r = log10(t)
% function r = log10(tps)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 06-May-2003
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/log10.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = log10(t) = (exp(t)+exp(-t))/2
%------------------------------------------------------------------------------
r = log(t)/log(10);