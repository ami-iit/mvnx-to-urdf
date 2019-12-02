
% This script allows to create the URDF model of a human subject.
%
% The script requires to:
% - create manually a folder 'data' where storing the raw data;
% - fill a user dialog box with
%   1) the number of the subject (e.g., <1> if the raw data is 'Subj-01.mvnx');
%   2) the number of DoFs of the URDF model (e.g., 48 or 66);
%   3) the mass in Kg of the subject.


% Author: Claudia Latella, 2019
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

%% Preliminaries
clear;clc;close all;
rng(1); % forcing the casual generator to be const

% Add paths
addpath(genpath('src'));
addpath(genpath('data'));
addpath(genpath('../src'));
addpath(genpath('../templates'));
addpath(genpath('../utilities'));

% Path to raw data
bucket.pathToRawData = fullfile(pwd,'data/mvnx');

% Path to processed data
bucket.pathToProcessedData = fullfile(pwd,'processed');
if ~exist(bucket.pathToProcessedData)
    mkdir (bucket.pathToProcessedData)
end

%% Create a dialog box for user input data
prompt = {'Subject number (e.g., 1):', ...
    'Model DoFs (e.g., 48 or 66):', ...
    'Do you want to include the hands? (y or n)', ...
    'Subject mass [Kg] (e.g., 60, 60.5):',...
    'Subject height [m] (e.g., 1.60):'};
dlgtitle = 'Settings';
userAnswer = inputdlg(prompt,dlgtitle);

% Subject number
bucket.subjectID = str2double(cell2mat(userAnswer(1)));

% Model DoFs
if strcmp(userAnswer(2),'48')
    model48DoFs = true;
    model66DoFs = false;
    bucket.filenameURDF = sprintf(fullfile(bucket.pathToProcessedData,'/XSensURDF_subj-0%d_%dDoFs.urdf'), ...
        bucket.subjectID, str2double(cell2mat(userAnswer(2))));
end
if strcmp(userAnswer(2),'66')
    model48DoFs = false;
    model66DoFs = true;
    bucket.filenameURDF = sprintf(fullfile(bucket.pathToProcessedData,'/XSensURDF_subj-0%d_%dDoFs.urdf'), ...
        bucket.subjectID, str2double(cell2mat(userAnswer(2))));
end

% Presence of the hands
modelWithHands = false; % by default
if strcmp(userAnswer(3),'y')
    modelWithHands = true;
    % template 48Dofs with the hands
    if model48DoFs
        bucket.filenameURDF = sprintf(fullfile(bucket.pathToProcessedData,'/XSensURDF_subj-0%d_%dDoFsHands.urdf'), ...
            bucket.subjectID, str2double(cell2mat(userAnswer(2))));
    end
    % template 66Dofs with the hands
    if model66DoFs
        % TODO
    end
end

% Subject mass
bucket.mass = str2double(cell2mat(userAnswer(4)));

% Subject height
bucket.height = str2double(cell2mat(userAnswer(5)));

%% Create SUIT struct
disp('==========================================================================');
fprintf('[Start] Computation of Subject_%02d URDF model\n',bucket.subjectID);

if ~exist(fullfile(bucket.pathToProcessedData,'suit.mat'))
    % 1) ---extract data from .mvnx file
    bucket.mvnxFilename = fullfile(bucket.pathToRawData,sprintf('Subj-0%d.mvnx',bucket.subjectID));
    suit = extractDataFromMvnx(bucket.mvnxFilename);
    % 2) ---compute sensor position w.r.t. the links
    bucket.len = round((suit.properties.lenData)/2); % NOTE: this is an assumption!!
    % You can insert a fixed number of frames useful to capture all
    % the movements performed during your own experiment.
    suit = computeSuitSensorPosition(suit,bucket.len);
    save(fullfile(bucket.pathToProcessedData,'/suit.mat'),'suit');
else
    load(fullfile(bucket.pathToProcessedData,'suit.mat'));
end

%% Extract subject parameters from SUIT struct
subjectParamsFromData = subjectParamsComputation(suit, bucket.mass);
if modelWithHands
    subjectParamsFromData = subjectParamsComputation_Hands(subjectParamsFromData, bucket.height, bucket.mass);
end

%% Create URDF model
if modelWithHands
    bucket.URDFmodel = createXsensLikeURDFmodel_withHands(str2double(cell2mat(userAnswer(2))), ...
        subjectParamsFromData, ...
        suit.sensors, ...
        'filename',bucket.filenameURDF, ...
        'GazeboModel',true);
else
    bucket.URDFmodel = createXsensLikeURDFmodel(str2double(cell2mat(userAnswer(2))), ...
        subjectParamsFromData, ...
        suit.sensors, ...
        'filename',bucket.filenameURDF, ...
        'GazeboModel',true);
end
fprintf('[End] Computation of Subject_%02d URDF model\n',bucket.subjectID);
disp('==========================================================================');
