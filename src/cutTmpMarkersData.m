
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function tmp = cutTmpMarkersData(tmp, masterFile)
%CUTTMPMARKERSDATA cuts Vicon markers dataset.

tmp.timeCut     = [tmp.timeCut masterFile.markersRaw.Time];
tmp.palmPosCut  = [tmp.palmPosCut masterFile.markersRaw.palm.xyz];
tmp.lit1PosCut  = [tmp.lit1PosCut masterFile.markersRaw.lit1.xyz];
tmp.lit2PosCut  = [tmp.lit2PosCut masterFile.markersRaw.lit2.xyz];
tmp.lit3PosCut  = [tmp.lit3PosCut masterFile.markersRaw.lit3.xyz];
tmp.rin1PosCut  = [tmp.rin1PosCut masterFile.markersRaw.rin1.xyz];
tmp.rin2PosCut  = [tmp.rin2PosCut masterFile.markersRaw.rin2.xyz];
tmp.rin3PosCut  = [tmp.rin3PosCut masterFile.markersRaw.rin3.xyz];
tmp.mid1PosCut  = [tmp.mid1PosCut masterFile.markersRaw.mid1.xyz];
tmp.mid2PosCut  = [tmp.mid2PosCut masterFile.markersRaw.mid2.xyz];
tmp.mid3PosCut  = [tmp.mid3PosCut masterFile.markersRaw.mid3.xyz];
tmp.ind1PosCut  = [tmp.ind1PosCut masterFile.markersRaw.ind1.xyz];
tmp.ind2PosCut  = [tmp.ind2PosCut masterFile.markersRaw.ind2.xyz];
tmp.ind3PosCut  = [tmp.ind3PosCut masterFile.markersRaw.ind3.xyz];
tmp.thu1PosCut  = [tmp.thu1PosCut masterFile.markersRaw.thu1.xyz];
tmp.thu2PosCut  = [tmp.thu2PosCut masterFile.markersRaw.thu2.xyz];
tmp.thu3PosCut  = [tmp.thu3PosCut masterFile.markersRaw.thu3.xyz];
tmp.thu4PosCut  = [tmp.thu4PosCut masterFile.markersRaw.thu4.xyz];
tmp.radioPosCut = [tmp.radioPosCut masterFile.markersRaw.radio.xyz];
tmp.ulnaPosCut  = [tmp.ulnaPosCut  masterFile.markersRaw.ulna.xyz];
tmp.wristPosCut = [tmp.wristPosCut masterFile.markersRaw.wrist.xyz];
end
