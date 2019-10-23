list_filenames = dir('data/vr_test');
primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

data_list = [];
num_samples = 8192;
user_fft_mean = zeros(1, num_samples/2)';
system_fft_mean = zeros(1, num_samples/2)';
dist_fft_mean = zeros(1, num_samples/2)';
user_input_fft_mean = zeros(1, num_samples/2)';
sys_out_fft_mean = zeros(1, num_samples/2)';

freq = zeros(num_samples);
num_runs = 0;

for i = 1:length(list_filenames)
    if (contains(list_filenames(i).name, '.csv'))
       num_runs = num_runs + 1 ;
       data = load_data(list_filenames(i).name);
       [user_fft, system_fft, dist_fft, user_input_fft, system_out_fft, freq] = system_identification(data);
       user_fft_mean = user_fft_mean + user_fft;
       dist_fft_mean = dist_fft_mean + dist_fft;
       user_input_fft_mean = user_input_fft_mean + user_input_fft;
       sys_out_fft_mean = sys_out_fft_mean + system_out_fft;
       system_fft_mean = system_fft_mean + system_fft;
    end
end

user_fft_mean = user_fft_mean/num_runs;
system_fft_mean = system_fft_mean/num_runs;
dist_fft_mean = dist_fft_mean/num_runs;
user_input_fft_mean = user_input_fft_mean/num_runs;
system_out_fft_mean = sys_out_fft_mean/num_runs;

x = parameter_estimation(user_fft_mean, freq, primes);
estimated_tf_pilot = pilot_fun(freq, x);

figure;
title("Dist Signal");
loglog(freq, abs(dist_fft_mean)); hold on;
loglog(freq(primes), abs(dist_fft_mean(primes)), 'o');

figure; 
title("User Input");
loglog(freq, abs(user_input_fft_mean)); hold on;
loglog(freq(primes), abs(user_input_fft_mean(primes)), 'o');

figure;
title("System Out");
loglog(freq, abs(sys_out_fft_mean)); hold on;
loglog(freq(primes), abs(sys_out_fft_mean(primes)), 'o');


figure;
loglog(freq, abs(estimated_tf_pilot)); hold on;
loglog(freq(primes), abs(user_fft_mean(primes)), 'o');

figure;
semilogx(freq, unwrap(angle(estimated_tf_pilot))); hold on;
semilogx(freq(primes), unwrap(angle(user_fft_mean(primes))), 'o');



