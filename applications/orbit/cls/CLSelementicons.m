function SPEAR3elementicons;
%initialize element icon data for SPEAR3
%other machines modify family names accordingly
%call this routine from orbit initialization

global THERING SYS
    
dx=0.01;
dx2=0.005;

AO=GetAO;
ElementIcons=cell(1,size(THERING,2));  %generate ElementIcons cell array/store information in appdata

%BPMS
fam='BPMx';
phi=2*pi*[0:0.01:1];
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=ind;
phi=2*pi*[0:0.05:1];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
    ElementIcons{jj}.xpts=cos(phi)/180;      %180 gets horizontal size correct
    ElementIcons{jj}.ypts=(sin(phi)+1.8)/4;  %+1.8)/4 gets vertical size and position correct
    ElementIcons{jj}.color='g';   
    ElementIcons{jj}.elementimage='clsbpm_1.jpg';
    ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
    ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
  end

%Correctors
fam='HCM';
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
dx=0.005;  dx2=0.0015;
dy=0.6; dy2=0.10;
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[0   dx;    dx   dx2;    dx2 dx2; dx2 -dx2; -dx2 -dx2; -dx2 -dx; -dx   0;];
        ElementIcons{jj}.ypts=[1.0 dy;    dy   dy;     dy  dy2; dy2  dy2;  dy2  dy;   dy   dy;  dy 1.0;];
        ElementIcons{jj}.color='k';
        ElementIcons{jj}.elementimage='clscorrector_1.jpg';
        ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
 end

%Bends
dx=0.010;
dx2=0.002;
dy=0.85;
dy2=0.1;

fam='BEND';   
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[-dx2 -dx;  -dx  dx;     dx   dx2;     dx2  -dx2;];
        ElementIcons{jj}.ypts=[dy2   dy;   dy  dy;     dy   dy2;     dy2   dy2;];
        ElementIcons{jj}.color='b';
        ElementIcons{jj}.elementimage='clsbend_1.jpg';           %BEND
        ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
  end


%Horizontally Focusing Quads
dx=0.003;
dy=0.33;

fam='QFA';      
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        ElementIcons{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        ElementIcons{jj}.color='r';
        ElementIcons{jj}.elementimage='clsquadrupole_1.jpg';
         ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
 end

fam='QFB';     
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        ElementIcons{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        ElementIcons{jj}.color='r';
        ElementIcons{jj}.elementimage='clsquadrupole_1.jpg';
         ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
 end
 
fam='QFC';     
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        ElementIcons{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        ElementIcons{jj}.color='r';
        ElementIcons{jj}.elementimage='clsquadrupole_1.jpg';
        ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
 end

%Horizontally Focusing Sextupoles
dx=0.005;  dx2=0.002;
dy=0.85;

fam='SD';      
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[0 -dx; -dx   dx;    dx2  0;];
        ElementIcons{jj}.ypts=[0  dy;  dy   dy;    dy   0;];
        ElementIcons{jj}.color='y';
        ElementIcons{jj}.elementimage='clssextupole_1.jpg';
        ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
  end

%Vertically Focusing Sextupoles
dx=0.005;  dx2=0.002;
dy=0.15;

fam='SF';      
ifam=isfamily(fam);
ind=AO.(fam).AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        ElementIcons{jj}.xpts=[-dx  0;    0   dx;    dx -dx;];
        ElementIcons{jj}.ypts=[ dy  1.0;  1.0 dy;    dy  dy;];
        ElementIcons{jj}.color='y';
        ElementIcons{jj}.elementimage='clssextupole_1.jpg';
        ElementIcons{jj}.AOFamily=AO.(fam).FamilyName;
        ElementIcons{jj}.AODevice=AO.(fam).DeviceList(ii,:);
 end
    
elemind=sort(elemind);
SYS.elemind=elemind(:);   %store element indices for display

setappdata(0,'ElementIcons',ElementIcons);


