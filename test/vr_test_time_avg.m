list_filenames = dir('data/vr_test');
primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];

data_list = [];
total_num_samples = 9000;
num_samples = 8192;
user_time_mean = zeros(1, total_num_samples)';
out_time_mean = zeros(1, total_num_samples)';
angAcc_time_mean = zeros(1, total_num_samples)';
angVel_time_mean = zeros(1, total_num_samples)';
dist_time_mean = zeros(1, total_num_samples)';
user_input_time_mean = zeros(1, total_num_samples)';
sys_out_time_mean = zeros(1, total_num_samples)';

freq = zeros(num_samples);
num_runs = 0;

for i = 1:length(list_filenames)
    if (contains(list_filenames(i).name, '.csv'))
       num_runs = num_runs + 1 ;
       data = load_data(list_filenames(i).name);
       user_time_mean = user_time_mean + data.userInput;
       out_time_mean = out_time_mean + data.rollAngle;
       dist_time_mean = dist_time_mean + data.disturbanceInput;
       angVel_time_mean = angVel_time_mean + data.angVel;
       angAcc_time_mean = angAcc_time_mean + data.angAcc;
    end
end

user_time_mean = user_time_mean/num_runs;
out_time_mean = out_time_mean/num_runs;
dist_time_mean = dist_time_mean/num_runs;
angAcc_time_mean = angAcc_time_mean/num_runs;
angVel_time_mean = angVel_time_mean/num_runs;

mean_data.userInput = user_time_mean;
mean_data.rollAngle = out_time_mean;
mean_data.disturbanceInput = dist_time_mean;
mean_data.time = data.time;
mean_data.angVel = angVel_time_mean;
mean_data.angAcc = angAcc_time_mean;

[user_fft, system_fft, dist_fft, user_input_fft, system_out_fft, freq] = system_identification(mean_data);


x = parameter_estimation(user_fft, freq, primes);
estimated_tf_pilot = pilot_fun(freq, x);


figure;
title("Dist Signal");
loglog(freq, abs(dist_fft)); hold on;
loglog(freq(primes), abs(dist_fft(primes)), 'o');
grid on;

savefig('test/figs/dist_signal.fig');
saveas(gcf, 'test/figs/vr_dist_signal.jpg');


figure; 
title("User Input");
loglog(freq, abs(user_input_fft)); hold on;
loglog(freq(primes), abs(user_input_fft(primes)), 'o');
grid on;

savefig('test/figs/user_input_signal.fig');
saveas(gcf, 'test/figs/vr_user_input_signal.jpg');


figure;
title("System Out");
loglog(freq, abs(system_out_fft)); hold on;
loglog(freq(primes), abs(system_out_fft(primes)), 'o');
grid on;

savefig('test/figs/sys_output_signal.fig');
saveas(gcf, 'test/figs/vr_sys_output_signal.jpg');


figure;
loglog(freq, abs(estimated_tf_pilot)); hold on;
loglog(freq(primes), abs(user_fft(primes)), 'o');
grid on;

savefig('test/figs/abs_pilot_tf.fig');
saveas(gcf, 'test/figs/vr_abs_pilot_tf.jpg');

figure;
semilogx(freq, unwrap(angle(estimated_tf_pilot))); hold on;
semilogx(freq(primes), unwrap(angle(user_fft(primes))), 'o');
grid on;

savefig('test/figs/phase_pilot_tf.fig');
saveas(gcf, 'test/figs/vr_phase_pilot_tf.jpg');

figure;
loglog(freq(primes), abs(user_fft(primes)), 'o');
grid on;

savefig('test/figs/abs_pilot_coeff.fig');
saveas(gcf, 'test/figs/vr_abs_pilot_coeff.jpg');

figure;
semilogx(freq(primes), rad2deg(unwrap(angle(user_fft(primes)))), 'o');
grid on;

savefig('test/figs/phase_pilot_coeff.fig');
saveas(gcf, 'test/figs/vr_phase_pilot_coeff.jpg');