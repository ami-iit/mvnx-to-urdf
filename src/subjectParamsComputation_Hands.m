
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [subjectParams] = subjectParamsComputation_Hands(subjectParams, H, M)
% SUBJECTPARAMSCOMPUTATION_HANDS computes the bounding boxes for the anthropometric
% model of the human hands.

%% Total mass of the hand
totalHandMass = 0.006 * M; % from anthropometric assumption

%% --RIGHT HAND
%% RIGHT PALM
% box sizes for the entire palm considered as a whole parallelepiped
rightPalm_x = 0.0482 * H; % HB,from anthropometric assumption
rightPalm_y = 0.0657 * H; % PL,from anthropometric assumption
rightPalm_z = subjectParams.rightForeArm_z/2; % model assumption
right_finger_x = 1/4 * rightPalm_x; % model assumption
% RIGHT PALM CLOSE TO THE THUMB (half of the right palm)
% box sizes
subjectParams.rightPalmCloseToThumbBox = [rightPalm_x/2, rightPalm_y, rightPalm_z];
% box origin
subjectParams.jRightPalm_rotyOrigin = [0, -1/2 * rightPalm_y, 0]; % wrt jRightWrist
subjectParams.rightPalmCloseToThumbBoxOrigin = [1/4 * rightPalm_x, -1/2 * rightPalm_y, 0]; % wrt jRightWrist
% Mass and inertia
subjectParams.rightPalmCloseToThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParams.rightPalmCloseToThumbIxx  = (subjectParams.rightPalmCloseToThumbMass/12) * (rightPalm_y^2 + rightPalm_z^2);
subjectParams.rightPalmCloseToThumbIyy  = (subjectParams.rightPalmCloseToThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_z^2);
subjectParams.rightPalmCloseToThumbIzz  = (subjectParams.rightPalmCloseToThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_y^2);
% -----
% RIGHT PALM FAR FROM THE THUMB (half of the right palm)
% box sizes
subjectParams.rightPalmFarFromThumbBox = [rightPalm_x/2, rightPalm_y, rightPalm_z];
% box origin
subjectParams.rightPalmFarFromThumbBoxOrigin = [-1/4 * rightPalm_x, 0, 0]; % jRightPalm_roty
% Mass and inertia
subjectParams.rightPalmFarFromThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParams.rightPalmFarFromThumbIxx  = (subjectParams.rightPalmFarFromThumbMass/12) * (rightPalm_y^2 + rightPalm_z^2);
subjectParams.rightPalmFarFromThumbIyy  = (subjectParams.rightPalmFarFromThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_z^2);
subjectParams.rightPalmFarFromThumbIzz  = (subjectParams.rightPalmFarFromThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_y^2);
%% RIGHT PINKY
totalPinkyLength = 0.0356 * H; % LFL,from anthropometric assumption
totalPinkyMass   = (7 * totalHandMass)/100; % 7% of the total hand mass, assumption!!!
% RIGHT PINKY1
% box sizes
subjectParams.rightPinky1_y = 1/2 * totalPinkyLength; % from anthropometric assumption
subjectParams.rightPinky1_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightPinky1_rotxOrigin = [-3/8 * rightPalm_x, -1/2 * rightPalm_y, 0]; % wrt jRightPalm_roty
subjectParams.rightPinky1BoxOrigin    = 1/2 * [0, -subjectParams.rightPinky1_y, 0]; % wrt jRightPinky1_rotx
% Mass and inertia
subjectParams.rightPinky1Mass = 1/3 * totalPinkyMass;
subjectParams.rightPinky1Ixx  = (subjectParams.rightPinky1Mass/12) * (3 * (subjectParams.rightPinky1_z/2)^2 + subjectParams.rightPinky1_y^2);
subjectParams.rightPinky1Iyy  = (subjectParams.rightPinky1Mass/2)  * ((subjectParams.rightPinky1_z/2)^2) ;
subjectParams.rightPinky1Izz  = (subjectParams.rightPinky1Mass/12) * (3 * (subjectParams.rightPinky1_z/2)^2 + subjectParams.rightPinky1_y^2);
% -----
% RIGHT PINKY2
% box sizes
subjectParams.rightPinky2_y = 3/10 * totalPinkyLength; % from anthropometric assumption
subjectParams.rightPinky2_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightPinky2_rotxOrigin = [0, -subjectParams.rightPinky1_y, 0]; % wrt jRightPinky1_rotx
subjectParams.rightPinky2BoxOrigin    = 1/2 * [0, -subjectParams.rightPinky2_y, 0]; % wrt jRightPinky2_rotx
% Mass and inertia
subjectParams.rightPinky2Mass = 1/3 * totalPinkyMass;
subjectParams.rightPinky2Ixx  = (subjectParams.rightPinky2Mass/12) * (3 * (subjectParams.rightPinky2_z/2)^2 + subjectParams.rightPinky2_y^2);
subjectParams.rightPinky2Iyy  = (subjectParams.rightPinky2Mass/2)  * ((subjectParams.rightPinky2_z/2)^2) ;
subjectParams.rightPinky2Izz  = (subjectParams.rightPinky2Mass/12) * (3 * (subjectParams.rightPinky2_z/2)^2 + subjectParams.rightPinky2_y^2);
% -----
% RIGHT PINKY3
% box sizes
subjectParams.rightPinky3_y = 1/5 * totalPinkyLength; % from anthropometric assumption
subjectParams.rightPinky3_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightPinky3_rotxOrigin = [0, -subjectParams.rightPinky2_y, 0]; % wrt jRightPinky2_rotx
subjectParams.rightPinky3BoxOrigin    = 1/2 * [0, -subjectParams.rightPinky3_y, 0]; % wrt jRightPinky3_rotx
% Mass and inertia
subjectParams.rightPinky3Mass = 1/3 * totalPinkyMass;
subjectParams.rightPinky3Ixx  = (subjectParams.rightPinky3Mass/12) * (3 * (subjectParams.rightPinky3_z/2)^2 + subjectParams.rightPinky3_y^2);
subjectParams.rightPinky3Iyy  = (subjectParams.rightPinky3Mass/2)  * ((subjectParams.rightPinky3_z/2)^2) ;
subjectParams.rightPinky3Izz  = (subjectParams.rightPinky3Mass/12) * (3 * (subjectParams.rightPinky3_z/2)^2 + subjectParams.rightPinky3_y^2);
%% RIGHT RING FINGER
totalRingLength = 0.0428 * H; % RFL,from anthropometric assumption
totalRingMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% RIGHT RING1
% box sizes
subjectParams.rightRing1_y = 1/2 * totalRingLength; % from anthropometric assumption
subjectParams.rightRing1_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightRing1_rotxOrigin = [-1/8 * rightPalm_x, -1/2 * rightPalm_y, 0]; % wrt jRightPalm_roty
% subjectParams.jRightRing1_rotxOrigin = [-1/8 * rightPalm_x, -rightPalm_y, 0]; % wrt jRightWrist
subjectParams.rightRing1BoxOrigin    = 1/2 * [0, -subjectParams.rightRing1_y, 0]; % wrt jRightRing1_rotx
% Mass and inertia
subjectParams.rightRing1Mass = 1/3 * totalRingMass;
subjectParams.rightRing1Ixx  = (subjectParams.rightRing1Mass/12) * (3 * (subjectParams.rightRing1_z/2)^2 + subjectParams.rightRing1_y^2);
subjectParams.rightRing1Iyy  = (subjectParams.rightRing1Mass/2)  * ((subjectParams.rightRing1_z/2)^2) ;
subjectParams.rightRing1Izz  = (subjectParams.rightRing1Mass/12) * (3 * (subjectParams.rightRing1_z/2)^2 + subjectParams.rightRing1_y^2);
% -----
% RIGHT RING2
% box sizes
subjectParams.rightRing2_y = 3/10 * totalRingLength; % from anthropometric assumption
subjectParams.rightRing2_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightRing2_rotxOrigin = [0, -subjectParams.rightRing1_y, 0]; % wrt jRightRing1_rotx
subjectParams.rightRing2BoxOrigin    = 1/2 * [0, -subjectParams.rightRing2_y, 0]; % wrt jRightRing2_rotx
% Mass and inertia
subjectParams.rightRing2Mass = 1/3 * totalRingMass;
subjectParams.rightRing2Ixx  = (subjectParams.rightRing2Mass/12) * (3 * (subjectParams.rightRing2_z/2)^2 + subjectParams.rightRing2_y^2);
subjectParams.rightRing2Iyy  = (subjectParams.rightRing2Mass/2)  * ((subjectParams.rightRing2_z/2)^2) ;
subjectParams.rightRing2Izz  = (subjectParams.rightRing2Mass/12) * (3 * (subjectParams.rightRing2_z/2)^2 + subjectParams.rightRing2_y^2);
% -----
% RIGHT RING3
% box sizes
subjectParams.rightRing3_y = 1/5 * totalRingLength; % from anthropometric assumption
subjectParams.rightRing3_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightRing3_rotxOrigin = [0, -subjectParams.rightRing2_y, 0]; % wrt jRightRing2_rotx
subjectParams.rightRing3BoxOrigin    = 1/2 * [0, -subjectParams.rightRing3_y, 0]; % wrt jRightRing3_rotx
% Mass and inertia
subjectParams.rightRing3Mass = 1/3 * totalRingMass;
subjectParams.rightRing3Ixx  = (subjectParams.rightRing3Mass/12) * (3 * (subjectParams.rightRing3_z/2)^2 + subjectParams.rightRing3_y^2);
subjectParams.rightRing3Iyy  = (subjectParams.rightRing3Mass/2)  * ((subjectParams.rightRing3_z/2)^2) ;
subjectParams.rightRing3Izz  = (subjectParams.rightRing3Mass/12) * (3 * (subjectParams.rightRing3_z/2)^2 + subjectParams.rightRing3_y^2);
%% RIGHT MIDDLE FINGER
totalMiddleLength = 0.0478 * H; % MFL,from anthropometric assumption
totalMiddleMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% RIGHT MIDDLE1
% box sizes
subjectParams.rightMiddle1_y = 1/2 * totalMiddleLength; % from anthropometric assumption
subjectParams.rightMiddle1_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightMiddle1_rotxOrigin = [1/8 * rightPalm_x, -rightPalm_y, 0]; % wrt jRightWrist
subjectParams.rightMiddle1BoxOrigin    = 1/2 * [0, -subjectParams.rightMiddle1_y, 0]; % wrt jRightMiddle1_rotx
% Mass and inertia
subjectParams.rightMiddle1Mass = 1/3 * totalMiddleMass;
subjectParams.rightMiddle1Ixx  = (subjectParams.rightMiddle1Mass/12) * (3 * (subjectParams.rightMiddle1_z/2)^2 + subjectParams.rightMiddle1_y^2);
subjectParams.rightMiddle1Iyy  = (subjectParams.rightMiddle1Mass/2)  * ((subjectParams.rightMiddle1_z/2)^2) ;
subjectParams.rightMiddle1Izz  = (subjectParams.rightMiddle1Mass/12) * (3 * (subjectParams.rightMiddle1_z/2)^2 + subjectParams.rightMiddle1_y^2);
% -----
% RIGHT MIDDLE2
% box sizes
subjectParams.rightMiddle2_y = 3/10 * totalMiddleLength; % from anthropometric assumption
subjectParams.rightMiddle2_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightMiddle2_rotxOrigin = [0, -subjectParams.rightMiddle1_y, 0]; % wrt jRightMiddle1_rotx
subjectParams.rightMiddle2BoxOrigin    = 1/2 * [0, -subjectParams.rightMiddle2_y, 0]; % wrt jRightMiddle2_rotx
% Mass and inertia
subjectParams.rightMiddle2Mass = 1/3 * totalMiddleMass;
subjectParams.rightMiddle2Ixx  = (subjectParams.rightMiddle2Mass/12) * (3 * (subjectParams.rightMiddle2_z/2)^2 + subjectParams.rightMiddle2_y^2);
subjectParams.rightMiddle2Iyy  = (subjectParams.rightMiddle2Mass/2)  * ((subjectParams.rightMiddle2_z/2)^2) ;
subjectParams.rightMiddle2Izz  = (subjectParams.rightMiddle2Mass/12) * (3 * (subjectParams.rightMiddle2_z/2)^2 + subjectParams.rightMiddle2_y^2);
% -----
% RIGHT MIDDLE3
% box sizes
subjectParams.rightMiddle3_y = 1/5 * totalMiddleLength; % from anthropometric assumption
subjectParams.rightMiddle3_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightMiddle3_rotxOrigin = [0, -subjectParams.rightMiddle2_y, 0]; % wrt jRightMiddle2_rotx
subjectParams.rightMiddle3BoxOrigin    = 1/2 * [0, -subjectParams.rightMiddle3_y, 0]; % wrt jRightMiddle3_rotx
% Mass and inertia
subjectParams.rightMiddle3Mass = 1/3 * totalMiddleMass;
subjectParams.rightMiddle3Ixx  = (subjectParams.rightMiddle3Mass/12) * (3 * (subjectParams.rightMiddle3_z/2)^2 + subjectParams.rightMiddle3_y^2);
subjectParams.rightMiddle3Iyy  = (subjectParams.rightMiddle3Mass/2)  * ((subjectParams.rightMiddle3_z/2)^2) ;
subjectParams.rightMiddle3Izz  = (subjectParams.rightMiddle3Mass/12) * (3 * (subjectParams.rightMiddle3_z/2)^2 + subjectParams.rightMiddle3_y^2);
%% RIGHT INDEX FINGER
totalIndexLength = 0.0433 * H; % IFL,from anthropometric assumption
totalIndexMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% RIGHT INDEX1
% box sizes
subjectParams.rightIndex1_y = 1/2 * totalIndexLength; % from anthropometric assumption
subjectParams.rightIndex1_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightIndex1_rotxOrigin = [3/8 * rightPalm_x, -rightPalm_y, 0]; % wrt jRightWrist
subjectParams.rightIndex1BoxOrigin    = 1/2 * [0, -subjectParams.rightIndex1_y, 0]; % wrt jRightIndex1_rotx
% Mass and inertia
subjectParams.rightIndex1Mass = 1/3 * totalIndexMass;
subjectParams.rightIndex1Ixx  = (subjectParams.rightIndex1Mass/12) * (3 * (subjectParams.rightIndex1_z/2)^2 + subjectParams.rightIndex1_y^2);
subjectParams.rightIndex1Iyy  = (subjectParams.rightIndex1Mass/2)  * ((subjectParams.rightIndex1_z/2)^2) ;
subjectParams.rightIndex1Izz  = (subjectParams.rightIndex1Mass/12) * (3 * (subjectParams.rightIndex1_z/2)^2 + subjectParams.rightIndex1_y^2);
% -----
% RIGHT INDEX2
% box sizes
subjectParams.rightIndex2_y = 3/10 * totalIndexLength; % from anthropometric assumption
subjectParams.rightIndex2_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightIndex2_rotxOrigin = [0, -subjectParams.rightIndex1_y, 0]; % wrt jRightIndex1_rotx
subjectParams.rightIndex2BoxOrigin    = 1/2 * [0, -subjectParams.rightIndex2_y, 0]; % wrt jRightIndex2_rotx
% Mass and inertia
subjectParams.rightIndex2Mass = 1/3 * totalIndexMass;
subjectParams.rightIndex2Ixx  = (subjectParams.rightIndex2Mass/12) * (3 * (subjectParams.rightIndex2_z/2)^2 + subjectParams.rightIndex2_y^2);
subjectParams.rightIndex2Iyy  = (subjectParams.rightIndex2Mass/2)  * ((subjectParams.rightIndex2_z/2)^2) ;
subjectParams.rightIndex2Izz  = (subjectParams.rightIndex2Mass/12) * (3 * (subjectParams.rightIndex2_z/2)^2 + subjectParams.rightIndex2_y^2);
% -----
% RIGHT INDEX3
% box sizes
subjectParams.rightIndex3_y = 1/5 * totalIndexLength; % from anthropometric assumption
subjectParams.rightIndex3_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightIndex3_rotxOrigin = [0, -subjectParams.rightIndex2_y, 0]; % wrt jRightIndex2_rotx
subjectParams.rightIndex3BoxOrigin    = 1/2 * [0, -subjectParams.rightIndex3_y, 0]; % wrt jRightIndex3_rotx
% Mass and inertia
subjectParams.rightIndex3Mass = 1/3 * totalIndexMass;
subjectParams.rightIndex3Ixx  = (subjectParams.rightIndex3Mass/12) * (3 * (subjectParams.rightIndex3_z/2)^2 + subjectParams.rightIndex3_y^2);
subjectParams.rightIndex3Iyy  = (subjectParams.rightIndex3Mass/2)  * ((subjectParams.rightIndex3_z/2)^2) ;
subjectParams.rightIndex3Izz  = (subjectParams.rightIndex3Mass/12) * (3 * (subjectParams.rightIndex3_z/2)^2 + subjectParams.rightIndex3_y^2);
%% RIGHT THUMB FINGER
% Important note: TFL is here only for the last 2 digits!
thumbLength_2finalDigits = 0.0323 * H; % TFL,from anthropometric assumption
thumbLength_firstDigit   = 1/2 * rightPalm_y; % from visual assumption
totalThumbMass   = (13 * totalHandMass)/100; % 13% of the total hand mass, assumption!!!
% RIGHT THUMB1
% box sizes
subjectParams.rightThumb1_y = thumbLength_firstDigit; % from visual assumption
subjectParams.rightThumb1_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightThumb1_rotyOrigin = [1/2 * rightPalm_x, -1/8 * rightPalm_y, 0]; % wrt jRightWrist
subjectParams.rightThumb1BoxOrigin    = 1/2 * [0, -subjectParams.rightThumb1_y, 0]; % wrt jRightThumb1_roty
% Mass and inertia
subjectParams.rightThumb1Mass = 1/3 * totalThumbMass;
subjectParams.rightThumb1Ixx  = (subjectParams.rightThumb1Mass/12) * (3 * (subjectParams.rightThumb1_z/2)^2 + subjectParams.rightThumb1_y^2);
subjectParams.rightThumb1Iyy  = (subjectParams.rightThumb1Mass/2)  * ((subjectParams.rightThumb1_z/2)^2) ;
subjectParams.rightThumb1Izz  = (subjectParams.rightThumb1Mass/12) * (3 * (subjectParams.rightThumb1_z/2)^2 + subjectParams.rightThumb1_y^2);
% -----
% RIGHT THUMB2
% box sizes
subjectParams.rightThumb2_y = 2/3 * thumbLength_2finalDigits; % from anthropometric assumption
subjectParams.rightThumb2_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightThumb2_rotxOrigin = [0, -subjectParams.rightThumb1_y, 0]; % wrt jRightThumb1_roty
subjectParams.rightThumb2BoxOrigin    = 1/2 * [0, -subjectParams.rightThumb2_y, 0]; % jRightThumb2_rotx
% Mass and inertia
subjectParams.rightThumb2Mass = 1/3 * totalThumbMass;
subjectParams.rightThumb2Ixx  = (subjectParams.rightThumb2Mass/12) * (3 * (subjectParams.rightThumb2_z/2)^2 + subjectParams.rightThumb2_y^2);
subjectParams.rightThumb2Iyy  = (subjectParams.rightThumb2Mass/2)  * ((subjectParams.rightThumb2_z/2)^2) ;
subjectParams.rightThumb2Izz  = (subjectParams.rightThumb2Mass/12) * (3 * (subjectParams.rightThumb2_z/2)^2 + subjectParams.rightThumb2_y^2);
% -----
% RIGHT THUMB3
% box sizes
subjectParams.rightThumb3_y = 1/3 * thumbLength_2finalDigits; % from anthropometric assumption
subjectParams.rightThumb3_z = rightPalm_z; % model assumption
% box origin
subjectParams.jRightThumb3_rotxOrigin = [0, -subjectParams.rightThumb2_y, 0]; % wrt jRightThumb2_rotx
subjectParams.rightThumb3BoxOrigin    = 1/2 * [0, -subjectParams.rightThumb3_y, 0]; % jRightThumb3_rotx
% Mass and inertia
subjectParams.rightThumb3Mass = 1/3 * totalThumbMass;
subjectParams.rightThumb3Ixx  = (subjectParams.rightThumb3Mass/12) * (3 * (subjectParams.rightThumb3_z/2)^2 + subjectParams.rightThumb3_y^2);
subjectParams.rightThumb3Iyy  = (subjectParams.rightThumb3Mass/2)  * ((subjectParams.rightThumb3_z/2)^2) ;
subjectParams.rightThumb3Izz  = (subjectParams.rightThumb3Mass/12) * (3 * (subjectParams.rightThumb3_z/2)^2 + subjectParams.rightThumb3_y^2);

