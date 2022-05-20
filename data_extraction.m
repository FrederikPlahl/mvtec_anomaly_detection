clc;
clear;
close all;

material = ["bottle", "cable", "capsule", "carpet", "grid", "hazelnut", "leather", "metal_nut", "pill", "screw", "tile", "toothbrush", "transistor", "wood", "zipper"];

% Create structs for each element with names and multiple imds
for counter = 1:length(material)
    % Create empty arrays for processing data before saving
    error = {};
    maskFilename = {};
    wrongImages = {};
    allImages = {};

    % First column of the struct is the name of the element
    element(counter).name = material(counter);
    
    % Save images from each element in imds
    imdsMask = imageDatastore("00_data/"+element(counter).name+"/ground_truth/", "FileExtensions",".png", "IncludeSubfolders",true, "LabelSource","foldernames");
    imdsAllImages = imageDatastore("00_data/"+element(counter).name+"/test/","FileExtensions",".png", "IncludeSubfolders",true, "LabelSource","foldernames");
    
    % Sort out all "good" images without error
    for i = 1:length(imdsAllImages.Files)
        if imdsAllImages.Labels(i)=="good"
            wrongImages{end+1,1} = string(imdsAllImages.Files(i));
        end
        allImages{end+1,1} = string(imdsAllImages.Files(i));
    end
    
    for k = 1:length(allImages)
        for j = 1:length(wrongImages)
            if k>length(allImages)
                break
            end
            if string(allImages(k,1))==string(wrongImages(j,1))
                allImages(k,:) = [];
            end
        end
    end
         
    
    
    % Create boundingboxes from masks
    for size = 1:length(imdsMask.Files)
        region = regionprops(imread(imdsMask.Files{size,1}));
        region_table = struct2table(region);
        for field = 1:length(region)
            if region(field).Area > 0
                error{end+1,1} = region(field).BoundingBox;
            end
        end
        maskFilename(size, 1) = imdsMask.Files(size);
    end

    % Second column of the struct is a table with all bb and image-paths
    element(counter).data = table(error);
    element(counter).data.maskFilename = maskFilename;
    element(counter).data.imageFilename = allImages;

    % Third/fourth column of the struct is a table with all bb and image-paths
    % for training/testing

    % Shuffle all data
    rng(0);
    shuffledData = element(counter).data;
    shuffledIdx = randperm(height(shuffledData));
    shuffledData = shuffledData(shuffledIdx,:);
    
    % Train Test Split (80% Train, 20% Test)
    cv = cvpartition(height(shuffledData),'HoldOut',0.2);
    idx = cv.test;
    trainingDataTbl = shuffledData(~idx,:);
    testDataTbl  = shuffledData(idx,:);

    element(counter).data_train = trainingDataTbl;
    element(counter).data_test = testDataTbl;


end
save("element.mat","element")