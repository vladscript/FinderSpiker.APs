%% Gets Firing Rates of Current Clamp Experiments:
% Current Pulses & Voltage Records
% It detects Pulse Steps and Length
% Get Action Potentials Rate: N APs /Pulse Length
%   Input
%     Xcurrent
%     Xvoltage,
%     fs
%   Ouputs
%     FR: table:
%      Current Amp | Pulse Time | N APs | Firing Rate | Vrest | VThreshold
%     APs: Action Potentials cell per Pulse
%       Cell Data of [onset,amplitude and EoFR] per AP per pulse
%     PulseP: vector of Pulse Time Parameters:
%        [Start,Length]
function [FR,APs,PulseP]=getfiringrate(Xcurrent,Xvoltage,fs)
%%Setup
Nsteps=size(Xcurrent,1);
FR=table;
APs=cell(Nsteps,1);
%% Get Time Pulse of the biggest Current Pulse:
[~,IndxMaxCP]=max(range(Xcurrent'));
ymax=Xcurrent(IndxMaxCP,:);
% % % Pulse Current PDF must be bi-modal:
% % Npeaks=666;
% % [~,~,bi]=ksdensity(ymax,linspace(min(ymax),max(ymax),100));
% % Nstages=1;
% % while Npeaks>2
% %     biaugmented=bi*2*Nstages;
% %     fprintf('>>Estimating smoothed current PDF, bandwidth: %3.1f\n',biaugmented)
% %     [pI,Ibin]=ksdensity(ymax,linspace(min(ymax),max(ymax),100),'bandwidth',biaugmented);
% %     [Peaks,IpeakValue]=findpeaks(pI,Ibin);
% %     Npeaks=numel(Peaks);
% %     Nstages=Nstages+1;
% % end
% Find Pulse Intervals with max and min of the "derivative"
[~,StartPulseSample]=max(diff(ymax));
[~,EndPulseSample]=min(diff(ymax));
PulseTime=(EndPulseSample-StartPulseSample)/fs;
PulseP=[StartPulseSample,PulseTime];
fprintf('>>Current Pulse:   ___|¯¯|_____\n')
fprintf('>>Start Time:      %3.1f ms\n',StartPulseSample/fs*1000)
fprintf('>>Pulse Length:    %3.1f ms\n',PulseTime*1000)
fprintf('>>Record Length:   %3.1f ms\n',size(Xcurrent,2)/fs*1000)

%% Main Loops
% Current Amp | Step Curr Amp | N APs | Firing Rate | Vrest | VThreshold
% Initiaizae Features
AmplitudePulse=zeros(Nsteps,1);
StepCurrent=zeros(Nsteps,1);
StatsFeaturesPulse=zeros(Nsteps,5);
StatsFeaturesBasal=zeros(Nsteps,5);
% range, mean, skew, var, kurt
fprintf('>>Steps: ');
% % Check Signals
% figure; H1=subplot(2,1,1); H2=subplot(2,1,2);
% 1 st Loop for Signal Statistical Features Extraction
for n=1:Nsteps
    % Read Records
    y=Xcurrent(n,:);
    x=Xvoltage(n,:);
    % Basal Values
    ybasal=y([1:StartPulseSample-1,EndPulseSample+1:end]);
    xbasal=x([1:StartPulseSample-1,EndPulseSample+1:end]);
    % Pulse Values
    ypulse=y(StartPulseSample:EndPulseSample);
    xpulse=x(StartPulseSample:EndPulseSample);
    % Current Features
    AmplitudePulse(n)=mean(ypulse);
    StepCurrent(n)=AmplitudePulse(n)-mean(ybasal);
    % Voltage Features
    StatsFeaturesPulse(n,:)=[range(xpulse),mean(xpulse),skewness(xpulse),...
                            var(xpulse),kurtosis(xpulse)];
    StatsFeaturesBasal(n,:)=[range(xbasal),mean(xbasal),skewness(xbasal),...
                            var(xbasal),kurtosis(xbasal)];
    if n<Nsteps
        fprintf('%i, ',n);
    else
        fprintf('%i\n',n);
    end
%     % Check Signals
%     plot(H1,x);
%     plot(H2,y)
%     pause
end
Vrest=StatsFeaturesBasal(:,2);
STEP=mean(diff(StepCurrent));
[~,StepZeroIndx]=min(abs(StepCurrent));
[~,VoltageZeroIndx]=min(StatsFeaturesPulse(:,5));
fprintf('>>%i steps of %2.1f amplitude\n\n',Nsteps,STEP);
fprintf('>>Deteced #Pulse with 0-amplitude: %i',StepZeroIndx)
if StepZeroIndx==VoltageZeroIndx
    fprintf(' and no APs\n');
else
    fprintf('\n');
end
%% Action Potentials Detection:
IndxAPs=zeros(Nsteps,1);
% var(Voltage with APs )>var(Voltage without APs ) :
IndxAPs(StatsFeaturesPulse(:,4)>max(StatsFeaturesBasal(:,4)))=1;
fprintf('>>Detected records with Action Potentials: %i\n',sum(IndxAPs));
fprintf('>>Detecting Action Potentials:\n');
% 2nd Loop for Action Potentials
N_APs=zeros(Nsteps,1);
RowNames=cell(Nsteps,1);
for n=1:Nsteps
    % Read Records
    x=Xvoltage(n,:);
    % Pulse Values
    xpulse=x(StartPulseSample:EndPulseSample);
    if IndxAPs(n)
        ActionPotentials=get_APs(xpulse);
        N_APs(n)=size(ActionPotentials,1);
    else
        ActionPotentials=[];
    end
    APs{n}=ActionPotentials;
    RowNames{n}=['Pulse_',num2str(n)];
end
Rate_APs=N_APs/PulseTime;
TimePulse=repmat(PulseTime,Nsteps,1);
FR=table(TimePulse,AmplitudePulse,StepCurrent,N_APs,Rate_APs,Vrest,...
    'RowNames',RowNames,...
'VariableNames',{'Time_Pulse_s','Current_Value','Delta_Current',...
                'N_APs','Firing_Rate','Rest_Potential'});
% Current Amp | Step Curr Amp | N APs | Firing Rate | Vrest | VThreshold
%% Get Table and Save Results