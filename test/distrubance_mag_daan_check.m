omega_0 = 2 * pi/81.92;
time = linspace(0.01, 81.92, 8192);
primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];
freq = omega_0 * primes;
low_pass_filter = abs(1.1./(1 - 0.6i * freq));


figure;
semilogx(freq, mag2db(low_pass_filter), 'o');
grid on;