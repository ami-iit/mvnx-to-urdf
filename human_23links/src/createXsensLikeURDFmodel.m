
% Copyright (C) 2018 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [urdfModelTemplate] = createXsensLikeURDFmodel(DoFs_number, subjectParams, sensors, varargin)
%CREATEXSENSLIKEURDFMODEL generates a URDF model of the subject.
%
% Inputs :
% -  DoFs_number   : number of DoFs of the model;
% -  subjectParams : anthropometric parameters coming from the previous
%                    function;
% -  sensors       :  sensors information coming from suit;
% -  filename      : (optional) allows to save the file.urdf in a folder
%                     called 'Models'.
% -  GazeboModel   : (optional) true or false. If true a model for Gazebo
%                    is generated with masses and inertias different from 0

options = struct(   ...
    'FILENAME',      '',...
    'GAZEBOMODEL',  false...
    );

% read the acceptable names
optionNames = fieldnames(options);

% count arguments
nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
    error('createXsensLikeURDFmodel needs propertyName/propertyValue pairs')
end

for pair = reshape(varargin,2,[]) % pair is {propName;propValue}
    inpName = upper(pair{1}); % make case insensitive
    
    if any(strcmp(inpName,optionNames))
        % overwrite options. If you want you can test for the right class here
        % Also, if you find out that there is an option you keep getting wrong,
        % you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
        options.(inpName) = pair{2};
    else
        error('%s is not a recognized parameter name',inpName)
    end
end

