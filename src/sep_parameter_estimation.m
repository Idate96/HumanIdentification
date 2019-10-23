function [x] = parameter_estimation(user_fft, frequencies, prime_ids)
        x_0 = ones(1, 5);
        %options = optimset('Algorithm','interior-point','LargeScale','on');
        user_data = [real(user_fft(prime_ids)), imag(user_fft(prime_ids))];
        freq = frequencies(prime_ids);
        [x,resnorm,residuals,exitflag,output] = ...
            lsqcurvefit(@separated_pilot_fun, x_0, freq, user_data); 
        %x = fmincon(f_min, x_0, [], [], [], [], lb, ub);
end