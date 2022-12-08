function [tRise_1y, tDur_1y] = detectTTL(data_1v, adjacent_type, adjacent_value)
%���˳�TTLͨ���������źţ��������غͳ���ʱ�����
%[tRise_1y, tDur_1y] = detectTTL(data_1v)
%[tRise_1y, tDur_1y] = detectTTL(data_1v, 'up-up', 20)
%
% ---------------------------Input---------------------------
% data_1v     :  TTLͨ���������������ݡ����� [bool 0 | bool 1]����
% adjacent    :  ���ڵ�����['up-up', 'down-up', 'down-down']
% adjacent_value: ���ڵ�ֵ [>=0]
%
% ---------------------------Output--------------------------
% tRise_1y    :  TTL��������ʱ�̣���λ������
% tDur_1y     :  TTL�ĸߵ�ƽ����ʱ������λ������
%
    assert( isvector(data_1v) );
    if islogical(data_1v)
        TTL = double(data_1v);
    else
        mean_data = 0.5*(max(data_1v) + min(data_1v));
        TTL = double( data_1v > mean_data );
    end
    TTL = [0; set1y(TTL); 0]; %HEAD & TAIL with 0
    TTLdiff = diff(TTL);
    tRise_1y = find(TTLdiff==1);
    tDown_1y = find(TTLdiff==-1);
    tDur_1y = tDown_1y - tRise_1y;
    
    if length(tRise_1y) <= 1 || ~exist('adjacent_type', 'var')
        return;
    end
    switch adjacent_type
        case 'up-up'
            tRest = tRise_1y(2:end) - tRise_1y(1:end-1);
        case 'down-up'
            tRest = tRise_1y(2:end) - tDown_1y(1:end-1);
        case 'down-down'
            tRest = tDown_1y(2:end) - tDown_1y(1:end-1);
        otherwise
            error('����Ĳ���');
    end

    ind_merge = tRest < adjacent_value;
    tRise_1y([false; ind_merge]) = [];
    tDown_1y([ind_merge; false]) = [];
    tDur_1y = tDown_1y - tRise_1y;