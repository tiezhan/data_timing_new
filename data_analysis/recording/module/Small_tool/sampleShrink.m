function [newdata_v, rate] = sampleShrink(data_v, nearto)
%减少plot的采样点，修订日期2016-6-20，陈昕枫
%function [newdata_v, rate] = sampleShrink(data_v, nearto)
%----Input 参数---------
% data_v     : 要缩小的向量
% nearto     : 缩小到恰好 >=数量级 (10对数), 默认缩小到10k采样。
%
%----Output 参数---------
% newdata_v  : 缩小后的向量
% rate       : 缩小的倍数 (>=1) 
    len = length(data_v);
    if ~isvector(data_v); error('传输data必须为向量!');end
    if ~exist('nearto','var'); nearto = min([10000, len]);end
    rate = 10^( floor(log10(len / nearto)) );
    if rate < 1
        warning('该函数不能放大');
        newdata_v = data_v;
        rate = 1;
    elseif rate == 1
        disp('刚好不缩放');
        newdata_v = data_v;
        rate =1;
    else        
        len2 = floor(len/rate/2)*2*rate;
        data2 = data_v(1:len2);
        data3 = reshape(data2, rate*2, []);
        min_val = min(data3);%1x
        max_val = max(data3);
        newdata_v = reshape([max_val;min_val],1,[]);
        if xor(isrow(data_v),isrow(newdata_v)); newdata_v = newdata_v'; end
        if len2==len;return;end
        newdata_v(end+1) = mean(data_v(len2+1:end));      
    end
end