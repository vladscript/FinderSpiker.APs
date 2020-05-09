% Call Directories where ALL scripts are
%% ADDING ALLSCRIPTS
fprintf('\n>>Loading FinderSpiker.APs: ')
if exist('abfload.m','file')
    fprintf('already ')
else
    ActualDir=pwd;
    addpath(genpath([ActualDir,'\Scripts']))
end
fprintf('done.\n\n')