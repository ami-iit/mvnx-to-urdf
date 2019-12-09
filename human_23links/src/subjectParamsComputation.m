function [subjectParams] = subjectParamsComputation(suit, M)
% SUBJECTPARAMSCOMPUTATTION computes sizes for bounding boxes by extracting
% dimensions directly from suit data. The convention for the reference
% frame is that one in Figure 60 of MVN user manual.
%
% Important note1:
% - for pelvis link (the base) the reference frame is located in the point
%   pHipOrigin. This is also the point of the location of the bounding
%   box (so, the point wrt the COM is expressed).
% - for all the other links, the location of the joint reference frame
%   coincides with the bounding box origi (so, the point wrt the COM is
%   expressed).
%
% Important note:
% For those links which are defined with a parallelepiped bounding box, the
% convention for the size vector is: [DIM ALONG x, DIM ALONG y, DIM ALONG z].
% For cylinder bounding boxes x dimension is the diameter.

%% --LINK BASE
%% PELVIS
% joints
[pelvis_struct, ~] = linksFromName(suit.links, 'Pelvis');
[subjectParams.jL5S1, ~] = pointsFromName(pelvis_struct.points, 'jL5S1');
[subjectParams.jLeftHip, ~] = pointsFromName(pelvis_struct.points, 'jLeftHip');
[subjectParams.jRightHip, ~] = pointsFromName(pelvis_struct.points, 'jRightHip');
% box sizes
[pLeftASI, ~] = pointsFromName(pelvis_struct.points, 'pLeftASI');
[pRightASI, ~] = pointsFromName(pelvis_struct.points, 'pRightASI');
[pSacrum, ~] = pointsFromName(pelvis_struct.points, 'pSacrum');
pelvis_x = pLeftASI(1) - pSacrum(1);
pelvis_y = pLeftASI(2) - pRightASI(2);
pelvis_z = subjectParams.jL5S1(3) - subjectParams.jRightHip(3);
subjectParams.pelvisBox = [pelvis_x, pelvis_y, pelvis_z];
% box origin
originWrtRightUpperCorner = 0.5 * [-pelvis_x, pelvis_y, -pelvis_z];     %wrt pRightUpperCorner
subjectParams.pelvisBoxOrigin = [pRightASI(1:2,:)', subjectParams.jL5S1(3)] + originWrtRightUpperCorner ;%wrt pHipOrigin
% mass and inertia
subjectParams.pelvisMass     = 0.08 * M;
subjectParams.pelvisIxx      = (subjectParams.pelvisMass/12) * (pelvis_y^2 + pelvis_z^2);
subjectParams.pelvisIyy      = (subjectParams.pelvisMass/12) * (pelvis_z^2 + pelvis_x^2);
subjectParams.pelvisIzz      = (subjectParams.pelvisMass/12) * (pelvis_x^2 + pelvis_y^2);
% markers
[subjectParams.pHipOrigin, ~] = pointsFromName(pelvis_struct.points, 'pHipOrigin');
[subjectParams.pRightASI, ~] = pointsFromName(pelvis_struct.points, 'pRightASI');
[subjectParams.pLeftASI, ~] = pointsFromName(pelvis_struct.points, 'pLeftASI');
[subjectParams.pRightCSI, ~] = pointsFromName(pelvis_struct.points, 'pRightCSI');
[subjectParams.pLeftCSI, ~] = pointsFromName(pelvis_struct.points, 'pLeftCSI');
[subjectParams.pRightIschialTub, ~] = pointsFromName(pelvis_struct.points, 'pRightIschialTub');
[subjectParams.pLeftIschialTub, ~] = pointsFromName(pelvis_struct.points, 'pLeftIschialTub');
[subjectParams.pSacrum, ~] = pointsFromName(pelvis_struct.points, 'pSacrum');
%% -- CHAIN LINKS 2-7
%% L5
% joints
[L5_struct, ~] = linksFromName(suit.links, 'L5');
[subjectParams.jL4L3, ~] = pointsFromName(L5_struct.points, 'jL4L3');
% box sizes
L5_x = pelvis_x;
L5_y = subjectParams.jLeftHip(2) - subjectParams.jRightHip(2);
L5_z = subjectParams.jL4L3(3);
subjectParams.L5Box = [L5_x, L5_y, L5_z];
% box origin
subjectParams.L5BoxOrigin = 0.5 * [0, 0, L5_z] ;%wrt jL5S1
% mass and inertia
subjectParams.L5Mass       = 0.102 * M;
subjectParams.L5Ixx        = (subjectParams.L5Mass/12) * (L5_y^2 + L5_z^2);
subjectParams.L5Iyy        = (subjectParams.L5Mass/12) * (L5_z^2 + L5_x^2);
subjectParams.L5Izz        = (subjectParams.L5Mass/12) * (L5_x^2 + L5_y^2);
% markers
[subjectParams.pL5SpinalProcess, ~] = pointsFromName(L5_struct.points, 'pL5SpinalProcess');
%% L3
% joints
[L3_struct, ~] = linksFromName(suit.links, 'L3');
[subjectParams.jL1T12, ~] = pointsFromName(L3_struct.points, 'jL1T12');
% box sizes
L3_x = pelvis_x;
L3_y = L5_y;
L3_z = subjectParams.jL1T12(3);
subjectParams.L3Box = [L3_x, L3_y, L3_z];
% box origin
subjectParams.L3BoxOrigin = 0.5 * [0, 0, L3_z] ;%wrt jL4L3
% mass and inertia
subjectParams.L3Mass       = 0.102 * M;
subjectParams.L3Ixx        = (subjectParams.L3Mass/12) * (L3_y^2 + L3_z^2);
subjectParams.L3Iyy        = (subjectParams.L3Mass/12) * (L3_z^2 + L3_x^2);
subjectParams.L3Izz        = (subjectParams.L3Mass/12) * (L3_x^2 + L3_y^2);
% markers
[subjectParams.pL3SpinalProcess, ~] = pointsFromName(L3_struct.points, 'pL3SpinalProcess');
%% T12
% joints
[T12_struct, ~] = linksFromName(suit.links, 'T12');
[subjectParams.jT9T8, ~] = pointsFromName(T12_struct.points, 'jT9T8');
% box sizes
T12_x = pelvis_x;
T12_y = L5_y;
T12_z = subjectParams.jT9T8(3);
subjectParams.T12Box = [T12_x, T12_y, T12_z];
% box origin
subjectParams.T12BoxOrigin = 0.5 * [0, 0, T12_z] ;%wrt jL1T12
% mass and inertia
subjectParams.T12Mass       = 0.102 * M;
subjectParams.T12Ixx        = (subjectParams.T12Mass/12) * (T12_y^2 + T12_z^2);
subjectParams.T12Iyy        = (subjectParams.T12Mass/12) * (T12_z^2 + T12_x^2);
subjectParams.T12Izz        = (subjectParams.T12Mass/12) * (T12_x^2 + T12_y^2);
% markers
[subjectParams.pT12SpinalProcess, ~] = pointsFromName(T12_struct.points, 'pT12SpinalProcess');
%% T8
% joints
[T8_struct, ~] = linksFromName(suit.links, 'T8');
[subjectParams.jT1C7, ~] = pointsFromName(T8_struct.points, 'jT1C7');
[subjectParams.jRightT4Shoulder, ~] = pointsFromName(T8_struct.points, 'jRightT4Shoulder');
[subjectParams.jLeftT4Shoulder, ~] = pointsFromName(T8_struct.points, 'jLeftT4Shoulder');
% box sizes
[pC7SpinalProcess, ~] = pointsFromName(T8_struct.points, 'pC7SpinalProcess');
[pPX, ~] = pointsFromName(T8_struct.points, 'pPX');
T8_x = pPX(1) - pC7SpinalProcess(1);
T8_y = subjectParams.jLeftT4Shoulder(2) - subjectParams.jRightT4Shoulder(2) ;
T8_z = subjectParams.jT1C7(3);
subjectParams.T8Box = [T8_x, T8_y, T8_z];
% box origin
subjectParams.T8BoxOrigin = 0.5 * [0, 0, T8_z] ;%wrt jT9T8
% mass and inertia
subjectParams.T8Mass     = 0.04 * M;
subjectParams.T8Ixx      = (subjectParams.T8Mass/12) * (T8_y^2 + T8_z^2);
subjectParams.T8Iyy      = (subjectParams.T8Mass/12) * (T8_z^2 + T8_x^2);
subjectParams.T8Izz      = (subjectParams.T8Mass/12) * (T8_x^2 + T8_y^2);
% markers
[subjectParams.pPX, ~] = pointsFromName(T8_struct.points, 'pPX');
[subjectParams.pIJ, ~] = pointsFromName(T8_struct.points, 'pIJ');
[subjectParams.pT4SpinalProcess, ~] = pointsFromName(T8_struct.points, 'pT4SpinalProcess');
[subjectParams.pT8SpinalProcess, ~] = pointsFromName(T8_struct.points, 'pT8SpinalProcess');
[subjectParams.pC7SpinalProcess, ~] = pointsFromName(T8_struct.points, 'pC7SpinalProcess');
%% NECK
% joints
[neck_struct, ~] = linksFromName(suit.links, 'Neck');
[subjectParams.jC1Head, ~] = pointsFromName(neck_struct.points, 'jC1Head');
% box sizes
[pC7SpinalProcess, ~] = pointsFromName(neck_struct.points, 'pC7SpinalProcess');
subjectParams.neck_x = abs(pC7SpinalProcess(1));
subjectParams.neck_z = subjectParams.jC1Head(3);
% box origin
subjectParams.neckBoxOrigin = 0.5 * [0, 0, subjectParams.neck_z] ;%wrt jT1C7
% mass and inertia
subjectParams.neckMass       = 0.012 * M;
subjectParams.neckIxx        = (subjectParams.neckMass/12) * (3 * subjectParams.neck_x^2 + subjectParams.neck_z^2);
subjectParams.neckIyy        = (subjectParams.neckMass/12) * (3 * subjectParams.neck_x^2 + subjectParams.neck_z^2);
subjectParams.neckIzz        = (subjectParams.neckMass/2) * (subjectParams.neck_x^2);
%% HEAD
% box sizes
[head_struct, ~] = linksFromName(suit.links, 'Head');
[pTopHead, ~] = pointsFromName(head_struct.points, 'pTopOfHead');
subjectParams.head_z = abs(pTopHead(3));
% box origin
subjectParams.headBoxOrigin = 0.5 * [0, 0, subjectParams.head_z] ;%wrt C1Head
% mass and inertia
subjectParams.headMass     = 0.036 * M;
subjectParams.headIxx      = (2 * subjectParams.headMass/5) * ((subjectParams.head_z/2)^2);
subjectParams.headIyy      = (2 * subjectParams.headMass/5) * ((subjectParams.head_z/2)^2);
subjectParams.headIzz      = (2 * subjectParams.headMass/5) * ((subjectParams.head_z/2)^2);
% markers
[subjectParams.pTopOfHead, ~] = pointsFromName(head_struct.points, 'pTopOfHead');
[subjectParams.pRightAuricularis, ~] = pointsFromName(head_struct.points, 'pRightAuricularis');
[subjectParams.pLeftAuricularis, ~] = pointsFromName(head_struct.points, 'pLeftAuricularis');
[subjectParams.pBackOfHead, ~] = pointsFromName(head_struct.points, 'pBackOfHead');
%% -- CHAIN LINKS 8-11
%% RIGHT SHOULDER
% joints
[rightShoulder_struct, ~] = linksFromName(suit.links, 'RightShoulder');
[subjectParams.jRightShoulder, ~] = pointsFromName(rightShoulder_struct.points, 'jRightShoulder');
% box sizes
[pRightAcromion, ~] = pointsFromName(rightShoulder_struct.points, 'pRightAcromion');
subjectParams.rightSho_y = abs(subjectParams.jRightShoulder(2));
subjectParams.rightSho_z = abs(pRightAcromion(3)); % assumption!!!!!
% box origin
subjectParams.rightShoulderBoxOrigin = 0.5 * [0, -subjectParams.rightSho_y, 0];%wrt jRightT4Shoulder
% mass and inertia
subjectParams.rightShoulderMass       = 0.031 * M;
subjectParams.rightShoulderIxx        = (subjectParams.rightShoulderMass/12) * (3 * (subjectParams.rightSho_z/2)^2 + subjectParams.rightSho_y^2);
subjectParams.rightShoulderIyy        = (subjectParams.rightShoulderMass/2) * ((subjectParams.rightSho_z/2)^2);
subjectParams.rightShoulderIzz        = (subjectParams.rightShoulderMass/12) * (3 * (subjectParams.rightSho_z/2)^2 + subjectParams.rightSho_y^2);
% markers
[subjectParams.pRightAcromion, ~] = pointsFromName(rightShoulder_struct.points, 'pRightAcromion');
%% RIGHT UPPER ARM
% joints
[rightUpperArm_struct, ~] = linksFromName(suit.links, 'RightUpperArm');
[subjectParams.jRightElbow, ~] = pointsFromName(rightUpperArm_struct.points, 'jRightElbow');
% box sizes
[pRightArmLatEp, ~] = pointsFromName(rightUpperArm_struct.points, 'pRightArmLatEpicondyle');
[pRightArmMedEp, ~] = pointsFromName(rightUpperArm_struct.points, 'pRightArmMedEpicondyle');
subjectParams.rightUpperArm_y = abs(subjectParams.jRightElbow(2));
subjectParams.rightUpperArm_z = pRightArmLatEp(3) - pRightArmMedEp(3);
% box origin
subjectParams.rightUpperArmBoxOrigin = 0.5 * [0, -subjectParams.rightUpperArm_y, 0];%wrt jRightShoulder
% mass and inertia
subjectParams.rightUpperArmMass       = 0.030 * M;
subjectParams.rightUpperArmIxx        = (subjectParams.rightUpperArmMass/12) * (3 * (subjectParams.rightUpperArm_z/2)^2 + subjectParams.rightUpperArm_y^2);
subjectParams.rightUpperArmIyy        = (subjectParams.rightUpperArmMass/2) * ((subjectParams.rightUpperArm_z/2)^2);
subjectParams.rightUpperArmIzz        = (subjectParams.rightUpperArmMass/12) * (3 * (subjectParams.rightUpperArm_z/2)^2 + subjectParams.rightUpperArm_y^2);
% markers
[subjectParams.pRightArmLatEpicondyle, ~] = pointsFromName(rightUpperArm_struct.points, 'pRightArmLatEpicondyle');
[subjectParams.pRightArmMedEpicondyle, ~] = pointsFromName(rightUpperArm_struct.points, 'pRightArmMedEpicondyle');
%% RIGHT FOREARM
% joints
[rightForearm_struct, ~] = linksFromName(suit.links, 'RightForeArm');
[subjectParams.jRightWrist, ~] = pointsFromName(rightForearm_struct.points, 'jRightWrist');
% box sizes
subjectParams.rightForeArm_y = abs(subjectParams.jRightWrist(2));
subjectParams.rightForeArm_z = 2/3 * subjectParams.rightUpperArm_z; % assumption!!!
% box origin
subjectParams.rightForeArmBoxOrigin = 0.5 * [0, -subjectParams.rightForeArm_y, 0];%wrt jRightElbow
% mass and inertia
subjectParams.rightForeArmMass       = 0.020 * M;
subjectParams.rightForeArmIxx        = (subjectParams.rightForeArmMass/12) * (3 * (subjectParams.rightForeArm_z/2)^2 + subjectParams.rightForeArm_y^2);
subjectParams.rightForeArmIyy        = (subjectParams.rightForeArmMass/2) * ((subjectParams.rightForeArm_z/2)^2);
subjectParams.rightForeArmIzz        = (subjectParams.rightForeArmMass/12) * (3 * (subjectParams.rightForeArm_z/2)^2 + subjectParams.rightForeArm_y^2);
% markers
[subjectParams.pRightUlnarStyloid, ~] = pointsFromName(rightForearm_struct.points, 'pRightUlnarStyloid');
[subjectParams.pRightRadialStyloid, ~] = pointsFromName(rightForearm_struct.points, 'pRightRadialStyloid');
[subjectParams.pRightOlecranon, ~] = pointsFromName(rightForearm_struct.points, 'pRightOlecranon');
%% RIGHT HAND
% box sizes
[rightHand_struct, ~] = linksFromName(suit.links, 'RightHand');
[pTopHand, ~] = pointsFromName(rightHand_struct.points, 'pRightTopOfHand');
rightHand_y = abs(pTopHand(2));
rightHand_x = 2/3 * rightHand_y; % assumption!!!
rightHand_z = subjectParams.rightForeArm_z; % assumption!!!
subjectParams.rightHandBox = [rightHand_x, rightHand_y, rightHand_z];
% box origin
subjectParams.rightHandBoxOrigin = 0.5 * [0, -rightHand_y, 0];%wrt jRightWrist
% Mass and inertia
subjectParams.rightHandMass     = 0.006 * M;
subjectParams.rightHandIxx      = (subjectParams.rightHandMass/12) * (rightHand_y^2 + rightHand_z^2);
subjectParams.rightHandIyy      = (subjectParams.rightHandMass/12) * (rightHand_x^2 + rightHand_z^2);
subjectParams.rightHandIzz      = (subjectParams.rightHandMass/12) * (rightHand_x^2 + rightHand_y^2);
% markers
[subjectParams.pRightTopOfHand, ~] = pointsFromName(rightHand_struct.points, 'pRightTopOfHand');
[subjectParams.pRightPinky, ~] = pointsFromName(rightHand_struct.points, 'pRightPinky');
[subjectParams.pRightBallHand, ~] = pointsFromName(rightHand_struct.points, 'pRightBallHand');
%% -- CHAIN LINKS 12-15
%% LEFT SHOULDER
% joints
[leftShoulder_struct, ~] = linksFromName(suit.links, 'LeftShoulder');
[subjectParams.jLeftShoulder, ~] = pointsFromName(leftShoulder_struct.points, 'jLeftShoulder');
% box sizes
[pLeftAcromion, ~] = pointsFromName(leftShoulder_struct.points, 'pLeftAcromion');
subjectParams.leftSho_y = abs(subjectParams.jLeftShoulder(2));
subjectParams.leftSho_z = abs(pLeftAcromion(3)); % assumption!!!!!
% box origin
subjectParams.leftShoulderBoxOrigin = 0.5 * [0, subjectParams.leftSho_y, 0];%wrt jLeftT4Shoulder
% mass and inertia
subjectParams.leftShoulderMass       = 0.031 * M;
subjectParams.leftShoulderIxx        = (subjectParams.leftShoulderMass/12) * (3 * (subjectParams.leftSho_z/2)^2 + subjectParams.leftSho_y^2);
subjectParams.leftShoulderIyy        = (subjectParams.leftShoulderMass/2) * ((subjectParams.leftSho_z/2)^2);
subjectParams.leftShoulderIzz        = (subjectParams.leftShoulderMass/12) * (3 * (subjectParams.leftSho_z/2)^2 + subjectParams.leftSho_y^2);
% markers
[subjectParams.pLeftAcromion, ~] = pointsFromName(leftShoulder_struct.points, 'pLeftAcromion');
%% LEFT UPPER ARM
% joints
[leftUpperArm_struct, ~] = linksFromName(suit.links, 'LeftUpperArm');
[subjectParams.jLeftElbow, ~] = pointsFromName(leftUpperArm_struct.points, 'jLeftElbow');
% box sizes
[pLeftArmLatEp, ~] = pointsFromName(leftUpperArm_struct.points, 'pLeftArmLatEpicondyle');
[pLeftArmMedEp, ~] = pointsFromName(leftUpperArm_struct.points, 'pLeftArmMedEpicondyle');
subjectParams.leftUpperArm_y = abs(subjectParams.jLeftElbow(2));
subjectParams.leftUpperArm_z = pLeftArmLatEp(3) - pLeftArmMedEp(3);
% box origin
subjectParams.leftUpperArmBoxOrigin = 0.5 * [0, subjectParams.leftUpperArm_y, 0];%wrt jLeftShoulder
% mass and inertia
subjectParams.leftUpperArmMass       = 0.030 * M;
subjectParams.leftUpperArmIxx        = (subjectParams.leftUpperArmMass/12) * (3 * (subjectParams.leftUpperArm_z/2)^2 + subjectParams.leftUpperArm_y^2);
subjectParams.leftUpperArmIyy        = (subjectParams.leftUpperArmMass/2) * ((subjectParams.leftUpperArm_z/2)^2);
subjectParams.leftUpperArmIzz        = (subjectParams.leftUpperArmMass/12) * (3 * (subjectParams.leftUpperArm_z/2)^2 + subjectParams.leftUpperArm_y^2);
% markers
[subjectParams.pLeftArmLatEpicondyle, ~] = pointsFromName(leftUpperArm_struct.points, 'pLeftArmLatEpicondyle');
[subjectParams.pLeftArmMedEpicondyle, ~] = pointsFromName(leftUpperArm_struct.points, 'pLeftArmMedEpicondyle');
%% LEFT FOREARM
% joints
[leftForearm_struct, ~] = linksFromName(suit.links, 'LeftForeArm');
[subjectParams.jLeftWrist, ~] = pointsFromName(leftForearm_struct.points, 'jLeftWrist');
% box sizes
subjectParams.leftForeArm_y = abs(subjectParams.jLeftWrist(2));
subjectParams.leftForeArm_z = 2/3 * subjectParams.leftUpperArm_z; % assumption!!!
% box origin
subjectParams.leftForeArmBoxOrigin = 0.5 * [0, subjectParams.leftForeArm_y, 0];%wrt jLeftElbow
% mass and inertia
subjectParams.leftForeArmMass       = 0.020 * M;
subjectParams.leftForeArmIxx        = (subjectParams.leftForeArmMass/12) * (3 * (subjectParams.leftForeArm_z/2)^2 + subjectParams.leftForeArm_y^2);
subjectParams.leftForeArmIyy        = (subjectParams.leftForeArmMass/2) *  ((subjectParams.leftForeArm_z/2)^2) ;
subjectParams.leftForeArmIzz        = (subjectParams.leftForeArmMass/12) *(3 * (subjectParams.leftForeArm_z/2)^2 + subjectParams.leftForeArm_y^2);
% markers
[subjectParams.pLeftUlnarStyloid, ~] = pointsFromName(leftForearm_struct.points, 'pLeftUlnarStyloid');
[subjectParams.pLeftRadialStyloid, ~] = pointsFromName(leftForearm_struct.points, 'pLeftRadialStyloid');
[subjectParams.pLeftOlecranon, ~] = pointsFromName(leftForearm_struct.points, 'pLeftOlecranon');
%% LEFT HAND
% box sizes
[leftHand_struct, ~] = linksFromName(suit.links, 'LeftHand');
[pTopHand, ~] = pointsFromName(leftHand_struct.points, 'pLeftTopOfHand');
leftHand_y = abs(pTopHand(2));
leftHand_x = 2/3 * leftHand_y; % assumption!!!
leftHand_z = subjectParams.leftForeArm_z; % assumption!!!
subjectParams.leftHandBox = [leftHand_x, leftHand_y, leftHand_z];
% box origin
subjectParams.leftHandBoxOrigin = 0.5 * [0, leftHand_y, 0];%wrt jLeftWrist
% Mass and inertia
subjectParams.leftHandMass     = 0.006 * M;
subjectParams.leftHandIxx      = (subjectParams.leftHandMass/12) * (leftHand_y^2 + leftHand_z^2);
subjectParams.leftHandIyy      = (subjectParams.leftHandMass/12) * (leftHand_x^2 + leftHand_z^2);
subjectParams.leftHandIzz      = (subjectParams.leftHandMass/12) * (leftHand_x^2 + leftHand_y^2);
% markers
[subjectParams.pLeftTopOfHand, ~] = pointsFromName(leftHand_struct.points, 'pLeftTopOfHand');
[subjectParams.pLeftPinky, ~] = pointsFromName(leftHand_struct.points, 'pLeftPinky');
[subjectParams.pLeftBallHand, ~] = pointsFromName(leftHand_struct.points, 'pLeftBallHand');
%% -- CHAIN LINKS 16-19
%% RIGHT UPPER LEG
% joints
[rightUpperLeg_struct, ~] = linksFromName(suit.links, 'RightUpperLeg');
[subjectParams.jRightKnee, ~] = pointsFromName(rightUpperLeg_struct.points, 'jRightKnee');
% box size
[pRightTro, ~] = pointsFromName(rightUpperLeg_struct.points, 'pRightGreaterTrochanter');
[pRightKneeUL, ~] = pointsFromName(rightUpperLeg_struct.points, 'pRightKneeMedEpicondyle');
subjectParams.rightUpperLeg_x = pRightKneeUL(2) - pRightTro(2);
subjectParams.rightUpperLeg_z = abs(subjectParams.jRightKnee(3));
% box origin
subjectParams.rightUpperLegBoxOrigin = 0.5 * [0, 0, -subjectParams.rightUpperLeg_z];%wrt jRightHip
% mass and inertia
subjectParams.rightUpperLegMass       = 0.125 * M;
subjectParams.rightUpperLegIxx        = (subjectParams.rightUpperLegMass/12) * (3 * (subjectParams.rightUpperLeg_x/2)^2 + subjectParams.rightUpperLeg_z^2);
subjectParams.rightUpperLegIyy        = (subjectParams.rightUpperLegMass/12) * (3 * (subjectParams.rightUpperLeg_x/2)^2 + subjectParams.rightUpperLeg_z^2);
subjectParams.rightUpperLegIzz        = (subjectParams.rightUpperLegMass/2) * ((subjectParams.rightUpperLeg_x/2)^2);
% markers
[subjectParams.pRightGreaterTrochanter, ~] = pointsFromName(rightUpperLeg_struct.points, 'pRightGreaterTrochanter');
[subjectParams.pRightPatella, ~] = pointsFromName(rightUpperLeg_struct.points, 'pRightPatella');
%% RIGHT LOWER LEG
% joints
[rightLowerLeg_struct, ~] = linksFromName(suit.links, 'RightLowerLeg');
[subjectParams.jRightAnkle, ~] = pointsFromName(rightLowerLeg_struct.points, 'jRightAnkle');
% box size
[pRightKneeLatLL, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightKneeLatEpicondyle');
[pRightKneeMedLL, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightKneeMedEpicondyle');
subjectParams.rightLowerLeg_x = pRightKneeMedLL(2) - pRightKneeLatLL(2);
subjectParams.rightLowerLeg_z = abs(subjectParams.jRightAnkle(3));
% box origin
subjectParams.rightLowerLegBoxOrigin = 0.5 * [0, 0, -subjectParams.rightLowerLeg_z];%wrt jRightKnee
% mass and inertia
subjectParams.rightLowerLegMass     = 0.0365 * M;
subjectParams.rightLowerLegIxx      = (subjectParams.rightLowerLegMass/12) * (3 * (subjectParams.rightLowerLeg_x/2)^2 + subjectParams.rightLowerLeg_z^2);
subjectParams.rightLowerLegIyy      = (subjectParams.rightLowerLegMass/12) * (3 * (subjectParams.rightLowerLeg_x/2)^2 + subjectParams.rightLowerLeg_z^2);
subjectParams.rightLowerLegIzz      = (subjectParams.rightLowerLegMass/2) * ((subjectParams.rightLowerLeg_x/2)^2);
% markers
[subjectParams.pRightKneeLatEpicondyle, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightKneeLatEpicondyle');
[subjectParams.pRightKneeMedEpicondyle, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightKneeMedEpicondyle');
[subjectParams.pRightLatMalleolus, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightLatMalleolus');
[subjectParams.pRightMedMalleolus, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightMedMalleolus');
[subjectParams.pRightTibialTub, ~] = pointsFromName(rightLowerLeg_struct.points, 'pRightTibialTub');
%% RIGHT FOOT
% joints
[rightFoot_struct, ~] = linksFromName(suit.links, 'RightFoot');
[subjectParams.jRightBallFoot, ~] = pointsFromName(rightFoot_struct.points, 'jRightBallFoot');
% box sizes
[pRightHeel, ~] = pointsFromName(rightFoot_struct.points, 'pRightHeelFoot');
rightFoot_x = subjectParams.jRightBallFoot(1) - pRightHeel(1);
rightFoot_y = subjectParams.rightLowerLeg_x; % assumption!!!
rightFoot_z = abs(pRightHeel(3));
subjectParams.rightFootBox = [rightFoot_x, rightFoot_y, rightFoot_z];
% box origin
originWrtRightHeel = 0.5 * [rightFoot_x, 0, rightFoot_z]; %wrt pRightHeelFoot
subjectParams.rightFootBoxOrigin = pRightHeel' + originWrtRightHeel ;%wrt jRightAnkle
% mass and inertia
subjectParams.rightFootMass      = 0.0130 *  M;
subjectParams.rightFootIxx       = (subjectParams.rightFootMass/12) * (rightFoot_y^2 + rightFoot_z^2);
subjectParams.rightFootIyy       = (subjectParams.rightFootMass/12) * (rightFoot_x^2 + rightFoot_z^2);
subjectParams.rightFootIzz       = (subjectParams.rightFootMass/12) * (rightFoot_x^2 + rightFoot_y^2);
% markers
[subjectParams.pRightHeelFoot, ~] = pointsFromName(rightFoot_struct.points, 'pRightHeelFoot');
[subjectParams.pRightFirstMetatarsal, ~] = pointsFromName(rightFoot_struct.points, 'pRightFirstMetatarsal');
[subjectParams.pRightFifthMetatarsal, ~] = pointsFromName(rightFoot_struct.points, 'pRightFifthMetatarsal');
[subjectParams.pRightPivotFoot, ~] = pointsFromName(rightFoot_struct.points, 'pRightPivotFoot');
[subjectParams.pRightHeelCenter, ~] = pointsFromName(rightFoot_struct.points, 'pRightHeelCenter');
%% RIGHT TOE
% box sizes
[rightToe_struct, ~] = linksFromName(suit.links, 'RightToe');
[pRightToe, ~] = pointsFromName(rightToe_struct.points, 'pRightToe');
rightToe_x = abs(pRightToe(1));
rightToe_y = rightFoot_y; % assumption!!!
rightToe_z = abs(pRightToe(3));
subjectParams.rightToeBox = [rightToe_x, rightToe_y, rightToe_z];
% box origin
subjectParams.rightToeBoxOrigin = 0.5 * [rightToe_x, 0, 0];%wrt jRightKnee
% mass and inertia
subjectParams.rightToeMass      = 0.0015 * M;
subjectParams.rightToeIxx       = (subjectParams.rightToeMass/12) * (rightToe_y^2 + rightToe_z^2);
subjectParams.rightToeIyy       = (subjectParams.rightToeMass/12) * (rightToe_x^2 + rightToe_z^2);
subjectParams.rightToeIzz       = (subjectParams.rightToeMass/12) * (rightToe_x^2 + rightToe_y^2);
% markers
[subjectParams.pRightToe, ~] = pointsFromName(rightToe_struct.points, 'pRightToe');
%% -- CHAIN LINKS 20-23
%% LEFT UPPER LEG
% joints
[leftUpperLeg_struct, ~] = linksFromName(suit.links, 'LeftUpperLeg');
[subjectParams.jLeftKnee, ~] = pointsFromName(leftUpperLeg_struct.points, 'jLeftKnee');
% box size
[pLeftTro, ~] = pointsFromName(leftUpperLeg_struct.points, 'pLeftGreaterTrochanter');
[pLeftKneeUL, ~] = pointsFromName(leftUpperLeg_struct.points, 'pLeftKneeMedEpicondyle');
subjectParams.leftUpperLeg_x = pLeftKneeUL(2) - pLeftTro(2);
subjectParams.leftUpperLeg_z = abs(subjectParams.jLeftKnee(3));
% box origin
subjectParams.leftUpperLegBoxOrigin = 0.5 * [0, 0, -subjectParams.leftUpperLeg_z];%wrt jLeftHip
% mass and inertia
subjectParams.leftUpperLegMass       = 0.125 * M;
subjectParams.leftUpperLegIxx        = (subjectParams.leftUpperLegMass/12) * (3 * (subjectParams.leftUpperLeg_x/2)^2 + subjectParams.leftUpperLeg_z^2);
subjectParams.leftUpperLegIyy        = (subjectParams.leftUpperLegMass/12) * (3 * (subjectParams.leftUpperLeg_x/2)^2 + subjectParams.leftUpperLeg_z^2);
subjectParams.leftUpperLegIzz        = (subjectParams.leftUpperLegMass/2) * ((subjectParams.leftUpperLeg_x/2)^2);
% markers
[subjectParams.pLeftGreaterTrochanter, ~] = pointsFromName(leftUpperLeg_struct.points, 'pLeftGreaterTrochanter');
[subjectParams.pLeftPatella, ~] = pointsFromName(leftUpperLeg_struct.points, 'pLeftPatella');
%% LEFT LOWER LEG
% joints
[leftLowerLeg_struct, ~] = linksFromName(suit.links, 'LeftLowerLeg');
[subjectParams.jLeftAnkle, ~] = pointsFromName(leftLowerLeg_struct.points, 'jLeftAnkle');
% box size
[pLeftKneeLatLL, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftKneeLatEpicondyle');
[pLeftKneeMedLL, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftKneeMedEpicondyle');
subjectParams.leftLowerLeg_x = abs(pLeftKneeMedLL(2) - pLeftKneeLatLL(2));
subjectParams.leftLowerLeg_z = abs(subjectParams.jLeftAnkle(3));
% box origin
subjectParams.leftLowerLegBoxOrigin = 0.5 * [0, 0, -subjectParams.leftLowerLeg_z];%wrt jLeftKnee
% mass and inertia
subjectParams.leftLowerLegMass     = 0.0365 * M;
subjectParams.leftLowerLegIxx      = (subjectParams.leftLowerLegMass/12) * (3 * (subjectParams.leftLowerLeg_x/2)^2 + subjectParams.leftLowerLeg_z^2);
subjectParams.leftLowerLegIyy      = (subjectParams.leftLowerLegMass/12) * (3 * (subjectParams.leftLowerLeg_x/2)^2 + subjectParams.leftLowerLeg_z^2);
subjectParams.leftLowerLegIzz      = (subjectParams.leftLowerLegMass/2) * ((subjectParams.leftLowerLeg_x/2)^2);
% markers
[subjectParams.pLeftKneeLatEpicondyle, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftKneeLatEpicondyle');
[subjectParams.pLeftKneeMedEpicondyle, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftKneeMedEpicondyle');
[subjectParams.pLeftLatMalleolus, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftLatMalleolus');
[subjectParams.pLeftMedMalleolus, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftMedMalleolus');
[subjectParams.pLeftTibialTub, ~] = pointsFromName(leftLowerLeg_struct.points, 'pLeftTibialTub');
%% LEFT FOOT
% joints
[leftFoot_struct, ~] = linksFromName(suit.links, 'LeftFoot');
[subjectParams.jLeftBallFoot, ~] = pointsFromName(leftFoot_struct.points, 'jLeftBallFoot');
% box sizes
[pLeftHeel, ~] = pointsFromName(leftFoot_struct.points, 'pLeftHeelFoot');
leftFoot_x = subjectParams.jLeftBallFoot(1) - pLeftHeel(1);
leftFoot_y = subjectParams.leftLowerLeg_x; % assumption!!!
subjectParams.leftFoot_z = abs(pLeftHeel(3));
subjectParams.leftFootBox = [leftFoot_x, leftFoot_y, subjectParams.leftFoot_z];
% box origin
originWrtLeftHeel = 0.5 * [leftFoot_x, 0, subjectParams.leftFoot_z]; %wrt pLeftHeelFoot
subjectParams.leftFootBoxOrigin = pLeftHeel' + originWrtLeftHeel ;%wrt jLeftAnkle
% mass and inertia
subjectParams.leftFootMass      = 0.0130 *  M;
subjectParams.leftFootIxx       = (subjectParams.leftFootMass/12) * (leftFoot_y^2 + subjectParams.leftFoot_z^2);
subjectParams.leftFootIyy       = (subjectParams.leftFootMass/12) * (leftFoot_x^2 + subjectParams.leftFoot_z^2);
subjectParams.leftFootIzz       = (subjectParams.leftFootMass/12) * (leftFoot_x^2 + leftFoot_y^2);
% markers
[subjectParams.pLeftHeelFoot, ~] = pointsFromName(leftFoot_struct.points, 'pLeftHeelFoot');
[subjectParams.pLeftFirstMetatarsal, ~] = pointsFromName(leftFoot_struct.points, 'pLeftFirstMetatarsal');
[subjectParams.pLeftFifthMetatarsal, ~] = pointsFromName(leftFoot_struct.points, 'pLeftFifthMetatarsal');
[subjectParams.pLeftPivotFoot, ~] = pointsFromName(leftFoot_struct.points, 'pLeftPivotFoot');
[subjectParams.pLeftHeelCenter, ~] = pointsFromName(leftFoot_struct.points, 'pLeftHeelCenter');
%% LEFT TOE
% box sizes
[leftToe_struct, ~] = linksFromName(suit.links, 'LeftToe');
[pLeftToe, ~] = pointsFromName(leftToe_struct.points, 'pLeftToe');
leftToe_x = abs(pLeftToe(1));
leftToe_y = rightFoot_y; % assumption!!!
leftToe_z = abs(pLeftToe(3));
subjectParams.leftToeBox = [leftToe_x, leftToe_y, leftToe_z];
% box origin
subjectParams.leftToeBoxOrigin = 0.5 * [leftToe_x, 0, 0];%wrt jLeftKnee
% mass and inertia
subjectParams.leftToeMass      = 0.0015 * M;
subjectParams.leftToeIxx       = (subjectParams.leftToeMass/12) * (leftToe_y^2 + leftToe_z^2);
subjectParams.leftToeIyy       = (subjectParams.leftToeMass/12) * (leftToe_x^2 + leftToe_z^2);
subjectParams.leftToeIzz       = (subjectParams.leftToeMass/12) * (leftToe_x^2 + leftToe_y^2);
% markers
[subjectParams.pLeftToe, ~] = pointsFromName(leftToe_struct.points, 'pLeftToe');
end
