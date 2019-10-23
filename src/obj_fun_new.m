function value = obj_fun_new(x, fft_coeff, frequencies)
% x = (k_p, T_L, tau, omega_n, damp_n)
    H_p = pilot_fun(frequencies, x);
    angle_fft = unwrap(angle(fft_coeff));
    angle_hp = unwrap(angle(H_p))';
    abs_fft = abs(fft_coeff);
    abs_hp = abs(H_p)';
    square_abs = ((abs_hp - abs_fft)./abs_fft).^2 ;
    square_angle = ((angle_hp - angle_fft)./angle_fft).^2;
    value = sum(((abs_hp - abs_fft)./abs_fft).^2 + ((angle_hp - angle_fft)./angle_fft).^2);
end