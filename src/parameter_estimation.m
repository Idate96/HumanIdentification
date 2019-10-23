function [x] = parameter_estimation(user_fft, frequencies, prime_ids)
        lb=[0 0 0.001 4 0.1];
        ub=[1 20 0.6 14 1];
        x_0 = lb + rand(1,5).*(ub-lb);
        %options = optimset('Algorithm','interior-point','LargeScale','on');
        f_min = @(x) obj_fun(x, user_fft(prime_ids), frequencies(prime_ids));
        x = fmincon(f_min, x_0, [], [], [], [], lb, ub);
end