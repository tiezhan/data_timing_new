function [xxxx] = testmice(data)
xxxx = []
for i = 1:size(data,1)
    dd = data(i,:) 
    dd1 = dd(isfinite(dd))
    xxxx(i,:) = [dd1(:,1)  dd1(:,end)]  
end
% dd1(:,round(length(dd1)/2)) %% ȡ1/2 end ����xxxx�м��ɵõ� ѵ��һ��ʱ������