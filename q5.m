%This program is meant to analysis the liklihood values for a range of
%alpha values. To find the optimal parameter using max-likelihood.
clear all;
global_var;

load ('RSSI-measurements-unknown-alpha.mat'); %observation data
liklihood = zeros(10,1);

%% Estimation of trajectory using the given observation
for iter=1:2
    liklihood_func = zeros(10,1);
    a_i=1;
    for alpha = 0.1:0.1:1

        clear w;
        tau = zeros(6, num_steps);

        w_pdf = @(mu, var) mvnpdf(var, mu, obs_std);
        part = mvnrnd(mu_x0, sigma_x0, num_part)'; 
        obs_density_mean = generate_y_mean(part);

        w(:,1) = w_pdf(obs_density_mean', Y(:,1)'); 

        sum_w = sum(bsxfun(@times, part, w'),2);
        tau(:, 1) = sum_w/sum(w);

        for k = 2:num_steps, 
            part = generate_x(part, alpha); % generates the particles for next step
            obs_density_mean = generate_y_mean(part);  %generate mean for observation density 
            w(:, k) = w_pdf( obs_density_mean', Y(:, k)'); % estimation of conditional density or w  for all particles
            sum_nw = sum(bsxfun(@times, part, w(:, k)'),2); 
            tau(:,k) = sum_nw/sum(w(:,k)); 
            ind = randsample(num_part, num_part, true, w(:,k));
            part = part(:,ind);
            k
        end
        liklihood_func(a_i) = sum(log(sum(w)/num_part))/num_steps;
        liklihood(a_i) = liklihood(a_i) + liklihood_func(a_i);
        a_i = a_i +1;
        alpha
        
    end
end

liklihood= liklihood/2; 

plot(liklihood);