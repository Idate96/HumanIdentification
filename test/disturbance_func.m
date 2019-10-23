function disturbance_out = disturbance(time)
    T_sampling = 81.92;
    omega_0 =  2 * pi/T_sampling;
    prime_ids = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];
    phases = deg2rad([4, 151, 43, 122, 324, 184, 281, 194, 162, 43]); % deg
    amplitudes = deg2rad([1.106, 1.099, 1.083, 1.058, 0.957, 0.842, 0.646, 0.428, 0.247, 0.136]); % deg
    disturbance_out = 0;
    for i = 1:length(prime_ids)
        disturbance_out = disturbance_out + amplitudes(i) * sin(prime_ids(i) * omega_0 * time + phases(i));
    end
end