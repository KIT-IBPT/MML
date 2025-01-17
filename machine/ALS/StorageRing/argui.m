function argui

%[Temp,I]=sort(ARChanNames(:,5));
%Names=ARChanNames(I,:);

%[Temp,I]=sort(ARChanNames(:,3:4));
%Names=ARChanNames(I,:);


fig1 = figure;
set(fig1, ...
   'Units', 'Normal', ...
   'MenuBar', 'None', ... 
   'Name', 'Plot Channel Name', ...
   'NumberTitle', 'Off', ...
   'Position', [.2 .5 .6 .45]);


h1 = axes(...
   'Units', 'Normal', ...
   'Position', [.1 .2 .82 .7]);


popcol1=uicontrol(gcf, ...
   'Style','popup', ...
   'String',str2mat('BPMx','BPMy','IDBPMx','IDBPMy','BEND','QFA','SF','SD','QF','QD','HCM','VCM','SQSF','SQSD','IDpos','IDvel'), ...
   'Callback','row=get(findobj(gcbf,''Tag'',''popfamily''),''Value''); chantype=get(findobj(gcbf,''Tag'',''popchantype''),''Value'')-1; Family=get(findobj(gcbf,''Tag'',''popfamily''),''String''); set(findobj(gcbf,''Tag'',''popname''),''String'',getname(deblank(Family(row,:)),[],chantype)); row=get(findobj(gcbf,''Tag'',''popname''),''Value''); Names=get(findobj(gcbf,''Tag'',''popname''),''String''); arplot(deblank(Names(row,:)));', ...
   'Units', 'Points', ...
   'Position',[5 5 81 19], ...
   'Value', 1, ...   
   'tag','popfamily');


popcol2=uicontrol(gcf, ...
   'Style','popup', ...
   'String',str2mat('Analog Monitor','Analog Control','Boolean Monitor','Boolean Control'), ...
   'Callback','row=get(findobj(gcbf,''Tag'',''popfamily''),''Value''); chantype=get(findobj(gcbf,''Tag'',''popchantype''),''Value'')-1; Family=get(findobj(gcbf,''Tag'',''popfamily''),''String''); set(findobj(gcbf,''Tag'',''popname''),''String'',getname(deblank(Family(row,:)),[],chantype)); row=get(findobj(gcbf,''Tag'',''popname''),''Value''); Names=get(findobj(gcbf,''Tag'',''popname''),''String''); arplot(deblank(Names(row,:)));', ...
   'Units', 'Points', ...
   'Position',[5+81+10 5 86 19], ...
   'tag','popchantype');


popcol3=uicontrol(gcf, ...
   'Style','popup', ...
   'String',getname('BPMx'), ...
   'Callback','row=get(findobj(gcbf,''Tag'',''popname''),''Value''); Names=get(findobj(gcbf,''Tag'',''popname''),''String''); arplot(deblank(Names(row,:)));', ...
   'Units', 'Points', ...
   'Value', 1, ...   
   'Position',[5+81+10+86+10 5 190 19], ...
   'tag','popname');


