clear;
%SOUND PRESSURE LEVELS
source = dsp.AudioFileReader("police-siren.wav");
fs = source.SampleRate;

player = audioDeviceWriter(SampleRate=fs);

% scope  = timescope(SampleRate=fs, ...
%     TimeSpanSource="property",TimeSpan=3, ...
%     YLimits=[20 110], ...
%     ShowLegend=true,BufferLength=4*3*fs, ...
%     ChannelNames=["Lt_AF","Leq_A","Lpeak_A","Lmax_AF"], ...
%     Name="Sound Pressure Level Meter");

SPL = splMeter(TimeWeighting="Fast", ...
    FrequencyWeighting="A-weighting", ...
    SampleRate=fs, ...
    TimeInterval=2);

while ~isDone(source)
    x = source();
    player(x);
    [Lt,Leq,Lpeak,Lmax] = SPL(x);
    % scope([Lt,Leq,Lpeak,Lmax])
end

release(source)
release(player)
release(SPL)
% release(scope)

dbMax = max(max(Leq, [], 2));


% TIME DOMAIN TO FREQUENCY DOMAIN
% 1kHz_44100Hz_16bit_05sec.mp3


[audioIn,fs] = audioread("police-siren.wav");
% audioIn(:,2) = [];%incase 2 signals
Lt(:,2) = [];
L_Signal = length(audioIn);
t = (0:L_Signal-1)/fs;
Y_fft = fft(audioIn);
subplot(2,1,1);
plot(fs/L_Signal*(0:L_Signal-1), abs(Y_fft),"LineWidth", 1.5);
title("Frequencyplot");
% Y_2fft = fftshift(Y_fft);
% plot(fs/L_Signal*(-L_Signal/2:L_Signal/2-1), abs(Y_2fft), "LineWidth",1.5);
% title("ShiftedFFt");
P2 = abs(Y_fft);%Double sided spectrum
amp_Spectrum = P2(1:L_Signal/2+1);
amp_Spectrum(2:end-1) = 2*(amp_Spectrum(2:end-1));
f_spectrum = fs/L_Signal*(0:(L_Signal/2));%half freq spectrum
subplot(2,1,2);
plot(f_spectrum,amp_Spectrum,"LineWidth",1.5);
title("Frequency Amplitude Plot");

%GET FUNDAMENTAL FREQ

[max, maxIndex] = max(amp_Spectrum);
FundamentalFrequency = f_spectrum(maxIndex);

%MATHEMATICAL FORMULA(Get A)
A_standard = 18.398; r_a = 2.42; 
V_standard = 2073.49; r_v = 6.34; l = 16.42;
K = 54590.145; % K = c/2pi (mm/sec)
resonantFrequency = K * sqrt(A_standard/V_standard);
%GeometricConstant = (FundamentalFrequency/K) * sqrt(l);
% ini_gConstant = r_a/r_v;
% new_gConstant = (FundamentalFrequency/K) * sqrt(l);
% changingFactor = new_gConstant/ini_gConstant; %mechanical energy change constant

target = 5142;    %target value 
closest = interp1(f_spectrum,f_spectrum,target,'nearest');
freqIndex = find(f_spectrum == closest);
ampAtResonant = amp_Spectrum(freqIndex);
volt_Factor = ampAtResonant/max;

%PIEZOELECTRIC CONVERSION (ASSUME DAMPING FACTOR 1 : CRITICAL DAMPING
%Properties : fres = 18khz : D = 12mm : Y = 6.3 * 10^10 : density = 7700 kg/m^3
%: T = 0.31 um : d31, piezoelectric strain constant = -175
D = 0.012; T = 0.31 * 10^-6 ; d31 = -175 ; Y = 6.3 * 10^10; 
pascalMax = 10.^(dbMax/20);
factor = 0.707^((FundamentalFrequency - resonantFrequency)/126.3);
maxParray = repmat(Lt, length(Lt)/1024, 1); %since operating at resonating freq and critical damping
VoltageGen = (-3.418 * 10^-3).*maxParray * volt_Factor;

