function vector = stateToVector(quad_state)
% STATETOVECTOR Converts a quad state to a vector for gpops.
vector = [...
    quad_state.X, quad_state.Y, quad_state.Z, ...
    quad_state.X_dot, quad_state.Y_dot, quad_state.Z_dot, ...
    quad_state.phi, quad_state.theta, quad_state.psi, ...
    quad_state.p, quad_state.q, quad_state.r];
end

