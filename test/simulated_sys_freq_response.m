% identify simulated system with only input disturbance
s = tf('s');
sys = 4/s^2;
data = load_data('data/test_data_long_dist.csv');
T_sampling = 81.92;
start_sampling_id = 800;
num_samples = T_sampling * sampling_freq;

sampling_freq = 100;
time = 0:0.01:92;
u = disturbance_func(time);
[y, t, x] = lsim(sys, u, time);

u_samples = u(start_sampling_id + 1:start_sampling_id + num_samples);
y_samples = y(start_sampling_id + 1:start_sampling_id + num_samples);


u_fft = fft(u_samples);
y_fft = fft(y_samples);

u_fft = u_fft(2: num_samples/2 + 1);
y_fft = y_fft(2: num_samples/2 + 1)';

sys_fft = y_fft./u_fft;

primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

omega_0 = 2 * pi / T_sampling;
freq_domain = omega_0:omega_0:(pi*sampling_freq);

figure;
loglog(freq_domain, abs(sys_fft)); hold on;
loglog(freq_domain(primes), abs(sys_fft(primes)), 'o');

