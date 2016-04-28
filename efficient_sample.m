function [eff_samp_size] = efficient_sample(w)
    global_var;
    sum_cv = 0 ;
    for i=1: num_part
        sum_cv = sum_cv + (w(i)*num_part/sum(w)-1)^2;
    end
    cv = sqrt(sum_cv/num_part);
    eff_samp_size = num_part/(1+cv^2);
end
