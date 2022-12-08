function delay_1v = BF_firstLickDelay(Tone_1v, lick_1v, noperiod_num)
%��ȡ��Tone�ʴ������lick������ʱ���޶�����2016-10-10����꿷�
%function delay_1v = BF_firstLickDelay(Tone_1v, lick_1v, noperiod_num=0)
%delay_1v = BF_firstLickDelay(lsttone,lstlick)
%----Input ����---------
% Tone_1v     : ��������ĵ㣬ʱ���ʴ�
% lick_1v     : ����ƥ�����ĵ�ģ�ʱ���ʴ�
% noperiod_num������Ӧ�ڣ�Tone_1v - lick_1v > ǡ������Ĭ��=0
%
%----Output ����---------
% delay_1v    : ��ȡ��ÿ�֡����ĵ㡱�����ʱ��û�е���nan����

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