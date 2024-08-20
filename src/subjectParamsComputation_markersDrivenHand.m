
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [subjectParamsFromData] = subjectParamsComputation_markersDrivenHand(subjectParamsFromData, markersDistance, M)
%SUBJECTPARAMSCOMPUTATION_MARKERSDRIVENHAND computes the bounding boxes for
% the markers-driven human hand.

%% Preliminaries
totalHandMass = 0.006 * M; % from anthropometric assumption
% Indices
for distIdx = 1 : length(markersDistance.norm)
    % palm trapezium
    if strcmp('radio-ind1', markersDistance.norm(distIdx).label)
        radio_ind1_index = distIdx;
        continue;
    end
    if strcmp('ulna-radio', markersDistance.norm(distIdx).label)
        ulna_radio_index = distIdx;
        continue;
    end
    if strcmp('ulna-lit1', markersDistance.norm(distIdx).label)
        ulna_lit1_index = distIdx;
        continue;
    end
    % -----
    % fingers width
    if strcmp('ind1-mid1', markersDistance.norm(distIdx).label)
        ind1_mid1_index = distIdx;
        continue;
    end
    if strcmp('mid1-rin1', markersDistance.norm(distIdx).label)
        mid1_rin1_index = distIdx;
        continue;
    end
    if strcmp('rin1-lit1', markersDistance.norm(distIdx).label)
        rin1_lit1_index = distIdx;
        continue;
    end
    % -----
    % pinky
    if strcmp('lit1-lit2', markersDistance.norm(distIdx).label)
        lit1_lit2_index = distIdx;
        continue;
    end
    if strcmp('lit1-lit3', markersDistance.norm(distIdx).label)
        lit1_lit3_index = distIdx;
        continue;
    end
    % -----
    % ring
    if strcmp('rin1-rin2', markersDistance.norm(distIdx).label)
        rin1_rin2_index = distIdx;
        continue;
    end
    if strcmp('rin1-rin3', markersDistance.norm(distIdx).label)
        rin1_rin3_index = distIdx;
        continue;
    end
    % -----
    % middle
    if strcmp('mid1-mid2', markersDistance.norm(distIdx).label)
        mid1_mid2_index = distIdx;
        continue;
    end
    if strcmp('mid1-mid3', markersDistance.norm(distIdx).label)
        mid1_mid3_index = distIdx;
        continue;
    end
    % -----
    % index
    if strcmp('ind1-ind2', markersDistance.norm(distIdx).label)
        ind1_ind2_index = distIdx;
        continue;
    end
    if strcmp('ind1-ind3', markersDistance.norm(distIdx).label)
        ind1_ind3_index = distIdx;
        continue;
    end
    % -----
    % thumb
    if strcmp('thu1-thu4', markersDistance.norm(distIdx).label)
        thu1_thu4_index = distIdx;
        continue;
    end
    % -----
    % extra
    if strcmp('ulna-wrist', markersDistance.norm(distIdx).label)
        ulna_wrist_index = distIdx;
        continue;
    end
    if strcmp('radio-wrist', markersDistance.norm(distIdx).label)
        radio_wrist_index = distIdx;
        continue;
    end
    if strcmp('palm-radio', markersDistance.norm(distIdx).label)
        palm_radio_index = distIdx;
        continue;
    end
    if strcmp('palm-ulna', markersDistance.norm(distIdx).label)
        palm_ulna_index = distIdx;
        continue;
    end
end
% Fibonacci size for second digits for which we do not have a marker
fib.series = fibonacciWrapper(4);
fib.idealFirstDigit  = fib.series(4,1);
fib.idealSecondDigit = fib.series(3,1);

%% Distances
distance_ind1_mid1   = markersDistance.norm(ind1_mid1_index).mean_staticAcquisition;
distance_mid1_rin1   = markersDistance.norm(mid1_rin1_index).mean_staticAcquisition;
distance_rin1_lit1   = markersDistance.norm(rin1_lit1_index).mean_staticAcquisition;
distance_ulna_radio  = markersDistance.norm(ulna_radio_index).mean_staticAcquisition;
distance_radio_ind1  = markersDistance.norm(radio_ind1_index).mean_staticAcquisition;
distance_ulna_lit1   = markersDistance.norm(ulna_lit1_index).mean_staticAcquisition;
distance_lit1_lit3   = markersDistance.norm(lit1_lit3_index).mean_staticAcquisition;
distance_lit1_lit2   = markersDistance.norm(lit1_lit2_index).mean_staticAcquisition;
distance_rin1_rin3   = markersDistance.norm(rin1_rin3_index).mean_staticAcquisition;
distance_rin1_rin2   = markersDistance.norm(rin1_rin2_index).mean_staticAcquisition;
distance_mid1_mid3   = markersDistance.norm(mid1_mid3_index).mean_staticAcquisition;
distance_mid1_mid2   = markersDistance.norm(mid1_mid2_index).mean_staticAcquisition;
distance_ind1_ind3   = markersDistance.norm(ind1_ind3_index).mean_staticAcquisition;
distance_ind1_ind2   = markersDistance.norm(ind1_ind2_index).mean_staticAcquisition;
distance_thu1_thu4   = markersDistance.norm(thu1_thu4_index).mean_staticAcquisition;
distance_palm_ulna   = markersDistance.norm(palm_ulna_index).mean_staticAcquisition;
distance_palm_radio  = markersDistance.norm(palm_radio_index).mean_staticAcquisition;
distance_radio_wrist = markersDistance.norm(radio_wrist_index).mean_staticAcquisition;
distance_ulna_wrist  = markersDistance.norm(ulna_wrist_index).mean_staticAcquisition;

%% --RIGHT HAND
%% RIGHT PALM
indFinger_x = distance_ind1_mid1; % e.g., 0.024;
midFinger_x =  (distance_ind1_mid1/2) + (distance_mid1_rin1/2); % e.g., 0.018;
midFinger_x =  midFinger_x - (midFinger_x * 18/100); % model assumption, -18%;
rinFinger_x =  (distance_mid1_rin1/2) + (distance_rin1_lit1/2); % e.g., 0.014;
rinFinger_x = rinFinger_x - (rinFinger_x * 28/100); % model assumption, -28%;
litFinger_x =  distance_rin1_lit1; % e.g., 0.020;
litFinger_x = litFinger_x + (litFinger_x * 12/100); % model assumption, +12%;

B  = indFinger_x + midFinger_x + rinFinger_x + litFinger_x;
b  = distance_ulna_radio;
l1 = distance_radio_ind1;
l2 = distance_ulna_lit1;
trapeziumHeight = computeTrapeziumHeight(B,b,l1,l2);

