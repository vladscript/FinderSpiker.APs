% GUI for visual Inspection
function Action_Magic(Experiment,Xcurrent,Xvoltage,FR,APs,PulseP,fs)
% Initialize
AxisLimitVoltage=[min(Xvoltage(:)),max(Xvoltage(:))];
if min(Xcurrent(:))<max(Xcurrent(:))
    AxisLimitCurrent=[min(Xcurrent(:)),max(Xcurrent(:))];
else
    AxisLimitCurrent=[min(Xcurrent(:))-10,max(Xcurrent(:))+10];
end
[Nsignals,Frames]=size(Xcurrent);
% FRout=FR;
% APsOut=APs;
x=[]; y=[]; APsData=[]; Parameters=[]; ActionPotentials=[]; 
AmpThreshold=0;
fprintf('Loading GUI...')
checksignals=figure('numbertitle','off',...
            'position',[46 42 600 450],...
            'keypressfcn',@manual_ctrl,...
            'CloseRequestFcn',@close_and_update);
ax1=subplot(2,1,1); %  Voltage - - - - - - - - - - - - - - - 
set(ax1,'NextPlot','replacechildren');
set(ax1,'ButtonDownFcn',@set_threshold);
ax2=subplot(2,1,2); % Current - - - - - - - - - - -
set(ax2,'NextPlot','replacechildren');
linkaxes([ax1,ax2],'x');
%% Initialize Plot **************************************************
n=1;
checksignals.Name=[' Action Potentials of: ',Experiment];
Get_Data();
Plot_Data_Now();
fprintf('... Ready!\n')
%% NESTED functions ########################################
    function Get_Data()
        x=Xvoltage(n,:);        % Voltage
        y=Xcurrent(n,:);        % Current
        APsData=APs{n};         % Action Potentials
        Parameters=FR{n,:};     % Parameters
    end

    function Plot_Data_Now()
        % VOLTAGE - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        cla(ax1); % Replot Stuff
        hold(ax1,'on')
        plot(ax1,x,'b','LineWidth',2)
        % Highlight Action Potentials
        for m=1:size(APsData,1)
            plot(ax1,APsData(m,1)+PulseP(1)-1:APsData(m,3)+PulseP(1)-1,...
                x(APsData(m,1)+PulseP(1)-1:APsData(m,3)+PulseP(1)-1),...
                'Color',[1.0,0,0.4],'LineWidth',2);
        end
        grid(ax1,'on');
        hold(ax1,'off')
        ax1.YLim=AxisLimitVoltage;
        ax1.XLim=[0,Frames];
        ylabel(ax1,'Voltage')
        ax1.XTick=[0,PulseP(1),PulseP(1)+PulseP(2)*fs-1];
        % Label Xticks:
        for ilab=1:numel(ax1.XTick)
            ax1.XTickLabel{ilab}=num2str(ax1.XTick(ilab)/fs*1000);
        end
        ylabel(ax1,'Voltage','Interpreter','Tex')
        title(ax1,['N of Action Potentials=',num2str(Parameters(4))],...
              'FontSize',8,'FontWeight','normal');
        % CURRENT - - - - - - - - - - - - - - - - - - - - - - - - - 
        cla(ax2);
        hold(ax2,'on')
        plot(ax2,y,'k','LineWidth',3)
        grid(ax2,'on');
        hold(ax2,'off')
        ax2.YLim=AxisLimitCurrent;
        ax2.XLim=[0,Frames];
        ax2.XTick=[0,PulseP(1),PulseP(1)+PulseP(2)*fs-1];
        ax2.XTickLabel=[];
        ylabel(ax2,'Current','Interpreter','Tex')
        title(ax2,['Current Pulse=',num2str(Parameters(2))],...
              'FontSize',8,'FontWeight','normal');
        drawnow;
    end
    function manual_ctrl(checksignals,~,~)
        key=get(checksignals,'CurrentKey');
        if strcmp(key,'rightarrow')
            disp('Next ------->')
            if n<Nsignals
                n=n+1; % Increases
            else
                n=Nsignals; % Stays
            end
            Get_Data;
            disp(n)
%             update_data;
            Plot_Data_Now;
            % SHOULD SAVE DATA
        elseif strcmp(key,'leftarrow')
            disp('<-- Previous')
            if n==1
                n=1;
            else
                n=n-1;
            end
            Get_Data;
            disp(n)
%             update_data;
            Plot_Data_Now;
            % Set_Name_Axis
        end
    end
    function close_and_update(~,~,~)
        fprintf('>>Closing: ')
        checkname=1;
        while checkname==1
            % Get Directory
            DP=pwd;
            Slashes=find(DP=='\');
            DefaultPath=[DP(1:Slashes(end)),'Processed Data'];
            if exist(DefaultPath,'dir')==0
                DefaultPath=pwd; % Current Diretory of MATLAB
            end
            fprintf('\n\n [ To update changes, please select the .mat file ] \n\n')
            [FileName,PathName] = uigetfile('*.mat',[' Pick the Analysis File to SAVE CHANGES ',Experiment],...
                'MultiSelect', 'off',DefaultPath);
            if strcmp(FileName(1:end-4),Experiment)
                checkname=0;
                % SAVE DATA
                save([PathName,FileName],'APs','FR','-append');
                fprintf('Action Potentials UPDATED (Visual ~ Inspection)@%s\n',Experiment)
                % Update CSV File
                fprintf('>>Overwritting Table: ')
                FileDirSave=pwd;
                slashes=find(FileDirSave=='\');
                FileDirSave=FileDirSave(1:slashes(end));
                FolderTable='Firing Tables\';
                writetable(FR,[FileDirSave,FolderTable,'\',Experiment,'_FR.csv'],...
                                    'Delimiter',',','QuoteStrings',true);
                fprintf('done.\n')
                delete(gcf)
            elseif FileName==0
                checkname=0;
                fprintf('Changes DISCARDED @%s',Experiment)
                delete(gcf)
            else
                fprintf('Not the same Experiment:\n%s & %s\n',FileName,Experiment)
                disp('Try again!')
            end
        end    
        delete(checksignals);
        disp(FR);
        fprintf('done.\n')
    end

    function set_threshold(~,~)
        % rect: [xmin ymin width height]
        rect=getrect;
        AmpThreshold=rect(2);
        fprintf('Amplitude Threshold: %2.1f\n',AmpThreshold);
        fprintf('>> Re-Analysing Trace:')
        Check4APs()
        fprintf('done.\n')
        Get_Data();
        Plot_Data_Now;       % update plot
        figure(checksignals) % Focus on Window
    end

    function Check4APs(~,~)
        xpulse=x(PulseP(1):PulseP(1)+PulseP(2)*fs-1);
        ActionPotentials=get_APs(xpulse,AmpThreshold);
        % update_data: FR & APs
        FR{n,4}=size(ActionPotentials,1);
        FR{n,5}=size(ActionPotentials,1)/PulseP(end);
        APs{n}=ActionPotentials;
    end
end
%% END OF THE WORLD