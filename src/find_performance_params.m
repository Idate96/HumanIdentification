function params = find_performance_params(mean_data)
    rmse = rms(mean_data.userInput);
    rmsu = rms(mean_data.rollAngle);
    params.rmse = rmse;
    params.rmsu = rmsu; 
end