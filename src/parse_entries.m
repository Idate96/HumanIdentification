function sampled_data = parse_entries(data, start_sampling_time, sampling_period, sampling_freq)
    start_sampling_id = find(abs(data.time-start_sampling_time)<1e-3);
    %start_sampling_id = start_sampling_time * sampling_freq;  
    end_sampling_id = start_sampling_id + sampling_period * sampling_freq;
    sampled_data = data;
    sampled_data.time = data.time(start_sampling_id + 1:end_sampling_id) - data.time(start_sampling_id);
    sampled_data.userInput = data.userInput(start_sampling_id + 1:end_sampling_id);
    sampled_data.disturbanceInput = data.disturbanceInput(start_sampling_id + 1:end_sampling_id);
    sampled_data.angAcc = data.angAcc(start_sampling_id + 1:end_sampling_id);
    sampled_data.angVel = data.angVel(start_sampling_id + 1:end_sampling_id);
    sampled_data.rollAngle = data.rollAngle(start_sampling_id + 1:end_sampling_id);
end

