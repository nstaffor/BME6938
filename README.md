# BME6938 Final Project SVM Activity Classifer

We assume that the user has already extracted the data they want to process for a given subject from the raw data sets on Figshare (Ingraham et al) with the corresponding classification labels in a struct. Data must be stored in a struct with each entry corresponding to a subject's given sensor measurement. Running the first section of the Subject_feature_extract.m script will create a feature struct for a given subject. In this first section, raw data is transformed into time and frequency features (such as mean, median, zero-crossing, etc.). The second section of the script loads all the structs for each subject and creates a large matrix. The user can specify  which activities should be included and the number of subjects to be included in the training and testing set. Then, the script will generate a matrix with the feature data corresponding to the training and testing subject selection as well as a matrix with the ground truth activity labels. This Subject_feature_extract.m script gives the user the flexibility to load specific subject's data, assign subjects to different testing/training groups, and output subsets of the activities into the training/testing matrices. If you want to try this script out, download the "SampleSubjectsDataExtracted.mat" file and follow the comments in the Subject_feature_extract.m. This sample .mat file contains a very small subset of the subject data. 

(NOTE: 
The files extract_time_features.m and extract_frequency_features.m are the functions that take in a matrix of data and output the matrix of selected features. For example, the user specifies if the input data is EMG or IMU data and the output is a matrix corresponding to the time or frequency features we selected such as zero crossing mean and median.) 

Let's assume you've already used the Subject_feature_extract.m script to extract features and create the large training and testing matrices. You may have outputed something like the "testing_all_filtered.mat" and "training_all_filtered.mat" files (found in the repository). These .mat files are training and testing data corresponding to feature selection done on Subjects 1-10 (excluding Subject 6) using Filtered EMG data and all activity types. If you download main.m, you should be setup to run the testing_all_filtered.mat and training_all_filtered.mat files with the main.m script. 

The other sample data set included is TrainSubject_XY.mat and Test_XY.mat. This data corresponds to unfiltered EMG data for the classes of walking, standing, inclined walking and running. To run the SVM model on this data, the user will need to load the appropriate file in the script and will have to change the training and testing features names to the ones corresponding to the loaded data file. For instance the XTest and YTest would need to be changed to the variable corresponding the the names in Test_XY.mat. The other parameter that a user will need to change depending on the data set is the class_testing variable. The activities that are in data set should correspond to the numbers in the class_testing matrix:
1 = standing
2 = Walking
3 = Inclined walking
4 = Running
5 = Cycling.
For example, the testing_all_filtered.mat  has standing, walking, inclined walking, running and cycling in it, so the class_testing matrix should include 1,2,3,4,5. The only other parameters a user might want to change is if they want to run the hyperparameter optimization. To do this, a user would comment out the current model and uncomment the model labeled as hyperparameter estimation. 
