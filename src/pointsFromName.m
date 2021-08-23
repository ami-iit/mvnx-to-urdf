
% Copyright (C) 2018 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [points, found] = pointsFromName(pointsStruct, pointName)
% POINTSFROMNAME returns the struct related to the point string you
% are looking for.
%
% Inputs:
% - points    : struct of type points;
% - pointName : string denoting the point you are looking for;
%
% Outputs:
% - points    : 3x1 vector of points;
% - found     : true if point has been found, false otherwise.

for indx = 1 : pointsStruct.nrOfPoints
    if  strcmp(pointsStruct.label{1,indx},pointName)
        points = pointsStruct.pointsValue(:,indx);
        found = true;
        break;
    else 
        found = false;
    end   
end
if found == false
    error(sprintf('Something wrong in the acquisition! Point label <%s> not found.',pointName));
end
end