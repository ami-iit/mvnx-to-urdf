
% Copyright (C) 2018 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [jointList] = extractJointsFromModel(humanModel)
%EXTRACTJOINTSFROMMODEL creates a struct with the index, the label and the
% type per each joint in the .urdf model.

nrOfJoints = humanModel.getNrOfJoints;
joints.iDynTree_idx = cell(nrOfJoints,1);
joints.name         = cell(nrOfJoints,1);
for jointIdx = 0 : nrOfJoints-1
    joints.iDynTree_idx{jointIdx+1} = humanModel.getJointIndex(humanModel.getJointName(jointIdx));
    joints.name{jointIdx+1}         = humanModel.getJointName(jointIdx);
end

if humanModel.getNrOfJoints == humanModel.getNrOfDOFs
    type = 'revolute';
end

for i = 1 : nrOfJoints
    jointList(i).idx   = joints.iDynTree_idx{i};
    jointList(i).label = joints.name{i};
    jointList(i).type  = type;
end
end
