clc; close all; clear all;

rng(1); % Force the casual generator to be const
format long;

%% Add src to the path
addpath(genpath('src'));
addpath(genpath('../../src'));
addpath(genpath('../../external'));

%% Set Java path needed by OSIM - SCREWS MATLAB CURRENT CONFIGURATION
% % UNCOMMENT ONLY IF YOU KNOW WHAT YOU ARE DOING
% % Routine left here just for Legacy, not to be used since it erases the
% % current path.
% setupJAVAPath();

%% Preliminaries
% Create a structure 'bucket' where storing different stuff generated by
% running the code
bucket = struct;

%% Configure
% Root folder of the dataset
bucket.datasetRoot = fullfile(pwd, 'dataExperiment');

% Subject and task to be processed
subjectID = 1;
taskID = 1;

%% Covariances setting
priors = struct;
priors.acc_IMU     = 1e-3 * ones(3,1);                     %[m^2/s^2]   , from datasheet
% priors.gyro_IMU    = xxxxxx * ones(3,1);                 %[rad^2/s^2] , from datasheet
priors.angAcc      = 1e-6 * ones(3,1); %test
priors.ddq         = 6.66e-3;                              %[rad^2/s^4] , from worst case covariance
priors.foot_fext   = 1e-4 *[59; 59; 36; 2.25; 2.25; 0.56]; %[N^2,(Nm)^2]
priors.noSens_fext = 1e-6 * ones(6,1);

bucket.Sigmad = 1e+3;
% low reliability on the estimation (i.e., no prior info on the regularization term d)
bucket.SigmaD = 1e+1;
% high reliability on the model constraints

%% Options
opts.suitAsParsedMVNX  = true;
opts.suitAsIWear       = false;

%% Run MAPest main.m
main;
