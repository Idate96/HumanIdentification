function plot_fft_primes(freq, fft_data, primes, title_name, data_folder, type)
    figure('visible', 'off');
    title(title_name);
    if type == "all"
        subplot(2, 1, 1);
        loglog(freq(primes), abs(fft_data(primes)), 'o'); hold on;

        subplot(2, 1, 2);
        semilogx(freq(primes), unwrap(angle(fft_data(primes))), 'o'); hold on;
    elseif type == "abs"

        loglog(freq(primes), abs(fft_data(primes)), 'o'); hold on;
    elseif type == "phase"
        semilogx(freq(primes), unwrap(angle(fft_data(primes))), 'o'); hold on;
    end
    grid on;

    folder = strcat("images/", data_folder);
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    saveas(gcf, strcat(folder, "/", title_name, ".jpg"));
end