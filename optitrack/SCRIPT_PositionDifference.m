% SCRIPT_DisplayData
%   Display data received by from OptiTrack software to the command window.
%
%   M. Kutzer 10Mar2016, USNA

%% Clear workspace, close all figures, clear command window
clear all
close all
clc

%% Create OptiTrack object and initialize
obj = OptiTrack;
obj.Initialize;

%% Display data
while true
    % Get current rigid body information
    rb = obj.RigidBody;
    % Output frame information
    fprintf('\nFrame Index: %d\n',rb(1).FrameIndex);
    % Update each rigid body
    for i = 1:numel(rb)
        fprintf('- %s, Tracking Status: %d\n',rb(i).Name,rb(i).isTracked);
        if rb(i).isTracked
            DeltaP2Base = rb(1).Position-rb(2).Position
            fprintf('\t   Difference in Position [%f,%f,%f]\n',DeltaP2Base);
            %fprintf('\t Quaternion [%f,%f,%f,%f]\n',rb(i).Quaternion);
            %pause(0.1);
            
        else
            fprintf('\t Position []\n');
            fprintf('\t Quaternion []\n');
            pause(0.1);
    end
end
end
        