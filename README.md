# Finder Spiker.APs 

## Action Potential Features Extraction
![Logo](/Figures/Logo_FinderSpiker---APs.png)

### Experiment Profile (Patch Clamp):
* Current Squared Steps 
* Voltage Recordings

# See [**Quick User Guide**](http://htmlpreview.github.io/?https://github.com/vladscript/FinderSpiker.APs/blob/master/html/User_Guide.html)

## Reads Data from
### [ImPatch](http://impatch.ifc.unam.mx/) Files (Current & Voltage Files)CSV, 
### pCLAMP files [ABF](https://mdc.custhelp.com/app/answers/detail/a_id/16506/~/pclamp%3A-versions-of-the-abf-file-format-are-associated-with-which-software) (see [abfload.m](https://github.com/fcollman/abfload))
### copy-paste @EXCEL files from newer versions of pCLAMP

### INPUT FILES:

### EXPERIMENT_ID.abf
* Files acquired with [pclamp](https://mdc.custhelp.com/app/products/detail/p/95/session/L2F2LzEvdGltZS8xNTg5MDAxNTU0L2dlbi8xNTg5MDAxNTU0L3NpZC9mVXlVYzFMdGhoM1pENE54cVQ4X3d3eDZrdmpMOF9MN29lUDB5dThTUkxLNXZMa0lual8xcUp6emE5aVVWNHFlUU9vaUZQR05KSVJzQmZkYzFyWXklN0VuRmc1WTVpME1ENE9abGxWZ3dxQSU3RXpZaTR1elQwRHFKbV9BJTIxJTIx) versions <10
* Read units from file
### EXPERIMENT_ID.csv
* Separated Voltage and Current Files
* From [ImPatch](http://impatch.ifc.unam.mx/)
### EXPERIMENT_ID.xlsx
* Time      in ms
* Voltage   in mV
* Current   in pA
 
## OUTPUTS FILES

### Feature Table of Experiment
EXPERIMENT_ID_FR.csv

### Data MATLAB file for posterior analysis:
* EXPERIMENT_ID.mat @ '.../FinderSPike.APs/Processed Data/' folder



### 3rd Party Software
- Harald Hentschke (2020). [abfload](https://www.mathworks.com/matlabcentral/fileexchange/6190-abfload) MATLAB Central File Exchange.# FinderSpiker.APs
