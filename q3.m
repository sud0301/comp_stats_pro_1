clear all;
global_var;

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
%load ('RSSI-measurements.mat');  % uncomment to run on given observation data

%% Estimation of trajectory using the given observation
tau = zeros(6, num_steps);
eff_sample_size = zeros(num_steps,1);

w_pdf = @(mu, var) mvnpdf(var, mu, obs_std);
part = mvnrnd(mu_x0, sigma_x0, num_part)'; 
obs_density_mean = generate_y_mean(part);

w(:,1) = w_pdf(obs_density_mean', Y(:,1)'); %initialize w for time = 1
eff_sample_size(1) = efficient_sample(w(:,1)); % call function to calculate eff sample size
sum_w = sum(bsxfun(@times,part,w'),2);
tau(:, 1) = sum_w/sum(w);

tic
for k = 2:num_steps, 
    part = generate_x(part); % generates the particles for next step
    obs_density_mean = generate_y_mean(part); %generate mean for observation density 
    w(:, k) = w(:,k-1).*w_pdf( obs_density_mean', Y(:, k)'); % estimation of conditional density or w  for all particles
    sum_nw = sum(bsxfun(@times, part, w(:, k)'),2);
    tau(:,k) = sum_nw/sum(w(:,k)); 
    eff_sample_size(k) = efficient_sample(w(:,k)); %calling function to eff sample size 
    k
end
toc   

%% Plot the trajectory compared with ground truth trajectory 
figure(1)
plot(x1, x2, 'b-' );
hold on;
plot(tau(1,:), tau(4,:), 'r-');
hold on;
plot(stations(1,:), stations(2,:), '*');

%% Plot the histogram of w values
figure(2)
subplot(3,1,1)       
histogram(log10(w(:,1)),[-350:10:0])
title('n = 1')

subplot(3,1,2)       
histogram(log10(w(:,10)),[-350:10:0])
title('n = 10')

subplot(3, 1, 3)       
histogram(log10(w(:,50)),[-350:10:0])
title('n = 50')

%% Plot of non-zero w at each time steps. It degenerates after approx 50 time steps
figure(3)
for pp =1:500
    num(pp)=sum(w(:,pp)~=0);
end
plot(num(1:100));