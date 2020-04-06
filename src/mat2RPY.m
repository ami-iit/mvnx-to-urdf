
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [rpy] = mat2RPY(R)
    %mat2RPY Utility function to convert from rotation matrix to RPY
    % This function map exactly the same code of iDynTree function

    rpy = zeros(3,1);

    if (R(3,1) < 1.0)
        if (R(3,1) > -1.0)
            rpy(1) = atan2(R(3,2), R(3,3));
            rpy(2) = asin(-R(3,1));
            rpy(3) = atan2(R(2,1), R(1,1));
        else
           % Not a unique solution
           rpy(1) = 0.0;
           rpy(2) = pi / 2.0;
           rpy(3) = -atan2(-R(2,3), R(2,2));
        end
    else
        % Not a unique solution
           rpy(1) = 0.0;
           rpy(2) = pi / 2.0;
           rpy(3) = atan2(-R(2,3), R(2,2));
    end
end 