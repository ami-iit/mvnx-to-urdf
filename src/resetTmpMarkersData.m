
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function tmp = resetTmpMarkersData(tmp)
%RESETTMPMARKERSPOS resets temporary markers data used for computation.

tmp.nrOfCounter = 0;
tmp.timeCut     = [];
tmp.palmPosCut  = [];
tmp.lit1PosCut  = [];
tmp.lit2PosCut  = [];
tmp.lit3PosCut  = [];
tmp.rin1PosCut  = [];
tmp.rin2PosCut  = [];
tmp.rin3PosCut  = [];
tmp.mid1PosCut  = [];
tmp.mid2PosCut  = [];
tmp.mid3PosCut  = [];
tmp.ind1PosCut  = [];
tmp.ind2PosCut  = [];
tmp.ind3PosCut  = [];
tmp.thu1PosCut  = [];
tmp.thu2PosCut  = [];
tmp.thu3PosCut  = [];
tmp.thu4PosCut  = [];
tmp.radioPosCut = [];
tmp.ulnaPosCut  = [];
tmp.wristPosCut = [];
end
