% Specify the folder where the files live.
myFolder = '/Users/rxnkshitij748/Documents/MATLAB/PROJECT/Hospital noise original/test3files';
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
    uiwait(warndlg(errorMessage));
    myFolder = uigetdir(); % Ask for a new one.
    if myFolder == 0
         % User clicked Cancel
         return;
    end
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.wav'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
numberfiles = length(theFiles);
powerArraywithTune = [1,numberfiles];
powerArraywithoutTune = [1,numberfiles];
for n = 1 : numberfiles
    filepath = string(theFiles(n).folder) + "/" + string(theFiles(n).name);
    powerGenTune = PowerwithTuning(filepath);
    powerGenwithoutTune = PowerwithoutTuning(filepath);
    powerArraywithTune(n) = powerGenTune;
    powerArraywithoutTune(n) = powerGenwithoutTune;
end

total_powerwithTune = sum(powerArraywithTune);
total_powerwithoutTune = nansum(powerArraywithoutTune);

