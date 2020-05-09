%% Funtion to load Axon Binary Files (.abf)
% It uses the function abfload from: https://www.mathworks.com/matlabcentral/fileexchange/6190-abfload
% INPUT
%   Open dialogue box to pick a file
% Output
%   x: signal vector [pA]
%   fs: sampling frequency
function [Xcurrent,Xvoltage,fs,FileName]=load_VI_abf
%% Read File    
DefaultPath=pwd;    
[FileName,PathName] = uigetfile('*.abf',' Pick an Axon file ',...
    'MultiSelect', 'off',DefaultPath);
%% Load Data
[DATA,ts_us,hinfo]=abfloadV2([PathName,FileName]);
% Print Details:
clc
fprintf('\n*** File %s Details ***\n',FileName)
fprintf('>>Version File: %s\n',hinfo.fFileSignature);
DataDate=num2str( hinfo.uFileStartDate );
DateVector = [str2num(DataDate(1:4)),str2num(DataDate(end-3:end-2)),...
    str2num(DataDate(end-1:end)),6,6,6];
formatOut = 'dd/mmm/yyyy';
DateExp=datestr(DateVector,formatOut);
fprintf('>>Experiment Date: %s \n',DateExp);
TimeExp=datestr(seconds(hinfo.uFileStartTimeMS*1-3/3600),'HH:MM:SS PM');
fprintf('>>Experiment Start Time: %s \n',TimeExp);
fprintf('>>Channels & Units:\n')
for i=1:hinfo.nADCNumChannels
    fprintf('  %s -> %s\n\n',hinfo.recChNames{i},hinfo.recChUnits{i});
end
fprintf('>>Number of episodes: %i of %3.2f seconds\n',hinfo.lActualEpisodes,hinfo.sweepLengthInPts*ts_us*1e-6);
fprintf('>>Sampling interval [us]: %i\n',hinfo.si);
fprintf('************************************\n')
%% GET DATA
fprintf('>>Loading current & voltage data: \n')
ts=ts_us/(1e6);                 % Sampling Period from [us] to [s]
fs=1/(ts_us/(1e6));             % Sampling Frequency [Hz]
% Current & Voltage Data to Matrices
Xcurrent=zeros(hinfo.lActualEpisodes,hinfo.sweepLengthInPts);
Xvoltage=zeros(hinfo.lActualEpisodes,hinfo.sweepLengthInPts);
for i=1:hinfo.lActualEpisodes
    Xvoltage(i,:)=DATA(:,1,i);
    Xcurrent(i,:)=DATA(:,2,i);
    fprintf('*')
end
fprintf('\ndone.\n')
%% Preview Data
signalindex=hinfo.lActualEpisodes;
DownSamplingFactor=20;
currentpulse=downsample( Xcurrent(signalindex,:),DownSamplingFactor);
voltagerecord=downsample( Xvoltage(signalindex,:),DownSamplingFactor);
timevector=downsample(linspace(0,hinfo.sweepLengthInPts*ts,hinfo.sweepLengthInPts),DownSamplingFactor);
PreviewFig=figure; 
[hAx,~,~]=plotyy(timevector,currentpulse,timevector,voltagerecord);
grid on;
ylabel(hAx(1),['Current [',hinfo.recChUnits{2},']']); % left y-axis
ylabel(hAx(2),['Voltage [',hinfo.recChUnits{1},']']); % right y-axis
xlabel('Seconds [s]');
title(['Segment: ',num2str(signalindex)]);
PreviewFig.Name=['Preview of ',FileName];
PreviewFig.NumberTitle='off';