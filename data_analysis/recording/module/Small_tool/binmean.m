function data_bin = binmean(data, binsize)
%对一段数据以binsize逐段取平均
%function data_1y = binmean(data, binsize)
%----Input 参数---------
% data            :  数据, 1v 或 nsample_x_ntrial
% binsize         :  bin的大小, 1num
%
%----Output 参数---------
% data_bin         :  平均后的数据
    
    if isvector(data)
        data = set1y(data);
    end
    [nsample, ntrial] = size(data);
    assert(nsample > 1);
    
    len = 0:binsize:nsample;
    data_clean = data(1:len(end), :);
    data_1y = data_clean(:);
    data_m_1x = mean(reshape(data_1y, binsize, []), 1)';
    data_bin = reshape(data_m_1x, [], ntrial);
end