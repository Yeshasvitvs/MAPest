
clear;clc;close all;

%% Add src to the path
addpath(genpath('../../src'));

rng(1); % forcing the casual generator to be const

model.FileName = 'models/threeLinkHuman_subject1_sensorExt.urdf';

%% Load model URDF

modelLoader = iDynTree.ModelLoader();
if ~modelLoader.loadModelFromFile(model.FileName);
    fprint('Something wrong with the model loading.')
end
model = modelLoader.model(); 
sensors = modelLoader.sensors();

%% Specify the sensors structure

berdyOptions = iDynTree.BerdyOptions();
berdyOptions.includeAllNetExternalWrenchesAsSensors          = true;
berdyOptions.includeAllNetExternalWrenchesAsDynamicVariables = true;
berdyOptions.includeAllJointAccelerationsAsSensors           = true;
berdyOptions.includeAllJointTorquesAsSensors                 = false;
berdyOptions.includeFixedBaseExternalWrench                  = true;

berdy = iDynTree.BerdyHelper();
berdy.init(model, sensors, berdyOptions);
                                             
%% Load data from sensors
data = load('data/ExperimentDataset.mat');

data.numOfSamples = size(data.sensors.acc,2);

%accelerometer
SENS.acc_struct.type    = 1;
SENS.acc_struct.id      = 'imu_acc';
SENS.acc_struct.meas    = data.sensors.acc;
SENS.acc_struct.var     = 0.001111 * ones(3,1);

%gyroscope
SENS.gyro_struct.type   = 4;
SENS.gyro_struct.id     = 'imu_gyro';
SENS.gyro_struct.meas   = zeros(size(data.sensors.acc)); %no gyro for this experiment
SENS.gyro_struct.var    = 5e-5 * ones(3,1);

%joint acceleration as sensors
SENS.ddq1.type          = 2;
SENS.ddq1.id            = 'ankle';
SENS.ddq1.meas          = data.joints.ddq(1,:);
SENS.ddq1.var           = 6.66e-6;

SENS.ddq2.type          = 2;
SENS.ddq2.id            = 'hip';
SENS.ddq2.meas          = data.joints.ddq(2,:);
SENS.ddq2.var           = 6.66e-6;

%external forse as sensors
SENS.fext1.type         = 3;
SENS.fext1.id           = 'foot';
SENS.fext1.meas         = data.sensors.fts_footFrame;
SENS.fext1.var          = [59; 59; 36; 2.25; 2.25; 0.56];

SENS.fext2.type         = 3;
SENS.fext2.id           = 'leg';
SENS.fext2.meas         = zeros(6, data.numOfSamples);
SENS.fext2.var          = [59; 59; 36; 2.25; 2.25; 0.56];

SENS.fext3.type         = 3;
SENS.fext3.id           = 'torso';
SENS.fext3.meas         = zeros(6, data.numOfSamples);
SENS.fext3.var          = [59; 59; 36; 2.25; 2.25; 0.56];

data.packedSens = [ SENS.ddq1; SENS.fext1; SENS.acc_struct; SENS.ddq2; ...
                    SENS.gyro_struct; SENS.fext2; SENS.fext3];
    
[y, Sigmay] = berdyMeasurementsWrapping(data.packedSens);

%% MAP

% set priors
priors = struct;
priors.mud = zeros(berdy.getNrOfDynamicVariables(), 1);
priors.Sigmad = 1e+4 * eye(berdy.getNrOfDynamicVariables());
priors.SigmaD = 1e-4 * eye(berdy.getNrOfDynamicEquations());
priors.Sigmay = Sigmay; 

% set state
state = struct;
state.q = data.joints.q;
state.dq = data.joints.dq;

% compute MAP
[mu_dgiveny, Sigma_dgiveny] = MAPcomputation(berdy,state,y,priors);

%% Plots results

time = 0:0.01:0.01*(data.numOfSamples-1);

fig = figure();
axes1 = axes('Parent',fig,...
             'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
% title('Joint torques')

plot1 = plot(time,mu_dgiveny(19,:)); hold on;
set(plot1,'color',[1 0 0],...
          'lineWidth',1.5,...
          'LineStyle','-');
plot2 = plot(time,mu_dgiveny(45,:)); hold on;
set(plot2,'color',[0 0.498039215803146 0],...
          'lineWidth',1.5,...
          'LineStyle','-');     

leg = legend('$\tau_{1,MAP}$','$\tau_{2,MAP}$');
set(leg,'Interpreter','latex',...
        'FontSize',18,...
        'Location','southeast');
    
xlabel('Time [s]',...
        'FontWeight','bold',...
        'FontSize',20,...
        'Interpreter','latex');
ylabel('$\tau$ [Nm]',...
        'FontWeight','bold',...
        'FontSize',20,...
        'Interpreter','latex');
axis tight;
grid on;





