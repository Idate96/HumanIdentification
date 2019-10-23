x_exp = [0.2, 0.5, 0.4, 10, 0.5]';
omega_0 = 2 * pi/81.92;
time = linspace(0.01, 81.92, 8192);
primes = [2, 3, 5, 7, 13, 19, 31, 53, 97, 177];
freq = omega_0 * primes;

pilot_fft_prime = pilot_fun(freq, x_exp)';

lb=[0 0 0.001 6 0.1];
ub=[1 10 0.6 14 1];
x_0 = lb + rand(1,5).*(ub-lb);
%options = optimset('Algorithm','interior-point','LargeScale','on');
f_min = @(x) obj_fun(x, pilot_fft_prime, freq);
x_estimated = fmincon(f_min, x_0, [], [], [], [], lb, ub);