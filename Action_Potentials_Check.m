%% Review Data Results
% 
% Visual Inpstecion for APs detection
% 
Import_FinderSpikerAPs;
Action_Magic(Experiment,Xcurrent,Xvoltage,FR,APs,PulseP,fs);
% Print User Guide
fprintf('\n Keys:')
fprintf('\n Pulse Navigation: <- Left and Right -> Arrows\n')
fprintf('\n Add Action Potential')
fprintf('\n 1) Click on Voltage AXIS')
fprintf('\n 2) Drag cursor on new Voltage threshold\n')
fprintf('\n Update results')
fprintf('\n 1) Close and save on .mat file\n')
waitfor(gcf);
clear
fprintf('\n>>Complete.\n')