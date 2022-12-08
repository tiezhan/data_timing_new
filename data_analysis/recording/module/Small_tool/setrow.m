% a_1x = setrow(a_1v);
% a_1y = setrow(a_1v)';
%让向量变成1x; 若为矩阵，报错 
%没有'setcolumn.m'
%2016-1-18 陈昕枫

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