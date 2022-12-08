function pfmats = BF_h5_to_mat(pfnames)
%转化 h5 文件(wavesurfer)为 .mat。 可同时转化多个。
%function BF_h5_to_mat(pfnames)
%----Input 参数---------
% pfnames    : mat文件路径, 可省略
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
%BF_h5_to_abf(); %弹出对话框

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.h5');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames)
    pfmats{i} = trans(pfnames{i});
end

%% translate each file
function pfnew = trans(pf)
[p, f, ~] = fileparts(pf);
pfnew = fullfile(p, [f,'_h5.mat']);
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '_h5.mat');
    return;
end

% matfile type swith
% dat3D      : nchan_by_nsample_by_ntrial
MAT = struct();
[MAT.data, MAT.Fs, MAT.chaninfo] = readH5(pf);
save(pfnew, '-struct', 'MAT');

%% 读取h5
function [dat3D, Fs, chaninfo] = readH5(pfname_H5)
Fs = h5read(pfname_H5,'/header/Acquisition/SampleRate');
sweepduration=h5read(pfname_H5,'/header/SweepDuration'); %单个sweep时长,单位s
sweepscale=h5read(pfname_H5,'/header/Acquisition/AnalogChannelScales'); %尺度
chanunits=h5read(pfname_H5,'/header/Acquisition/AnalogChannelUnits');  %乘以尺度后单位
nsweep=h5read(pfname_H5,'/header/NSweepsPerRun'); %sweep个数
channames = h5read(pfname_H5,'/header/Acquisition/AnalogChannelNames');
info=h5info(pfname_H5,'/');
names={info.Groups.Name};
issweep = regexp(names,'/sweep_\d+');
indsweep= cellfun( @(x)~isempty(x), issweep);
namesweep=names(indsweep);
sortsweep=sort(namesweep);
  
% 核对信息
assert(~isempty(sortsweep), '没有sweep，数据错误');
assert(length(sortsweep)==nsweep, '没有sweep，数据错误');
data=h5read(pfname_H5,[sortsweep{1},'/analogScans']);
[nsample, nchan] = size(data);
assert(length(channames) == nchan && length(chanunits) == nchan, '数据文件损坏--通道数不一!');

fprintf('文件信息: %dsweep  * %0.fsec = %0.fsec \n', ...
        nsweep, sweepduration, nsweep*sweepduration);
for i=1:nchan
     fprintf('[%.0f]:\t%s (%s)\n', i, channames{i}, chanunits{i});
end

% dat3D
dat3D = zeros(nsample, nchan, nsweep);
for i=1:nsweep
    data_1 = h5read(pfname_H5,[sortsweep{i},'/analogScans']);
    data_2 = double(data_1) * diag(sweepscale);
    dat3D(:,:,i) = data_2;
end

% chaninfo
chaninfo = struct();
chaninfo.channames = channames;
chaninfo.chanunits = chanunits;