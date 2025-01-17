aspinit_bare;
global THERING
THERING = sext_off(THERING);

deletemisalign;

iterations = 1;
setmisalign('bend',[0 0 0 0 0 0],3);
setmisalign('qfa' ,[0 0 0 0 0 0],3);
setmisalign('qfb' ,[0 0 0 0 0 0],3);
setmisalign('qda' ,[0 0 0 0 0 0],3);
setmisalign('sfa' ,[0 0 0 0 0 0],3);
setmisalign('sfb' ,[0 0 0 0 0 0],3);
setmisalign('sda' ,[0 0 0 0 0 0],3);
setmisalign('sdb' ,[0 0 0 0 0 0],3);
setgirdermisalign('g1m1','g1m2',[0 0 0 0 0 0],3);
setgirdermisalign('g2m1','g2m2',[0 0 0 0 0 0],3);

calcmialign(iterations,'normal');

spos = findspos(THERING,1:length(THERING)+1);
for i=1:iterations
    figure;
    
    % Apply the calculated misalignment
    applymisalign;
    
    % Find the closed orbit
    Orb = findorbit4(THERING,0,1:length(THERING)+1);
    
    % Plot distorted orbit
    subplot(1,2,1);
    plot(spos,Orb(1,:),'b-',spos,Orb(3,:),'r:');
    title('Distorted orbit');
    xlabel('S position (m)');
    ylabel('(m)');
    
    % Calculate response matrix.
    
end