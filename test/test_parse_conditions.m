path = 'data/0/RollTrackingLog/';
list_files = dir(path);
num_samples = 9000;

loaded_data = load_dataset(list_files, num_samples);
conditions = parse_conditions(loaded_data, 0, false);


