function [A_m, A_std, A_sem] = mean_std_sem(A, dim)
% mean & std & sem value of array
% function [A_m, A_std, A_sem] = mean_std_sem(A, dim)
assert(~isempty(A), 'Input array should not be empty!');
if ~exist('dim', 'var')
    A_m = mean(A);
    A_std = std(A);
    if isvector(A)
        n = length(A);
    else
        n = size(A, 1);
    end
else
    A_m = mean(A, dim);
    A_std = std(A, 0, dim);
    n = size(A, dim);
end
A_sem = A_std / sqrt(n);