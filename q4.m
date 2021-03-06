clear all;
global_var;

alpha = 0.6;
[phi si_w si_z] = alpha_function(alpha);

%{
%% generate sample trajectory using the motion model
x0 = mvnrnd(mu_x0, sigma_x0); 
z_index = randi(5,1);
traj(:, 1) = x0';  % x0 initialization

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

plot(x1, x2, 'b-' );
hold on;

%}
load ('RSSI-measurements.mat'); %observation data
%load ('RSSI-measurements-unknown-alpha.mat'); %observation data

%% Estimation of trajectory using the given observation
tau = zeros(6, num_steps);

w_pdf = @(mu, var) mvnpdf(var, mu, obs_std);
part = mvnrnd(mu_x0, sigma_x0, num_part)'; 
obs_density_mean = generate_y_mean(part);

w(:,1) = w_pdf(obs_density_mean', Y(:,1)'); 

sum_w = sum(bsxfun(@times,part,w'),2);
tau(:, 1) = sum_w/sum(w);

tic
for k = 2:num_steps, 
    part = generate_x(part,alpha); % generates the particles for next step
    obs_density_mean = generate_y_mean(part);  %generate mean for observation density 
    % estimation of conditional density or w  for all particles (NOT MULTIPLIED BY PREVIOUS WEIGHTS)
    w(:, k) = w_pdf( obs_density_mean', Y(:, k)'); 
    sum_nw = sum(bsxfun(@times, part, w(:, k)'),2); 
    tau(:,k) = sum_nw/sum(w(:,k)); 
    %Drawing randomly new particle with probability of normalized importance weights
    ind = randsample(num_part, num_part, true, w(:,k));
    part = part(:,ind);
    k
end
toc   

%% Plot the trajectory compared with ground truth trajectory 
fig4 = figure(4);
plot(tau(1,:), tau(4,:), 'r-');
hold on;
plot(stations(1,:), stations(2,:), '*');
title('Obtained trajectory using SISR Algorithm');
saveas(fig4, 'SISR_trajectory.jpg');
disp('Press a key !')
pause;
%% Plot the histogram of w values
fig5=figure(5);
subplot(5,1,1)       
histogram(log10(w(:,1)),[-350:10:0])
title('n = 1')

subplot(5,1,2)       
histogram(log10(w(:,10)),[-350:10:0])
title('n = 10')

subplot(5, 1, 3)       
histogram(log10(w(:,50)),[-350:10:0])
title('n = 50')

subplot(5, 1, 4)       
histogram(log10(w(:,200)),[-350:10:0])
title('n = 200')

subplot(5, 1, 5)       
histogram(log10(w(:,400)),[-350:10:0])
title('n = 400')
saveas(fig5, 'SISR_histograms.jpg');
disp('Press a key to continue !')
pause;