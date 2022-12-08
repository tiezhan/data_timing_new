function data_bin = binmean(data, binsize)
%��һ��������binsize���ȡƽ��
%function data_1y = binmean(data, binsize)
%----Input ����---------
% data            :  ����, 1v �� nsample_x_ntrial
% binsize         :  bin�Ĵ�С, 1num
%
%----Output ����---------
% data_bin         :  ƽ���������
    
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