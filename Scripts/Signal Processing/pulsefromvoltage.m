function [StartPulse, LengthPulse] = pulsefromvoltage(Xvoltage,fs)
StartPulse=1;
LengthPulse=1;
[Ns,Samples]=size(Xvoltage);
SizeWin=round(fs/20);
WinIntervals=1:SizeWin:Samples;
ModesSeparation=zeros(Ns,1);
BigAssModes=zeros(Ns,2);
for n=1:Ns
    x=Xvoltage(n,:);
    % Search for record with double modes
    [px,binx]=ksdensity(x, linspace(min(x),max(x),100));
    % Get biggest 2 peaks if any
    [Amp,Position,~,Promin]=findpeaks(px,binx);
    [~,sortedindex]=sort(Promin,'descend');
    if numel(Amp)>1
        Amp=Amp(sortedindex);
        Position=Position(sortedindex);
        ModesSeparation(n) = abs(diff(Position(1:2)));
        BigAssModes(n,:)=[Position(1),Position(2)];
    else
        fprintf('n>>No voltage response')
    end
end
% Use record with biggest difference between modes
[~,indc]=max(ModesSeparation);
InterValue=mean(BigAssModes(indc,:));
x=Xvoltage(indc,:);
Indexes=find(x<InterValue);
AlphaIndex=find(diff(Indexes)>1);
% Segments of the Signal
xstart=x(1:Indexes(AlphaIndex(1)));
xpulse=x(Indexes(AlphaIndex(1)):Indexes(AlphaIndex(end)));
% Start of the Pulse
ystart = smooth(xstart,20);
dystart=diff(ystart);
NegDySamp=find(dystart<0);
StartPulse=NegDySamp(end);
% End of the Pulse
ypulse = smooth(xpulse,round(numel(xpulse)/20),'loess');
dypulse=diff(ypulse);
PosDySamp=find(dystart>0);
LengthPulse=numel(xpulse)+numel(xstart)+1-PosDySamp(end);


