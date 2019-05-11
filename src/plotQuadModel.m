% Wil Selby
% Washington, DC
% May 30, 2015

% This function sets the inital vertices and faces of the quadrotor arms
% and motors for drawing purposes. In this coordinate system, the front of
% the quadrotor is to the left and Motor 1 is the left motor.


%% Store data in global variable
global Quad

load Quad_plotting_model

Quad.X_arm  = patch('xdata', QuadModel.X_armX, ...
                    'ydata', QuadModel.X_armY, ...
                    'zdata', QuadModel.X_armZ, ...
                    'facealpha', .9, 'facecolor', 'b');
Quad.Y_arm  = patch('xdata', QuadModel.Y_armX, ...
                    'ydata', QuadModel.Y_armY, ...
                    'zdata', QuadModel.Y_armZ, ...
                    'facealpha', .9, 'facecolor', 'b');
Quad.Motor1 = patch('xdata', QuadModel.Motor1X, ...
                    'ydata', QuadModel.Motor1Y, ...
                    'zdata', QuadModel.Motor1Z, ...
                    'facealpha',.3,'facecolor','g');
Quad.Motor2 = patch('xdata', QuadModel.Motor2X, ...
                    'ydata', QuadModel.Motor2Y, ...
                    'zdata', QuadModel.Motor2Z, ...
                    'facealpha',.3,'facecolor','k');
Quad.Motor3 = patch('xdata', QuadModel.Motor3X, ...
                    'ydata', QuadModel.Motor3Y, ...
                    'zdata', QuadModel.Motor3Z, ...
                    'facealpha',.3,'facecolor','k');
Quad.Motor4 = patch('xdata', QuadModel.Motor4X, ...
                    'ydata', QuadModel.Motor4Y, ...
                    'zdata', QuadModel.Motor4Z, ...
                    'facealpha',.3,'facecolor','b');