% box sizes for the entire palm considered as a whole parallelepiped
rightPalm_x = B;
rightPalm_y = trapeziumHeight;
rightPalm_z = subjectParamsFromData.rightForeArm_z/2; % from anthropometric assumption
% -----
% RIGHT PALM CLOSE TO THE THUMB (half of the right palm)
% box sizes
subjectParamsFromData.rightPalmCloseToThumbBox = [rightPalm_x/2, rightPalm_y, rightPalm_z];
% box origin
subjectParamsFromData.jRightPalm_rotyOrigin = [0, -1/2 * rightPalm_y, 0]; % wrt jRightWrist
subjectParamsFromData.rightPalmCloseToThumbBoxOrigin = [1/4 * rightPalm_x, -1/2 * rightPalm_y, 0]; % wrt jRightWrist
% Mass and inertia
subjectParamsFromData.rightPalmCloseToThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParamsFromData.rightPalmCloseToThumbIxx  = (subjectParamsFromData.rightPalmCloseToThumbMass/12) * (rightPalm_y^2 + rightPalm_z^2);
subjectParamsFromData.rightPalmCloseToThumbIyy  = (subjectParamsFromData.rightPalmCloseToThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_z^2);
subjectParamsFromData.rightPalmCloseToThumbIzz  = (subjectParamsFromData.rightPalmCloseToThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_y^2);
% -----
% RIGHT PALM FAR FROM THE THUMB (half of the right palm)
% box sizes
subjectParamsFromData.rightPalmFarFromThumbBox = [rightPalm_x/2, rightPalm_y, rightPalm_z];
% box origin
subjectParamsFromData.rightPalmFarFromThumbBoxOrigin = [-1/4 * rightPalm_x, 0, 0]; % wrt jRightPalm_roty
% Mass and inertia
subjectParamsFromData.rightPalmFarFromThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParamsFromData.rightPalmFarFromThumbIxx  = (subjectParamsFromData.rightPalmFarFromThumbMass/12) * (rightPalm_y^2 + rightPalm_z^2);
subjectParamsFromData.rightPalmFarFromThumbIyy  = (subjectParamsFromData.rightPalmFarFromThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_z^2);
subjectParamsFromData.rightPalmFarFromThumbIzz  = (subjectParamsFromData.rightPalmFarFromThumbMass/12) * ((rightPalm_x/2)^2 + rightPalm_y^2);
%% RIGHT PINKY
totalPinkyLength = distance_lit1_lit3;
totalPinkyMass   = (7 * totalHandMass)/100; % 7% of the total hand mass, assumption!!!
% -----
% RIGHT PINKY1
% box sizes
subjectParamsFromData.rightPinky1_y = distance_lit1_lit2;
subjectParamsFromData.rightPinky1_z = litFinger_x;
% box origin
subjectParamsFromData.litFinger_origin = rightPalm_x/2 - litFinger_x/2;
subjectParamsFromData.jRightPinky1_rotxOrigin = [-subjectParamsFromData.litFinger_origin, -1/2 * rightPalm_y, 0]; % wrt jRightPalm_roty
subjectParamsFromData.rightPinky1BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightPinky1_y, 0]; % wrt jRightPinky1_rotx
% Mass and inertia
subjectParamsFromData.rightPinky1Mass = 1/3 * totalPinkyMass;
subjectParamsFromData.rightPinky1Ixx  = (subjectParamsFromData.rightPinky1Mass/12) * (3 * (subjectParamsFromData.rightPinky1_z/2)^2 + subjectParamsFromData.rightPinky1_y^2);
subjectParamsFromData.rightPinky1Iyy  = (subjectParamsFromData.rightPinky1Mass/2)  * ((subjectParamsFromData.rightPinky1_z/2)^2) ;
subjectParamsFromData.rightPinky1Izz  = (subjectParamsFromData.rightPinky1Mass/12) * (3 * (subjectParamsFromData.rightPinky1_z/2)^2 + subjectParamsFromData.rightPinky1_y^2);
% -----
% RIGHT PINKY2
% box sizes
subjectParamsFromData.rightPinky2_y = (subjectParamsFromData.rightPinky1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.rightPinky2_z = litFinger_x;
% box origin
subjectParamsFromData.jRightPinky2_rotxOrigin = [0, -subjectParamsFromData.rightPinky1_y, 0]; % wrt jRightPinky1_rotx
subjectParamsFromData.rightPinky2BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightPinky2_y, 0]; % wrt jRightPinky2_rotx
% Mass and inertia
subjectParamsFromData.rightPinky2Mass = 1/3 * totalPinkyMass;
subjectParamsFromData.rightPinky2Ixx  = (subjectParamsFromData.rightPinky2Mass/12) * (3 * (subjectParamsFromData.rightPinky2_z/2)^2 + subjectParamsFromData.rightPinky2_y^2);
subjectParamsFromData.rightPinky2Iyy  = (subjectParamsFromData.rightPinky2Mass/2)  * ((subjectParamsFromData.rightPinky2_z/2)^2) ;
subjectParamsFromData.rightPinky2Izz  = (subjectParamsFromData.rightPinky2Mass/12) * (3 * (subjectParamsFromData.rightPinky2_z/2)^2 + subjectParamsFromData.rightPinky2_y^2);
% -----
% RIGHT PINKY3
% box sizes
subjectParamsFromData.rightPinky3_y = abs(totalPinkyLength - subjectParamsFromData.rightPinky1_y - subjectParamsFromData.rightPinky2_y);
subjectParamsFromData.rightPinky3_z = litFinger_x;
% box origin
subjectParamsFromData.jRightPinky3_rotxOrigin = [0, -subjectParamsFromData.rightPinky2_y, 0]; % wrt jRightPinky2_rotx
subjectParamsFromData.rightPinky3BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightPinky3_y, 0]; % wrt jRightPinky3_rotx
% Mass and inertia
subjectParamsFromData.rightPinky3Mass = 1/3 * totalPinkyMass;
subjectParamsFromData.rightPinky3Ixx  = (subjectParamsFromData.rightPinky3Mass/12) * (3 * (subjectParamsFromData.rightPinky3_z/2)^2 + subjectParamsFromData.rightPinky3_y^2);
subjectParamsFromData.rightPinky3Iyy  = (subjectParamsFromData.rightPinky3Mass/2)  * ((subjectParamsFromData.rightPinky3_z/2)^2) ;
subjectParamsFromData.rightPinky3Izz  = (subjectParamsFromData.rightPinky3Mass/12) * (3 * (subjectParamsFromData.rightPinky3_z/2)^2 + subjectParamsFromData.rightPinky3_y^2);
%% RIGHT RING FINGER
totalRingLength = distance_rin1_rin3;
totalRingMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% -----
% RIGHT RING1
% box sizes
subjectParamsFromData.rightRing1_y = distance_rin1_rin2;
subjectParamsFromData.rightRing1_z = rinFinger_x;
% box origin
subjectParamsFromData.rinFinger_origin = rightPalm_x/2 - litFinger_x - rinFinger_x/2;
subjectParamsFromData.jRightRing1_rotxOrigin = [-subjectParamsFromData.rinFinger_origin, -1/2 * rightPalm_y, 0]; % wrt jRightPalm_roty
subjectParamsFromData.rightRing1BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightRing1_y, 0]; % wrt jRightRing1_rotx
% Mass and inertia
subjectParamsFromData.rightRing1Mass = 1/3 * totalRingMass;
subjectParamsFromData.rightRing1Ixx  = (subjectParamsFromData.rightRing1Mass/12) * (3 * (subjectParamsFromData.rightRing1_z/2)^2 + subjectParamsFromData.rightRing1_y^2);
subjectParamsFromData.rightRing1Iyy  = (subjectParamsFromData.rightRing1Mass/2)  * ((subjectParamsFromData.rightRing1_z/2)^2) ;
subjectParamsFromData.rightRing1Izz  = (subjectParamsFromData.rightRing1Mass/12) * (3 * (subjectParamsFromData.rightRing1_z/2)^2 + subjectParamsFromData.rightRing1_y^2);
% -----
% RIGHT RING2
% box sizes
subjectParamsFromData.rightRing2_y = (subjectParamsFromData.rightRing1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.rightRing2_z = rinFinger_x;
% box origin
subjectParamsFromData.jRightRing2_rotxOrigin = [0, -subjectParamsFromData.rightRing1_y, 0]; % wrt jRightRing1_rotx
subjectParamsFromData.rightRing2BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightRing2_y, 0]; % wrt jRightRing2_rotx
% Mass and inertia
subjectParamsFromData.rightRing2Mass = 1/3 * totalRingMass;
subjectParamsFromData.rightRing2Ixx  = (subjectParamsFromData.rightRing2Mass/12) * (3 * (subjectParamsFromData.rightRing2_z/2)^2 + subjectParamsFromData.rightRing2_y^2);
subjectParamsFromData.rightRing2Iyy  = (subjectParamsFromData.rightRing2Mass/2)  * ((subjectParamsFromData.rightRing2_z/2)^2) ;
subjectParamsFromData.rightRing2Izz  = (subjectParamsFromData.rightRing2Mass/12) * (3 * (subjectParamsFromData.rightRing2_z/2)^2 + subjectParamsFromData.rightRing2_y^2);
% -----
% RIGHT RING3
% box sizes
subjectParamsFromData.rightRing3_y = abs(totalRingLength - subjectParamsFromData.rightRing1_y - subjectParamsFromData.rightRing2_y);
subjectParamsFromData.rightRing3_z = rinFinger_x;
% box origin
subjectParamsFromData.jRightRing3_rotxOrigin = [0, -subjectParamsFromData.rightRing2_y, 0]; % wrt jRightRing2_rotx
subjectParamsFromData.rightRing3BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightRing3_y, 0]; % wrt jRightRing3_rotx
% Mass and inertia
subjectParamsFromData.rightRing3Mass = 1/3 * totalRingMass;
subjectParamsFromData.rightRing3Ixx  = (subjectParamsFromData.rightRing3Mass/12) * (3 * (subjectParamsFromData.rightRing3_z/2)^2 + subjectParamsFromData.rightRing3_y^2);
subjectParamsFromData.rightRing3Iyy  = (subjectParamsFromData.rightRing3Mass/2)  * ((subjectParamsFromData.rightRing3_z/2)^2) ;
subjectParamsFromData.rightRing3Izz  = (subjectParamsFromData.rightRing3Mass/12) * (3 * (subjectParamsFromData.rightRing3_z/2)^2 + subjectParamsFromData.rightRing3_y^2);
%% RIGHT MIDDLE FINGER
totalMiddleLength = distance_mid1_mid3;
totalMiddleMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% -----
% RIGHT MIDDLE1
% box sizes
subjectParamsFromData.rightMiddle1_y = distance_mid1_mid2;
subjectParamsFromData.rightMiddle1_z = midFinger_x;
% box origin
subjectParamsFromData.midFinger_origin = rightPalm_x/2 - indFinger_x - midFinger_x/2;
subjectParamsFromData.jRightMiddle1_rotxOrigin = [subjectParamsFromData.midFinger_origin, -rightPalm_y, 0]; % wrt jRightWrist
subjectParamsFromData.rightMiddle1BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightMiddle1_y, 0]; % wrt jRightMiddle1_rotx
% Mass and inertia
subjectParamsFromData.rightMiddle1Mass = 1/3 * totalMiddleMass;
subjectParamsFromData.rightMiddle1Ixx  = (subjectParamsFromData.rightMiddle1Mass/12) * (3 * (subjectParamsFromData.rightMiddle1_z/2)^2 + subjectParamsFromData.rightMiddle1_y^2);
subjectParamsFromData.rightMiddle1Iyy  = (subjectParamsFromData.rightMiddle1Mass/2)  * ((subjectParamsFromData.rightMiddle1_z/2)^2) ;
subjectParamsFromData.rightMiddle1Izz  = (subjectParamsFromData.rightMiddle1Mass/12) * (3 * (subjectParamsFromData.rightMiddle1_z/2)^2 + subjectParamsFromData.rightMiddle1_y^2);
% -----
% RIGHT MIDDLE2
% box sizes
subjectParamsFromData.rightMiddle2_y = (subjectParamsFromData.rightMiddle1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.rightMiddle2_z = midFinger_x;
% box origin
subjectParamsFromData.jRightMiddle2_rotxOrigin = [0, -subjectParamsFromData.rightMiddle1_y, 0]; % wrt jRightMiddle1_rotx
subjectParamsFromData.rightMiddle2BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightMiddle2_y, 0]; % wrt jRightMiddle2_rotx
% Mass and inertia
subjectParamsFromData.rightMiddle2Mass = 1/3 * totalMiddleMass;
subjectParamsFromData.rightMiddle2Ixx  = (subjectParamsFromData.rightMiddle2Mass/12) * (3 * (subjectParamsFromData.rightMiddle2_z/2)^2 + subjectParamsFromData.rightMiddle2_y^2);
subjectParamsFromData.rightMiddle2Iyy  = (subjectParamsFromData.rightMiddle2Mass/2)  * ((subjectParamsFromData.rightMiddle2_z/2)^2) ;
subjectParamsFromData.rightMiddle2Izz  = (subjectParamsFromData.rightMiddle2Mass/12) * (3 * (subjectParamsFromData.rightMiddle2_z/2)^2 + subjectParamsFromData.rightMiddle2_y^2);
% -----
% RIGHT MIDDLE3
% box sizes
subjectParamsFromData.rightMiddle3_y = abs(totalMiddleLength - subjectParamsFromData.rightMiddle1_y - subjectParamsFromData.rightMiddle2_y);
subjectParamsFromData.rightMiddle3_z = midFinger_x;
% box origin
subjectParamsFromData.jRightMiddle3_rotxOrigin = [0, -subjectParamsFromData.rightMiddle2_y, 0]; % wrt jRightMiddle2_rotx
subjectParamsFromData.rightMiddle3BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightMiddle3_y, 0]; % wrt jRightMiddle3_rotx
% Mass and inertia
subjectParamsFromData.rightMiddle3Mass = 1/3 * totalMiddleMass;
subjectParamsFromData.rightMiddle3Ixx  = (subjectParamsFromData.rightMiddle3Mass/12) * (3 * (subjectParamsFromData.rightMiddle3_z/2)^2 + subjectParamsFromData.rightMiddle3_y^2);
subjectParamsFromData.rightMiddle3Iyy  = (subjectParamsFromData.rightMiddle3Mass/2)  * ((subjectParamsFromData.rightMiddle3_z/2)^2) ;
subjectParamsFromData.rightMiddle3Izz  = (subjectParamsFromData.rightMiddle3Mass/12) * (3 * (subjectParamsFromData.rightMiddle3_z/2)^2 + subjectParamsFromData.rightMiddle3_y^2);
%% RIGHT INDEX FINGER
totalIndexLength = distance_ind1_ind3;
totalIndexMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% -----
% RIGHT INDEX1
% box sizes
subjectParamsFromData.rightIndex1_y = distance_ind1_ind2;
subjectParamsFromData.rightIndex1_z = indFinger_x;
% box origin
subjectParamsFromData.indFinger_origin = rightPalm_x/2 - indFinger_x/2;
subjectParamsFromData.jRightIndex1_rotxOrigin = [subjectParamsFromData.indFinger_origin, -rightPalm_y, 0]; % wrt jRightWrist
subjectParamsFromData.rightIndex1BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightIndex1_y, 0]; % wrt jRightIndex1_rotx
% Mass and inertia
subjectParamsFromData.rightIndex1Mass = 1/3 * totalIndexMass;
subjectParamsFromData.rightIndex1Ixx  = (subjectParamsFromData.rightIndex1Mass/12) * (3 * (subjectParamsFromData.rightIndex1_z/2)^2 + subjectParamsFromData.rightIndex1_y^2);
subjectParamsFromData.rightIndex1Iyy  = (subjectParamsFromData.rightIndex1Mass/2)  * ((subjectParamsFromData.rightIndex1_z/2)^2) ;
subjectParamsFromData.rightIndex1Izz  = (subjectParamsFromData.rightIndex1Mass/12) * (3 * (subjectParamsFromData.rightIndex1_z/2)^2 + subjectParamsFromData.rightIndex1_y^2);
% -----
% RIGHT INDEX2
% box sizes
subjectParamsFromData.rightIndex2_y = (subjectParamsFromData.rightIndex1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.rightIndex2_z = indFinger_x;
% box origin
subjectParamsFromData.jRightIndex2_rotxOrigin = [0, -subjectParamsFromData.rightIndex1_y, 0]; % wrt jRightIndex1_rotx
subjectParamsFromData.rightIndex2BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightIndex2_y, 0]; % wrt jRightIndex2_rotx
% Mass and inertia
subjectParamsFromData.rightIndex2Mass = 1/3 * totalIndexMass;
subjectParamsFromData.rightIndex2Ixx  = (subjectParamsFromData.rightIndex2Mass/12) * (3 * (subjectParamsFromData.rightIndex2_z/2)^2 + subjectParamsFromData.rightIndex2_y^2);
subjectParamsFromData.rightIndex2Iyy  = (subjectParamsFromData.rightIndex2Mass/2)  * ((subjectParamsFromData.rightIndex2_z/2)^2) ;
subjectParamsFromData.rightIndex2Izz  = (subjectParamsFromData.rightIndex2Mass/12) * (3 * (subjectParamsFromData.rightIndex2_z/2)^2 + subjectParamsFromData.rightIndex2_y^2);
% -----
% RIGHT INDEX3
% box sizes
subjectParamsFromData.rightIndex3_y = abs(totalIndexLength - subjectParamsFromData.rightIndex1_y - subjectParamsFromData.rightIndex2_y);
subjectParamsFromData.rightIndex3_z = indFinger_x;
% box origin
subjectParamsFromData.jRightIndex3_rotxOrigin = [0, -subjectParamsFromData.rightIndex2_y, 0]; % wrt jRightIndex2_rotx
subjectParamsFromData.rightIndex3BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightIndex3_y, 0]; % wrt jRightIndex3_rotx
% Mass and inertia
subjectParamsFromData.rightIndex3Mass = 1/3 * totalIndexMass;
subjectParamsFromData.rightIndex3Ixx  = (subjectParamsFromData.rightIndex3Mass/12) * (3 * (subjectParamsFromData.rightIndex3_z/2)^2 + subjectParamsFromData.rightIndex3_y^2);
subjectParamsFromData.rightIndex3Iyy  = (subjectParamsFromData.rightIndex3Mass/2)  * ((subjectParamsFromData.rightIndex3_z/2)^2) ;
subjectParamsFromData.rightIndex3Izz  = (subjectParamsFromData.rightIndex3Mass/12) * (3 * (subjectParamsFromData.rightIndex3_z/2)^2 + subjectParamsFromData.rightIndex3_y^2);
%% RIGHT THUMB FINGER
totalThumbMass = (13 * totalHandMass)/100; % 13% of the total hand mass, assumption!!!
totalRightThumb_y = distance_thu1_thu4;
% -----
% RIGHT THUMB1
% box sizes
subjectParamsFromData.rightThumb1_y =  4/7 * rightPalm_y; %markersDistance.norm(thu1_thu2_index).difference(timestamp);
subjectParamsFromData.rightThumb1_z = subjectParamsFromData.rightIndex1_z;
% box origin
subjectParamsFromData.jRightThumb1_rotyOrigin = [1/2 * rightPalm_x, -3/8 * rightPalm_y, 0]; % wrt jRightWrist
subjectParamsFromData.rightThumb1BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightThumb1_y, 0]; % wrt jRightThumb1_roty
% Mass and inertia
subjectParamsFromData.rightThumb1Mass = 1/3 * totalThumbMass;
subjectParamsFromData.rightThumb1Ixx  = (subjectParamsFromData.rightThumb1Mass/12) * (3 * (subjectParamsFromData.rightThumb1_z/2)^2 + subjectParamsFromData.rightThumb1_y^2);
subjectParamsFromData.rightThumb1Iyy  = (subjectParamsFromData.rightThumb1Mass/2)  * ((subjectParamsFromData.rightThumb1_z/2)^2) ;
subjectParamsFromData.rightThumb1Izz  = (subjectParamsFromData.rightThumb1Mass/12) * (3 * (subjectParamsFromData.rightThumb1_z/2)^2 + subjectParamsFromData.rightThumb1_y^2);
% -----
% RIGHT THUMB2
% box sizes
subjectParamsFromData.rightThumb2_y = 4/7 * (totalRightThumb_y-subjectParamsFromData.rightThumb1_y); %markersDistance.norm(thu2_thu3_index).difference(timestamp); %
subjectParamsFromData.rightThumb2_z = subjectParamsFromData.rightIndex1_z;
% box origin
subjectParamsFromData.jRightThumb2_rotxOrigin = [0, -subjectParamsFromData.rightThumb1_y, 0]; % wrt jRightThumb1_roty
subjectParamsFromData.rightThumb2BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightThumb2_y, 0]; % jRightThumb2_rotx
% Mass and inertia
subjectParamsFromData.rightThumb2Mass = 1/3 * totalThumbMass;
subjectParamsFromData.rightThumb2Ixx  = (subjectParamsFromData.rightThumb2Mass/12) * (3 * (subjectParamsFromData.rightThumb2_z/2)^2 + subjectParamsFromData.rightThumb2_y^2);
subjectParamsFromData.rightThumb2Iyy  = (subjectParamsFromData.rightThumb2Mass/2)  * ((subjectParamsFromData.rightThumb2_z/2)^2) ;
subjectParamsFromData.rightThumb2Izz  = (subjectParamsFromData.rightThumb2Mass/12) * (3 * (subjectParamsFromData.rightThumb2_z/2)^2 + subjectParamsFromData.rightThumb2_y^2);
% -----
% RIGHT THUMB3
% box sizes
subjectParamsFromData.rightThumb3_y =  3/7 * (totalRightThumb_y-subjectParamsFromData.rightThumb1_y); %markersDistance.norm(thu3_thu4_index).difference(timestamp); %
subjectParamsFromData.rightThumb3_z = subjectParamsFromData.rightIndex1_z;
% box origin
subjectParamsFromData.jRightThumb3_rotxOrigin = [0, -subjectParamsFromData.rightThumb2_y, 0]; % wrt jRightThumb2_rotx
subjectParamsFromData.rightThumb3BoxOrigin    = 1/2 * [0, -subjectParamsFromData.rightThumb3_y, 0]; % jRightThumb3_rotx
% Mass and inertia
subjectParamsFromData.rightThumb3Mass = 1/3 * totalThumbMass;
subjectParamsFromData.rightThumb3Ixx  = (subjectParamsFromData.rightThumb3Mass/12) * (3 * (subjectParamsFromData.rightThumb3_z/2)^2 + subjectParamsFromData.rightThumb3_y^2);
subjectParamsFromData.rightThumb3Iyy  = (subjectParamsFromData.rightThumb3Mass/2)  * ((subjectParamsFromData.rightThumb3_z/2)^2) ;
subjectParamsFromData.rightThumb3Izz  = (subjectParamsFromData.rightThumb3Mass/12) * (3 * (subjectParamsFromData.rightThumb3_z/2)^2 + subjectParamsFromData.rightThumb3_y^2);

