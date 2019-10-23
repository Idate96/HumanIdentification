function [user_fft, system_fft, dist_fft, user_input_fft, system_out_fft, freq] = system_identification(data)
    start_sampling_period = 8;
    sampling_period = 81.92;
    omega_0 = 2 * pi/sampling_period;
    sampling_freq = 100;
    N = sampling_freq * sampling_period;
    freq = omega_0:omega_0:(sampling_freq * pi);
    

    parsed_data = parse_entries(data, start_sampling_period, sampling_period, sampling_freq);
    [dist_fft, user_input_fft, system_out_fft] = fft_data(parsed_data);
    user_fft = (-user_input_fft./system_out_fft);
    system_fft = (system_out_fft./(user_input_fft + dist_fft));
end