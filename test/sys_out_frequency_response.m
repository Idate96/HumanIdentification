data = load_data('test_data_step.csv');
start_sampling_period = 8;
sampling_period = 81.92;
omega_0 = 2 * pi/sampling_period;
sampling_freq = 100;
N = sampling_freq * sampling_period;

parsed_data = parse_entries(data, start_sampling_period, sampling_period, sampling_freq);

primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

% disturbance data get from the text file directly
error_fft_unity = fft(deg2rad(parsed_data.rollAngle));
error_fft_unity = error_fft_unity(2:N/2 + 1);

figure;
loglog(freq_domain, abs(error_fft_unity)); hold on;
loglog(freq_domain(primes), abs(error_fft_unity(primes)), 'o');


figure;
loglog(freq_domain, abs(dist_fft)); hold on;
loglog(freq_domain(primes), abs(dist_fft(primes)), 'o');