%% --LEFT HAND
%% LEFT PALM
indFinger_x = distance_ind1_mid1; % e.g., 0.024;
midFinger_x =  (distance_ind1_mid1/2) + (distance_mid1_rin1/2); % e.g., 0.018;
midFinger_x =  midFinger_x - (midFinger_x * 18/100); % model assumption, -18%;
rinFinger_x =  (distance_mid1_rin1/2) + (distance_rin1_lit1/2); % e.g., 0.014;
rinFinger_x = rinFinger_x - (rinFinger_x * 28/100); % model assumption, -28%;
litFinger_x =  distance_rin1_lit1; % e.g., 0.020;
litFinger_x = litFinger_x + (litFinger_x * 12/100); % model assumption, +12%;

B  = indFinger_x + midFinger_x + rinFinger_x + litFinger_x;
b  = distance_ulna_radio;
l1 = distance_radio_ind1;
l2 = distance_ulna_lit1;
trapeziumHeight = computeTrapeziumHeight(B,b,l1,l2);

% box sizes for the entire palm considered as a whole parallelepiped
leftPalm_x = B;
leftPalm_y = trapeziumHeight;
leftPalm_z = subjectParamsFromData.leftForeArm_z/2; % from anthropometric assumption
% -----
% LEFT PALM CLOSE TO THE THUMB (half of the left palm)
% box sizes
subjectParamsFromData.leftPalmCloseToThumbBox = [leftPalm_x/2, leftPalm_y, leftPalm_z];
% box origin
subjectParamsFromData.jLeftPalm_rotyOrigin = [0, 1/2 * leftPalm_y, 0]; % wrt jLeftWrist
subjectParamsFromData.leftPalmCloseToThumbBoxOrigin = [1/4 * leftPalm_x, 1/2 * leftPalm_y, 0]; % wrt jLeftWrist
% Mass and inertia
subjectParamsFromData.leftPalmCloseToThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParamsFromData.leftPalmCloseToThumbIxx  = (subjectParamsFromData.leftPalmCloseToThumbMass/12) * (leftPalm_y^2 + leftPalm_z^2);
subjectParamsFromData.leftPalmCloseToThumbIyy  = (subjectParamsFromData.leftPalmCloseToThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_z^2);
subjectParamsFromData.leftPalmCloseToThumbIzz  = (subjectParamsFromData.leftPalmCloseToThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_y^2);
% -----
% LEFT PALM FAR FROM THE THUMB (half of the left palm)
% box sizes
subjectParamsFromData.leftPalmFarFromThumbBox = [leftPalm_x/2, leftPalm_y, leftPalm_z];
% box origin
subjectParamsFromData.leftPalmFarFromThumbBoxOrigin = [-1/4 * leftPalm_x, 0, 0]; % wrt jLeftPalm_roty
% Mass and inertia
subjectParamsFromData.leftPalmFarFromThumbMass = (25 * totalHandMass)/100; % 25% of the total hand mass, assumption!!!
subjectParamsFromData.leftPalmFarFromThumbIxx  = (subjectParamsFromData.leftPalmFarFromThumbMass/12) * (leftPalm_y^2 + leftPalm_z^2);
subjectParamsFromData.leftPalmFarFromThumbIyy  = (subjectParamsFromData.leftPalmFarFromThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_z^2);
subjectParamsFromData.leftPalmFarFromThumbIzz  = (subjectParamsFromData.leftPalmFarFromThumbMass/12) * ((leftPalm_x/2)^2 + leftPalm_y^2);
%% LEFT PINKY
totalPinkyLength = distance_lit1_lit3;
totalPinkyMass   = (7 * totalHandMass)/100; % 7% of the total hand mass, assumption!!!
% -----
% LEFT PINKY1
% box sizes
subjectParamsFromData.leftPinky1_y = distance_lit1_lit2;
subjectParamsFromData.leftPinky1_z = litFinger_x;
% box origin
subjectParamsFromData.litFinger_origin = leftPalm_x/2 - litFinger_x/2;
subjectParamsFromData.jLeftPinky1_rotxOrigin = [-subjectParamsFromData.litFinger_origin, 1/2 * leftPalm_y, 0]; % wrt jLeftPalm_roty
subjectParamsFromData.leftPinky1BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftPinky1_y, 0]; % wrt jLeftPinky1_rotx
% Mass and inertia
subjectParamsFromData.leftPinky1Mass = 1/3 * totalPinkyMass;
subjectParamsFromData.leftPinky1Ixx  = (subjectParamsFromData.leftPinky1Mass/12) * (3 * (subjectParamsFromData.leftPinky1_z/2)^2 + subjectParamsFromData.leftPinky1_y^2);
subjectParamsFromData.leftPinky1Iyy  = (subjectParamsFromData.leftPinky1Mass/2)  * ((subjectParamsFromData.leftPinky1_z/2)^2) ;
subjectParamsFromData.leftPinky1Izz  = (subjectParamsFromData.leftPinky1Mass/12) * (3 * (subjectParamsFromData.leftPinky1_z/2)^2 + subjectParamsFromData.leftPinky1_y^2);
% -----
% LEFT PINKY2
% box sizes
subjectParamsFromData.leftPinky2_y = (subjectParamsFromData.leftPinky1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.leftPinky2_z = litFinger_x;
% box origin
subjectParamsFromData.jLeftPinky2_rotxOrigin = [0, subjectParamsFromData.leftPinky1_y, 0]; % wrt jLeftPinky1_rotx
subjectParamsFromData.leftPinky2BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftPinky2_y, 0]; % wrt jLeftPinky2_rotx
% Mass and inertia
subjectParamsFromData.leftPinky2Mass = 1/3 * totalPinkyMass;
subjectParamsFromData.leftPinky2Ixx  = (subjectParamsFromData.leftPinky2Mass/12) * (3 * (subjectParamsFromData.leftPinky2_z/2)^2 + subjectParamsFromData.leftPinky2_y^2);
subjectParamsFromData.leftPinky2Iyy  = (subjectParamsFromData.leftPinky2Mass/2)  * ((subjectParamsFromData.leftPinky2_z/2)^2) ;
subjectParamsFromData.leftPinky2Izz  = (subjectParamsFromData.leftPinky2Mass/12) * (3 * (subjectParamsFromData.leftPinky2_z/2)^2 + subjectParamsFromData.leftPinky2_y^2);
% -----
% LEFT PINKY3
% box sizes
subjectParamsFromData.leftPinky3_y = abs(totalPinkyLength - subjectParamsFromData.leftPinky1_y - subjectParamsFromData.leftPinky2_y);
subjectParamsFromData.leftPinky3_z = litFinger_x;
% box origin
subjectParamsFromData.jLeftPinky3_rotxOrigin = [0, subjectParamsFromData.leftPinky2_y, 0]; % wrt jLeftPinky2_rotx
subjectParamsFromData.leftPinky3BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftPinky3_y, 0]; % wrt jLeftPinky3_rotx
% Mass and inertia
subjectParamsFromData.leftPinky3Mass = 1/3 * totalPinkyMass;
subjectParamsFromData.leftPinky3Ixx  = (subjectParamsFromData.leftPinky3Mass/12) * (3 * (subjectParamsFromData.leftPinky3_z/2)^2 + subjectParamsFromData.leftPinky3_y^2);
subjectParamsFromData.leftPinky3Iyy  = (subjectParamsFromData.leftPinky3Mass/2)  * ((subjectParamsFromData.leftPinky3_z/2)^2) ;
subjectParamsFromData.leftPinky3Izz  = (subjectParamsFromData.leftPinky3Mass/12) * (3 * (subjectParamsFromData.leftPinky3_z/2)^2 + subjectParamsFromData.leftPinky3_y^2);
%% LEFT RING FINGER
totalRingLength = distance_rin1_rin3;
totalRingMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% -----
% LEFT RING1
% box sizes
subjectParamsFromData.leftRing1_y = distance_rin1_rin2;
subjectParamsFromData.leftRing1_z = rinFinger_x;
% box origin
subjectParamsFromData.rinFinger_origin = leftPalm_x/2 - litFinger_x - rinFinger_x/2;
subjectParamsFromData.jLeftRing1_rotxOrigin = [-subjectParamsFromData.rinFinger_origin, 1/2 * leftPalm_y, 0]; % wrt jLeftPalm_roty
subjectParamsFromData.leftRing1BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftRing1_y, 0]; % wrt jLeftRing1_rotx
% Mass and inertia
subjectParamsFromData.leftRing1Mass = 1/3 * totalRingMass;
subjectParamsFromData.leftRing1Ixx  = (subjectParamsFromData.leftRing1Mass/12) * (3 * (subjectParamsFromData.leftRing1_z/2)^2 + subjectParamsFromData.leftRing1_y^2);
subjectParamsFromData.leftRing1Iyy  = (subjectParamsFromData.leftRing1Mass/2)  * ((subjectParamsFromData.leftRing1_z/2)^2) ;
subjectParamsFromData.leftRing1Izz  = (subjectParamsFromData.leftRing1Mass/12) * (3 * (subjectParamsFromData.leftRing1_z/2)^2 + subjectParamsFromData.leftRing1_y^2);
% -----
% LEFT RING2
% box sizes
subjectParamsFromData.leftRing2_y = (subjectParamsFromData.leftRing1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.leftRing2_z = rinFinger_x;
% box origin
subjectParamsFromData.jLeftRing2_rotxOrigin = [0, subjectParamsFromData.leftRing1_y, 0]; % wrt jLeftRing1_rotx
subjectParamsFromData.leftRing2BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftRing2_y, 0]; % wrt jLeftRing2_rotx
% Mass and inertia
subjectParamsFromData.leftRing2Mass = 1/3 * totalRingMass;
subjectParamsFromData.leftRing2Ixx  = (subjectParamsFromData.leftRing2Mass/12) * (3 * (subjectParamsFromData.leftRing2_z/2)^2 + subjectParamsFromData.leftRing2_y^2);
subjectParamsFromData.leftRing2Iyy  = (subjectParamsFromData.leftRing2Mass/2)  * ((subjectParamsFromData.leftRing2_z/2)^2) ;
subjectParamsFromData.leftRing2Izz  = (subjectParamsFromData.leftRing2Mass/12) * (3 * (subjectParamsFromData.leftRing2_z/2)^2 + subjectParamsFromData.leftRing2_y^2);
% -----
% LEFT RING3
% box sizes
subjectParamsFromData.leftRing3_y = abs(totalRingLength - subjectParamsFromData.leftRing1_y - subjectParamsFromData.leftRing2_y);
subjectParamsFromData.leftRing3_z = rinFinger_x;
% box origin
subjectParamsFromData.jLeftRing3_rotxOrigin = [0, subjectParamsFromData.leftRing2_y, 0]; % wrt jLeftRing2_rotx
subjectParamsFromData.leftRing3BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftRing3_y, 0]; % wrt jLeftRing3_rotx
% Mass and inertia
subjectParamsFromData.leftRing3Mass = 1/3 * totalRingMass;
subjectParamsFromData.leftRing3Ixx  = (subjectParamsFromData.leftRing3Mass/12) * (3 * (subjectParamsFromData.leftRing3_z/2)^2 + subjectParamsFromData.leftRing3_y^2);
subjectParamsFromData.leftRing3Iyy  = (subjectParamsFromData.leftRing3Mass/2)  * ((subjectParamsFromData.leftRing3_z/2)^2) ;
subjectParamsFromData.leftRing3Izz  = (subjectParamsFromData.leftRing3Mass/12) * (3 * (subjectParamsFromData.leftRing3_z/2)^2 + subjectParamsFromData.leftRing3_y^2);
%% LEFT MIDDLE FINGER
totalMiddleLength = distance_mid1_mid3;
totalMiddleMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% -----
% LEFT MIDDLE1
% box sizes
subjectParamsFromData.leftMiddle1_y = distance_mid1_mid2;
subjectParamsFromData.leftMiddle1_z = midFinger_x;
% box origin
subjectParamsFromData.midFinger_origin = leftPalm_x/2 - indFinger_x - midFinger_x/2;
subjectParamsFromData.jLeftMiddle1_rotxOrigin = [subjectParamsFromData.midFinger_origin, leftPalm_y, 0]; % wrt jLeftWrist
subjectParamsFromData.leftMiddle1BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftMiddle1_y, 0]; % wrt jLeftMiddle1_rotx
% Mass and inertia
subjectParamsFromData.leftMiddle1Mass = 1/3 * totalMiddleMass;
subjectParamsFromData.leftMiddle1Ixx  = (subjectParamsFromData.leftMiddle1Mass/12) * (3 * (subjectParamsFromData.leftMiddle1_z/2)^2 + subjectParamsFromData.leftMiddle1_y^2);
subjectParamsFromData.leftMiddle1Iyy  = (subjectParamsFromData.leftMiddle1Mass/2)  * ((subjectParamsFromData.leftMiddle1_z/2)^2) ;
subjectParamsFromData.leftMiddle1Izz  = (subjectParamsFromData.leftMiddle1Mass/12) * (3 * (subjectParamsFromData.leftMiddle1_z/2)^2 + subjectParamsFromData.leftMiddle1_y^2);
% -----
% LEFT MIDDLE2
% box sizes
subjectParamsFromData.leftMiddle2_y = (subjectParamsFromData.leftMiddle1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.leftMiddle2_z = midFinger_x;
% box origin
subjectParamsFromData.jLeftMiddle2_rotxOrigin = [0, subjectParamsFromData.leftMiddle1_y, 0]; % wrt jLeftMiddle1_rotx
subjectParamsFromData.leftMiddle2BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftMiddle2_y, 0]; % wrt jLeftMiddle2_rotx
% Mass and inertia
subjectParamsFromData.leftMiddle2Mass = 1/3 * totalMiddleMass;
subjectParamsFromData.leftMiddle2Ixx  = (subjectParamsFromData.leftMiddle2Mass/12) * (3 * (subjectParamsFromData.leftMiddle2_z/2)^2 + subjectParamsFromData.leftMiddle2_y^2);
subjectParamsFromData.leftMiddle2Iyy  = (subjectParamsFromData.leftMiddle2Mass/2)  * ((subjectParamsFromData.leftMiddle2_z/2)^2) ;
subjectParamsFromData.leftMiddle2Izz  = (subjectParamsFromData.leftMiddle2Mass/12) * (3 * (subjectParamsFromData.leftMiddle2_z/2)^2 + subjectParamsFromData.leftMiddle2_y^2);
% -----
% LEFT MIDDLE3
% box sizes
subjectParamsFromData.leftMiddle3_y = abs(totalMiddleLength - subjectParamsFromData.leftMiddle1_y - subjectParamsFromData.leftMiddle2_y);
subjectParamsFromData.leftMiddle3_z = midFinger_x;
% box origin
subjectParamsFromData.jLeftMiddle3_rotxOrigin = [0, subjectParamsFromData.leftMiddle2_y, 0]; % wrt jLeftMiddle2_rotx
subjectParamsFromData.leftMiddle3BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftMiddle3_y, 0]; % wrt jLeftMiddle3_rotx
% Mass and inertia
subjectParamsFromData.leftMiddle3Mass = 1/3 * totalMiddleMass;
subjectParamsFromData.leftMiddle3Ixx  = (subjectParamsFromData.leftMiddle3Mass/12) * (3 * (subjectParamsFromData.leftMiddle3_z/2)^2 + subjectParamsFromData.leftMiddle3_y^2);
subjectParamsFromData.leftMiddle3Iyy  = (subjectParamsFromData.leftMiddle3Mass/2)  * ((subjectParamsFromData.leftMiddle3_z/2)^2) ;
subjectParamsFromData.leftMiddle3Izz  = (subjectParamsFromData.leftMiddle3Mass/12) * (3 * (subjectParamsFromData.leftMiddle3_z/2)^2 + subjectParamsFromData.leftMiddle3_y^2);
%% LEFT INDEX FINGER
totalIndexLength = distance_ind1_ind3;
totalIndexMass   = (10 * totalHandMass)/100; % 10% of the total hand mass, assumption!!!
% -----
% LEFT INDEX1
% box sizes
subjectParamsFromData.leftIndex1_y = distance_ind1_ind2;
subjectParamsFromData.leftIndex1_z = indFinger_x;
% box origin
subjectParamsFromData.indFinger_origin = leftPalm_x/2 - indFinger_x/2;
subjectParamsFromData.jLeftIndex1_rotxOrigin = [subjectParamsFromData.indFinger_origin, leftPalm_y, 0]; % wrt jLeftWrist
subjectParamsFromData.leftIndex1BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftIndex1_y, 0]; % wrt jLeftIndex1_rotx
% Mass and inertia
subjectParamsFromData.leftIndex1Mass = 1/3 * totalIndexMass;
subjectParamsFromData.leftIndex1Ixx  = (subjectParamsFromData.leftIndex1Mass/12) * (3 * (subjectParamsFromData.leftIndex1_z/2)^2 + subjectParamsFromData.leftIndex1_y^2);
subjectParamsFromData.leftIndex1Iyy  = (subjectParamsFromData.leftIndex1Mass/2)  * ((subjectParamsFromData.leftIndex1_z/2)^2) ;
subjectParamsFromData.leftIndex1Izz  = (subjectParamsFromData.leftIndex1Mass/12) * (3 * (subjectParamsFromData.leftIndex1_z/2)^2 + subjectParamsFromData.leftIndex1_y^2);
% -----
% LEFT INDEX2
% box sizes
subjectParamsFromData.leftIndex2_y = (subjectParamsFromData.leftIndex1_y * fib.idealSecondDigit)/fib.idealFirstDigit;
subjectParamsFromData.leftIndex2_z = indFinger_x;
% box origin
subjectParamsFromData.jLeftIndex2_rotxOrigin = [0, subjectParamsFromData.leftIndex1_y, 0]; % wrt jLeftIndex1_rotx
subjectParamsFromData.leftIndex2BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftIndex2_y, 0]; % wrt jLeftIndex2_rotx
% Mass and inertia
subjectParamsFromData.leftIndex2Mass = 1/3 * totalIndexMass;
subjectParamsFromData.leftIndex2Ixx  = (subjectParamsFromData.leftIndex2Mass/12) * (3 * (subjectParamsFromData.leftIndex2_z/2)^2 + subjectParamsFromData.leftIndex2_y^2);
subjectParamsFromData.leftIndex2Iyy  = (subjectParamsFromData.leftIndex2Mass/2)  * ((subjectParamsFromData.leftIndex2_z/2)^2) ;
subjectParamsFromData.leftIndex2Izz  = (subjectParamsFromData.leftIndex2Mass/12) * (3 * (subjectParamsFromData.leftIndex2_z/2)^2 + subjectParamsFromData.leftIndex2_y^2);
% -----
% LEFT INDEX3
% box sizes
subjectParamsFromData.leftIndex3_y = abs(totalIndexLength - subjectParamsFromData.leftIndex1_y - subjectParamsFromData.leftIndex2_y);
subjectParamsFromData.leftIndex3_z = indFinger_x;
% box origin
subjectParamsFromData.jLeftIndex3_rotxOrigin = [0, subjectParamsFromData.leftIndex2_y, 0]; % wrt jLeftIndex2_rotx
subjectParamsFromData.leftIndex3BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftIndex3_y, 0]; % wrt jLeftIndex3_rotx
% Mass and inertia
subjectParamsFromData.leftIndex3Mass = 1/3 * totalIndexMass;
subjectParamsFromData.leftIndex3Ixx  = (subjectParamsFromData.leftIndex3Mass/12) * (3 * (subjectParamsFromData.leftIndex3_z/2)^2 + subjectParamsFromData.leftIndex3_y^2);
subjectParamsFromData.leftIndex3Iyy  = (subjectParamsFromData.leftIndex3Mass/2)  * ((subjectParamsFromData.leftIndex3_z/2)^2) ;
subjectParamsFromData.leftIndex3Izz  = (subjectParamsFromData.leftIndex3Mass/12) * (3 * (subjectParamsFromData.leftIndex3_z/2)^2 + subjectParamsFromData.leftIndex3_y^2);
%% LEFT THUMB FINGER
totalThumbMass = (13 * totalHandMass)/100; % 13% of the total hand mass, assumption!!!
totalLeftThumb_y = distance_thu1_thu4;
% -----
% LEFT THUMB1
% box sizes
subjectParamsFromData.leftThumb1_y =  4/7 * leftPalm_y; %markersDistance.norm(thu1_thu2_index).difference(timestamp);
subjectParamsFromData.leftThumb1_z = subjectParamsFromData.leftIndex1_z;
% box origin
subjectParamsFromData.jLeftThumb1_rotyOrigin = [1/2 * leftPalm_x, 3/8 * leftPalm_y, 0]; % wrt jLeftWrist
subjectParamsFromData.leftThumb1BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftThumb1_y, 0]; % wrt jLeftThumb1_roty
% Mass and inertia
subjectParamsFromData.leftThumb1Mass = 1/3 * totalThumbMass;
subjectParamsFromData.leftThumb1Ixx  = (subjectParamsFromData.leftThumb1Mass/12) * (3 * (subjectParamsFromData.leftThumb1_z/2)^2 + subjectParamsFromData.leftThumb1_y^2);
subjectParamsFromData.leftThumb1Iyy  = (subjectParamsFromData.leftThumb1Mass/2)  * ((subjectParamsFromData.leftThumb1_z/2)^2) ;
subjectParamsFromData.leftThumb1Izz  = (subjectParamsFromData.leftThumb1Mass/12) * (3 * (subjectParamsFromData.leftThumb1_z/2)^2 + subjectParamsFromData.leftThumb1_y^2);
% -----
% LEFT THUMB2
% box sizes
subjectParamsFromData.leftThumb2_y = 4/7 * (totalLeftThumb_y-subjectParamsFromData.leftThumb1_y); %markersDistance.norm(thu2_thu3_index).difference(timestamp); %
subjectParamsFromData.leftThumb2_z = subjectParamsFromData.leftIndex1_z;
% box origin
subjectParamsFromData.jLeftThumb2_rotxOrigin = [0, subjectParamsFromData.leftThumb1_y, 0]; % wrt jLeftThumb1_roty
subjectParamsFromData.leftThumb2BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftThumb2_y, 0]; % jLeftThumb2_rotx
% Mass and inertia
subjectParamsFromData.leftThumb2Mass = 1/3 * totalThumbMass;
subjectParamsFromData.leftThumb2Ixx  = (subjectParamsFromData.leftThumb2Mass/12) * (3 * (subjectParamsFromData.leftThumb2_z/2)^2 + subjectParamsFromData.leftThumb2_y^2);
subjectParamsFromData.leftThumb2Iyy  = (subjectParamsFromData.leftThumb2Mass/2)  * ((subjectParamsFromData.leftThumb2_z/2)^2) ;
subjectParamsFromData.leftThumb2Izz  = (subjectParamsFromData.leftThumb2Mass/12) * (3 * (subjectParamsFromData.leftThumb2_z/2)^2 + subjectParamsFromData.leftThumb2_y^2);
% -----
% LEFT THUMB3
% box sizes
subjectParamsFromData.leftThumb3_y =  3/7 * (totalLeftThumb_y-subjectParamsFromData.leftThumb1_y); %markersDistance.norm(thu3_thu4_index).difference(timestamp); %
subjectParamsFromData.leftThumb3_z = subjectParamsFromData.leftIndex1_z;
% box origin
subjectParamsFromData.jLeftThumb3_rotxOrigin = [0, subjectParamsFromData.leftThumb2_y, 0]; % wrt jLeftThumb2_rotx
subjectParamsFromData.leftThumb3BoxOrigin    = 1/2 * [0, subjectParamsFromData.leftThumb3_y, 0]; % jLeftThumb3_rotx
% Mass and inertia
subjectParamsFromData.leftThumb3Mass = 1/3 * totalThumbMass;
subjectParamsFromData.leftThumb3Ixx  = (subjectParamsFromData.leftThumb3Mass/12) * (3 * (subjectParamsFromData.leftThumb3_z/2)^2 + subjectParamsFromData.leftThumb3_y^2);
subjectParamsFromData.leftThumb3Iyy  = (subjectParamsFromData.leftThumb3Mass/2)  * ((subjectParamsFromData.leftThumb3_z/2)^2) ;
subjectParamsFromData.leftThumb3Izz  = (subjectParamsFromData.leftThumb3Mass/12) * (3 * (subjectParamsFromData.leftThumb3_z/2)^2 + subjectParamsFromData.leftThumb3_y^2);

