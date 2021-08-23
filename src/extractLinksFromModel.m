
% Copyright (C) 2018 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [linkList] = extractLinksFromModel(humanModel)
%EXTRACTLINKSFROMMODEL creates a struct with the index and the label per
%each link in the .urdf model.

nrOfLinks = humanModel.getNrOfLinks;
links.iDynTree_idx = cell(nrOfLinks,1);
links.name         = cell(nrOfLinks,1);
for linkIdx = 0 : nrOfLinks-1
    links.iDynTree_idx{linkIdx+1} = humanModel.getFrameIndex(humanModel.getFrameName(linkIdx));
    links.name{linkIdx+1}         = humanModel.getFrameName(linkIdx);
end

for i = 1 : nrOfLinks
    linkList(i).idx   = links.iDynTree_idx{i};
    linkList(i).label = links.name{i};
end
end
