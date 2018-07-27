clc; close all; clear all;

rng(1); % Force the casual generator to be const
format long;

%% Add src to the path
addpath(genpath('src'));
addpath(genpath('templates'));
addpath(genpath('../../src'));
addpath(genpath('../../external'));

%% Set Java path needed by OSIM - SCREWS MATLAB CURRENT CONFIGURATION
%       UNCONMMENT ONLY IF YOU KNOW WHAT YOU ARE DOING
%  Routine left here just for Legacy, not to be used since it erases the
%  current path. 

setupJAVAPath();

%% Preliminaries
% Create a structure 'bucket' where storing different stuff generating by
% running the code
bucket = struct;

%% Configure
% Root folder of the dataset
bucket.datasetRoot = fullfile(pwd, 'dataJSI');
%bucket.datasetRoot = fullfile('D:\Datasets\2018_Feb_JSI');

% Subject and task to be processed
subjectID = 1;
taskID = 1;

% Check the EXO option
opts.EXO = true;

%% Run MAPest main.m
main;
