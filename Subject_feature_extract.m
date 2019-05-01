% creates subject data file off both requency and time features extracted
% you must update the data inputed to correspond to which subject you want
% to extract the features for at the begining here and in the subject data
% file name at the bottom part of the script
%% ****Make sure to change to make a struct with the correct subject name!!!******
data_EMG = EMG_3;
data_IMU = empatica_3;
sample_freq_EMG = 1000; % Hz
sample_freq_IMU = 32; % Hz



data_label = [];
subject_features = [];
feilds = fieldnames(data_EMG);

% for loop that extracts features for each of the different activites per
% subject
for i= 1:numel(feilds)
    if( isnumeric(data_EMG.(feilds{i})) )
        % for the functions for extracting time and frequency features you
        % must specify if it is EMG or IMU data becuase the function will
        % filter the data differntly. If you are imputing EMG place a 1 as
        % the last input to the function if it is IMU use 0
        frequency_features_EMG = extract_frequency_features(data_EMG.(feilds{i})(:,1:8),sample_freq_EMG,1);
        time_features_EMG = extract_time_features(data_EMG.(feilds{i})(:,1:8),sample_freq_EMG,1);
        % creates frequency feature vectors for IMU data
        frequency_features_IMU = extract_frequency_features(data_IMU.(feilds{i})(:,1:3),sample_freq_IMU,0);
        time_features_IMU = extract_time_features(data_IMU.(feilds{i})(:,1:3),sample_freq_IMU,0);
    
        len = size(frequency_features_EMG);
        data_label = [data_label; i*ones(len(1),1)];
    end
  % creates the feature and label vector for one subject and all thier
  % differerent activities
  features = [frequency_features_EMG,  time_features_EMG, frequency_features_IMU, time_features_IMU];
  subject_features = [subject_features; features];
end 
%% ****Make sure to change to make a struct with the correct subject name!!!******
Subject3_Data_Labels = struct('X', subject_features, 'Y', data_label);

%% create data sets without certain activities can use this after you have one large feature and label vector of all 
% existing data for a subject and then can pick and choose which activities
% should be included to test on different conditions

%create testing data and remove certain activity
% activity to include
% activity codes: 1. standing, 2. walking, 3. incline walking, 4. running,
% 5. cycling
% the numbers included in the array create a training and testing set with
% that activities data
number = [1,2,4,5];

training_features = [];
training_labels = [];

testing_features = [];
testing_labels = [];

% for making testing data
for k = [1,2,3,4,5,7,8]
    file = load(['Subject',num2str(k),'_filtered.mat']);
    f = fieldnames(file)
    subField = fieldnames(file.(f{1}));
    label = file.(f{1}).(subField{2});
    features = file.(f{1}).(subField{1});
    
    % find features want to include
    for i = number
    index = find(label== i);
    % creates training feature and label set that you then can save from the
    % workspace
    training_features = [training_features; features(index,:)]; 
    training_labels = [training_labels; label(index)];
    
    end
end

% for making training data
% k corresponds to which subjects you want to include in the testing set
% right now just subjects 9 and 10 are included
for k = [9,10]
    file = load(['Subject',num2str(k),'_filtered.mat']);
    f = fieldnames(file)
    subField = fieldnames(file.(f{1}));
    label = file.(f{1}).(subField{2});
    features = file.(f{1}).(subField{1});
    
    % find features want to include
    for i = number
    index = find(label== i);
    % creates testing feature and label set that you then can save from the
    % workspace
    testing_features = [testing_features; features(index,:)]; 
    testing_labels = [testing_labels; label(index)];
    
    end
end