function setmachineconfig_bts(varargin)


% Online do this if running online
Mode = getmode('BEND');

if strcmpi(Mode, 'Online')
    DirStart = pwd;
    
    if ispc
        cd \\Als-filer\physbase\hlc\BTS
    else
        cd /home/als/physbase/hlc/BTS
    end
    
    % Get the injection lattice
    SP = getinjectionlattice;
    
    % Compare file dates
    TimeStamp = SP.HCM.Setpoint.TimeStamp;
    Buildflag = 0;
    try
        LoadStruct = load('EDMBuildTimeStamp', 'TimeStamp');
        TimeStampFile = LoadStruct.TimeStamp;
        if abs(etime(TimeStampFile,TimeStamp)) > .1
            Buildflag = 1;
        else
            Buildflag = 0;
        end
    catch
        Buildflag = 1;
    end
    
    if Buildflag
        Families = {'HCM','VCM','Q','BEND'};
        
        try
            fprintf('   Building EDM script files.\n');
            for i = 1:length(Families)
                FileName = sprintf('%s_Setpoint_MachineSave.sh', Families{i});
                try
                    DataStruct = SP.(Families{i}).Setpoint;
                catch
                    fprintf('   %s family not found in the machine save.\n', Families{i});
                end
                FileName = mml2caput(DataStruct.FamilyName, DataStruct.Field, DataStruct.Data, DataStruct.DeviceList, FileName, 0);
            end
        catch
            fprintf('%s\n', lasterr);
            fprintf('   An error occurred writting the BTS lattice save scripts for the EDM applications.\n');
            fprintf('   The Matlab save/restore is not affected by this, just the EDM applications.\n\n');
        end
        
        try
            fprintf('   Building EDM screens so that the Golden values are there.  If open, the EDM BTS Magnet \n');
            fprintf('   Power Supply applications will need to be restarted before the change is visable.\n');
            
            buildedmapps;
            %mml2edm_pulsedmagnets;
            %mml2edm_mps;

            % Save the time stamp file
            save('EDMBuildTimeStamp', 'TimeStamp');

        catch
            fprintf('%s\n', lasterr);
            fprintf('   An error occurred rebuilding the EDM Magnet Power Supply application for the BTS (mml2edm_mps).\n');
        end
    end
    
    cd(DirStart);
end