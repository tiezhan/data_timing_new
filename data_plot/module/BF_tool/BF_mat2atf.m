function pfouts = BF_mat2atf(pfnames)
%转化 mat 文件(多种格式内容)为 .atf。 可同时转化多个。
%function BF_mat2atf(pfnames)
%----Input 参数---------
% pfnames    : mat文件路径, 可省略
%
%----Output 参数---------
% pfouts     : atf文件路径，cell类型
%
%----Input  文件---------
% data  : 1D nsample
%       : 2D nsample_by_nchan
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string
%         : chanunits, cell of string
%
%----Example-------------
%BF_mat2atf(); %弹出对话框

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.mat');
end
pfouts = cell(size(pfnames));
for i=1:length(pfnames)
    pfouts{i} = trans(pfnames{i});
end

%% translate each file
function pfnew = trans(pf)
[~, f, ~] = fileparts(pf);
pfnew = regexprep(pf, '\.mat$', '_mat.atf');
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '_mat.atf');
    return;
end

% matfile type swith
% dat3D      : nchan_by_nsample_by_ntrial
vars_type1 = {'data', 'Fs'};
vars_type2 = '^Trace_.*_(\d+)_(\d+)$';
varnames = who('-file', pf);
if all(ismember(vars_type1, varnames))
    [dat3D, Fs, chaninfo] = matfile_1(pf);
else 
    cell_flag = regexpi(varnames, vars_type2);
    if ~isempty( [cell_flag{:}] )
        [dat3D, Fs, chaninfo] = matfile_2(pf);
    else
        error('File Content error');
    end
end
data2atf(dat3D, Fs, pfnew, chaninfo);

%% MAT 数据格式1
% data  : 1y or nchan_nsample_ntrial
% Fs    : num
% chaninfo: 结构体, 可有可无, 包含{'channames', 'chanunits'}
function [dat3D, Fs, chaninfo] = matfile_1(pf)

MAT = load(pf, '-mat');
data = MAT.data;
Fs   = MAT.Fs;
if ~isfield(MAT, 'chaninfo')
    chaninfo = struct();
else
    chaninfo = MAT.chaninfo;
end

dims = size(data);
switch length(dims)
    case 2
        if dims(1)==1;  data=data'; end
        dat3D = data;
    case 3
        dat3D = data;
    otherwise
        error('MAT文件中的 data 数据尺度错误！');
end

%% MAT 数据格式2
% Trace_*_itial_ichan : 2y 
% chaninfo: 结构体, 可有可无, 包含{'channames', 'chanunits'}
function [dat3D, Fs, chaninfo] = matfile_2(pf)

dat3D = zeros(0,0,0);
varnames = who('-file', pf);
MAT = load(pf, '-mat');
Fs = [];
if ~isfield(MAT, 'chaninfo')
    chaninfo = struct();
else
    chaninfo = MAT.chaninfo;
end


for i=1:length(varnames)
    expression='^Trace_.*_(\d+)_(\d+)$';
    ind = regexpi(varnames{i},expression);
    if isempty(ind); continue; end
    
    itrial = str2double(regexprep(varnames{i}, expression, '$1'));
    ichan = str2double(regexprep(varnames{i}, expression, '$2'));
    assert(~isnan(itrial) && ~isnan(ichan));
    
    temp = MAT.(varnames{i});
    tempWave = temp(:,2); %1y
    if isempty(Fs)
        ytime = temp(:,1); %1y
        xtick = (1:length(ytime))'; %1y
        p=polyfit(xtick,ytime,1);
        Fs=1/p(1);
    end
    
    dat3D(ichan, :, itrial) = tempWave;
end


