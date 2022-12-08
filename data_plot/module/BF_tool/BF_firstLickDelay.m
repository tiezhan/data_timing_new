function delay_1v = BF_firstLickDelay(Tone_1v, lick_1v, noperiod_num)
%获取离Tone邮戳最近的lick发生的时间差，修订日期2016-10-10，陈昕枫
%function delay_1v = BF_firstLickDelay(Tone_1v, lick_1v, noperiod_num=0)
%delay_1v = BF_firstLickDelay(lsttone,lstlick)
%----Input 参数---------
% Tone_1v     : 对齐的中心点，时间邮戳
% lick_1v     : 用来匹配中心点的，时间邮戳
% noperiod_num：不响应期，Tone_1v - lick_1v > 恰好它，默认=0
%
%----Output 参数---------
% delay_1v    : 获取离每轮“中心点”最近的时间差，没有的用nan补足

    if ~exist('noperiod_num','var')
        noperiod_num=0;
    end
    lick_1v = sort(lick_1v);
    delay_1v = zeros(size(Tone_1v));
    for i = 1:length(Tone_1v)
        tdiff = lick_1v - Tone_1v(i);
        ind = find(tdiff > noperiod_num , 1, 'first');
        if isempty(ind)
            delay_1v(i) = nan;
        else
            delay_1v(i) = tdiff(ind);
        end
    end
end