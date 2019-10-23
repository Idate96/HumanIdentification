function [abs_tf_interp, phase_tf_interp, crossover_freq, phase_margin] = find_tf_margins(tf_coefficients, freq, domain)
    abs_tf = 20 * log10(abs(tf_coefficients));
    phase_tf = unwrap(angle(tf_coefficients));
    
    abs_tf_interp = interp1q(freq, abs_tf, domain);
    phase_tf_interp = interp1q(freq, phase_tf, domain);
    
    [zero, crossover_freq_id] = min(abs(abs_tf_interp - 1));
    crossover_freq = domain(crossover_freq_id);
    phase_margin = pi + phase_tf_interp(crossover_freq_id);
end