classdef MoistureTest < matlab.unittest.TestCase

    methods (Test)

        function testDry(testCase)
            M = computeMoisture(3.3, 3.3, 2.9);
            testCase.verifyEqual(M, 30, 'AbsTol', 1);
        end

        function testWet(testCase)
            M = computeMoisture(2.9, 3.3, 2.9);
            testCase.verifyEqual(M, 70, 'AbsTol', 1);
        end

        function testMid(testCase)
            M = computeMoisture(3.1, 3.3, 2.9);
            testCase.verifyGreaterThan(M, 30);
            testCase.verifyLessThan(M, 70);
        end

        function testTooHigh(testCase)
            M = computeMoisture(5, 3.3, 2.9);
            testCase.verifyLessThanOrEqual(M, 100);
        end

        function testTooLow(testCase)
            M = computeMoisture(0, 3.3, 2.9);
            testCase.verifyGreaterThanOrEqual(M, 0);
        end

    end
end