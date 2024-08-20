
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

%% main_markerDrivenHandModel
% This script allows to build the hand model (into the human URDF)
% starting from a standard marker acquisition.
%
% The script requires to have a subject .mat where the raw markers
% acquisition data have been stored.  This .mat must contain:
% - a list of the markers label (e.g., marker_list);
% - a vector for the time acquisition (e.g., Time);
% - a substruct per each marker containing the position of the marker over
%   time during the acquisition (e.g., palm.xyz, wrist.xyz, ...)

%% Extract markers data
disp('-------------------------------------------------------------------');
disp('[Start] Markers dataset extraction ...');
% Load the masterFile
masterFile = load(fullfile(bucket.pathToRawData,sprintf(('S%03d.mat'),bucket.subjectID)));
markersDataExtraction;
disp('[End] Dataset extraction');

%% Section for markers-driven hand in URDF
% 1) ---Compute the distance between markers
markersDistance = computeMarkersDistance(masterFile);

% 2) ---Compute the parameters for the hand
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % IMPORTANT NOTE:
    % In this section we have only the parameters related to the right
    % hand. Data are copied for the left hand.
    % If you have markers on top of the left hand, the code can be modified
    % accordingly.
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subjectParamsFromData = subjectParamsComputation_markersDrivenHand ...
    (subjectParamsFromData, markersDistance, bucket.mass);
save(fullfile(bucket.pathToProcessedData,'subjectParamsFromData.mat'),'subjectParamsFromData');

% 3) ---Build the URDF model
bucket.URDFmodel    = createXsensLikeURDFmodel_withHands(bucket.dofs, subjectParamsFromData, ...
    'filename',bucket.filenameURDF, 'GazeboModel',true);

%% Clearvars
clearvars tmp;