%% --LEFT HAND
%% LEFT PALM
% box sizes for the entire palm considered as a whole parallelepiped
leftPalm_x = 0.0482 * H; % HB,from anthropometric assumption
leftPalm_y = 0.0657 * H; % PL,from anthropometric assumption
leftPalm_z = subjectParams.leftForeArm_z/2; % model assumption
left_finger_x = 1/4 * leftPalm_x; % model assumption
% LEFT PALM CLOSE TO THE THUMB (half of the left palm)
% box sizes
subjectParams.leftPalmCloseToThumbBox = [leftPalm_x/2, leftPalm_y, leftPalm_z];
% box origin
subjectParams.jLeftPalm_rotyOrigin = [0, 1/2 * leftPalm_y, 0]; % wrt jLeftWrist
subjectParams.leftPalmCloseToThumbBoxOrigin = [1/4 * leftPalm_x, 1/2 * leftPalm_y, 0]; % wrt jLeftWrist
% Mass and inertia
subjectParams.leftPalmCloseToThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParams.leftPalmCloseToThumbIxx  = (subjectParams.leftPalmCloseToThumbMass/12) * (leftPalm_y^2 + leftPalm_z^2);
subjectParams.leftPalmCloseToThumbIyy  = (subjectParams.leftPalmCloseToThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_z^2);
subjectParams.leftPalmCloseToThumbIzz  = (subjectParams.leftPalmCloseToThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_y^2);
% -----
% LEFT PALM FAR FROM THE THUMB (half of the left palm)
% box sizes
subjectParams.leftPalmFarFromThumbBox = [leftPalm_x/2, leftPalm_y, leftPalm_z];
% box origin
subjectParams.leftPalmFarFromThumbBoxOrigin = [-1/4 * leftPalm_x, 0, 0]; % jLeftPalm_roty
% Mass and inertia
subjectParams.leftPalmFarFromThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParams.leftPalmFarFromThumbIxx  = (subjectParams.leftPalmFarFromThumbMass/12) * (leftPalm_y^2 + leftPalm_z^2);
subjectParams.leftPalmFarFromThumbIyy  = (subjectParams.leftPalmFarFromThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_z^2);
subjectParams.leftPalmFarFromThumbIzz  = (subjectParams.leftPalmFarFromThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_y^2);
%% LEFT PINKY
totalPinkyLength = 0.0356 * H; % LFL,from anthropometric assumption
totalPinkyMass   = (7 * totalHandMass)/100; % 7% of the total hand mass, assumption!!!
% LEFT PINKY1
% box sizes
subjectParams.leftPinky1_y = 1/2 * totalPinkyLength; % from anthropometric assumption
subjectParams.leftPinky1_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftPinky1_rotxOrigin = [-3/8 * leftPalm_x, 1/2 * leftPalm_y, 0]; % wrt jLeftPalm_roty
subjectParams.leftPinky1BoxOrigin    = 1/2 * [0, subjectParams.leftPinky1_y, 0]; % wrt jLeftPinky1_rotx
% Mass and inertia
subjectParams.leftPinky1Mass = 1/3 * totalPinkyMass;
subjectParams.leftPinky1Ixx  = (subjectParams.leftPinky1Mass/12) * (3 * (subjectParams.leftPinky1_z/2)^2 + subjectParams.leftPinky1_y^2);
subjectParams.leftPinky1Iyy  = (subjectParams.leftPinky1Mass/2)  * ((subjectParams.leftPinky1_z/2)^2) ;
subjectParams.leftPinky1Izz  = (subjectParams.leftPinky1Mass/12) * (3 * (subjectParams.leftPinky1_z/2)^2 + subjectParams.leftPinky1_y^2);
% -----
% LEFT PINKY2
% box sizes
subjectParams.leftPinky2_y = 3/10 * totalPinkyLength; % from anthropometric assumption
subjectParams.leftPinky2_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftPinky2_rotxOrigin = [0, subjectParams.leftPinky1_y, 0]; % wrt jLeftPinky1_rotx
subjectParams.leftPinky2BoxOrigin    = 1/2 * [0, subjectParams.leftPinky2_y, 0]; % wrt jLeftPinky2_rotx
% Mass and inertia
subjectParams.leftPinky2Mass = 1/3 * totalPinkyMass;
subjectParams.leftPinky2Ixx  = (subjectParams.leftPinky2Mass/12) * (3 * (subjectParams.leftPinky2_z/2)^2 + subjectParams.leftPinky2_y^2);
subjectParams.leftPinky2Iyy  = (subjectParams.leftPinky2Mass/2)  * ((subjectParams.leftPinky2_z/2)^2) ;
subjectParams.leftPinky2Izz  = (subjectParams.leftPinky2Mass/12) * (3 * (subjectParams.leftPinky2_z/2)^2 + subjectParams.leftPinky2_y^2);
% -----
% LEFT PINKY3
% box sizes
subjectParams.leftPinky3_y = 1/5 * totalPinkyLength; % from anthropometric assumption
subjectParams.leftPinky3_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftPinky3_rotxOrigin = [0, subjectParams.leftPinky2_y, 0]; % wrt jLeftPinky2_rotx
subjectParams.leftPinky3BoxOrigin    = 1/2 * [0, subjectParams.leftPinky3_y, 0]; % wrt jLeftPinky3_rotx
% Mass and inertia
subjectParams.leftPinky3Mass = 1/3 * totalPinkyMass;
subjectParams.leftPinky3Ixx  = (subjectParams.leftPinky3Mass/12) * (3 * (subjectParams.leftPinky3_z/2)^2 + subjectParams.leftPinky3_y^2);
subjectParams.leftPinky3Iyy  = (subjectParams.leftPinky3Mass/2)  * ((subjectParams.leftPinky3_z/2)^2) ;
subjectParams.leftPinky3Izz  = (subjectParams.leftPinky3Mass/12) * (3 * (subjectParams.leftPinky3_z/2)^2 + subjectParams.leftPinky3_y^2);
%% LEFT RING FINGER
totalRingLength = 0.0428 * H; % RFL,from anthropometric assumption
totalRingMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% LEFT RING1
% box sizes
subjectParams.leftRing1_y = 1/2 * totalRingLength; % from anthropometric assumption
subjectParams.leftRing1_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftRing1_rotxOrigin = [-1/8 * leftPalm_x, 1/2 * leftPalm_y, 0]; % wrt jLeftPalm_roty
subjectParams.leftRing1BoxOrigin    = 1/2 * [0, subjectParams.leftRing1_y, 0]; % wrt jLeftRing1_rotx
% Mass and inertia
subjectParams.leftRing1Mass = 1/3 * totalRingMass;
subjectParams.leftRing1Ixx  = (subjectParams.leftRing1Mass/12) * (3 * (subjectParams.leftRing1_z/2)^2 + subjectParams.leftRing1_y^2);
subjectParams.leftRing1Iyy  = (subjectParams.leftRing1Mass/2)  * ((subjectParams.leftRing1_z/2)^2) ;
subjectParams.leftRing1Izz  = (subjectParams.leftRing1Mass/12) * (3 * (subjectParams.leftRing1_z/2)^2 + subjectParams.leftRing1_y^2);
% -----
% LEFT RING2
% box sizes
subjectParams.leftRing2_y = 3/10 * totalRingLength; % from anthropometric assumption
subjectParams.leftRing2_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftRing2_rotxOrigin = [0, subjectParams.leftRing1_y, 0]; % wrt jLeftRing1_rotx
subjectParams.leftRing2BoxOrigin    = 1/2 * [0, subjectParams.leftRing2_y, 0]; % wrt jLeftRing2_rotx
% Mass and inertia
subjectParams.leftRing2Mass = 1/3 * totalRingMass;
subjectParams.leftRing2Ixx  = (subjectParams.leftRing2Mass/12) * (3 * (subjectParams.leftRing2_z/2)^2 + subjectParams.leftRing2_y^2);
subjectParams.leftRing2Iyy  = (subjectParams.leftRing2Mass/2)  * ((subjectParams.leftRing2_z/2)^2) ;
subjectParams.leftRing2Izz  = (subjectParams.leftRing2Mass/12) * (3 * (subjectParams.leftRing2_z/2)^2 + subjectParams.leftRing2_y^2);
% -----
% LEFT RING3
% box sizes
subjectParams.leftRing3_y = 1/5 * totalRingLength; % from anthropometric assumption
subjectParams.leftRing3_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftRing3_rotxOrigin = [0, subjectParams.leftRing2_y, 0]; % wrt jLeftRing2_rotx
subjectParams.leftRing3BoxOrigin    = 1/2 * [0, subjectParams.leftRing3_y, 0]; % wrt jLeftRing3_rotx
% Mass and inertia
subjectParams.leftRing3Mass = 1/3 * totalRingMass;
subjectParams.leftRing3Ixx  = (subjectParams.leftRing3Mass/12) * (3 * (subjectParams.leftRing3_z/2)^2 + subjectParams.leftRing3_y^2);
subjectParams.leftRing3Iyy  = (subjectParams.leftRing3Mass/2)  * ((subjectParams.leftRing3_z/2)^2) ;
subjectParams.leftRing3Izz  = (subjectParams.leftRing3Mass/12) * (3 * (subjectParams.leftRing3_z/2)^2 + subjectParams.leftRing3_y^2);
%% LEFT MIDDLE FINGER
totalMiddleLength = 0.0478 * H; % MFL,from anthropometric assumption
totalMiddleMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% LEFT MIDDLE1
% box sizes
subjectParams.leftMiddle1_y = 1/2 * totalMiddleLength; % from anthropometric assumption
subjectParams.leftMiddle1_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftMiddle1_rotxOrigin = [1/8 * leftPalm_x, leftPalm_y, 0]; % wrt jLeftWrist
subjectParams.leftMiddle1BoxOrigin    = 1/2 * [0, subjectParams.leftMiddle1_y, 0]; % wrt jLeftMiddle1_rotx
% Mass and inertia
subjectParams.leftMiddle1Mass = 1/3 * totalMiddleMass;
subjectParams.leftMiddle1Ixx  = (subjectParams.leftMiddle1Mass/12) * (3 * (subjectParams.leftMiddle1_z/2)^2 + subjectParams.leftMiddle1_y^2);
subjectParams.leftMiddle1Iyy  = (subjectParams.leftMiddle1Mass/2)  * ((subjectParams.leftMiddle1_z/2)^2) ;
subjectParams.leftMiddle1Izz  = (subjectParams.leftMiddle1Mass/12) * (3 * (subjectParams.leftMiddle1_z/2)^2 + subjectParams.leftMiddle1_y^2);
% -----
% LEFT MIDDLE2
% box sizes
subjectParams.leftMiddle2_y = 3/10 * totalMiddleLength; % from anthropometric assumption
subjectParams.leftMiddle2_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftMiddle2_rotxOrigin = [0, subjectParams.leftMiddle1_y, 0]; % wrt jLeftMiddle1_rotx
subjectParams.leftMiddle2BoxOrigin    = 1/2 * [0, subjectParams.leftMiddle2_y, 0]; % wrt jLeftMiddle2_rotx
% Mass and inertia
subjectParams.leftMiddle2Mass = 1/3 * totalMiddleMass;
subjectParams.leftMiddle2Ixx  = (subjectParams.leftMiddle2Mass/12) * (3 * (subjectParams.leftMiddle2_z/2)^2 + subjectParams.leftMiddle2_y^2);
subjectParams.leftMiddle2Iyy  = (subjectParams.leftMiddle2Mass/2)  * ((subjectParams.leftMiddle2_z/2)^2) ;
subjectParams.leftMiddle2Izz  = (subjectParams.leftMiddle2Mass/12) * (3 * (subjectParams.leftMiddle2_z/2)^2 + subjectParams.leftMiddle2_y^2);
% -----
% LEFT MIDDLE3
% box sizes
subjectParams.leftMiddle3_y = 1/5 * totalMiddleLength; % from anthropometric assumption
subjectParams.leftMiddle3_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftMiddle3_rotxOrigin = [0, subjectParams.leftMiddle2_y, 0]; % wrt jLeftMiddle2_rotx
subjectParams.leftMiddle3BoxOrigin    = 1/2 * [0, subjectParams.leftMiddle3_y, 0]; % wrt jLeftMiddle3_rotx
% Mass and inertia
subjectParams.leftMiddle3Mass = 1/3 * totalMiddleMass;
subjectParams.leftMiddle3Ixx  = (subjectParams.leftMiddle3Mass/12) * (3 * (subjectParams.leftMiddle3_z/2)^2 + subjectParams.leftMiddle3_y^2);
subjectParams.leftMiddle3Iyy  = (subjectParams.leftMiddle3Mass/2)  * ((subjectParams.leftMiddle3_z/2)^2) ;
subjectParams.leftMiddle3Izz  = (subjectParams.leftMiddle3Mass/12) * (3 * (subjectParams.leftMiddle3_z/2)^2 + subjectParams.leftMiddle3_y^2);
%% LEFT INDEX FINGER
totalIndexLength = 0.0433 * H; % IFL,from anthropometric assumption
totalIndexMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% LEFT INDEX1
% box sizes
subjectParams.leftIndex1_y = 1/2 * totalIndexLength; % from anthropometric assumption
subjectParams.leftIndex1_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftIndex1_rotxOrigin = [3/8 * leftPalm_x, leftPalm_y, 0]; % wrt jLeftWrist
subjectParams.leftIndex1BoxOrigin    = 1/2 * [0, subjectParams.leftIndex1_y, 0]; % wrt jLeftIndex1_rotx
% Mass and inertia
subjectParams.leftIndex1Mass = 1/3 * totalIndexMass;
subjectParams.leftIndex1Ixx  = (subjectParams.leftIndex1Mass/12) * (3 * (subjectParams.leftIndex1_z/2)^2 + subjectParams.leftIndex1_y^2);
subjectParams.leftIndex1Iyy  = (subjectParams.leftIndex1Mass/2)  * ((subjectParams.leftIndex1_z/2)^2) ;
subjectParams.leftIndex1Izz  = (subjectParams.leftIndex1Mass/12) * (3 * (subjectParams.leftIndex1_z/2)^2 + subjectParams.leftIndex1_y^2);
% -----
% LEFT INDEX2
% box sizes
subjectParams.leftIndex2_y = 3/10 * totalIndexLength; % from anthropometric assumption
subjectParams.leftIndex2_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftIndex2_rotxOrigin = [0, subjectParams.leftIndex1_y, 0]; % wrt jLeftIndex1_rotx
subjectParams.leftIndex2BoxOrigin    = 1/2 * [0, subjectParams.leftIndex2_y, 0]; % wrt jLeftIndex2_rotx
% Mass and inertia
subjectParams.leftIndex2Mass = 1/3 * totalIndexMass;
subjectParams.leftIndex2Ixx  = (subjectParams.leftIndex2Mass/12) * (3 * (subjectParams.leftIndex2_z/2)^2 + subjectParams.leftIndex2_y^2);
subjectParams.leftIndex2Iyy  = (subjectParams.leftIndex2Mass/2)  * ((subjectParams.leftIndex2_z/2)^2) ;
subjectParams.leftIndex2Izz  = (subjectParams.leftIndex2Mass/12) * (3 * (subjectParams.leftIndex2_z/2)^2 + subjectParams.leftIndex2_y^2);
% -----
% LEFT INDEX3
% box sizes
subjectParams.leftIndex3_y = 1/5 * totalIndexLength; % from anthropometric assumption
subjectParams.leftIndex3_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftIndex3_rotxOrigin = [0, subjectParams.leftIndex2_y, 0]; % wrt jLeftIndex2_rotx
subjectParams.leftIndex3BoxOrigin    = 1/2 * [0, subjectParams.leftIndex3_y, 0]; % wrt jLeftIndex3_rotx
% Mass and inertia
subjectParams.leftIndex3Mass = 1/3 * totalIndexMass;
subjectParams.leftIndex3Ixx  = (subjectParams.leftIndex3Mass/12) * (3 * (subjectParams.leftIndex3_z/2)^2 + subjectParams.leftIndex3_y^2);
subjectParams.leftIndex3Iyy  = (subjectParams.leftIndex3Mass/2)  * ((subjectParams.leftIndex3_z/2)^2) ;
subjectParams.leftIndex3Izz  = (subjectParams.leftIndex3Mass/12) * (3 * (subjectParams.leftIndex3_z/2)^2 + subjectParams.leftIndex3_y^2);
%% LEFT THUMB FINGER
% Important note: TFL is here only for the last 2 digits!
thumbLength_2finalDigits = 0.0323 * H; % TFL,from anthropometric assumption
thumbLength_firstDigit   = 1/2 * leftPalm_y; % from visual assumption
totalThumbMass   = (13 * totalHandMass)/100; % 13% of the total hand mass, assumption!!!
% LEFT THUMB1
% box sizes
subjectParams.leftThumb1_y = thumbLength_firstDigit; % from visual assumption
subjectParams.leftThumb1_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftThumb1_rotyOrigin = [1/2 * leftPalm_x, 1/8 * leftPalm_y, 0]; % wrt jLeftWrist
subjectParams.leftThumb1BoxOrigin    = 1/2 * [0, subjectParams.leftThumb1_y, 0]; % wrt jLeftThumb1_roty
% Mass and inertia
subjectParams.leftThumb1Mass = 1/3 * totalThumbMass;
subjectParams.leftThumb1Ixx  = (subjectParams.leftThumb1Mass/12) * (3 * (subjectParams.leftThumb1_z/2)^2 + subjectParams.leftThumb1_y^2);
subjectParams.leftThumb1Iyy  = (subjectParams.leftThumb1Mass/2)  * ((subjectParams.leftThumb1_z/2)^2) ;
subjectParams.leftThumb1Izz  = (subjectParams.leftThumb1Mass/12) * (3 * (subjectParams.leftThumb1_z/2)^2 + subjectParams.leftThumb1_y^2);
% -----
% LEFT THUMB2
% box sizes
subjectParams.leftThumb2_y = 2/3 * thumbLength_2finalDigits; % from anthropometric assumption
subjectParams.leftThumb2_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftThumb2_rotxOrigin = [0, subjectParams.leftThumb1_y, 0]; % wrt jLeftThumb1_roty
subjectParams.leftThumb2BoxOrigin    = 1/2 * [0, subjectParams.leftThumb2_y, 0]; % jLeftThumb2_rotx
% Mass and inertia
subjectParams.leftThumb2Mass = 1/3 * totalThumbMass;
subjectParams.leftThumb2Ixx  = (subjectParams.leftThumb2Mass/12) * (3 * (subjectParams.leftThumb2_z/2)^2 + subjectParams.leftThumb2_y^2);
subjectParams.leftThumb2Iyy  = (subjectParams.leftThumb2Mass/2)  * ((subjectParams.leftThumb2_z/2)^2) ;
subjectParams.leftThumb2Izz  = (subjectParams.leftThumb2Mass/12) * (3 * (subjectParams.leftThumb2_z/2)^2 + subjectParams.leftThumb2_y^2);
% -----
% LEFT THUMB3
% box sizes
subjectParams.leftThumb3_y = 1/3 * thumbLength_2finalDigits; % from anthropometric assumption
subjectParams.leftThumb3_z = leftPalm_z; % model assumption
% box origin
subjectParams.jLeftThumb3_rotxOrigin = [0, subjectParams.leftThumb2_y, 0]; % wrt jLeftThumb2_rotx
subjectParams.leftThumb3BoxOrigin    = 1/2 * [0, subjectParams.leftThumb3_y, 0]; % jLeftThumb3_rotx
% Mass and inertia
subjectParams.leftThumb3Mass = 1/3 * totalThumbMass;
subjectParams.leftThumb3Ixx  = (subjectParams.leftThumb3Mass/12) * (3 * (subjectParams.leftThumb3_z/2)^2 + subjectParams.leftThumb3_y^2);
subjectParams.leftThumb3Iyy  = (subjectParams.leftThumb3Mass/2)  * ((subjectParams.leftThumb3_z/2)^2) ;
subjectParams.leftThumb3Izz  = (subjectParams.leftThumb3Mass/12) * (3 * (subjectParams.leftThumb3_z/2)^2 + subjectParams.leftThumb3_y^2);

end
