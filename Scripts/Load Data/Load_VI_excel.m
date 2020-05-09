%% Funtion to load Excel Files (from ABF)
% INPUT
%   Open dialogue box to pick an Excel file
% Output
%   V: Voltage Records
%   I: Current Records
%   fs: sampling frequency
function [V,I,fs,FileName]=Load_VI_excel
%% Read File    
DefaultPath=pwd; % Current Diretory of MATLAB    
[FileName,PathName] = uigetfile('*.xlsx',' Pick an Excel file ',...
    'MultiSelect', 'off',DefaultPath);
%% Load Data
DATA=importfilefromexcel([PathName,FileName]);
[~,R]=size(DATA); % N samples, R records
% First Row is Vector time
t=DATA(:,1);                        % in [ms]
fs=1/(abs(t(2)-t(1))*(1e-3));       % in [Hz]
if mod((R-1)/2,2)==0
    V=DATA(:,2:(R-1)/2+1)';
    I=DATA(:,(R-1)/2+2:end)';
    % PREVIEW DATA
    DownSamplingFactor=20;
    currentpulse=downsample( I(end,:),DownSamplingFactor);
    voltagerecord=downsample( V(end,:),DownSamplingFactor);
    timevector=downsample(t,DownSamplingFactor);
    PreviewFig=figure; 
    [hAx,~,~]=plotyy(timevector,currentpulse,timevector,voltagerecord);
    grid on;
    ylabel(hAx(1),'Current [pA]'); % left y-axis
    ylabel(hAx(2),'Voltage [mV]'); % right y-axis
    xlabel('Seconds [ms]');
    title(['Segment: ',num2str((R-1)/2)]);
    PreviewFig.Name=['Preview of ',FileName];
    PreviewFig.NumberTitle='off';
else
    disp('Something Wrong in Excel File')
end
