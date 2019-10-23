list_filenames = dir("data/finalTestVR/CP");
total_num_samples = 9000;

datas = pad_entries(list_filenames, total_num_samples);

data_folder = "finalTestVR_CP";
status = mkdir(strcat("test/figs/", data_folder));

primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];
omega_0 = 2 * pi/81.92;
omega_max = 2 * pi * 100 / 2;

data_list = [];
%% 
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

for i = 1:length(datas)
       data = datas(i);
       num_runs = num_runs + 1 ;
       user_time_mean = user_time_mean + data.userInput;
       out_time_mean = out_time_mean + data.rollAngle;
       dist_time_mean = dist_time_mean + data.disturbanceInput;
       angVel_time_mean = angVel_time_mean + data.angVel;
       angAcc_time_mean = angAcc_time_mean + data.angAcc;
       %% 
end

user_time_mean = user_time_mean/num_runs;
out_time_mean = out_time_mean/num_runs;
rmse = rms(out_time_mean);
rmse_u = rms(user_time_mean);
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

x_manual =   [  0.0192 ,  15  ,  0.3  ,  4   , 0.5252];
manual_tf_pilot = pilot_fun(freq, x_manual);

end_idx = 15/omega_0;

freq = freq(1:end_idx);
user_fft = user_fft(1:end_idx);
dist_fft = dist_fft(1:end_idx);
user_input_fft = user_input_fft(1:end_idx);
system_out_fft = system_out_fft(1:end_idx);
manual_tf_pilot = manual_tf_pilot(1:end_idx);
estimated_tf_pilot = estimated_tf_pilot(1:end_idx);


%% 
plot = 0;
%% 
%% 

if (plot)
    figure;
subplot(2, 1, 1);
loglog(freq(primes), abs(user_fft(primes)), 'o'); hold on;
loglog(freq, abs(estimated_tf_pilot));
legend("Measured", "Fitted");
title("Gain");
xlabel("Frequency [rad/s]");
ylabel("Magnitude [-]");

subplot(2, 1, 2);
semilogx(freq(primes), rad2deg(unwrap(angle(user_fft(primes)))), 'o'); hold on;
semilogx(freq, rad2deg(unwrap(angle(estimated_tf_pilot)))); hold on;
legend("Measured", "Fitted");
xlabel("Frequency [rad/s]");
ylabel("Phase [deg]");
title("Phase")


savefig(strcat("test/figs/", data_folder, "/log_optimization.fig"));
saveas(gcf, strcat("test/figs/", data_folder, "/log_optimization.jpg"));


manual_obj_fun = obj_fun(x_manual, user_fft(primes), freq(primes));
fprintf("Manuals obj fun: %d", manual_obj_fun);
auto_obj_fun = obj_fun(x, user_fft(primes), freq(primes));
fprintf("Automatic obj fun: %d", auto_obj_fun);

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


end
%%
domain = linspace(omega_0, primes(end) * omega_0, 1000)';
open_loop_tf = user_fft(primes) .* system_fft(primes);
[tf_interp_abs, tf_interp_phase, crossover_freq, phase_margin] = find_tf_margins(open_loop_tf, primes' * omega_0, domain);

if (plot)
figure;
semilogx(freq(primes), 20 * log10(abs(open_loop_tf)), 'o'); hold on;
semilogx(domain, tf_interp_abs);
grid on;

figure;
semilogx(freq(primes), rad2deg(unwrap(angle(open_loop_tf))), 'o'); hold on;
semilogx(domain, rad2deg(unwrap(tf_interp_phase)));
%% 
grid on;
end


