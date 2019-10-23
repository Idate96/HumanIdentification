data = load_data('test_user_run_1.csv');
start_sampling_period = 8;
sampling_period = 81.92;
omega_0 = 2 * pi/sampling_period;
sampling_freq = 100;
N = sampling_freq * sampling_period;

parsed_data = parse_entries(data, start_sampling_period, sampling_period, sampling_freq);

primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

% disturbance data get from the text file directly
dist_fft = fft(parsed_data.disturbanceInput);
dist_fft = dist_fft(2:N/2 + 1);

figure;
subplot(2,2,1);
loglog(freq_domain, abs(dist_fft)); hold on;
loglog(freq_domain(primes), abs(dist_fft(primes)), 'o');
title("Disturbance fft");


% system output data
sys_out_fft = fft(parsed_data.rollAngle);
sys_out_fft = sys_out_fft(2:N/2 + 1);

subplot(2,2,2);
loglog(freq_domain, abs(sys_out_fft)); hold on;
loglog(freq_domain(primes), abs(sys_out_fft(primes)), 'o');
title("Sys Output fft");

% user input data
user_input_fft = fft(parsed_data.userInput);
user_input_fft = user_input_fft(2:N/2 + 1);

subplot(2,2,3);
loglog(freq_domain, abs(user_input_fft)); hold on;
loglog(freq_domain(primes), abs(user_input_fft(primes)), 'o');
title("User output fft");

% system fft
system_fft = sys_out_fft./(user_input_fft + dist_fft);

subplot(2,2,4);
loglog(freq_domain, abs(system_fft)); hold on;
loglog(freq_domain(primes), abs(system_fft(primes)), 'o');
loglog(freq_domain, 4./(freq_domain.^2));
title("System fft");

