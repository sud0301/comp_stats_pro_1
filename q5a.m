clear all;
global_var;

alpha = 0.9; %alpha_m
[phi si_w si_z] = alpha_function(alpha);

load ('RSSI-measurements-unknown-alpha.mat'); %observation data

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
fig6 = figure(6);
plot(tau(1,:), tau(4,:), 'r-');
hold on;
plot(stations(1,:), stations(2,:), '*');
title('Obtained trajectory using SISR Algorithm with alpha-0.9');
saveas(fig6, 'SISR_trajectory_MLE.jpg')