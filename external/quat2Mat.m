
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [R] = quat2Mat(q)
    %quat2Mat Utility function to convert a quaternion in a rotation matrix
    % This function map exactly the same code of iDynTree function

    % Check if quaternion is normalized, otherwise normalize it
    if ~(norm(q) == 1.0)
        q = q / norm(q);
    end

    % Initialize the output matrix
    R = zeros(3);

    % Fill the rotation matrix
    R(1,1) = 1 - 2*(q(4)*q(4) + q(3)*q(3));
    R(2,2) = 1 - 2*(q(4)*q(4) + q(2)*q(2));
    R(3,3) = 1 - 2*(q(3)*q(3) + q(2)*q(2));

    R(1,2) = 2 * q(2)*q(3) - 2 * q(4)*q(1);
    R(2,1) = 2 * q(2)*q(3) + 2 * q(4)*q(1);

    R(1,3) = 2 * q(2)*q(4) + 2 * q(3)*q(1);
    R(3,1) = 2 * q(2)*q(4) - 2 * q(3)*q(1);

    R(2,3) = 2 * q(3)*q(4) - 2 * q(2)*q(1);
    R(3,2) = 2 * q(3)*q(4) + 2 * q(2)*q(1);

end

