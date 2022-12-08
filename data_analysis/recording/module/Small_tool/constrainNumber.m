function range_val = constrainNumber(val, range_min, range_max)
% ǿ��val��Լ���ķ�Χ��
% range_val = constrainNumber(val, range_min, range_max)
%---------------------------Input---------------------------
%val        :  ԭʼ����
%range_min  :  ��Сֵ
%range_max  :  ���ֵ
%
%---------------------------Output--------------------------
%range_val   :  Լ��������ݣ� range_min< range_val < range_max

    assert(range_min < range_max);
    ind_outmin = val<range_min;
    ind_outmax = val>range_max;
    range_val = val;
    range_val(ind_outmin) = range_min;
    range_val(ind_outmax) = range_max;
end