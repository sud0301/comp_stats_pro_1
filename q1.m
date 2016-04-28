 % all global constants are defined in the global_var file

clear all;
global_var; % File Contains all the constants; 
x0 = mvnrnd(mu_x0, sigma_x0); %initialize trajectory
traj(:, 1) = x0'; 
z_index = randi(5,1); %initial state for z, selected from uniform dist.

for m = 2:num_steps    
    p = P(z_index, :); %multinomial distribution
    z_index = find(mnrnd(1 ,p ,1));  % sampling from multinomial dist
    z = z_dist(:, z_index); 
    w_n = mvnrnd(mu_w, sigma_w, 1)'; % sampling from motion model distribution
    x_new = phi*traj(:, m-1) + si_z*z + si_w*w_n; % generating the trajectory
    traj = [traj x_new];
end

x1 = traj(1,:);
x2 = traj(4,:);

plot(x1, x2, 'b-' );
hold on;
plot(stations(1,:), stations(2,:), '*');
