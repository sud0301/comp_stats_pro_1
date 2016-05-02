clear all;
global_var;
alpha = 0.6;
[phi si_w si_z] = alpha_function(alpha);


%% generate sample trajectory using the motion model
x0 = mvnrnd(mu_x0, sigma_x0); 
z_index = randi(5,1);
traj(:, 1) = x0'; % initial position x0 for motion model 

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

Y =  zeros(7, num_steps);
obs_mean = zeros(7,num_steps);

%% generate observation for the above generated motion model

for i = 1:num_steps
    x_gt = repmat ([x1(i), x2(i)], num_stations ,1);
    norm_diff = sqrt(sum(abs(x_gt-stations').^2,2));
    obs_mean(:, i) = 90*ones(num_stations,1) - 10*eta*log10(norm_diff);
    Y(:, i)= obs_mean(:, i) + mvnrnd(mu_noise, std_noise,7,1);   
end