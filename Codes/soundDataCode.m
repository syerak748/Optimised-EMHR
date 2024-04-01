[audioIn,fs] = audioread("/Users/rxnkshitij748/Documents/MATLAB/PROJECT/DRILLAUDIO.mp3");
audioIn(:,2) = [];
t = (0:length(audioIn)-1)/fs;
plot(t,audioIn);
audioIn1 = transpose(audioIn);
%sound(audioIn1, fs);
t1 = (0:length(audioIn1)-1)/fs;
DrillSignal = transpose([t ; audioIn1]);