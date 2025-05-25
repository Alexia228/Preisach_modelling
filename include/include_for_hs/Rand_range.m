
% test
% clc
% Rand_range([80, 90], 2)

function range = Rand_range(numrange, N)
arguments
    numrange {mustBeVector(numrange), sizeeq2(numrange),...
        mustBeNumeric(numrange)}
    N (1,1) double = 1
end

min = numrange(1);
max = numrange(2);
range = rand(N, 1)*(max-min) + min;
end

function status = sizeeq2(x)
status = numel(x) == 2;
if ~status
    error('Must be vector with 2 elements')
end
end





