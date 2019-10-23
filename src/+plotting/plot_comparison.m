function plot_comparison(fft_data, analitical_data, freq_domain, primes)
    figure;
    title("Experimental and Analytical tf comparison");
    loglog(freq_domain, abs(fft_data), '-'); hold on;
    loglog(freq_domain(primes), abs(fft_data(primes)), 'o'); hold on;
    loglog(freq_domain, abs(analitical_data)); hold on;
    legend("Experimental", "Primes", "Analytical");
    xlabel("Frequency [rad/s]");
    ylabel("Mag");
end