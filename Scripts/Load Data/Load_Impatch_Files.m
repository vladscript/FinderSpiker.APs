%% Funtion to load CSV Files (from ImPatch)
% INPUT
%   Open dialogue box to pick an CSV files
% Output
%   Xvoltage: Voltage Records
%   Xcurrent: Current Records [mV]
%   fs: sampling frequency
%   FileName: Experiment Name
function [Xvoltage,Xcurrent,fs,FileName]=Load_Impatch_Files
%% READ DATA
formatIn = 'dd-mmm-yyyy';
OKFiles=false;
while ~OKFiles
    % Current File
    [FileNameC,PathNameC] = uigetfile('*.csv','Load Current Records',...
        'MultiSelect', 'on');
    % Voltage File
    [FileNameV,PathNameV] = uigetfile('*.csv','Load Voltage Records',...
        'MultiSelect', 'on',PathNameC);

    fprintf('>>Checking Metadata\n')
    [fsC,NsC,DateExpC]=checkmetadata(FileNameC,PathNameC);
    [fsV,NsV,DateExpV]=checkmetadata(FileNameV,PathNameV);
    if and(and(fsC==fsV,NsC==NsV),strcmp(DateExpC,DateExpV))
        fs=fsC;
        OKFiles=true;
        fprintf('>>Experiments OK:\n')
        fprintf('Sampling frequency:    %i Hz\n',fsC)
        fprintf('Record Lengths:        %i seconds\n',NsC/fs)
        DateExpC(DateExpC=='/')='-';
        EXPDate=datestr(datenum(DateExpC,formatIn));
        fprintf('Experiment Date:       %s \n',EXPDate)
    else
        fprintf('\n>>Check Files where parameters mismatched:\n')
        fprintf('File Names:            %s - %s Hz\n',FileNameC,FileNameV)
        fprintf('Sampling frequencies:  %i - %i Hz\n',fsC,fsV)
        fprintf('Record Lengths:        %i - %i seconds\n',NsC/fs,NsV/fs)
        DateExpC(DateExpC=='/')='-';
        DateExpV(DateExpV=='/')='-';
        EXPDateC=datestr(datenum(DateExpC,formatIn));
        EXPDateV=datestr(datenum(DateExpV,formatIn));
        fprintf('Experiment Dates:      %s - %s\n',EXPDateC,EXPDateV)
    end

end
% Load DATA matrices:
fprintf('****** ****** ****** ****** .\n')
fprintf('>>Loading Data of [%s] & [%s] ... ',FileNameC,FileNameV)
Xvoltage=table2array(readtable([PathNameV,FileNameV],'ReadVariableNames',0,'HeaderLines',5))';
Xcurrent=table2array(readtable([PathNameC,FileNameC],'ReadVariableNames',0,'HeaderLines',5))';
[Ns,Nx]=size(Xcurrent);
if Nx<Ns
    Xvoltage=Xvoltage';
    Xcurrent=Xcurrent';
    [Ns,Nx]=size(Xcurrent);
end
fprintf('done.\n')
%Other OUTPUTs
fs=fsC;
FileName=[DateExpC,'_I-V'];
%% PREVIEW DATA

t=linspace(0,Nx/fs,Nx);
DownSamplingFactor=20;
currentpulse=downsample( Xcurrent(end,:),DownSamplingFactor);
voltagerecord=downsample( Xvoltage(end,:),DownSamplingFactor);
timevector=downsample(t,DownSamplingFactor);
PreviewFig=figure; 
[hAx,~,~]=plotyy(timevector,currentpulse,timevector,voltagerecord);
grid on;
ylabel(hAx(1),'Current [pA]'); % left y-axis
ylabel(hAx(2),'Voltage [mV]'); % right y-axis
xlabel('Seconds [ms]');
title(['Segment: ',num2str(Ns)]);
PreviewFig.Name=['Preview of ',FileName];
PreviewFig.NumberTitle='off';