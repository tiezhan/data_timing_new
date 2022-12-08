function pfmats = BF_hekaMat2mat(pfnames)
% 转化 .mat(Haka File) 文件为 .mat。 可同时转化多个。
%function BF_hekaMat2mat(pfnames)
%----Input 参数---------
% pfnames    : mat文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Output 文件---------
% data  : 1D nsample, UNCHECKED
%       : 2D nsample_by_nchan, UNCHECKED
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string, EMPTY
%         : chanunits, cell of string, EMPTY
% time   : 1D nsample as second
%
%----Example-------------
%BF_hekaMat2mat(); %弹出对话框

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.mat');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames)
    pfmats{i} = trans(pfnames{i});
end

function pfnew = trans(pf)
[p, f, ~] = fileparts(pf);
pfnew =  fullfile(p,[f, '_heka.mat']);
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '.mat');
    return;
end
vars_type1 = {'data', 'Fs'};
vars_type2 = '^Trace_.*_(\d+)_(\d+)$';
varnames = who('-file', pf);
if all(ismember(vars_type1, varnames))
    pfnew = pf;
    fprintf('> %s%s\t<Corrected(skip)>\n\n', f, '.mat');
    return;
else
    cell_flag = regexpi(varnames, vars_type2);
    if ~isempty( [cell_flag{:}] )
        [data, Fs, chaninfo] = matfile_2(pf);
    else
        error('File Content error');
    end
end

save(pfnew, 'data','chaninfo','Fs');


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
        Fs=round(1/p(1));
    end
    
    dat3D( :,ichan, itrial) = tempWave;
end