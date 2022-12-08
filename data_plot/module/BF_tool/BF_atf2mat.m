function pfmats = BF_atf2mat(pfnames)
%转化 atf 文件为 .mat。 可同时转化多个。
%function BF_atf2mat(pfnames)
%----Input 参数---------
% pfnames    : atf文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Output 文件---------
% data  : 1D nsample
%       : 2D nsample_by_nchan
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string
%         : chanunits, cell of string
%
%----Example-------------
%BF_atf2mat(); %弹出对话框

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.atf');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames)
    pfmats{i} = trans(pfnames{i});
end

%% translate each file
function pfnew = trans(pf)
[~, f, ~] = fileparts(pf);
pfnew = regexprep(pf, '\.atf$', '_atf.mat');
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '_atf.mat');
    return;
end

% 读取数据
[headerlinesIn, chaninfo, ncol] = readhead(pf); %读取基本信息
dataStruct =importdata(pf, '\t', headerlinesIn); %读取data块
dataMatrix = dataStruct.data;
nchan = length(chaninfo.channames);
[nsample, ncol2] = size(dataMatrix);
ntrial = (ncol-1)/nchan;

% 校验数据
assert(nchan>=1, '通道数为0，,错误');
assert(nsample>2, '采样太少 (波形太短)');
assert(ncol == ncol2, '数据文件损坏');
assert(ceil(ntrial) == ntrial, 'Sweep数量计算出错');

% 数据转化格式
time_s = dataMatrix(:,1);
assert(time_s(1) == 0);
Fs = 1 / (time_s(2) - time_s(1));
dat3D = zeros(nsample, nchan, ntrial);
for i=1:nchan
    ind = (1+i):nchan:ncol;
    dat3D(:,i,:) = permute(dataMatrix(:, ind), [1, 3, 2]);
end

% 保存文件
MAT = struct();
MAT.Fs = Fs;
MAT.data = dat3D;
MAT.chaninfo = chaninfo;
save(pfnew, '-struct', 'MAT');

%% file info and head
function [headerlinesIn, chaninfo, ncol] = readhead(pf)
fun_notEOF = @(str)ischar(str);
fun_match  = @(str, expr)ischar(str)&&~isempty(regexp(str, expr, 'match'));
lineNum = 0;
fid = fopen(pf, 'r');

% 开始读取
% 识别:   [ATF	1.0]
fline=fgetl(fid); lineNum = lineNum + 1;
assert(fun_match(fline, '^ATF\t.+'), '文件格式错误');

% 识别:   [8	7] | [7 2]
fline=fgetl(fid); lineNum = lineNum + 1;
assert(fun_match(fline, '^(8|7)\t(\d+)'), '文件格式错误');
ncol = str2double(regexprep(fline, '^(8|7)\t(\d+)', '$2'));
assert(~isnan(ncol));

% 识别:   ["AcquisitionMode=Episodic Stimulation"]
fline=fgetl(fid); lineNum = lineNum + 1;
assert(fun_match(fline, '^"AcquisitionMode=(Episodic Stimulation|Gap Free)"$'), '文件格式错误');

% 识别:   ["SignalsExported=AI0,AI1"]
while ~fun_match(fline, '^"SignalsExported=(.+)"$')
    fline=fgetl(fid); lineNum = lineNum + 1;
    assert(fun_notEOF(fline));
end
str = regexprep(fline, '^"SignalsExported=(.+)"$', '$1');
channames = strsplit(str,',');
nchan = length(channames);
ntrial = (ncol-1) / nchan;
assert(nchan>=1 && ceil(ntrial)==ntrial);

% 识别:   ["Signals="	"AI0"	"AI1"	"AI0"	"AI1"	"AI0"	"AI1"]
while ~fun_match(fline, '^"Signals="(.+)$')
    fline=fgetl(fid); lineNum = lineNum + 1;
    assert(fun_notEOF(fline));
end
str = regexprep(fline, '^"Signals="(.+)$', '$1');
str_tempsign = '';
for i=1:nchan
    str_temp = sprintf('\t"%s"', channames{i});
    str_tempsign = [str_tempsign, str_temp];
end
str2 = repmat(str_tempsign, 1, ntrial);
assert(isequal(str, str2));

% 识别:   ["Time (s)"	"Trace #1 (mV)"	"Trace #1 (V)"	"Trace #2 (mV)"	"Trace #2 (V)"	"Trace #3 (mV)"	"Trace #3 (V)"]
while ~fun_match(fline, '^"Time \(s\)"(.+)$')
    fline=fgetl(fid); lineNum = lineNum + 1;
    assert(fun_notEOF(fline));
end
str = regexprep(fline, '^"Time \(s\)"(.+)$', '$1');
str_cell = strsplit(str, '\t');
chanunits = cell(nchan, 1);
for i= 1:nchan
    str_temp = str_cell{i+1};
    assert(~isempty(regexp(str_temp, '^"Trace #1 \((.*)\)"$', 'match')));
    chanunits{i} = regexprep(str_temp, '^"Trace #1 \((.*)\)"$', '$1');
end
str_temptrac = '';
for itrial = 1:ntrial
    for ichan = 1:nchan
        tempstr = sprintf('\t"Trace #%d (%s)"', itrial, chanunits{ichan});
        str_temptrac = [str_temptrac, tempstr];
    end
end
assert(isequal(str, str_temptrac));

% 输出信息
fclose(fid);
headerlinesIn = lineNum;
chaninfo = struct();
chaninfo.channames = channames;
chaninfo.chanunits = chanunits;

fprintf('文件信息: %d sweep \n', ntrial);
for i=1:nchan
     fprintf('[%.0f]:\t%s (%s)\n', i, channames{i}, chanunits{i});
end