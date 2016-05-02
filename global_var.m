global P mu_x0 sigma_x0 z_dist
global v eta num_stations mu_noise std_noise mu_w sigma_w num_part num_steps obs_std

z_dist = [0 3.5 0 0 -3.5; 0 0 3.5 -3.5 0];
P = [16/20 1/20 1/20 1/20 1/20 ;...
     1/20 16/20 1/20 1/20 1/20 ;...
     1/20 1/20 16/20 1/20 1/20 ;...
     1/20 1/20 1/20 16/20 1/20 ;...
     1/20 1/20 1/20 1/20 16/20 ] ;

mu_x0 = zeros(6,1);
sigma_x0 = diag([500, 5 , 5 , 200, 5, 5]);

v = 90;
eta = 3;
num_stations = 7;
mu_noise = 0;
std_noise = 1.5;

mu_w = zeros(2,1);
sigma_w = eye(2)*0.5^2;

num_part = 10000;
num_steps = 500;

obs_std = eye(7)*1.5^2;

load('stations.mat');
%load ('RSSI-measurements.mat');
