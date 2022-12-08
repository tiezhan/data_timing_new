function range_val = constrainNumber(val, range_min, range_max)
% 强制val在约束的范围内
% range_val = constrainNumber(val, range_min, range_max)
%---------------------------Input---------------------------
%val        :  原始数据
%range_min  :  最小值
%range_max  :  最大值
%
%---------------------------Output--------------------------
%range_val   :  约束后的数据， range_min< range_val < range_max

    assert(range_min < range_max);
    ind_outmin = val<range_min;
    ind_outmax = val>range_max;
    range_val = val;
    range_val(ind_outmin) = range_min;
    range_val(ind_outmax) = range_max;
end