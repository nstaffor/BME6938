# BME6938 Final Project SVM Activity Classifer

We assume that the user has already extracted the data they want to process for a given subject from the raw data sets on Figshare (Ingraham et al) with the corresponding classification labels in a struct. Data must be stored in a struct with each entry corresponding to a subject's given sensor measurement. Running the first section of this script will create a feature struct for a given subject. In this first section, raw data is transformed into time and frequency features (such as mean, median, zero-crossing, etc.). The second section of the script loads all the structs for each subject and creates a large matrix. The user can specify  which activities should be included and the number of subjects to be included in the training and testing set. Then, the script will generate a matrix with the feature data corresponding to the training and testing subject selection as well as a matrix with the ground truth activity labels. 

The files extract_time_features.m and extract_frequency_features.m are the functions that take in a matrix of data and output the matrix of selected features. For example, the user specifies if the input data is EMG or IMU data and the output is a matrix corresponding to the time or frequency features we selected such as zero crossing mean and median. 

There are already a couple of preprocessed data files included in the repository. For example, testing_all_filtered.mat, training_all_filtered.mat are training and testing data corresponding to the feature selection done with the filtered EMG data. If you download SVM_Model.m, you should be setup to run the testing_all_filtered.mat and training_all_filtered.mat files with the SVM_model.m script. 

The other sample data set included is TrainSubject_XY.mat and Test_XY.mat. This data corresponds to unfiltered EMG data for the classes of walking, standing, inclined walking and running. To run the SVM model on this data, the user will need to load the appropriate file in the script and will have to change the training and testing features names to the ones corresponding to the loaded data file. For instance the XTest and YTest would need to be changed to the variable corresponding the the names in Test_XY.mat. The other parameter that a user will need to change depending on the data set is the class_testing variable. The activities that are in data set should correspond to the numbers in the class_testing matrix:
1 = standing
2 = Walking
3 = Inclined walking
4 = Running
5 = Cycling
For example, the testing_all_filtered.mat  has standing, walking, inclined walking, running and cycling in it, so the class_testing matrix should include 1,2,3,4,5. The only other parameters a user might want to change is if they want to run the hyperparameter optimization. To do this, a user would comment out the current model and uncomment the model labeled as hyperparameter estimation. 