%% --EXTRA MARKERS
subjectParamsFromData.distance_palmForeArm = computeTriangleHeight(distance_palm_ulna,distance_palm_radio,distance_ulna_radio);
subjectParamsFromData.distance_wristHand   = computeTriangleHeight(distance_radio_wrist,distance_ulna_wrist,distance_ulna_radio);
subjectParamsFromData.distance_ulnaRadio   = b;




%% ------------------------- Inline functions -----------------------------
function [h] = computeTrapeziumHeight(B,b,l1,l2)
%COMPUTETRAPEZIUMHEIGHT computes the height of a scalene trapezium.
% Input: - B, maximum base
%        - b, minimum base
%        - l1,l2 lateral sides
% Compute area
R = (-b+B+l1+l2) * (-B+b+l1+l2) * (-B+b-l1+l2) * (-B+b+l1-l2);
A = ((B+b)/(4*(B-b))) * sqrt(R);
% Compute height from area
h = (2*A)/(B+b);
end

function [h] = computeTriangleHeight(l1,l2,b)
%COMPUTETRIANGLEHEIGHT computes the height of a generic triangle via Heron's formula.
% Input:  - l1,l2, sides
%         - b base
% Compute area
sp = (l1 + l2 + b)/2;
A = sqrt(sp * (sp-l1) * (sp-l2) * (sp-b));
% Compute height from area
h = (2*A)/b;
end

function fib = fibonacciWrapper(n)
%FIBONACCIWRAPPER generates the first n numbers of the Fibonacci's series.
fib = zeros(n,1);
fib(1) = 1;
fib(2) = 2;
for k = 3:n
    fib(k) = fib(k-1) + fib(k-2);
end
end
end
