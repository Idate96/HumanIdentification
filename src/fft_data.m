function [dist_fft, user_input_fft, system_out_fft] = fft_data(data)
% disturbance data get from the text file directly
N = length(data.time);
dist_fft = fft(data.disturbanceInput);
dist_fft = dist_fft(2:N/2 + 1);

% system output data
system_out_fft = fft(data.rollAngle);
system_out_fft = system_out_fft(2:N/2 + 1);

% user input data
user_input_fft = fft(data.userInput);
user_input_fft = user_input_fft(2:N/2 + 1);

end
