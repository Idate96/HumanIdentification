classdef ParserTest < matlab.unittest.TestCase
    methods (Test)
        function test_parser(testCase)
            start_sampling_time = 8;
            sampling_period = 81.92;
            sampling_freq = 100; % Hz
            data = load_data('data/test_data_1.csv');
            sampled_data = parse_entries(data, start_sampling_time, sampling_period, sampling_freq);
            testCase.verifyEqual(sampled_data.time(1), 1/sampling_freq, 'RelTol', 0.001);
            testCase.verifyEqual(sampled_data.time(end), sampling_period, 'RelTol', 0.00001);
            testCase.verifyEqual(length(sampled_data.time), sampling_period * sampling_freq);
        end
    end
end