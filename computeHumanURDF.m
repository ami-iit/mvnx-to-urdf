
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

%% computeHumanURDF
% This script allows to create the URDF model of a human subject.
%
% The script requires to:
% - create manually a folder 'data' where storing the raw data;
% - fill a user dialog box with
%   1) the number of the subject (e.g., <1> if the raw data is 'Subj-01.mvnx');
%   2) the number of DoFs of the URDF model (e.g., 48 or 66);
%   3) option for includinf articulated hands/no hands model;
%   4) the mass in [Kg] of the subject (e.g., 60, 60.5);
%   5) the height in [m] of the subject (e.g., 1.70).

%% Preliminaries
clear;clc;close all;
rng(1); % forcing the casual generator to be const

% Add paths
addpath(genpath('src'));
addpath(genpath('data'));
addpath(genpath('templates'));
addpath(genpath('utilities'));
addpath(genpath('external'));

% Path to data
bucket.pathToData = fullfile(pwd,'data');

%% Create a dialog box for user input data
prompt = {'Subject number (e.g., 1):', ...
    'Model DoFs (e.g., 48 or 66):', ...
    'Do you want to include the articulated hands? (y or n)', ...
    'Subject mass [Kg] (e.g., 60, 60.5):',...
    'Subject height [m] (e.g., 1.60):'};
dlgtitle = 'Settings';
userAnswer = inputdlg(prompt, dlgtitle,[1 80]);

% --------------------------- Subject number --------------------------
bucket.subjectID = str2double(cell2mat(userAnswer(1)));
% Path to subject folder
bucket.pathToSubject = fullfile(bucket.pathToData, sprintf('S%03d',bucket.subjectID));
% Path to raw data
bucket.pathToRawData = fullfile(bucket.pathToSubject,'rawData');
% Path to processed data
bucket.pathToProcessedData = fullfile(bucket.pathToSubject,'processed');
if ~exist(bucket.pathToProcessedData)
    mkdir (bucket.pathToProcessedData)
end

% ----------------------------- Model DoFs ----------------------------
if strcmp(userAnswer(2),'48')
    model48DoFs = true;
    model66DoFs = false;
    bucket.dofs = 48;
    bucket.filenameURDF = sprintf(fullfile(bucket.pathToProcessedData, ...
        '/XSensURDF_subj-0%d_%dDoFs.urdf'), ...
        bucket.subjectID, bucket.dofs);
    
    bucket.dofs = str2double(cell2mat(userAnswer(2)));
end
if strcmp(userAnswer(2),'66')
    model48DoFs = false;
    model66DoFs = true;
    bucket.filenameURDF = sprintf(fullfile(bucket.pathToProcessedData, ...
        '/XSensURDF_subj-0%d_%dDoFs.urdf'), ...
        bucket.subjectID, str2double(cell2mat(userAnswer(2))));
    bucket.dofs = str2double(cell2mat(userAnswer(2)));
end

if ~strcmp(userAnswer(2),'48') && ~strcmp(userAnswer(2),'66')
    error('[ERROR] No model template for this number of dof!')
end


% ------------------------- Presence of the hands ----------------------
modelWithHands = false; % by default
if strcmp(userAnswer(3),'y')
    modelWithHands = true;
    
    answer = questdlg('Which kind of hand model do you want to build?', ...
        'Hand model choice', ...
        'Anthropometric','Marker-driven','Anthropometric');
    % Handle response
    switch answer
        case 'Anthropometric'
            userChoice  = 1;
        case 'Marker-driven'
            userChoice  = 2;
    end

    % template 48Dofs with the hands
    if model48DoFs
        bucket.filenameURDF = sprintf(fullfile(bucket.pathToProcessedData, ...
            '/XSensURDF_subj-0%d_%dDoFsHands.urdf'), ...
            bucket.subjectID, bucket.dofs);
    end
    % template 66Dofs with the hands
    if model66DoFs
        error('[ERROR] No 66dof model with articulated hands yet :( To be developed.')
    end
end

% ------------------------- Subject mass ------------------------------
bucket.mass = str2double(cell2mat(userAnswer(4)));

% ------------------------ Subject height -----------------------------
bucket.height = str2double(cell2mat(userAnswer(5)));

%% Print info
disp('==========================================================================');
fprintf('[Start] Computation of Subject_%02d URDF model\n',bucket.subjectID);
fprintf('        - Model with %d DoFs (excluded hand DoFs)\n', bucket.dofs);
if modelWithHands && (userChoice == 1)
    fprintf('        - Model with anthropometric hand model\n');
elseif modelWithHands && (userChoice == 2)
    fprintf('        - Model with markers-driven hand model\n');
else
    fprintf('        - Model without articulated hand\n');
end
fprintf('        - Subject mass: %.2f [kg]\n', str2double(cell2mat(userAnswer(4))));
fprintf('        - Subject height: %.2f [m]\n', str2double(cell2mat(userAnswer(5))));

%% Create SUIT struct
if ~exist(fullfile(bucket.pathToProcessedData,'suit.mat'))
    % 1) ---extract data from .mvnx file
    bucket.mvnxFilename = fullfile(bucket.pathToRawData,sprintf('S%03d.mvnx',bucket.subjectID));
    suit = extractDataFromMvnx(bucket.mvnxFilename);
    
    % 2) ---compute sensor position w.r.t. the links
    bucket.len = round((suit.properties.lenData)/2);
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % IMPORTANT NOTE:
    % this is an assumption!!
    % You can insert a fixed number of frames useful to capture all
    % the movements performed during your own experiment.
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    suit = computeSuitSensorPosition(suit,bucket.len);
    save(fullfile(bucket.pathToProcessedData,'/suit.mat'),'suit');
else
    load(fullfile(bucket.pathToProcessedData,'suit.mat'));
end

%% Extract subject parameters
subjectParamsFromData = subjectParamsComputation(suit, bucket.mass, bucket.height);
if modelWithHands
    subjectParamsFromData = subjectParamsComputation_Hands(subjectParamsFromData, bucket.height, bucket.mass);
    save(fullfile(bucket.pathToProcessedData,'subjectParamsFromData.mat'),'subjectParamsFromData');
    % ---build URDF
    bucket.URDFmodel = createXsensLikeURDFmodel_withHands(bucket.dofs, ...
        subjectParamsFromData, ....
        'filename',bucket.filenameURDF, ...
        'GazeboModel',true);
    
    if userChoice == 2
        computeMarkerDrivenHandModel;
    end
else
    save(fullfile(bucket.pathToProcessedData,'subjectParamsFromData.mat'),'subjectParamsFromData');
    bucket.URDFmodel = createXsensLikeURDFmodel(bucket.dofs, ...
        subjectParamsFromData, ...
        suit.sensors, ...
        'filename',bucket.filenameURDF, ...
        'GazeboModel',true);
end

fprintf('[End]   Computation of Subject_%02d URDF model\n',bucket.subjectID);
disp('==========================================================================');
