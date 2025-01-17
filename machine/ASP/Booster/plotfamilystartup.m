function plotfamilystartup(handles)
% plotfamilystartup(handles)


Menu0 = handles.('LatticeConfiguration');

%MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
%set(MenuAdd,'Callback', 'bumpinj');
%set(MenuAdd, 'Separator','Off');


% Add a sector menu
% Using a [Arc Straight] nomenclature
Sectors = 4;
L = getfamilydata('Circumference');
if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    % Arc sector
    Extra = 4;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    for i = 2:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-L/Sectors-Extra L]),'],guidata(gcbo))']);

    % Straight section
    Extra = 8;
    for i = 1:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+i*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-Extra L]),'],guidata(gcbo))']);
end


drawnow;
