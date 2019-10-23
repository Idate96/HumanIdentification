list_filenames = dir('data/vr_test');
primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

data_list = [];
num_samples = 8192;
user_fft_mean = zeros(1, num_samples/2);
system_fft_mean = zeros(1, num_samples/2);
freq = zeros(num_samples);
num_runs = 0;

for i = 1:length(list_filenames)
    if (contains(list_filenames(i).name, '.csv'))
       num_runs = num_runs + 1 ;
       data = load_data(list_filenames(i).name);
       [user_fft, system_fft, freq] = system_identification(data);
       user_fft_mean = user_fft_mean + user_fft;
       system_fft_mean = system_fft_mean + system_fft;
    end
end

user_fft_mean = user_fft_mean/num_runs;
system_fft_mean = system_fft_mean/num_runs;

% analytical system
system_analitical = 4./(freq.^2);
%plot_comparison(system_fft_mean, system_analitical, freq, primes);
%plot_comparison(user_fft_mean, 1, freq, primes);
x_analytical = [0.5, 0.5, 0.1, 8, 0.1];
pilot_ana = pilot_fun(freq, x_analytical);
x_estimated = parameter_estimation(pilot_ana, freq, primes);
pilot_est = pilot_fun(freq, x_estimated);

figure;
loglog(freq, abs(pilot_est)); hold on;
loglog(freq, abs(pilot_ana), '--'); hold on;
loglog(freq(primes), abs(pilot_ana(primes)), 'o');

x = parameter_estimation(user_fft, freq, primes);
estimated_tf_pilot = pilot_fun(freq, x);
figure;
loglog(freq, abs(estimated_tf_pilot)); hold on;
loglog(freq(primes), abs(user_fft_mean(primes)), 'o');
figure;
semilogx(freq, unwrap(angle(estimated_tf_pilot))); hold on;
semilogx(freq(primes), unwrap(angle(user_fft_mean(primes))), 'o');



