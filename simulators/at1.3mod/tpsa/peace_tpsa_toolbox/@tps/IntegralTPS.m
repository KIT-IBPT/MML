function r = IntegralTPS(p,n)
% function r = IntegralTPS(tps,n)
% \int tps d x_n
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
%  @TPS/IntegralTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  IntegralTPS(p,n) == \int p d{u_n}
%------------------------------------------------------------------------------
global OSIP
r.n = p.n;
r.o = min(OSIP.MaximumOrder,p.o+1);
r.c = zeros(1,OSIP_NumberOfMonomials(r.n,r.o));
r = class(r,'TPS');
%The indices of the array p.c that point to nonzero elements.
k = find(p.c);
l = length(k);
for i=1:l
    ppv = OSIP.MonomialPowerVector(k(i),:)
    rpv = ppv;
    rpv(n) = rpv(n)+1;
    rj = OSIP_PowerVector2Monomial(rpv);
    r.c(rj) = p.c(k(i))/(ppv(n)+1);
end
clear k l i ppv rpv rj
