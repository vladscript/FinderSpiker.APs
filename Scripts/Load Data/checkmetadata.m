% Function to check etada Intel of ImPatch Files
% Input
%   FileName
%   PathName
% Output
%   Sampling Frequency
%   Samples per Record
%   Date File
%   Data Matrix
function [fs,PointsRec,ExpDate]=checkmetadata(FileName,PathName)
fprintf('>Scanning %s\n',FileName)
fileID = fopen([PathName,FileName]);
C = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
% Resolution: ***********************************
TimeResolution=C{1,1}{1,1};
Res=isstrprop( TimeResolution, 'digit');
SamplesperMS=str2num( TimeResolution(Res>0) );
fs=SamplesperMS*10^3;
% % Points per Record *****************************
NPoints=C{1,1}{2,1};
Points=isstrprop( NPoints, 'digit');
PointsRec=str2num( NPoints(Points>0) );
% % Experiment Date *******************************
ExpDate=C{1,1}{3,1};
fprintf('done.\n')