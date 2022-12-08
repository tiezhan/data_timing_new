function pfmats = BF_h5_to_mat(pfnames)
%ת�� h5 �ļ�(wavesurfer)Ϊ .mat�� ��ͬʱת�������
%function BF_h5_to_mat(pfnames)
%----Input ����---------
% pfnames    : mat�ļ�·��, ��ʡ��
%
%----Output ����---------
% pfmats     : mat�ļ�·����cell����
%
%----Output �ļ�---------
% data  : 1D nsample
%       : 2D nsample_by_nchan
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string
%         : chanunits, cell of string
%
%----Example-------------
%BF_h5_to_abf(); %�����Ի���

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

%% ��ȡh5
function [dat3D, Fs, chaninfo] = readH5(pfname_H5)
Fs = h5read(pfname_H5,'/header/Acquisition/SampleRate');
sweepduration=h5read(pfname_H5,'/header/SweepDuration'); %����sweepʱ��,��λs
sweepscale=h5read(pfname_H5,'/header/Acquisition/AnalogChannelScales'); %�߶�
chanunits=h5read(pfname_H5,'/header/Acquisition/AnalogChannelUnits');  %���Գ߶Ⱥ�λ
nsweep=h5read(pfname_H5,'/header/NSweepsPerRun'); %sweep����
channames = h5read(pfname_H5,'/header/Acquisition/AnalogChannelNames');
info=h5info(pfname_H5,'/');
names={info.Groups.Name};
issweep = regexp(names,'/sweep_\d+');
indsweep= cellfun( @(x)~isempty(x), issweep);
namesweep=names(indsweep);
sortsweep=sort(namesweep);
  
% �˶���Ϣ
assert(~isempty(sortsweep), 'û��sweep�����ݴ���');
assert(length(sortsweep)==nsweep, 'û��sweep�����ݴ���');
data=h5read(pfname_H5,[sortsweep{1},'/analogScans']);
[nsample, nchan] = size(data);
assert(length(channames) == nchan && length(chanunits) == nchan, '�����ļ���--ͨ������һ!');

fprintf('�ļ���Ϣ: %dsweep  * %0.fsec = %0.fsec \n', ...
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