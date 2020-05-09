%% $\bf{FinderSpiker.APs}$
% 
% *SOURCE* :
% <https://github.com/vladscript/FinderSpiker.APs>
% 
% |Steps Guide|
%% 1. AUTOMATIC FIRING RATES DETECTION
% 
% RUN:
% 
% * >>FinderSpiker_ActionPotentials
% 
% *Input* (see Demo Data)
% 
%   -ABF
%   -CSV V & I files
%   -XLSX
% 
% *Outputs*
% 
%   -   Preview of the Data (single current pulse and voltage record)
% 
%   -   Feature Table       @ csv File whose columns are:
% 
%  TimeLength_s | CurrentValue | Delta_Current | N_APs | FiringRate | MeanFreq_Hz | Rest_Potential
% 
%   -   Action Potentials,APs variable, @mat File which contains for each AP:
% 
%  Onset | Amplitude | EoFR
% 
%% 2. REVIEW DATA:
% 
% * Load .mat File (only if no data @ workspace)
% 
% RUN:
% 
% * >>Action_Potentials_Check
% 
% Use mode:
% 
% - Left and Right Arrows Switch Current Pulse 
% 
% - If missed APs: click on the *Voltage* *Axis* to define an *amplitude* threshold using
% *mouse* *cursor*
% 
% - Close and SAVE to *UPDATE*
% 
% - Close and CANCEL to *DISCARD*