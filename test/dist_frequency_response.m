data = load_data('test_data_long_dist.csv');
start_sampling_period = 8;
sampling_period = 81.92;
omega_0 = 2 * pi/sampling_period;
sampling_freq = 100;
N = sampling_freq * sampling_period;

parsed_data = parse_entries(data, start_sampling_period, sampling_period, sampling_freq);

primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

% original function sampled with parsed_data.time
dist_fft = fft(disturbance_func(parsed_data.time));
dist_fft = dist_fft(2:N/2 + 1);
freq_domain = omega_0:omega_0:(pi*sampling_freq);

figure;
loglog(freq_domain, abs(dist_fft)); hold on;
loglog(freq_domain(primes), abs(dist_fft(primes)), 'o');

% disturbance data get from the text file directly
dist_fft_unity = fft(deg2rad(parsed_data.disturbanceInput));
dist_fft_unity = dist_fft_unity(2:N/2 + 1);

figure;
loglog(freq_domain, abs(dist_fft_unity)); hold on;
loglog(freq_domain(primes), abs(dist_fft_unity(primes)), 'o');

% the comparison it's useful to identify mismatches between samping of time
% and frequencies.