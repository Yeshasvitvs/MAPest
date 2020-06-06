clc;
close all;
clear all;

datasetName = "Static T-Pose";
load('suit_sub02_static_n_pose.mat');

%% Filter parameters
alpha = 0.1; %smoothing factor 0 < alpha < 1

numOfLinks =  size(suit.links, 1);
velocityLegend = ["$v_x$", "$v_y$", "$v_z$", "$\omega_x$", "$\omega_y$", "$\omega_z$"];
accelerationLegend = ["$\dot{v}_x$", "$\dot{v}_y$", "$\dot{v}_z$", "$\dot{\omega}_x$", "$\dot{\omega}_y$", "$\dot{\omega}_z$"];

linkNames              = {};
measured_velocities    = {};
smoothed_velocities    = {};
measured_accelerations = {};
smoothed_accelerations = {};

for i = 1:numOfLinks
    
    linkNames{i} = suit.links{i,1}.label;
    
    measured_velocity = [suit.links{i,1}.meas.velocity' suit.links{i,1}.meas.angularVelocity'];
    smoothed_velocity = expfilter(measured_velocity, alpha);
    
    measured_velocities{i} = measured_velocity;
    smoothed_velocities{i} = smoothed_velocity;
    
    measured_acceleration = [suit.links{i,1}.meas.acceleration' suit.links{i,1}.meas.angularAcceleration'];
    smoothed_acceleration = expfilter(measured_acceleration, alpha);
    
    measured_accelerations{i} = measured_acceleration;
    smoothed_accelerations{i} = smoothed_acceleration;
    
    
    
end

plotData(measured_velocities, linkNames, '-', velocityLegend, datasetName, "Link Measured Velocities", "${}^{A}\mathrm{v}_{A,L}$");
plotData(smoothed_velocities, linkNames, '--', velocityLegend, datasetName, "Link Smoothed Velocities", "${}^{A}\hat{\mathrm{v}}_{A,L}$");

plotData(measured_accelerations, linkNames, '-', accelerationLegend, datasetName, "Link Measured Accelerations", "${}^{A}\dot{\mathrm{v}}_{A,L}$");
plotData(smoothed_accelerations, linkNames, '--', accelerationLegend, datasetName, "Link Smoothed Accelerations", "${}^{A}\dot{\hat{\mathrm{v}}}_{A,L}$");

