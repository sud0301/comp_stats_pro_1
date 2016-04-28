%% This function generates the new particles position at next time step using the motion model 
function [x_out] = generate_x( part)  
    global_var;
    z0_index = randi(5, num_part, 1); 
    p = P(z0_index, :);
    [~, z_index] = find(mnrnd(1 ,p));
    z = z_dist(:, z_index);
    x_out = zeros(6, num_part);    
    wx = mvnrnd(mu_w, sigma_w, num_part)'; % sample from the distribution of w
    x_out = phi*part + si_z*z + si_w*wx;  % x_out will be 6 X 10000
end