function [A_m, A_std, A_sem] = median_std_sem(A, dim)
% median & pseudo-std & presudo-sem，可替代 mean_std_sem.m
% function [A_m, A_std, A_sem] = median_std_sem(A, dim)
assert(~isempty(A), 'Input array should not be empty!');

std_p = 0.6526;
p_cut_down = (1-std_p)/2;
p_cut_up = 1-(1-std_p)/2;

if ~exist('dim', 'var')
    if isvector(A)
        n = length(A);
    else
        n = size(A, 1);
    end
    assert(n > 7, '样本数建议大于7');
    A_m = median(A);
    A_std_down = prctile(A, p_cut_down*100);
    A_std_up = prctile(A, p_cut_up*100);
    A_std    = (A_std_up - A_std_down)/2;
else
    n = size(A, dim);
    assert(n > 7, '样本数建议大于7');
    A_m = median(A, dim);
    A_std_down = prctile(A, p_cut_down*100, dim);
    A_std_up = prctile(A, p_cut_up*100, dim);
    A_std    = (A_std_up - A_std_down)/2;
end
A_sem = A_std / sqrt(n);