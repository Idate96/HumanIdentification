function value = obj_fun(x, fft_coeff, frequencies)
% x = (k_p, T_L, tau, omega_n, damp_n)
    H_p = pilot_fun(frequencies, x);
    %value = H_p.' - fft_coeff;
    value = sum((abs(H_p.' - fft_coeff).^2));
end