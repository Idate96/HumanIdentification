function [mean_data, fft_data, x] = load_condition(folder_path, saving_folder)

    list_filenames = dir(folder_path);
    total_num_samples = 9000;

    datas = load_dataset(list_filenames, total_num_samples);

    data_folder = saving_folder;

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

    end_idx = ceil(15/omega_0);

    freq = freq(1:end_idx);
    user_fft = user_fft(1:end_idx);
    dist_fft = dist_fft(1:end_idx);
    user_input_fft = user_input_fft(1:end_idx);
    system_out_fft = system_out_fft(1:end_idx);
    estimated_tf_pilot = estimated_tf_pilot(1:end_idx);

    fft_data.freq = freq;
    fft_data.user = user_fft;
    fft_data.dist = dist_fft;
    fft_data.user_input = user_input_fft;
    fft_data.system_out = system_out_fft;
    fft_data.user_tf_estimated = estimated_tf_pilot;
    
    domain = linspace(omega_0, primes(end) * omega_0, 1000)';
    open_loop_tf = user_fft(primes) .* system_fft(primes);
    [tf_interp_abs, tf_interp_phase, crossover_freq, phase_margin] = find_tf_margins(open_loop_tf, primes' * omega_0, domain);
    fft_data.crossover_freq = crossover_freq;
    fft_data.phase_margin = phase_margin;
    
    plotting.plot_fft(freq, dist_fft, primes, "Dist FFT", data_folder, "abs");
    plotting.plot_fft_primes(freq, user_fft, primes, "User TF Primes", data_folder, "abs");
    plotting.plot_fft(freq, user_input_fft, primes, "User Input FFT", data_folder, "abs");
    plotting.plot_fitting(freq, user_fft, estimated_tf_pilot, primes, "User FFT fitting", data_folder);
end

