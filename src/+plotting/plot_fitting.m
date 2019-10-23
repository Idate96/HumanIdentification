function plot_fitting(freq, fft_data, estimated_fft, primes, title_name, data_folder)
    figure('visible', 'off');
    title(title_name);
    
    subplot(2, 1, 1);
    loglog(freq(primes), abs(fft_data(primes)), 'o'); hold on;
    loglog(freq, abs(estimated_fft));
    legend("Measured", "Fitted");
    title("Gain");
    xlabel("Frequency [rad/s]");
    ylabel("Magnitude [-]");

    subplot(2, 1, 2);
    semilogx(freq(primes), rad2deg(unwrap(angle(fft_data(primes)))), 'o'); hold on;
    semilogx(freq, rad2deg(unwrap(angle(estimated_fft)))); hold on;
    legend("Measured", "Fitted");
    xlabel("Frequency [rad/s]");
    ylabel("Phase [deg]");
    title("Phase")

    folder = strcat("images/", data_folder);
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    
    saveas(gcf, strcat(folder, "/", title_name, ".jpg"));
end