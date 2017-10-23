function [result, suite] = run_hsicube_tests(do_coverage)
%RUN_HSICUBE_TESTS Run class tests with optional coverage report
% [result, suite] = run_hsicube_tests() will run the tests in the tests
% directory (in parallel by default). If 'enviread.m' is not found in the
% Matlab path, it will skip the ENVI class tests. It will return the result
% array and the test suite.
% 
% Calling
% [...] = run_hsicube_tests(true) 
% will also run and display the code coverage report.
import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

if nargin < 1
    do_coverage = false;
end

% Check for ENVI file reader/writer
% Skips tests and coverage if not found
if exist('enviread.m', 'file') == 2
    hasENVI = true;
else
    hasENVI = false;
end

[testdir, ~, ~] = fileparts(mfilename('fullpath'));

    
suite = TestSuite.fromFolder(fullfile(testdir, 'CubeTest'));

if hasENVI
    suite = [suite, TestSuite.fromFolder(fullfile(testdir, 'ENVITest'))];
else
    fprintf('!!! enviread.m not found; Skipping ENVI tests... !!!\n');
end

runner = TestRunner.withTextOutput;

if do_coverage
    basedir = fileparts(testdir);
    cover_folders = {'@Cube', '@CubeArgs', '@Utils'};
    if hasENVI
        cover_folders = [cover_folders, '@ENVI'];
    end
    
    runner.addPlugin(CodeCoveragePlugin.forFolder(...
                        fullfile(basedir, cover_folders)));
end

% Run tests in parallel, if do_coverage is false
% Coverage profiling doesn't support parallel tests
if do_coverage
    result = runner.run(suite);
else
    result = runner.runInParallel(suite);
end

end

