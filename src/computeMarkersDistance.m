
% Copyright (C) 2021 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [distance] = computeMarkersDistance(masterFile)
%COMPUTEMARKERSDISTANCE computes the distance between markers in [m]
% via the 2-norm.

trialLength = length(masterFile.markersRaw.Time{1,1});
differenceLabels = {
    'radio-ind1',  'ulna-radio','ulna-lit1', ... % palm trapezium
    'ind1-mid1', 'mid1-rin1','rin1-lit1',    ... % finger width
    'lit1-lit2', 'lit1-lit3',                ... % pinky
    'rin1-rin2', 'rin1-rin3',                ... % ring
    'mid1-mid2', 'mid1-mid3',                ... % middle
    'ind1-ind2', 'ind1-ind3',                ... % index
    'thu1-thu4',                             ... % thumb
    'palm-radio', 'palm-ulna', 'radio-wrist', 'ulna-wrist' ... % extra
    };
nrOfDifference = length(differenceLabels);

for diffIdx = 1 : nrOfDifference
    distance.norm(diffIdx).label = differenceLabels{diffIdx};
    dividends = split(differenceLabels{diffIdx}, "-");
    for lenIdx = 1 : trialLength
        dividend1data = masterFile.markersRaw.(dividends{1});
        dividend2data = masterFile.markersRaw.(dividends{2});
        distance.norm(diffIdx).difference(1,lenIdx) = norm(dividend1data.xyz{1, 1}(lenIdx,:) - ...
            dividend2data.xyz{1, 1}(lenIdx,:)) * 1e-3;
    end
    % Static acquisition: first 50 samples of the acquisition
    distance.norm(diffIdx).mean_staticAcquisition = mean(distance.norm(diffIdx).difference(:,1:50));
end
end
