list_filenames = dir('data/test/crappy_joy');
data_folder = "C";
primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];
omega_0 = 2 * pi/81.92;
omega_max = 2 * pi * 100 / 2;

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


x = sep_parameter_estimation(user_fft, freq, primes);
estimated_tf_pilot = pilot_fun(freq, x);

x_manual =   [  0.0192 ,  15  ,  0.3  ,  4   , 0.5252];
manual_tf_pilot = pilot_fun(freq, x_manual);

end_idx = 15/omega_0;

freq = freq(1:end_idx);
manual_tf_pilot = manual_tf_pilot(1:end_idx);
estimated_tf_pilot = estimated_tf_pilot(1:end_idx);

figure;
subplot(2, 1, 1);
loglog(freq(primes), abs(user_fft(primes)), 'o'); hold on;
loglog(freq, abs(manual_tf_pilot)); hold on;
loglog(freq, abs(estimated_tf_pilot));

subplot(2, 1, 2);
semilogx(freq(primes), unwrap(angle(user_fft(primes))), 'o'); hold on;
semilogx(freq(primes), unwrap(angle(manual_tf_pilot(primes))), 'x'); hold on;
semilogx(freq(primes), unwrap(angle(estimated_tf_pilot(primes))), 'x'); hold on;


manual_obj_fun = obj_fun(x_manual, user_fft(primes), freq(primes));
fprintf("Manuals obj fun: %d", manual_obj_fun);
auto_obj_fun = obj_fun(x, user_fft(primes), freq(primes));
fprintf("Automatic obj fun: %d", auto_obj_fun);

%% 
plot = 0;
%% 
%% 

if (plot)
figure;
title("Dist Signal");
loglog(freq, abs(dist_fft)); hold on;
loglog(freq(primes), abs(dist_fft(primes)), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/dome_dist_signal_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_dist_signal_filt.jpg"));
%% 

figure;
title("Dist Signal Unfiltered");
ylabel('Magnitude (dB)')
semilogx(freq(primes), 20 * log10(abs(dist_fft(primes))'./(primes*omega_0).^2 * 4 / num_samples * 2), 'o');
%% 
grid on;

savefig(strcat("test/figs/", data_folder, "/dome_dist_signal_unfilt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_dist_signal_unfilt.jpg"));


figure; 
title("User Input");
loglog(freq, abs(user_input_fft)); hold on;
loglog(freq(primes), abs(user_input_fft(primes)), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/dome_user_input_signal_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_user_input_signal_filt.jpg"));


figure;
title("System Out");
loglog(freq, abs(system_out_fft)); hold on;
loglog(freq(primes), abs(system_out_fft(primes)), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/dome_sys_output_signal_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_sys_output_signal_filt.jpg"));


figure;
loglog(freq, abs(estimated_tf_pilot)); hold on;
loglog(freq(primes), abs(user_fft(primes)), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/dome_abs_pilot_tf_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_abs_pilot_tf_filt.jpg"));


figure;
semilogx(freq, unwrap(angle(estimated_tf_pilot))); hold on;
semilogx(freq(primes), unwrap(angle(user_fft(primes))), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/dome_phase_pilot_tf_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_phase_pilot_tf_filt.jpg"));


figure;
loglog(freq(primes), abs(user_fft(primes)), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/abs_pilot_coeff_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_abs_pilot_coeff_filt.jpg"));


figure;
semilogx(freq(primes), rad2deg(unwrap(angle(user_fft(primes)))), 'o');
grid on;

savefig(strcat("test/figs/", data_folder, "/phase_pilot_coeff_filt.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/dome_phase_pilot_coeff_filt.jpg"));



%%
domain = linspace(omega_0, primes(end) * omega_0, 1000)';
[tf_interp_abs, tf_interp_phase, crossover_freq, phase_margin] = find_tf_margins(user_fft(primes), primes' * omega_0, domain);

figure;
loglog(freq(primes), abs(user_fft(primes)), 'o'); hold on;
loglog(domain, tf_interp_abs);
grid on;

figure;
semilogx(freq(primes), rad2deg(angle(user_fft(primes))), 'o'); hold on;
semilogx(domain, rad2deg(tf_interp_phase));
grid on;
end