%% 将数据制作为 Axona Text File 文件
function data2atf(dat3D, Fs, outtxt, chaninfo)
% 将数据制作为 Axona Text File 文件.
% function BF_data2atf(dat3D, Fs, outtxt)
% ---------------INPUT 参数--------------
% dat3D : 1D nsample
%       : 2D nchan_by_nsample
%       : 3D nchan_by_nsample_by_ntrial
% Fs    : simple rate
% outtxt: 'abc.atf', 可有可无
% chaninfo: 可有可无
%         : channames, cell of string
%         : chanunits, cell of string
%
% ---------------OUTPUT 文件--------------
% outtxt "A.atf"

    %% 参数补足
    if ~exist('outtxt', 'var')
        outtxt = 'A.atf';
    end
    if ~exist('chaninfo', 'var')
        chaninfo = struct();
    end
    
    %% 修正dat3D
    dims = size(dat3D);
    switch length(dims)
        case 2
            dat = permute(dat3D, [1, 2, 3]);
            if dims(2) == 1; dat = dat'; end
        case 3
            dat = dat3D;
        otherwise
            error('dat3D');
    end
    
    [nsample, nchan, ntrial] = size(dat);
    assert(nchan>=1 && nchan <= 100);
    assert(nsample>100);
    assert(ntrial>=1 && ntrial <= 100);
    
    chaninfo = updateinfo(chaninfo, nchan);namesstr = chaninfo.channames;
    [unitsstr, dat] = calUnits(dat, chaninfo);      %dat 单位变换
    %% 打印信息
    fprintf('--------文件信息--------\n');
    fprintf('通道\t:\t%.0f\n', nchan);
    fprintf('时长\t:\t%.2f (sec)\n', nsample / Fs);
    fprintf('Trial\t:\t%.0f\n', ntrial);
    fprintf('\n 导出文件 %s ......\n', outtxt);
    
    %% file head
    fid = fopen(outtxt, 'w');
    fprintf(fid, 'ATF\t1.0\n');
    fprintf(fid, '8\t%.0f\n', nchan*ntrial+1);
    fprintf(fid, '"AcquisitionMode=Episodic Stimulation"\n');
    fprintf(fid, '"Comment="\n');
    fprintf(fid, '"YTop=20000,10"\n');
    fprintf(fid, '"YBottom=-20000,-10"\n');
    fprintf(fid, '"SyncTimeUnits=5"\n');
    str_temptime = sprintf('%d,', zeros(1, ntrial)); str_temptime(end) = [];
    fprintf(fid, '"SweepStartTimesM=%s"\n', str_temptime);
    
    str_tempchan = '';
    for ichan = 1:nchan
        tempstr = sprintf('%s,', namesstr{ichan});
        str_tempchan = [str_tempchan, tempstr];
    end
    str_tempchan(end) = [];
    fprintf(fid, '"SignalsExported=%s"\n', str_tempchan);
    
    str_tempsign = '';
    for ichan = 1:nchan
        tempstr = sprintf('"%s"\t', namesstr{ichan});
        str_tempsign = [str_tempsign, tempstr];
    end
    str_tempsign = repmat(str_tempsign, 1, ntrial); str_tempsign(end) = [];
    fprintf(fid, '"Signals="\t%s\n', str_tempsign);
    
    str_temptrac = '';
    for itrial = 1:ntrial
        for ichan = 1:nchan
            tempstr = sprintf('"Trace #%d (%s)"\t', itrial, unitsstr{ichan});
            str_temptrac = [str_temptrac, tempstr];
        end
    end
    str_temptrac(end) = [];
    fprintf(fid, '"Time (s)"\t%s\n', str_temptrac);
    fclose(fid); %临时关闭
    
    %% 转化为二维矩阵, [Time, chan1_trial1, c2_t1, c3_t1,..c1_t2, ...cEnd_tEnd]
    ttick = (0:nsample-1)'/Fs;  %time tick
    dat2 = reshape(dat, nsample, nchan*ntrial);
    dat2 = [ttick, dat2];
    
    %% 写入矩阵
    dlmwrite(outtxt,dat2,'-append','delimiter','\t','precision',7);
    disp('导出文件成功');


function info = updateinfo(info, nchan)
    if ~isfield(info, 'channames')
        info.channames{nchan} = [];
    end
    if ~isfield(info, 'chanunits')
        info.chanunits{nchan} = [];
    end
    for i=1:nchan
        if isempty(info.channames{i})
            info.channames{i} = sprintf('Chan %.0f', i);
        end
    end


function [unitsstr, dat3Dunited] = calUnits(dat3D, chaninfo)
    [~, nchan, ~] = size(dat3D);
    dat3Dunited = dat3D;
    unitsstr = cell(nchan, 1);
    for i=1:nchan
        chaninfo_unit = chaninfo.chanunits{i};
        if isempty(chaninfo_unit)
            [unitsstr{i}, dat3Dunited(i,:,:)] =  calUnit(dat3D(i,:,:));
        else
            unitsstr{i} = chaninfo_unit;
        end
    end


function [unitstr, dataunited] = calUnit(data)
    max_d = max(abs(data(:)));
    scale = [1e3, 1, 1e-3, 1e-6, 1e-9, 1e-12];
    units = {'kX','X','mX','uX', 'nX','pX'};
    ind = find( max_d - scale > 0, 1, 'first');
    if isempty(ind); ind = length(scale); end
    
    unitstr = units{ind};
    dataunited = data / scale(ind);
