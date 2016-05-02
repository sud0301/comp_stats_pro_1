function [phi si_w si_z] = alpha_function(alpha)
    delta = 0.5;
    phi_t = [1 delta delta^2/2; 0 1 delta; 0 0 alpha];  
    phi = [phi_t zeros(3,3); zeros(3,3) phi_t];

    si_tz = [delta^2/2 ;  delta ; 0];
    si_tw = [delta^2/2 ;  delta ; 1];
    si_w = [si_tw zeros(3,1); zeros(3,1) si_tw];
    si_z = [si_tz zeros(3,1); zeros(3,1) si_tz];

end
