%% Review Data Results
% 
% Visual Inpstecion for APs detection
% 
Import_FinderSpikerAPs;
Action_Magic(Experiment,Xcurrent,Xvoltage,FR,APs,PulseP,fs);
waitfor(gcf);
clear
fprintf('\n>>Complete.\n')