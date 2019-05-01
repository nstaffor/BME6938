function [time_features] = extract_time_features(data,sampling_freq, data_type)
%This function extracts time-domain features of a time series input "data"
%over a 4 second sliding window. The output features are stored in a struct
%for mean, max amplitude, min amplitude, and standard deviation 
% Inputs: 
%   data - from standing, walking, incline, or running
%   sampling_freq - 32 Hz for empatica and 1000 Hz for EMG

% adapted from: https://github.com/yatharthsharma/Activity-Recognition 

window = 4*sampling_freq; %create a sliding window of 4 seconds 
overlap = 2; %50% overlap 

hop = window/overlap;

mean_feat = [];
max_feat = [];
min_feat = [];
std_feat = [];

if data_type ==1
   highpass_filtered = bandpass(data,[30 350], sampling_freq); 
   rectify = abs(highpass_filtered);
   data = lowpass(rectify, 5, sampling_freq);
    
end

for i = 1:hop:(length(data)-window)
    mean_feat = [mean_feat; mean(data(i:i+window,:))];
    max_feat = [max_feat; max(data(i:i+window,:))];
    min_feat = [min_feat; min(data(i:i+window,:))];
    std_feat = [std_feat; std(data(i:i+window,:))];
    
end
  
% account for extra frame
 end_index = i + window-1;
 if length(data)-(i + window-1) > 0
     
    mean_feat = [mean_feat; mean(data(end_index:length(data),:))];
    max_feat = [max_feat; max(data(end_index:length(data),:))];
    min_feat = [min_feat; min(data(end_index:length(data),:))];
    std_feat = [std_feat; std(data(end_index:length(data),:))];
     
time_features = [mean_feat,max_feat,...
    min_feat,std_feat];
end