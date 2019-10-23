classdef DisturbanceTest < matlab.unittest.TestCase
    methods (Test)
        function test_disturbance_input(testCase)
            data = load_data('data/test_data_dist.csv');
            expected_disturbance = disturbance_func(data.time);
            testCase.verifyEqual(sum(deg2rad(data.disturbanceInput) - expected_disturbance), 0, 'AbsTol', 0.0000001);
        end
    end
end