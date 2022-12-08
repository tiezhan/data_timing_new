function idx_1y= BF_FndArrinArr(dat_1xory, seek_1y)
%function Fndidx_1y= BF_FndtwoNum(dat_1xory, seek)
%dat_1xory=[1 0 1 1 0 1 0 0 1 0 2 0 1];
%[1,4,6,9] = BF_FndtwoNum(x, [1 0]);
%2015-9-6 陈昕枫 BaseFrame
	n1 = length(dat_1xory);
    n2 = length(seek_1y);
    idx_1y = zeros( n1,1);
    k=1;%idx_1y索引
    for i=1:n1-n2+1

       if isequal( dat_1xory(i:i+n2-1),seek_1y )
           %找到了该arry
           idx_1y(k) = i;
           k=k+1;
       end
    end
    idx_1y( find(idx_1y ==0 )) = [];%   清除尾端的0；
    
end
