function datas = load_dataset(list_filenames, num_samples)
    datas = [];
    for i = 1:length(list_filenames)
        if (contains(list_filenames(i).name, '.csv'))
            data = load_data(fullfile(list_filenames(i).folder, list_filenames(i).name));
            if (length(data.time) > num_samples)
               data.time = data.time(1:num_samples);
               data.userInput = data.userInput(1:num_samples);
               data.rollAngle = data.rollAngle(1:num_samples);
               data.disturbanceInput = data.disturbanceInput(1:num_samples);
               data.angVel = data.angVel(1:num_samples);
               data.angAcc = data.angAcc(1:num_samples);
               
            elseif (length(data.time) < num_samples)
               num_zeros = num_samples - length(data.time);
               data.time = [data.time; zeros(num_zeros, 1)];
               data.userInput = [data.userInput; zeros(num_zeros, 1)];
               data.rollAngle = [data.rollAngle; zeros(num_zeros, 1)];
               data.disturbanceInput = [data.disturbanceInput; zeros(num_zeros, 1)];
               data.angVel = [data.angVel; zeros(num_zeros, 1)];
               data.angAcc = [data.angAcc; zeros(num_zeros, 1)];  
            end
          datas = [datas, data];
        end
    end


function data = load_data(filename)
    file = fopen(filename);
    header = fgetl(file);
    list_fields = split(header, ",");
    % extract header data 
    data.name = extractAfter(list_fields(1), 6);
    data.run = extractAfter(list_fields(3), 6);
    data.condition = extractAfter(list_fields(2), 12);
    data.date = extractAfter(list_fields(4), 13);
    datamatrix = csvread(filename, 2, 0);
    data.time = datamatrix(:, 1);
    data.userInput = datamatrix(:, 2);
    data.disturbanceInput = datamatrix(:, 3);
    data.angAcc = datamatrix(:, 4);
    data.angVel = datamatrix(:, 5);
    data.rollAngle = datamatrix(:, 6);
end

end