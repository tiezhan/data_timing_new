function [xxxx] = testmice(data)
xxxx = []
for i = 1:size(data,1)
    dd = data(i,:) 
    dd1 = dd(isfinite(dd))
    xxxx(i,:) = [dd1(:,1)  dd1(:,end)]  
end
% dd1(:,round(length(dd1)/2)) %% 取1/2 end 置入xxxx中即可得到 训练一半时的数据