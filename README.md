# Finder Spiker.APs 

## Action Potential Features Extraction
![Logo](/Figures/Logo_FinderSpiker---APs.png)

### Experiment Profile (Patch Clamp):
* Current Squared Steps 
* Voltage Recordings

# See [**Quick User Guide**](http://htmlpreview.github.io/?https://github.com/vladscript/FinderSpiker.APs/blob/master/html/User_Guide.html)

Reads CSV, EXCEL and ABF files (version <2)

## INPUT FILES:

* EXPERIMENT_ID.abf
	Files acquired with pclamp versions <10
	Read units from file
* EXPERIMENT_ID.csv
	Separated Voltage and Current Files
	From ImPatch
* EXPERIMENT_ID.xlsx
	Time      in ms
	Voltage   in mV
	Current   in pA
 
* OUTPUTS

Feature Table of Experiment
EXPERIMENT_ID_FR.csv

Data MATLAB file for posterior analysis:
EXPERIMENT_ID.mat @ '.../FinderSPike.APs/Processed Data/' folder



### 3hd Party Software
- Harald Hentschke (2020). [abfload](https://www.mathworks.com/matlabcentral/fileexchange/6190-abfload) MATLAB Central File Exchange.# FinderSpiker.APs
