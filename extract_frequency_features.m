function [frequency_features] = extract_frequency_features(data,sampling_freq, data_type)
%This function extracts frequency-domain features of a time series input "data"
%over a 4 second sliding window. The output features are stored in a struct
%for mean, max amplitude, min amplitude, and standard deviation 
% Inputs: 
%   data - from standing, walking, incline, or running
%   sampling_freq - 32 Hz for empatica and 1000 Hz for EMG

% adapted from: https://github.com/yatharthsharma/Activity-Recognition
window = 4*sampling_freq; %create a sliding window of 4 seconds 
overlap = 2; %50% overlap 

hop = window/overlap;

% band pass filteres data for EMG
if data_type ==1
   highpass_filtered = bandpass(data,[30 350], sampling_freq); 
   data = highpass_filtered;
    
end
zcd = dsp.ZeroCrossingDetector;

% different feature extractions
zero_cross_feat = [];
emg_integrate_feat = [];
freq_mean = [];
freq_median = [];

% data converted to frequency domain
freq_data = fft(data);
count = 0;
for i = 1:hop:(length(data)-window-1)
   % for zero crossing
    zero_cross_feat = [zero_cross_feat; zcd(data(i:i+window-1,:))];
    % for emg integration
    emg_integrate_feat = [emg_integrate_feat; trapz(abs(data(i:i+window-1,:)))];
    % calculate mean in frequency domain
    freq_mean = [freq_mean; mean(freq_data(i:i+window-1,:))];
    % calculate median in frequency domain
    freq_median = [freq_median; median(freq_data(i:i+window-1,:))];
    count = count +1;
end

 % accounts for if window does not divide evenly into the window
 end_index = i + window-1;
 if length(data)-(i + window-1) > 0
    % for zero crossing
    zcd = dsp.ZeroCrossingDetector;
    zero_cross_feat = [zero_cross_feat; zcd(data(end_index:length(data),:))];
    % for emg integration
    emg_integrate_feat = [emg_integrate_feat; trapz(abs(data(end_index:length(data),:)))];
    % calculate mean in frequency domain
    freq_mean = [freq_mean; mean(freq_data(end_index:length(data),:))];
    % calculate median in frequency domain
    freq_median = [freq_median; median(freq_data(end_index:length(data),:))];
 end
 
frequency_features = [double(zero_cross_feat), emg_integrate_feat, freq_mean, freq_median];
end 