
% Copyright (C) 2021 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

tmp.nrOfCounter = 0;
tmp = resetTmpMarkersData(tmp);
tmp.nrOfCounter  = tmp.nrOfCounter + 1;
tmp = cutTmpMarkersData(tmp, masterFile);

% Transform markers data from (original) [mm] into [m]
markersData.time           = tmp.timeCut{1,1};
markersData.position.palm  = tmp.palmPosCut{1,1} * 1e-3;
markersData.position.lit1  = tmp.lit1PosCut{1,1} * 1e-3;
markersData.position.lit2  = tmp.lit2PosCut{1,1} * 1e-3;
markersData.position.lit3  = tmp.lit3PosCut{1,1} * 1e-3;
markersData.position.rin1  = tmp.rin1PosCut{1,1} * 1e-3;
markersData.position.rin2  = tmp.rin2PosCut{1,1} * 1e-3;
markersData.position.rin3  = tmp.rin3PosCut{1,1} * 1e-3;
markersData.position.mid1  = tmp.mid1PosCut{1,1} * 1e-3;
markersData.position.mid2  = tmp.mid2PosCut{1,1} * 1e-3;
markersData.position.mid3  = tmp.mid3PosCut{1,1} * 1e-3;
markersData.position.ind1  = tmp.ind1PosCut{1,1} * 1e-3;
markersData.position.ind2  = tmp.ind2PosCut{1,1} * 1e-3;
markersData.position.ind3  = tmp.ind3PosCut{1,1} * 1e-3;
markersData.position.thu1  = tmp.thu1PosCut{1,1} * 1e-3;
markersData.position.thu2  = tmp.thu2PosCut{1,1} * 1e-3;
markersData.position.thu3  = tmp.thu3PosCut{1,1} * 1e-3;
markersData.position.thu4  = tmp.thu4PosCut{1,1} * 1e-3;
markersData.position.radio = tmp.radioPosCut{1,1} * 1e-3;
markersData.position.ulna  = tmp.ulnaPosCut{1,1}  * 1e-3;
markersData.position.wrist = tmp.wristPosCut{1,1} * 1e-3;
