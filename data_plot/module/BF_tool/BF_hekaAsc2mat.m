function pfmat = BF_hekaAsc2mat(pfnames)
%转化 .asc(Haka File) 为 .mat。 可同时转化多个。
%function BF_hekaAsc2mat(pfnames)
%----Input 参数---------
% pfnames    : asc文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Output 文件---------
% data  : 1D nsample, UNCHECKED
%       : 2D nsample_by_nchan, UNCHECKED
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string
%         : chanunits, cell of string
%
%----Example-------------
%BF_hekaAsc2mat(); %弹出对话框

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.asc');
end
pfmat = cell(size(pfnames));
for i=1:length(pfnames)
    pfmat{i} = trans(pfnames{i});
end

%% translate each file
function pfnew = trans(pf)
[p, f, ~] = fileparts(pf);
pfnew = fullfile(p, [f,'_asc.mat']);
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '_asc.mat');
    return;
end
[chaninfo, Fs, nchan, nsample, nsweep, sp] = readhead(pf);
dat3D = readbody(pf, nchan, nsample, nsweep, sp);
[dat3D, chaninfo] = updateunit(dat3D, chaninfo);
MAT = struct();
MAT.Fs = Fs;
MAT.data = dat3D;
MAT.chaninfo = chaninfo;
save(pfnew, '-struct', 'MAT');
fprintf('Finish!\n');

%% readhead
function [chaninfo, Fs, nchan, nsample, nsweep, sp] = readhead(pf)
fid = fopen(pf, 'r');
fun_match  = @(str, expr)ischar(str)&&~isempty(regexp(str, expr, 'match'));

% 开始读取
% 验证开头
fline=fgetl(fid);
assert(fun_match(fline, '^Series_.+'), '文件格式错误');
fline=fgetl(fid);
assert(fun_match(fline, '^Sweep_.+'), '文件格式错误');
fline=fgetl(fid);
assert(fun_match(fline, '^"Index".+'), '文件格式错误');

% 识别通道信息
sp = fline(8);
sp_str = ['%f',sp];
str1 = regexprep(fline, '[ |\t|,]', '');
str2 = regexprep(str1, '""', '|');
str3 = regexprep(str2, '"', '');
items = strsplit(str3, '|');
assert(strcmp(items{1}, 'Index'), '文件格式错误');
assert(strcmp(items{2}, 'Time[s]'), '文件格式错误');
nchan = (length(items)-1)/2;
chaninfo = struct();
chaninfo.channames = cell(1, nchan);
chaninfo.chanunits = cell(1, nchan);
for i=1:nchan
    item = items{1+2*i};
    info = strsplit(item(1:end-1), '[');
    assert(length(info)==2 && ~isempty(info{1}), '通道命名错误');
    assert(strcmp(info{2}, 'V')||strcmp(info{2}, 'A'), '通道单位错误');
    chaninfo.channames{i} = info{1};
    chaninfo.chanunits{i} = info{2};
end

% 识别采样率
fline=fgetl(fid);
v1 = sscanf(fline, sp_str);
fline=fgetl(fid);
v2 = sscanf(fline, sp_str);
Fs = 1/(v2(2)-v1(2));

% 识别每次采样点数
nsample = 2;
while ~isempty(fgetl(fid))
    nsample = nsample+1;
end

% 识别sweep数
nsweep = 1;
while ~feof(fid)
    fline = fgetl(fid);
    if ~isempty(fline) && fline(1)=='S'
        nsweep = nsweep+1;
    end
end

fclose(fid);

%% readbody
function dat3D = readbody(pf, nchan, nsample, nsweep, sp)
fid = fopen(pf, 'r');
dat3D = zeros(nsample, nchan, nsweep);
fun_match  = @(str, expr)ischar(str)&&~isempty(regexp(str, expr, 'match'));
sp_str = ['%f',sp];

for isweep = 1:nsweep
    fgetl(fid);
    fgetl(fid);
    assert(fun_match(fgetl(fid), '^"Index".+'), '文件格式错误');
    for isample = 1:nsample
        A = sscanf(fgetl(fid), sp_str);
        dat3D(isample, :, isweep) = A(3:2:end);
    end
end

%% unit V-mV   A-pA
function [dat3D, chaninfo] = updateunit(dat3D, chaninfo)
nchan = length(chaninfo.chanunits);
for i=1:nchan
    unit = chaninfo.chanunits{i};
    switch unit
        case 'V'
            chaninfo.chanunits{i} = 'mV';
            dat3D(:, i, :) = dat3D(:, i, :) * 1e3;
        case 'A'
            chaninfo.chanunits{i} = 'pA';
            dat3D(:, i, :) = dat3D(:, i, :) * 1e12;
        otherwise
            error('');
    end
end