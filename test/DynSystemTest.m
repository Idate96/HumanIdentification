classdef DynSystemTest < matlab.unittest.TestCase
    methods (Test)
        function double_integrator_test(testCase)
            sampling_period = 0.01;
            data = load_data('data/test_data_step.csv');
            y = zeros(length(data.time) + 2, 2);
            for i = 1:(length(data.time) + 1)
                y(i + 1, 2) = y(i, 2) + 4 * sampling_period;
                y(i + 1, 1) = y(i, 1) + y(i + 1, 2) * sampling_period;
            end
            testCase.verifyEqual(sum(data.rollAngle - y(3:end, 1)), 0, 'AbsTol', 0.3);
        end
        
        function double_interator_only_forcing_func(testCase)
            data = load_data('data/test_data_long_dist.csv');
            sampling_period = 0.01;

            u = rad2deg(disturbance_func(data.time));
            y = zeros(length(data.time), 2);
            for i = 1:(length(data.time) - 1)
                y(i + 1, 2) = y(i, 2) + (4 * u(i)) * sampling_period;
                y(i + 1, 1) = y(i, 1) + y(i + 1, 2) * sampling_period;
            end
            figure;
            plot(data.time, y(:, 1), data.time, data.rollAngle);
            figure;
            plot(data.time, data.rollAngle);
            testCase.verifyEqual(sum(data.rollAngle - y(3:end, 1)), 0, 'AbsTol', 0.3);
        end  

    end

    methods 
        function dy = dyn_system(t, y)
            dy(1) = y(2);
            dy(2) = 4;
        end
    end
end


