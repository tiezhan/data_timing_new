% a_1x = setrow(a_1v);
% a_1y = setrow(a_1v)';
%���������1x; ��Ϊ���󣬱��� 
%û��'setcolumn.m'
%2016-1-18 ��꿷�

function data1_x=setrow(data_1v)
    [a,b]=size(data_1v);
    if a==1
        data1_x = data_1v;
    elseif b==1
        data1_x = data_1v';
    else
       error('It should not be Empty or Metrix!'); 
    end
end