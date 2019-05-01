% SVM Decomposition for Activity Recognition 
clear all;

% input in the desired training data set
load testing_all_filtered.mat 

test_features = real(training_features);
test_labels = training_labels;

%% For testing data
% loading testing data which we spcecified as that last two subjects 9 and 10 in our case   
load('testing_all_filtered.mat')  
XTest = real(testing_features);
YTest = testing_labels;
%%
% specifies which activities should be included in the model based on which
% data set is selected 
% 1. standing
% 2. walking
% 3. inclined walking
% 4. running
% 5. cycling
class_testing = [1,2,3,4,5];

 %% PCA
 % conducts PCA to narrow down the feature vector inputed into the SVM
 % model
[E1, A1, L1] = pca(test_features); 
figure()
plot(L1, 'o')
%%
% look at the plot generated which shows the varrience corresponding with
% each extracted PCA feature and we choose the first 9 features as our
% feature vector for our SVM model
test_features = A1(:,1:9);
test = horzcat(test_features,test_labels); %small_test;

% assigning featues and labels for training SVM Model
labels = test(:,end);%test_random(:,end);
features = test(:,1:end-1);%test_random(:,1:end-1);

%% Parameter Selection
% initalizin template that determins our parameters for the SVM model
% the parameters that are used are ones generated from MATLAB's
% hyperparameter tunning

% the commented out one is if you want to change the parameters of the
% model
%t = templateSVM('Standardize',true,'KernelFunction','gaussian', 'BoxConstraint',17.656, 'KernelScale', 284.22);
t = templateSVM('Standardize',true,'KernelFunction','gaussian');

%% Model Training
% makes results reproducible
rng default
% optomizing hyper parameters model uses parallel computation to try to
% increase the speed of calculation
options = statset('UseParallel',true);
% 
% uncoment this model if you want to do they hyperparemter estimation
% [Model, HyperParameterResults] = fitcecoc(features,labels,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'),...
%     'ClassNames',class_testing,...
%      'Options', options)

% Leave this model uncommented if you want to use default parameters 
Model = fitcecoc(features,labels,'Learners',t,'FitPosterior',true,...
    'ClassNames',class_testing,...
    'Verbose',2)
[label,~,~,Posterior] = resubPredict(Model,'Verbose',1);

idx = randsample(size(features,1),10,1);
Model.ClassNames

% displays the code matrix which disinguishes the code for each label
CodingMat = Model.CodingMatrix
 
% computes training error
error_training = resubLoss(Model)

 
%% For Prediction

% conducts PCA to reduce the number of features stick with using 9 features
% since that is what we trained the model on
[E2, A2, L2] = pca(XTest); 
XTest = A2(:,1:9);


test = horzcat(XTest,YTest);
test_random = test(randperm(size(test,1)),:);
% randomize the order of the testing data
YTest = test_random(:,end);
XTest= test_random(:,1:end-1);

% shows 10 samples the model has classified and compared to thier true
% labels
[label,score] = predict(Model,XTest);
table(YTest(1:10),label(1:10),score(1:10,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})
% calculating how many predictions from the model were correct compatred to
% the data's true label
Loss = loss(Model, XTest,YTest)

%% Plot Confusion Matrix
activity_num = class_testing; 
matrix = zeros(length(activity_num),length(YTest));
matrix_predict = zeros(length(activity_num),length(YTest));

% turns actual and predicted labels into one hot vectors to create
% confusion matrix chart
for i = 1:length(activity_num)
    index = find(YTest==activity_num(i));
    index_pred = find(label==activity_num(i));
    matrix(i,index) = 1;
    matrix_predict(i,index_pred) = 1;
end
    plotconfusion(matrix,matrix_predict)
    
   % Caclulates Confusion Matrix Data, but does not display in chart 
    C = confusionmat(YTest,label)
    