fileUrdfName = sprintf('XSensModelStyle_%dURDFtemplate.urdf',DoFs_number);
urdfModelTemplate = fileread(fileUrdfName);
%% Check sensor existence
if exist('sensors', 'var')
    fileID = fopen(fileUrdfName, 'w');
    for i = 1 : size(sensors,1)
        fprintf(fileID,sprintf('<!-- Sensor % d-->\n',i));
        fprintf(fileID,sprintf('<sensor name="%s_gyro" type="gyroscope">\n',sensors{i, 1}.label));
        fprintf(fileID,sprintf('<parent link="%s"/>\n',sensors{i, 1}.attachedLink));
        fprintf(fileID,sprintf('<origin xyz="%s" rpy="%s"/>\n</sensor>\n',num2str(sensors{i, 1}.position'),num2str(sensors{i, 1}.RPY)));
        fprintf(fileID,sprintf('<sensor name="%s_accelerometer" type="accelerometer">\n',sensors{i, 1}.label));
        fprintf(fileID,sprintf('<parent link="%s"/>\n',sensors{i, 1}.attachedLink));
        fprintf(fileID,sprintf('<origin xyz="%s" rpy="%s"/>\n</sensor>\n',num2str(sensors{i, 1}.position'),num2str(sensors{i, 1}.RPY)));
    end
%     sensorFile = fileread('XSensModelStyle_48URDFtemplate.urdf');
    sensorFile = fileread(sprintf('XSensModelStyle_%dURDFtemplate.urdf',DoFs_number));
    fclose(fileID);
    delete(fullfile(pwd,fileUrdfName));
    sensorsInsertingPoint = '<!--Insert sensors here, if any.-->';
    urdfModelTemplate = strrep(urdfModelTemplate,sensorsInsertingPoint,sensorFile);
end

%% --LINK BASE
%% PELVIS (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'PELVIS_BOX_ORIGIN',num2str(subjectParams.pelvisBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'PELVIS_COM_ORIGIN',num2str(subjectParams.pelvisBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'PELVIS_BOX_SIZE',num2str(subjectParams.pelvisBox));
urdfModelTemplate = strrep(urdfModelTemplate,'PELVISMASS',num2str(subjectParams.pelvisMass));
urdfModelTemplate = strrep(urdfModelTemplate,'PELVISINERTIAIXX',num2str(subjectParams.pelvisIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'PELVISINERTIAIYY',num2str(subjectParams.pelvisIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'PELVISINERTIAIZZ',num2str(subjectParams.pelvisIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jL5S1_ORIGIN',num2str(subjectParams.jL5S1'));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftHip_ORIGIN',num2str(subjectParams.jLeftHip'));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightHip_ORIGIN',num2str(subjectParams.jRightHip'));
%% -- CHAIN LINKS 2-7
%% L5 (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'L5_BOX_ORIGIN',num2str(subjectParams.L5BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'L5_COM_ORIGIN',num2str(subjectParams.L5BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'L5_BOX_SIZE',num2str(subjectParams.L5Box));
urdfModelTemplate = strrep(urdfModelTemplate,'L5MASS',num2str(subjectParams.L5Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'L5INERTIAIXX',num2str(subjectParams.L5Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'L5INERTIAIYY',num2str(subjectParams.L5Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'L5INERTIAIZZ',num2str(subjectParams.L5Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jL4L3_ORIGIN',num2str(subjectParams.jL4L3'));
%% L3 (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'L3_BOX_ORIGIN',num2str(subjectParams.L3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'L3_COM_ORIGIN',num2str(subjectParams.L3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'L3_BOX_SIZE',num2str(subjectParams.L3Box));
urdfModelTemplate = strrep(urdfModelTemplate,'L3MASS',num2str(subjectParams.L3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'L3INERTIAIXX',num2str(subjectParams.L3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'L3INERTIAIYY',num2str(subjectParams.L3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'L3INERTIAIZZ',num2str(subjectParams.L3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jL1T12_ORIGIN',num2str(subjectParams.jL1T12'));
%% T12 (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'T12_BOX_ORIGIN',num2str(subjectParams.T12BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'T12_COM_ORIGIN',num2str(subjectParams.T12BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'T12_BOX_SIZE',num2str(subjectParams.T12Box));
urdfModelTemplate = strrep(urdfModelTemplate,'T12MASS',num2str(subjectParams.T12Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'T12INERTIAIXX',num2str(subjectParams.T12Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'T12INERTIAIYY',num2str(subjectParams.T12Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'T12INERTIAIZZ',num2str(subjectParams.T12Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jT9T8_ORIGIN',num2str(subjectParams.jT9T8'));
%% T8 (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'T8_BOX_ORIGIN',num2str(subjectParams.T8BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'T8_COM_ORIGIN',num2str(subjectParams.T8BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'T8_BOX_SIZE',num2str(subjectParams.T8Box));
urdfModelTemplate = strrep(urdfModelTemplate,'T8MASS',num2str(subjectParams.T8Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'T8INERTIAIXX',num2str(subjectParams.T8Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'T8INERTIAIYY',num2str(subjectParams.T8Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'T8INERTIAIZZ',num2str(subjectParams.T8Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jT1C7_ORIGIN',num2str(subjectParams.jT1C7'));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightC7Shoulder_ORIGIN',num2str(subjectParams.jRightT4Shoulder'));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftC7Shoulder_ORIGIN',num2str(subjectParams.jLeftT4Shoulder'));
%% NECK (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'NECK_BOX_ORIGIN',num2str(subjectParams.neckBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'NECK_COM_ORIGIN',num2str(subjectParams.neckBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'NECKHEIGHT',num2str(subjectParams.neck_z));
urdfModelTemplate = strrep(urdfModelTemplate,'NECKRADIUS',num2str(0.5 * subjectParams.neck_x));
urdfModelTemplate = strrep(urdfModelTemplate,'NECKMASS',num2str(subjectParams.neckMass));
urdfModelTemplate = strrep(urdfModelTemplate,'NECKINERTIAIXX',num2str(subjectParams.neckIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'NECKINERTIAIYY',num2str(subjectParams.neckIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'NECKINERTIAIZZ',num2str(subjectParams.neckIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jC1Head_ORIGIN',num2str(subjectParams.jC1Head'));
%% HEAD (solid: sphere)
urdfModelTemplate = strrep(urdfModelTemplate,'HEAD_BOX_ORIGIN',num2str(subjectParams.headBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'HEAD_COM_ORIGIN',num2str(subjectParams.headBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'HEADRADIUS',num2str(0.5 * subjectParams.head_z));
urdfModelTemplate = strrep(urdfModelTemplate,'HEADMASS',num2str(subjectParams.headMass));
urdfModelTemplate = strrep(urdfModelTemplate,'HEADINERTIAIXX',num2str(subjectParams.headIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'HEADINERTIAIYY',num2str(subjectParams.headIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'HEADINERTIAIZZ',num2str(subjectParams.headIzz));
%% -- CHAIN LINKS 8-11
%% RIGHT SHOULDER (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDER_BOX_ORIGIN',num2str(subjectParams.rightShoulderBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDER_COM_ORIGIN',num2str(subjectParams.rightShoulderBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDERHEIGHT',num2str(subjectParams.rightSho_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDERRADIUS',num2str(subjectParams.rightSho_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDERMASS',num2str(subjectParams.rightShoulderMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDERINERTIAIXX',num2str(subjectParams.rightShoulderIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDERINERTIAIYY',num2str(subjectParams.rightShoulderIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTSHOULDERINERTIAIZZ',num2str(subjectParams.rightShoulderIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightShoulder_ORIGIN',num2str(subjectParams.jRightShoulder'));
%% RIGHT UPPER ARM (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARM_BOX_ORIGIN',num2str(subjectParams.rightUpperArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARM_COM_ORIGIN',num2str(subjectParams.rightUpperArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARMHEIGHT',num2str(subjectParams.rightUpperArm_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARMRADIUS',num2str(subjectParams.rightUpperArm_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARMMASS',num2str(subjectParams.rightUpperArmMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARMINERTIAIXX',num2str(subjectParams.rightUpperArmIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARMINERTIAIYY',num2str(subjectParams.rightUpperArmIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERARMINERTIAIZZ',num2str(subjectParams.rightUpperArmIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightElbow_ORIGIN',num2str(subjectParams.jRightElbow'));
%% RIGHT FORE ARM
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARM_BOX_ORIGIN',num2str(subjectParams.rightForeArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARM_COM_ORIGIN',num2str(subjectParams.rightForeArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARMHEIGHT',num2str(subjectParams.rightForeArm_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARMRADIUS',num2str(subjectParams.rightForeArm_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARMMASS',num2str(subjectParams.rightForeArmMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARMINERTIAIXX',num2str(subjectParams.rightForeArmIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARMINERTIAIYY',num2str(subjectParams.rightForeArmIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOREARMINERTIAIZZ',num2str(subjectParams.rightForeArmIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightElbow_ORIGIN',num2str(subjectParams.jRightT4Shoulder'));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightWrist_ORIGIN',num2str(subjectParams.jRightWrist'));
%% RIGHT HAND (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHAND_BOX_ORIGIN',num2str(subjectParams.rightHandBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHAND_COM_ORIGIN',num2str(subjectParams.rightHandBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHAND_BOX_SIZE',num2str(subjectParams.rightHandBox));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHANDMASS',num2str(subjectParams.rightHandMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHANDINERTIAIXX',num2str(subjectParams.rightHandIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHANDINERTIAIYY',num2str(subjectParams.rightHandIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTHANDINERTIAIZZ',num2str(subjectParams.rightHandIzz));
%% -- CHAIN LINKS 12-15
%% LEFT SHOULDER (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDER_BOX_ORIGIN',num2str(subjectParams.leftShoulderBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDER_COM_ORIGIN',num2str(subjectParams.leftShoulderBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDERHEIGHT',num2str(subjectParams.leftSho_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDERRADIUS',num2str(subjectParams.leftSho_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDERMASS',num2str(subjectParams.leftShoulderMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDERINERTIAIXX',num2str(subjectParams.leftShoulderIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDERINERTIAIYY',num2str(subjectParams.leftShoulderIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTSHOULDERINERTIAIZZ',num2str(subjectParams.leftShoulderIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftShoulder_ORIGIN',num2str(subjectParams.jLeftShoulder'));
%% LEFT UPPER ARM (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARM_BOX_ORIGIN',num2str(subjectParams.leftUpperArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARM_COM_ORIGIN',num2str(subjectParams.leftUpperArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARMHEIGHT',num2str(subjectParams.leftUpperArm_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARMRADIUS',num2str(subjectParams.leftUpperArm_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARMMASS',num2str(subjectParams.leftUpperArmMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARMINERTIAIXX',num2str(subjectParams.leftUpperArmIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARMINERTIAIYY',num2str(subjectParams.leftUpperArmIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERARMINERTIAIZZ',num2str(subjectParams.leftUpperArmIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftElbow_ORIGIN',num2str(subjectParams.jLeftElbow'));
%% LEFT FORE ARM (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARM_BOX_ORIGIN',num2str(subjectParams.leftForeArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARM_COM_ORIGIN',num2str(subjectParams.leftForeArmBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARMHEIGHT',num2str(subjectParams.leftForeArm_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARMRADIUS',num2str(subjectParams.leftForeArm_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARMMASS',num2str(subjectParams.leftForeArmMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARMINERTIAIXX',num2str(subjectParams.leftForeArmIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARMINERTIAIYY',num2str(subjectParams.leftForeArmIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOREARMINERTIAIZZ',num2str(subjectParams.leftForeArmIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftWrist_ORIGIN',num2str(subjectParams.jLeftWrist'));
%% LEFT HAND (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHAND_BOX_ORIGIN',num2str(subjectParams.leftHandBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHAND_COM_ORIGIN',num2str(subjectParams.leftHandBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHAND_BOX_SIZE',num2str(subjectParams.leftHandBox));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHANDMASS',num2str(subjectParams.leftHandMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHANDINERTIAIXX',num2str(subjectParams.leftHandIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHANDINERTIAIYY',num2str(subjectParams.leftHandIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTHANDINERTIAIZZ',num2str(subjectParams.leftHandIzz));
%% -- CHAIN LINKS 16-19
%% RIGHT UPPER LEG (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEG_BOX_ORIGIN',num2str(subjectParams.rightUpperLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEG_COM_ORIGIN',num2str(subjectParams.rightUpperLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEGHEIGHT',num2str(subjectParams.rightUpperLeg_z));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEGRADIUS',num2str(subjectParams.rightUpperLeg_x/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEGMASS',num2str(subjectParams.rightUpperLegMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEGINERTIAIXX',num2str(subjectParams.rightUpperLegIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEGINERTIAIYY',num2str(subjectParams.rightUpperLegIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTUPPERLEGINERTIAIZZ',num2str(subjectParams.rightUpperLegIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightKnee_ORIGIN',num2str(subjectParams.jRightKnee'));
%% RIGHT LOWER LEG (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEG_BOX_ORIGIN',num2str(subjectParams.rightLowerLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEG_COM_ORIGIN',num2str(subjectParams.rightLowerLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEGHEIGHT',num2str(subjectParams.rightLowerLeg_z));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEGRADIUS',num2str(subjectParams.rightLowerLeg_x/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEGMASS',num2str(subjectParams.rightLowerLegMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEGINERTIAIXX',num2str(subjectParams.rightLowerLegIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEGINERTIAIYY',num2str(subjectParams.rightLowerLegIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTLOWERLEGINERTIAIZZ',num2str(subjectParams.rightLowerLegIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightAnkle_ORIGIN',num2str(subjectParams.jRightAnkle'));
%% RIGHT FOOT (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOT_BOX_ORIGIN',num2str(subjectParams.rightFootBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOT_COM_ORIGIN',num2str(subjectParams.rightFootBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOT_BOX_SIZE',num2str(subjectParams.rightFootBox));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOTMASS',num2str(subjectParams.rightFootMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOTINERTIAIXX',num2str(subjectParams.rightFootIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOTINERTIAIYY',num2str(subjectParams.rightFootIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTFOOTINERTIAIZZ',num2str(subjectParams.rightFootIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightBallFoot_ORIGIN',num2str(subjectParams.jRightBallFoot'));

%% RIGHT TOE (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOE_BOX_ORIGIN',num2str(subjectParams.rightToeBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOE_COM_ORIGIN',num2str(subjectParams.rightToeBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOE_BOX_SIZE',num2str(subjectParams.rightToeBox));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOEMASS',num2str(subjectParams.rightToeMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOEINERTIAIXX',num2str(subjectParams.rightToeIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOEINERTIAIYY',num2str(subjectParams.rightToeIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTOEINERTIAIZZ',num2str(subjectParams.rightToeIzz));
%% -- CHAIN LINKS 20-23
%% LEFT UPPER LEG (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEG_BOX_ORIGIN',num2str(subjectParams.leftUpperLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEG_COM_ORIGIN',num2str(subjectParams.leftUpperLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEGHEIGHT',num2str(subjectParams.leftUpperLeg_z));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEGRADIUS',num2str(subjectParams.leftUpperLeg_x/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEGMASS',num2str(subjectParams.leftUpperLegMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEGINERTIAIXX',num2str(subjectParams.leftUpperLegIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEGINERTIAIYY',num2str(subjectParams.leftUpperLegIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTUPPERLEGINERTIAIZZ',num2str(subjectParams.leftUpperLegIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftKnee_ORIGIN',num2str(subjectParams.jLeftKnee'));
%% LEFT LOWER LEG (solid: cylinder)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEG_BOX_ORIGIN',num2str(subjectParams.leftLowerLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEG_COM_ORIGIN',num2str(subjectParams.leftLowerLegBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEGHEIGHT',num2str(subjectParams.leftLowerLeg_z));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEGRADIUS',num2str(subjectParams.leftLowerLeg_x/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEGMASS',num2str(subjectParams.leftLowerLegMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEGINERTIAIXX',num2str(subjectParams.leftLowerLegIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEGINERTIAIYY',num2str(subjectParams.leftLowerLegIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTLOWERLEGINERTIAIZZ',num2str(subjectParams.leftLowerLegIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftAnkle_ORIGIN',num2str(subjectParams.jLeftAnkle'));
%% LEFT FOOT (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOT_BOX_ORIGIN',num2str(subjectParams.leftFootBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOT_COM_ORIGIN',num2str(subjectParams.leftFootBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOT_BOX_SIZE',num2str(subjectParams.leftFootBox));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOTMASS',num2str(subjectParams.leftFootMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOTINERTIAIXX',num2str(subjectParams.leftFootIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOTINERTIAIYY',num2str(subjectParams.leftFootIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTFOOTINERTIAIZZ',num2str(subjectParams.leftFootIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftBallFoot_ORIGIN',num2str(subjectParams.jLeftBallFoot'));
%% LEFT TOE (solid: box)
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOE_BOX_ORIGIN',num2str(subjectParams.leftToeBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOE_COM_ORIGIN',num2str(subjectParams.leftToeBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOE_BOX_SIZE',num2str(subjectParams.leftToeBox));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOEMASS',num2str(subjectParams.leftToeMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOEINERTIAIXX',num2str(subjectParams.leftToeIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOEINERTIAIYY',num2str(subjectParams.leftToeIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTOEINERTIAIZZ',num2str(subjectParams.leftToeIzz));

%% Options
%Gazebo
fakemass=0;
fakein=0;
if options.GAZEBOMODEL == 1
    fakemass=0.0001;
    fakein=0.0003;
end
urdfModelTemplate = strrep(urdfModelTemplate,'FAKEMASS',num2str(fakemass));
urdfModelTemplate = strrep(urdfModelTemplate,'FAKEIN',num2str(fakein));
% Filename
if ~isempty(options.FILENAME)
    [dir,~,~] = fileparts(options.FILENAME);
    if ~exist(dir,'dir')
        mkdir(dir);
    end
    fileID = fopen(options.FILENAME,'w');
    fprintf(fileID,'%s', urdfModelTemplate);
    fclose(fileID);
end
end
