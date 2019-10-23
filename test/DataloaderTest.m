classdef DataloaderTest < matlab.unittest.TestCase
    methods (Test)
        function testLoadingData(testCase)
            expected_name = 'Lorenzo';
            expected_run = '0';
            expected_condition = '1';
            expected_num_samples = 9000;
            sample_time = 89.99;
            data = load_data('data/test_data_1.csv');
            testCase.verifyEqual(data.name{1}, expected_name);
            testCase.verifyEqual(data.run{1}, expected_run);
            testCase.verifyEqual(data.condition{1}, expected_condition);
            testCase.verifyEqual(length(data.time), expected_num_samples);
            testCase.verifyEqual(data.time(end) - data.time(1), sample_time, 'RelTol', 0.01);
        end
    end
end