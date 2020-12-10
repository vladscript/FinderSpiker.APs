% It assumes that APs are evoked ONLY during pulse time:
% Input
%   xpulse: voltage signal of the pulse interval
%   Threshold: varargin
% Output
%   ActionPotentialsTimes: [onset,Amplitude,EoFR]
function ActionPotentials=get_APs(xpulse,varargin)
% Check Signal Features
ActionPotentials=[];
% Denoised Signal
[xden,~]=mini_denoise(xpulse);
if isempty(varargin)
    % Detrend Signal
    fprintf('>Detrending:')
    y=smooth(xpulse,numel(xpulse)/5,'loess');
    fprintf('done.')
    % Check if there are APs
    MaxAmp=max(xden);
    ThresholdDetector=mean([MaxAmp,mean(y)]);
else
    ThresholdDetector=varargin{1};
end
[~,PeakPositions]=findpeaks(xden,'MinPeakHeight',ThresholdDetector);
if numel(PeakPositions)>0
    ActionPotentials=zeros(numel(PeakPositions),3);
    dxden=diff(xden);
    [~,PreValleys]=findpeaks(-dxden);
    for n=1:numel(PeakPositions)
        fprintf('*');
        if n<numel(PeakPositions)
            postPeak=PeakPositions(n+1);
        else
            postPeak=numel(xpulse);
        end
        Npeak=PeakPositions(n);
        PreOnsets=PreValleys(PreValleys<Npeak);
        if numel(PreOnsets)>0
            Onset=PreOnsets(end);
            [~,Nvalley]=min(xden(Npeak:postPeak));
            Ampl=xden(Npeak)-xden(Onset);
            EoFR=Npeak+Nvalley-1;
            ActionPotentials(n,:)=[Onset,Ampl,EoFR];
        end
    end
    fprintf('\n');
else
    disp('[[[[[[   NO ACTION POTENTIALS   ]]]]]]]')
end

% % REVIEW DATA
% ax1=subplot(2,1,1)
% plot(xden); hold on;
% plot(y); grid on;
% ax2=subplot(2,1,2)
% plot(diff(xden),'k'); grid on;
% linkaxes([ax1,ax2],'x')
% axis tight; 
    
