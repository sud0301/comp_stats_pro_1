clear all;
global_var;  % all global constants are defined in the global_var file

x0 = mvnrnd(mu_x0, sigma_x0); 
traj(:, 1) = x0'; 
z_index = randi(5,1); %initial state for z, selected from uniform dist.

for m = 2:num_steps    
    p = P(z_index, :);
    z_index = find(mnrnd(1 ,p ,1));
    z = z_dist(:, z_index);
    w_n = mvnrnd(mu_w, sigma_w, 1)'; 
    x_new = phi*traj(:, m-1) + si_z*z + si_w*w_n;
    traj = [traj x_new];
end

x1 = traj(1,:);
x2 = traj(4,:);

plot(x1, x2, 'b-' );
hold on;
plot(stations(1,:), stations(2,:), '*');
