function result = BF_fileDateCmp(file1, file2)
%% 比较2个文件的最后修改时间，以便用file1更新file2 (返回1、2时)
% function result = BF_fileDateCmp(file1, file2)
% ----------------Input 参数--------------------
% file1, file2   :  文件的路径
%
% ----------------Output 参数--------------------
% result         :  file1与file2时间比较的结果 [-1| 0| 1| -2| 2]
% file1 < file2, return -1;
% file1 == file2, return 0;
% file1 > file2, return +1;     //请更新file2
% file1(空)  file2,  return -2; //请创建file1
% file1   file2(空), return 2;  //请创建file2
% file1(空)   file2(空), error

finfo1 = dir(file1);
finfo2 = dir(file2);

%% 数据核实
assert(~(isempty(finfo1)&&isempty(finfo2)));
if isempty(finfo1)
    result = -2;
    return;
elseif isempty(finfo2)
    result = 2;
    return;
end

%% 时间比较
fdate1 = datetime(finfo1.date, 'InputFormat', 'd-MMM-y HH:mm:ss');
fdate2 = datetime(finfo2.date, 'InputFormat', 'd-MMM-y HH:mm:ss');
if(fdate1>fdate2)
    result = 1;
elseif(fdate1 == fdate2)
    result = 0;
else
    result = -1;
end