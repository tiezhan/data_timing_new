function [newdata_v, rate] = sampleShrink(data_v, nearto)
%����plot�Ĳ����㣬�޶�����2016-6-20����꿷�
%function [newdata_v, rate] = sampleShrink(data_v, nearto)
%----Input ����---------
% data_v     : Ҫ��С������
% nearto     : ��С��ǡ�� >=������ (10����), Ĭ����С��10k������
%
%----Output ����---------
% newdata_v  : ��С�������
% rate       : ��С�ı��� (>=1) 
    len = length(data_v);
    if ~isvector(data_v); error('����data����Ϊ����!');end
    if ~exist('nearto','var'); nearto = min([10000, len]);end
    rate = 10^( floor(log10(len / nearto)) );
    if rate < 1
        warning('�ú������ܷŴ�');
        newdata_v = data_v;
        rate = 1;
    elseif rate == 1
        disp('�պò�����');
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