function [urdfModelTemplate] = createXsensLikeURDFmodel_withHands(DoFs_number, subjectParams, sensors, varargin)
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

fileUrdfName = sprintf('XSensModelStyle_%dURDFhands_template.urdf',DoFs_number);
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
    sensorFile = fileread(sprintf('XSensModelStyle_%dURDFhands_template.urdf',DoFs_number));
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
%% RIGHT HAND (solid: boxes and cylinders)
% RIGHT PALM
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMB_BOX_ORIGIN',num2str(subjectParams.rightPalmCloseToThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMB_BOX_ORIGIN',num2str(subjectParams.rightPalmFarFromThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMB_COM_ORIGIN',num2str(subjectParams.rightPalmCloseToThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMB_COM_ORIGIN',num2str(subjectParams.rightPalmFarFromThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMB_BOX_SIZE',num2str(subjectParams.rightPalmCloseToThumbBox));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMB_BOX_SIZE',num2str(subjectParams.rightPalmFarFromThumbBox));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMBMASS',num2str(subjectParams.rightPalmCloseToThumbMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMBMASS',num2str(subjectParams.rightPalmFarFromThumbMass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMBINERTIAIXX',num2str(subjectParams.rightPalmCloseToThumbIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMBINERTIAIXX',num2str(subjectParams.rightPalmFarFromThumbIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMBINERTIAIYY',num2str(subjectParams.rightPalmCloseToThumbIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMBINERTIAIYY',num2str(subjectParams.rightPalmFarFromThumbIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMCLOSETOTHUMBINERTIAIZZ',num2str(subjectParams.rightPalmCloseToThumbIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPALMFARFROMTHUMBINERTIAIZZ',num2str(subjectParams.rightPalmFarFromThumbIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightPalm_ORIGIN',num2str(subjectParams.jRightPalm_rotyOrigin));
% -----
% RIGHT PINKY
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1_BOX_ORIGIN',num2str(subjectParams.rightPinky1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2_BOX_ORIGIN',num2str(subjectParams.rightPinky2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3_BOX_ORIGIN',num2str(subjectParams.rightPinky3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1_COM_ORIGIN',num2str(subjectParams.rightPinky1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2_COM_ORIGIN',num2str(subjectParams.rightPinky2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3_COM_ORIGIN',num2str(subjectParams.rightPinky3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1HEIGHT',num2str(subjectParams.rightPinky1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2HEIGHT',num2str(subjectParams.rightPinky2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3HEIGHT',num2str(subjectParams.rightPinky3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1RADIUS',num2str(subjectParams.rightPinky1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2RADIUS',num2str(subjectParams.rightPinky2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3RADIUS',num2str(subjectParams.rightPinky3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1MASS',num2str(subjectParams.rightPinky1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2MASS',num2str(subjectParams.rightPinky2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3MASS',num2str(subjectParams.rightPinky3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1INERTIAIXX',num2str(subjectParams.rightPinky1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2INERTIAIXX',num2str(subjectParams.rightPinky2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3INERTIAIXX',num2str(subjectParams.rightPinky3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1INERTIAIYY',num2str(subjectParams.rightPinky1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2INERTIAIYY',num2str(subjectParams.rightPinky2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3INERTIAIYY',num2str(subjectParams.rightPinky3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY1INERTIAIZZ',num2str(subjectParams.rightPinky1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY2INERTIAIZZ',num2str(subjectParams.rightPinky2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTPINKY3INERTIAIZZ',num2str(subjectParams.rightPinky3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightPinky1_ORIGIN',num2str(subjectParams.jRightPinky1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightPinky2_ORIGIN',num2str(subjectParams.jRightPinky2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightPinky3_ORIGIN',num2str(subjectParams.jRightPinky3_rotxOrigin));
% -----
% RIGHT RING FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1_BOX_ORIGIN',num2str(subjectParams.rightRing1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2_BOX_ORIGIN',num2str(subjectParams.rightRing2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3_BOX_ORIGIN',num2str(subjectParams.rightRing3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1_COM_ORIGIN',num2str(subjectParams.rightRing1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2_COM_ORIGIN',num2str(subjectParams.rightRing2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3_COM_ORIGIN',num2str(subjectParams.rightRing3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1HEIGHT',num2str(subjectParams.rightRing1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2HEIGHT',num2str(subjectParams.rightRing2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3HEIGHT',num2str(subjectParams.rightRing3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1RADIUS',num2str(subjectParams.rightRing1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2RADIUS',num2str(subjectParams.rightRing2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3RADIUS',num2str(subjectParams.rightRing3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1MASS',num2str(subjectParams.rightRing1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2MASS',num2str(subjectParams.rightRing2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3MASS',num2str(subjectParams.rightRing3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1INERTIAIXX',num2str(subjectParams.rightRing1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2INERTIAIXX',num2str(subjectParams.rightRing2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3INERTIAIXX',num2str(subjectParams.rightRing3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1INERTIAIYY',num2str(subjectParams.rightRing1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2INERTIAIYY',num2str(subjectParams.rightRing2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3INERTIAIYY',num2str(subjectParams.rightRing3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING1INERTIAIZZ',num2str(subjectParams.rightRing1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING2INERTIAIZZ',num2str(subjectParams.rightRing2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTRING3INERTIAIZZ',num2str(subjectParams.rightRing3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightRing1_ORIGIN',num2str(subjectParams.jRightRing1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightRing2_ORIGIN',num2str(subjectParams.jRightRing2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightRing3_ORIGIN',num2str(subjectParams.jRightRing3_rotxOrigin));
% -----
% RIGHT MIDDLE FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1_BOX_ORIGIN',num2str(subjectParams.rightMiddle1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2_BOX_ORIGIN',num2str(subjectParams.rightMiddle2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3_BOX_ORIGIN',num2str(subjectParams.rightMiddle3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1_COM_ORIGIN',num2str(subjectParams.rightMiddle1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2_COM_ORIGIN',num2str(subjectParams.rightMiddle2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3_COM_ORIGIN',num2str(subjectParams.rightMiddle3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1HEIGHT',num2str(subjectParams.rightMiddle1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2HEIGHT',num2str(subjectParams.rightMiddle2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3HEIGHT',num2str(subjectParams.rightMiddle3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1RADIUS',num2str(subjectParams.rightMiddle1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2RADIUS',num2str(subjectParams.rightMiddle2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3RADIUS',num2str(subjectParams.rightMiddle3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1MASS',num2str(subjectParams.rightMiddle1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2MASS',num2str(subjectParams.rightMiddle2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3MASS',num2str(subjectParams.rightMiddle3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1INERTIAIXX',num2str(subjectParams.rightMiddle1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2INERTIAIXX',num2str(subjectParams.rightMiddle2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3INERTIAIXX',num2str(subjectParams.rightMiddle3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1INERTIAIYY',num2str(subjectParams.rightMiddle1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2INERTIAIYY',num2str(subjectParams.rightMiddle2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3INERTIAIYY',num2str(subjectParams.rightMiddle3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE1INERTIAIZZ',num2str(subjectParams.rightMiddle1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE2INERTIAIZZ',num2str(subjectParams.rightMiddle2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTMIDDLE3INERTIAIZZ',num2str(subjectParams.rightMiddle3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightMiddle1_ORIGIN',num2str(subjectParams.jRightMiddle1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightMiddle2_ORIGIN',num2str(subjectParams.jRightMiddle2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightMiddle3_ORIGIN',num2str(subjectParams.jRightMiddle3_rotxOrigin));
% -----
% RIGHT INDEX FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1_BOX_ORIGIN',num2str(subjectParams.rightIndex1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2_BOX_ORIGIN',num2str(subjectParams.rightIndex2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3_BOX_ORIGIN',num2str(subjectParams.rightIndex3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1_COM_ORIGIN',num2str(subjectParams.rightIndex1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2_COM_ORIGIN',num2str(subjectParams.rightIndex2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3_COM_ORIGIN',num2str(subjectParams.rightIndex3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1HEIGHT',num2str(subjectParams.rightIndex1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2HEIGHT',num2str(subjectParams.rightIndex2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3HEIGHT',num2str(subjectParams.rightIndex3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1RADIUS',num2str(subjectParams.rightIndex1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2RADIUS',num2str(subjectParams.rightIndex2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3RADIUS',num2str(subjectParams.rightIndex3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1MASS',num2str(subjectParams.rightIndex1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2MASS',num2str(subjectParams.rightIndex2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3MASS',num2str(subjectParams.rightIndex3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1INERTIAIXX',num2str(subjectParams.rightIndex1Ixx ));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2INERTIAIXX',num2str(subjectParams.rightIndex2Ixx ));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3INERTIAIXX',num2str(subjectParams.rightIndex3Ixx ));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1INERTIAIYY',num2str(subjectParams.rightIndex1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2INERTIAIYY',num2str(subjectParams.rightIndex2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3INERTIAIYY',num2str(subjectParams.rightIndex3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX1INERTIAIZZ',num2str(subjectParams.rightIndex1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX2INERTIAIZZ',num2str(subjectParams.rightIndex2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTINDEX3INERTIAIZZ',num2str(subjectParams.rightIndex3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightIndex1_ORIGIN',num2str(subjectParams.jRightIndex1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightIndex2_ORIGIN',num2str(subjectParams.jRightIndex2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightIndex3_ORIGIN',num2str(subjectParams.jRightIndex3_rotxOrigin));
% -----
% RIGHT THUMB FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1_BOX_ORIGIN',num2str(subjectParams.rightThumb1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2_BOX_ORIGIN',num2str(subjectParams.rightThumb2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3_BOX_ORIGIN',num2str(subjectParams.rightThumb3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1_COM_ORIGIN',num2str(subjectParams.rightThumb1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2_COM_ORIGIN',num2str(subjectParams.rightThumb2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3_COM_ORIGIN',num2str(subjectParams.rightThumb3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1HEIGHT',num2str(subjectParams.rightThumb1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2HEIGHT',num2str(subjectParams.rightThumb2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3HEIGHT',num2str(subjectParams.rightThumb3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1RADIUS',num2str(subjectParams.rightThumb1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2RADIUS',num2str(subjectParams.rightThumb2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3RADIUS',num2str(subjectParams.rightThumb3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1MASS',num2str(subjectParams.rightThumb1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2MASS',num2str(subjectParams.rightThumb2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3MASS',num2str(subjectParams.rightThumb3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1INERTIAIXX',num2str(subjectParams.rightThumb1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2INERTIAIXX',num2str(subjectParams.rightThumb2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3INERTIAIXX',num2str(subjectParams.rightThumb3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1INERTIAIYY',num2str(subjectParams.rightThumb1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2INERTIAIYY',num2str(subjectParams.rightThumb2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3INERTIAIYY',num2str(subjectParams.rightThumb3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB1INERTIAIZZ',num2str(subjectParams.rightThumb1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB2INERTIAIZZ',num2str(subjectParams.rightThumb2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'RIGHTTHUMB3INERTIAIZZ',num2str(subjectParams.rightThumb3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightThumb1_ORIGIN',num2str(subjectParams.jRightThumb1_rotyOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightThumb2_ORIGIN',num2str(subjectParams.jRightThumb2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jRightThumb3_ORIGIN',num2str(subjectParams.jRightThumb3_rotxOrigin));
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
%% LEFT HAND (solid: boxes and cylinders)
% LEFT PALM
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMB_BOX_ORIGIN',num2str(subjectParams.leftPalmCloseToThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMB_BOX_ORIGIN',num2str(subjectParams.leftPalmFarFromThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMB_COM_ORIGIN',num2str(subjectParams.leftPalmCloseToThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMB_COM_ORIGIN',num2str(subjectParams.leftPalmFarFromThumbBoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMB_BOX_SIZE',num2str(subjectParams.leftPalmCloseToThumbBox));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMB_BOX_SIZE',num2str(subjectParams.leftPalmFarFromThumbBox));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMBMASS',num2str(subjectParams.leftPalmCloseToThumbMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMBMASS',num2str(subjectParams.leftPalmFarFromThumbMass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMBINERTIAIXX',num2str(subjectParams.leftPalmCloseToThumbIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMBINERTIAIXX',num2str(subjectParams.leftPalmFarFromThumbIxx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMBINERTIAIYY',num2str(subjectParams.leftPalmCloseToThumbIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMBINERTIAIYY',num2str(subjectParams.leftPalmFarFromThumbIyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMCLOSETOTHUMBINERTIAIZZ',num2str(subjectParams.leftPalmCloseToThumbIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPALMFARFROMTHUMBINERTIAIZZ',num2str(subjectParams.leftPalmFarFromThumbIzz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftPalm_ORIGIN',num2str(subjectParams.jLeftPalm_rotyOrigin));
% -----
% LEFT PINKY
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1_BOX_ORIGIN',num2str(subjectParams.leftPinky1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2_BOX_ORIGIN',num2str(subjectParams.leftPinky2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3_BOX_ORIGIN',num2str(subjectParams.leftPinky3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1_COM_ORIGIN',num2str(subjectParams.leftPinky1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2_COM_ORIGIN',num2str(subjectParams.leftPinky2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3_COM_ORIGIN',num2str(subjectParams.leftPinky3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1HEIGHT',num2str(subjectParams.leftPinky1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2HEIGHT',num2str(subjectParams.leftPinky2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3HEIGHT',num2str(subjectParams.leftPinky3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1RADIUS',num2str(subjectParams.leftPinky1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2RADIUS',num2str(subjectParams.leftPinky2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3RADIUS',num2str(subjectParams.leftPinky3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1MASS',num2str(subjectParams.leftPinky1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2MASS',num2str(subjectParams.leftPinky2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3MASS',num2str(subjectParams.leftPinky3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1INERTIAIXX',num2str(subjectParams.leftPinky1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2INERTIAIXX',num2str(subjectParams.leftPinky2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3INERTIAIXX',num2str(subjectParams.leftPinky3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1INERTIAIYY',num2str(subjectParams.leftPinky1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2INERTIAIYY',num2str(subjectParams.leftPinky2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3INERTIAIYY',num2str(subjectParams.leftPinky3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY1INERTIAIZZ',num2str(subjectParams.leftPinky1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY2INERTIAIZZ',num2str(subjectParams.leftPinky2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTPINKY3INERTIAIZZ',num2str(subjectParams.leftPinky3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftPinky1_ORIGIN',num2str(subjectParams.jLeftPinky1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftPinky2_ORIGIN',num2str(subjectParams.jLeftPinky2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftPinky3_ORIGIN',num2str(subjectParams.jLeftPinky3_rotxOrigin));
% -----
% LEFT RING FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1_BOX_ORIGIN',num2str(subjectParams.leftRing1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2_BOX_ORIGIN',num2str(subjectParams.leftRing2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3_BOX_ORIGIN',num2str(subjectParams.leftRing3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1_COM_ORIGIN',num2str(subjectParams.leftRing1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2_COM_ORIGIN',num2str(subjectParams.leftRing2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3_COM_ORIGIN',num2str(subjectParams.leftRing3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1HEIGHT',num2str(subjectParams.leftRing1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2HEIGHT',num2str(subjectParams.leftRing2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3HEIGHT',num2str(subjectParams.leftRing3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1RADIUS',num2str(subjectParams.leftRing1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2RADIUS',num2str(subjectParams.leftRing2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3RADIUS',num2str(subjectParams.leftRing3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1MASS',num2str(subjectParams.leftRing1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2MASS',num2str(subjectParams.leftRing2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3MASS',num2str(subjectParams.leftRing3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1INERTIAIXX',num2str(subjectParams.leftRing1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2INERTIAIXX',num2str(subjectParams.leftRing2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3INERTIAIXX',num2str(subjectParams.leftRing3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1INERTIAIYY',num2str(subjectParams.leftRing1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2INERTIAIYY',num2str(subjectParams.leftRing2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3INERTIAIYY',num2str(subjectParams.leftRing3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING1INERTIAIZZ',num2str(subjectParams.leftRing1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING2INERTIAIZZ',num2str(subjectParams.leftRing2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTRING3INERTIAIZZ',num2str(subjectParams.leftRing3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftRing1_ORIGIN',num2str(subjectParams.jLeftRing1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftRing2_ORIGIN',num2str(subjectParams.jLeftRing2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftRing3_ORIGIN',num2str(subjectParams.jLeftRing3_rotxOrigin));
% -----
% LEFT MIDDLE FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1_BOX_ORIGIN',num2str(subjectParams.leftMiddle1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2_BOX_ORIGIN',num2str(subjectParams.leftMiddle2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3_BOX_ORIGIN',num2str(subjectParams.leftMiddle3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1_COM_ORIGIN',num2str(subjectParams.leftMiddle1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2_COM_ORIGIN',num2str(subjectParams.leftMiddle2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3_COM_ORIGIN',num2str(subjectParams.leftMiddle3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1HEIGHT',num2str(subjectParams.leftMiddle1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2HEIGHT',num2str(subjectParams.leftMiddle2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3HEIGHT',num2str(subjectParams.leftMiddle3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1RADIUS',num2str(subjectParams.leftMiddle1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2RADIUS',num2str(subjectParams.leftMiddle2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3RADIUS',num2str(subjectParams.leftMiddle3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1MASS',num2str(subjectParams.leftMiddle1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2MASS',num2str(subjectParams.leftMiddle2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3MASS',num2str(subjectParams.leftMiddle3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1INERTIAIXX',num2str(subjectParams.leftMiddle1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2INERTIAIXX',num2str(subjectParams.leftMiddle2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3INERTIAIXX',num2str(subjectParams.leftMiddle3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1INERTIAIYY',num2str(subjectParams.leftMiddle1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2INERTIAIYY',num2str(subjectParams.leftMiddle2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3INERTIAIYY',num2str(subjectParams.leftMiddle3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE1INERTIAIZZ',num2str(subjectParams.leftMiddle1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE2INERTIAIZZ',num2str(subjectParams.leftMiddle2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTMIDDLE3INERTIAIZZ',num2str(subjectParams.leftMiddle3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftMiddle1_ORIGIN',num2str(subjectParams.jLeftMiddle1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftMiddle2_ORIGIN',num2str(subjectParams.jLeftMiddle2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftMiddle3_ORIGIN',num2str(subjectParams.jLeftMiddle3_rotxOrigin));
% -----
% LEFT INDEX FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1_BOX_ORIGIN',num2str(subjectParams.leftIndex1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2_BOX_ORIGIN',num2str(subjectParams.leftIndex2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3_BOX_ORIGIN',num2str(subjectParams.leftIndex3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1_COM_ORIGIN',num2str(subjectParams.leftIndex1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2_COM_ORIGIN',num2str(subjectParams.leftIndex2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3_COM_ORIGIN',num2str(subjectParams.leftIndex3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1HEIGHT',num2str(subjectParams.leftIndex1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2HEIGHT',num2str(subjectParams.leftIndex2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3HEIGHT',num2str(subjectParams.leftIndex3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1RADIUS',num2str(subjectParams.leftIndex1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2RADIUS',num2str(subjectParams.leftIndex2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3RADIUS',num2str(subjectParams.leftIndex3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1MASS',num2str(subjectParams.leftIndex1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2MASS',num2str(subjectParams.leftIndex2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3MASS',num2str(subjectParams.leftIndex3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1INERTIAIXX',num2str(subjectParams.leftIndex1Ixx ));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2INERTIAIXX',num2str(subjectParams.leftIndex2Ixx ));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3INERTIAIXX',num2str(subjectParams.leftIndex3Ixx ));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1INERTIAIYY',num2str(subjectParams.leftIndex1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2INERTIAIYY',num2str(subjectParams.leftIndex2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3INERTIAIYY',num2str(subjectParams.leftIndex3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX1INERTIAIZZ',num2str(subjectParams.leftIndex1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX2INERTIAIZZ',num2str(subjectParams.leftIndex2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTINDEX3INERTIAIZZ',num2str(subjectParams.leftIndex3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftIndex1_ORIGIN',num2str(subjectParams.jLeftIndex1_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftIndex2_ORIGIN',num2str(subjectParams.jLeftIndex2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftIndex3_ORIGIN',num2str(subjectParams.jLeftIndex3_rotxOrigin));
% -----
% LEFT THUMB FINGER
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1_BOX_ORIGIN',num2str(subjectParams.leftThumb1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2_BOX_ORIGIN',num2str(subjectParams.leftThumb2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3_BOX_ORIGIN',num2str(subjectParams.leftThumb3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1_COM_ORIGIN',num2str(subjectParams.leftThumb1BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2_COM_ORIGIN',num2str(subjectParams.leftThumb2BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3_COM_ORIGIN',num2str(subjectParams.leftThumb3BoxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1HEIGHT',num2str(subjectParams.leftThumb1_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2HEIGHT',num2str(subjectParams.leftThumb2_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3HEIGHT',num2str(subjectParams.leftThumb3_y));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1RADIUS',num2str(subjectParams.leftThumb1_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2RADIUS',num2str(subjectParams.leftThumb2_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3RADIUS',num2str(subjectParams.leftThumb3_z/2));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1MASS',num2str(subjectParams.leftThumb1Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2MASS',num2str(subjectParams.leftThumb2Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3MASS',num2str(subjectParams.leftThumb3Mass));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1INERTIAIXX',num2str(subjectParams.leftThumb1Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2INERTIAIXX',num2str(subjectParams.leftThumb2Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3INERTIAIXX',num2str(subjectParams.leftThumb3Ixx));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1INERTIAIYY',num2str(subjectParams.leftThumb1Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2INERTIAIYY',num2str(subjectParams.leftThumb2Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3INERTIAIYY',num2str(subjectParams.leftThumb3Iyy));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB1INERTIAIZZ',num2str(subjectParams.leftThumb1Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB2INERTIAIZZ',num2str(subjectParams.leftThumb2Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'LEFTTHUMB3INERTIAIZZ',num2str(subjectParams.leftThumb3Izz));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftThumb1_ORIGIN',num2str(subjectParams.jLeftThumb1_rotyOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftThumb2_ORIGIN',num2str(subjectParams.jLeftThumb2_rotxOrigin));
urdfModelTemplate = strrep(urdfModelTemplate,'jLeftThumb3_ORIGIN',num2str(subjectParams.jLeftThumb3_rotxOrigin));
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
