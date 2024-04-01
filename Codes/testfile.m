%resonance curve 
% V = 2073.49;
% A = 18.398;
% l = 3.16;
% q_factor = 2*3.14*sqrt(V*((l/A)^3));
% res_freq = 5142;
% BW = 5142/q_factor;

resonant_freq = K * sqrt(A_standard/(V_standard*la));
target = resonant_freq;    %target value 
closest = interp1(f_spectrum,f_spectrum,target,'nearest');
freqIndex = find(f_spectrum == closest);
ampAtResonant = amp_Spectrum(freqIndex);
volt_Factor = ampAtResonant/max;

