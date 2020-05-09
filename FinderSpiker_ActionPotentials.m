%%  FinderSpiker.APs
% Action Potentiall Features:
% INPUT
%  Experiment Data: ABF, CSV or xlx file
% OUTPUT
% .CSV Table of Features
% .mat File for posterioir anlaysis
%% Setup 
clc; clear; close all;
Import_FinderSpikerAPs;
%% LOAD DATA 
% Select kind of file:
% ABF/EXCEL/CSV
choiceFile=0;
fprintf('>>Select type of data file of the experiment:\n');
fprintf('\n 1)ABF\n')
fprintf('   Files acquired with pCLAMP versions <10\n')
fprintf('   Read units from file\n')
fprintf('\n 2)CSV\n')
fprintf('   ImPatch aquisition\n')
fprintf('   Separated Voltage and Current Files\n')
fprintf('\n 3)XLSX:\n')
fprintf('   Time      in ms\n')
fprintf('   Voltage   in mV\n')
fprintf('   Current   in pA\n')
while choiceFile==0
    choiceFile = menu('Choose a Data File Type','ABF','CSV','XLSX');
end
switch choiceFile
    case 1
        fprintf('>>ABF file for versions <2\n')
        [Xcurrent,Xvoltage,fs,FileName]=load_VI_abf;
        EndStr=find(FileName=='.');
        FileName=FileName(1:EndStr-1);
    case 2
        fprintf('>>CSV files: separated current and voltage files\n')
        [Xvoltage,Xcurrent,fs,FileName]=Load_Impatch_Files;
    case 3
        fprintf('>>XLSX file for copy-paste from pCLAMP to excel file\n')
        [Xvoltage,Xcurrent,fs,FileName]=Load_VI_excel;
        EndStr=find(FileName=='.');
        FileName=FileName(1:EndStr-1);
end
% Check Experiment ID
ExpIDDef{1}=FileName;
% Confirm ID of the Experiment
ExpInput= inputdlg('Experiment ID: ','Confirm unique ID:/Press Canel to use default', [1 75],ExpIDDef);
if ~isempty(ExpInput)
    Experiment=ExpInput{1};
    Experiment(Experiment==' ')='_'; % REPLACE SpaceS with '_'
end
fprintf('>>Experiment ID: %s\n',Experiment);
%% Get Firing Rates
[FR,APs,PulseP]=getfiringrate(Xcurrent,Xvoltage,fs);
fprintf('>>Completed Automatic Detection\n')
%% Save mat File
fprintf('>>Saving data: ')
FolderNamePD='Processed Data\';
% Direcotry to Save: Up from  this one (pwd)
FileDirSave=pwd;
slashes=find(FileDirSave=='\');
FileDirSave=FileDirSave(1:slashes(end));
if ~isdir([FileDirSave,FolderNamePD])
    fprintf('Folder [%s] created,',FolderNamePD)
    mkdir([FileDirSave,FolderNamePD]);
end
save([FileDirSave,FolderNamePD,Experiment,'.mat'],'Experiment','Xcurrent',...
    'Xvoltage','fs','FR','APs','PulseP');
fprintf('done.\n')
%% Save Table
fprintf('>>Saving Table: ')
FolderTable='Firing Tables\';
if ~isdir([FileDirSave,FolderTable])
    fprintf('Directory [%s] created',FolderTable)
    mkdir([FileDirSave,FolderTable]);
end
writetable(FR,[FileDirSave,FolderTable,Experiment,'_FR.csv'],...
        'Delimiter',',','QuoteStrings',true);
fprintf('done.\n')
disp(FR);
fprintf('>>Table saved @: \n%s\n%s\n',...
    [FileDirSave,FolderTable],[Experiment,'_FR.csv'])
fprintf('>>APs Intel @: \n%s\n%s\n',...
    [FileDirSave,FolderNamePD],[Experiment,'.mat'])
fprintf('>>For Visual Inspection Run: \n>>Action_Potentials_Check\n')