%------------------------- Drone Race Problem ----------------------------%
%-------------------------------------------------------------------------%
clear all;
close all;
clc;

%-------------------------------------------------------------------------%
%------------- Provide and Set Up Quadcopter -----------------------------%
%-------------------------------------------------------------------------%

%% Initialize Variables
global Quad;
Quad = parametersQuad();

%% Initialize the plot
initPlot;
plotQuadModel;

Quad.State = initState;
Quad.Control.U1 = 9.8;
Quad.Control.U2 = 0;
Quad.Control.U3 = 0;
Quad.Control.U4 = 0;

nonlinearQuadrotorDynamics(Quad.State, Quad.Control);

% Plot the Quadrotor's Position
plot_quad
Quad.counter;
drawnow

Quad.Control.U1 = 9.8;
Quad.Control.U2 = 0;
Quad.Control.U3 = 0;
Quad.Control.U4 = 0;

%-------------------------------------------------------------------------%
%------------- Provide and Set Up All Bounds for Problem -----------------%
%-------------------------------------------------------------------------%
t0                              = 0;     
%t1                              = 0.2;     
%t2                              = 0.8;     
tf                              = 1;

t_tol                           = 0.5;

t_min = [t0, tf-t_tol];
t_max = [t0, tf+t_tol];

                                   %x %y
x_endpoint_min                     = [0 0.1; 
                                     -10 -10;
                                     -10 -10;
                                     0.5 0.8];
x_endpoint_max                     = [0 0.1; 
                                    10 10;
                                    10 10;
                                    0.5 0.8];
                         
                                    %x %v
xmin                            = [-10 -10;
                                   -10 -10;
                                   -10 -10]; % TO FIX
xmax                            = [10 10;
                                   10 10;
                                   10 10]; % TO FIX

umin                            = [0 0  0];
umax                            = [2 3 2];

integral_min = [-100, -100, -100];
integral_max = [100, 100, 100];

for p = 1:3
    % Fixed initial time for all phases...
    bounds.phase(p).initialtime.lower  = t_min(p);
    bounds.phase(p).initialtime.upper  = t_max(p);

    % Free final time for all phases
    bounds.phase(p).finaltime.lower    = t_min(p+1);
    bounds.phase(p).finaltime.upper    = t_max(p+1);

    % Fixed initial state for all phases
    bounds.phase(p).initialstate.lower = x_endpoint_min(p,:);
    bounds.phase(p).initialstate.upper = x_endpoint_max(p,:);

    % Fixed final state for all phases
    bounds.phase(p).finalstate.lower   = x_endpoint_min(p+1,:);
    bounds.phase(p).finalstate.upper   = x_endpoint_max(p+1,:);

    % Tolerance for state on each phase
    bounds.phase(p).state.lower        = xmin(p,:);
    bounds.phase(p).state.upper        = xmax(p,:); % NOT SURE

    % Control bounds for each phase
    bounds.phase(p).control.lower      = umin(p);
    bounds.phase(p).control.upper      = umax(p);

    % Integral bounds for each phase
    bounds.phase(p).integral.lower     = integral_min(p);
    bounds.phase(p).integral.upper     = integral_max(p); % NOT SURE
end

bounds.eventgroup(1).lower = zeros(1,3);
bounds.eventgroup(1).upper = zeros(1,3);
bounds.eventgroup(2).lower = zeros(1,3);
bounds.eventgroup(2).upper = zeros(1,3);

%%
%-------------------------------------------------------------------------%
%---------------------- Provide Guess of Solution ------------------------%
%-------------------------------------------------------------------------%
x_0 = x_endpoint_min(1,:);
x_tf = x_endpoint_min(4,:);
u_min = umin(1);
u_max = umax(1);

% PHASE 1
p = 1;
guess.phase(p).time    = [t0; 0.2]; 
guess.phase(p).state   = [x_0; 0.05 0.45];
guess.phase(p).control = [u_max; u_max];
guess.phase(p).integral = 0;

% PHASE 2
p = 2;
guess.phase(p).time    = [0.2; 0.8]; 
guess.phase(p).state   = [0.05 0.45; 0.37 0.52];
guess.phase(p).control = [0.5; 0.5];
guess.phase(p).integral = 1;

% PHASE 3
p = 3;
guess.phase(p).time    = [t0; tf]; 
guess.phase(p).state   = [0.37 0.52; x_tf];
guess.phase(p).control = [u_max; u_max];
guess.phase(p).integral = 1;

%%
%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%
%  mesh.method            = 'hp-PattersonRao';
%  mesh.tolerance         = 1e-10;
%  mesh.maxiterations     = 40;
%  mesh.colpointsmin      = 10;
%  mesh.colpointsmax      = 40;
% NumIntervals           = 4;
% mesh.phase.colpoints   = 6*ones(1,NumIntervals);
% mesh.phase.fraction    = ones(1,NumIntervals)/NumIntervals;

%-------------------------------------------------------------------------%
%------------- Assemble Information into Problem Structure ---------------%        
%-------------------------------------------------------------------------%
setup.name                           = 'minCurve';
setup.functions.continuous           = @continuous;
setup.functions.endpoint             = @endpoint;
setup.bounds                         = bounds;
setup.guess                          = guess;
setup.nlp.solver                     = 'ipopt';
setup.nlp.ipoptoptions.linear_solver = 'ma57';
setup.derivatives.supplier           = 'sparseCD';
setup.derivatives.derivativelevel    = 'second';
setup.method                         = 'RPM-Differentiation';
%setup.mesh                           = mesh;

%%
%-------------------------------------------------------------------------%
%---------------------- Solve Problem Using GPOPS2 -----------------------%
%-------------------------------------------------------------------------%
output = gpops2(setup);
solution = output.result.solution;

%%
%-------------------------------------------------------------------------%
%---------------------- Plot Solution ------------------------------------%
%-------------------------------------------------------------------------%

% Plot State History
f = figure('DefaultAxesFontSize', 16);
f.Name = 'MultiPhase';
subplot(3,2,1)
title('X Numerical')
hold on
plot(solution.phase(1).time, solution.phase(1).state(:,1), 'LineWidth', 2)
plot(solution.phase(2).time, solution.phase(2).state(:,1), 'LineWidth', 2)
plot(solution.phase(3).time, solution.phase(3).state(:,1), 'LineWidth', 2)
xlabel('t'), ylabel('x')
subplot(3,2,2)
title('V Numerical')
hold on
plot(solution.phase(1).time, solution.phase(1).state(:,2), 'LineWidth', 2)
plot(solution.phase(2).time, solution.phase(2).state(:,2), 'LineWidth', 2)
plot(solution.phase(3).time, solution.phase(3).state(:,2), 'LineWidth', 2)
xlabel('t'), ylabel('v')
subplot(3,2,3:4)
title('State path (x vs. v)')
hold on
plot(solution.phase(1).state(:,1), solution.phase(1).state(:,2), 'LineWidth', 2)
plot(solution.phase(2).state(:,1), solution.phase(2).state(:,2), 'LineWidth', 2)
plot(solution.phase(3).state(:,1), solution.phase(3).state(:,2), 'LineWidth', 2)
xlabel('x'), ylabel('v')
subplot(3,2,5:6)
title('U Numerical')
hold on
plot(solution.phase(1).time, solution.phase(1).control, 'LineWidth', 2)
plot(solution.phase(2).time, solution.phase(2).control, 'LineWidth', 2)
plot(solution.phase(3).time, solution.phase(3).control, 'LineWidth', 2)
xlabel('t'), ylabel('u')