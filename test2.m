

%imds = imageDatastore(".\00_data\" + type + "\train\good","LabelSource","foldernames");
%setDir = fullfile(toolboxdir('vision'),'visiondata','stopSignImages');
%imgSets = imageSet(setDir,'recursive');

setDir  = fullfile(".\00_data\",'bottle','test');
%imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource','foldernames');
%imgSets = imageSet(setDir,'recursive');

%setDir  = fullfile(toolboxdir('vision'),'visiondata','imageSets');
imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource','foldernames');

[trainingSet,testSet] = splitEachLabel(imds,0.3,'randomize');

bag = bagOfFeatures(trainingSet);

categoryClassifier = trainImageCategoryClassifier(trainingSet,bag);

confMatrix = evaluate(categoryClassifier,testSet);

mean(diag(confMatrix));

img = imread(fullfile(setDir,'broken_large','001.png'));
[labelIdx, score] = predict(categoryClassifier,img);
categoryClassifier.Labels(labelIdx)

img = imread(fullfile(setDir,'good','001.png'));
[labelIdx, score] = predict(categoryClassifier,img);
categoryClassifier.Labels(labelIdx);

img = imread(fullfile(setDir,'broken_small','001.png'));
[labelIdx, score] = predict(categoryClassifier,img);
categoryClassifier.Labels(labelIdx)