function vector = dynamicsToVector(quad_state)
% STATETOVECTOR Converts a quad state to a vector for gpops.
vector = [...
    quad_state.X_dot, quad_state.Y_dot, quad_state.Z_dot, ...
    quad_state.X_ddot, quad_state.Y_ddot, quad_state.Z_ddot, ...
    quad_state.phi_dot, quad_state.theta_dot, quad_state.psi_dot, ...
    quad_state.p_dot, quad_state.q_dot, quad_state.r_dot];
end

