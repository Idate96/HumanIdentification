function plot_fft_data(dist_fft, sys_out_fft, user_input_fft, system_fff)

figure;
subplot(2,2,1);
loglog(freq_domain, abs(dist_fft)); hold on;
loglog(freq_domain(primes), abs(dist_fft(primes)), 'o');
title("Disturbance fft");


subplot(2,2,2);
loglog(freq_domain, abs(sys_out_fft)); hold on;
loglog(freq_domain(primes), abs(sys_out_fft(primes)), 'o');
title("Sys Output fft");

subplot(2,2,3);
loglog(freq_domain, abs(user_input_fft)); hold on;
loglog(freq_domain(primes), abs(user_input_fft(primes)), 'o');
title("User output fft");

subplot(2,2,4);
loglog(freq_domain, abs(system_fft)); hold on;
loglog(freq_domain(primes), abs(system_fft(primes)), 'o');
loglog(freq_domain, 4./(freq_domain.^2));
title("System fft");

end