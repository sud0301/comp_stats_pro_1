function [] = set_global_var(alpha_in)
    global P delta phi_t phi si_tz si_tw si_w si_z mu_x0 sigma_x0 z_dist
    global v eta num_stations mu_noise std_noise mu_w sigma_w num_part num_steps obs_std

    alpha = alpha_in;
    z_dist = [0 3.5 0 0 -3.5; 0 0 3.5 -3.5 0];
    P = [16/20 1/20 1/20 1/20 1/20 ;...
         1/20 16/20 1/20 1/20 1/20 ;...
         1/20 1/20 16/20 1/20 1/20 ;...
         1/20 1/20 1/20 16/20 1/20 ;...
         1/20 1/20 1/20 1/20 16/20 ] ;

    delta = 0.5;
    phi_t = [1 delta delta^2/2; 0 1 delta; 0 0 alpha];  
    phi = [phi_t zeros(3,3); zeros(3,3) phi_t];

    si_tz = [delta^2/2 ;  delta ; 0];
    si_tw = [delta^2/2 ;  delta ; 1];
    si_w = [si_tw zeros(3,1); zeros(3,1) si_tw];
    si_z = [si_tz zeros(3,1); zeros(3,1) si_tz];

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
end
