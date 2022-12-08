function pfmats = BF_atf2mat(pfnames)
%ת�� atf �ļ�Ϊ .mat�� ��ͬʱת�������
%function BF_atf2mat(pfnames)
%----Input ����---------
% pfnames    : atf�ļ�·��, ��ʡ��
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
%BF_atf2mat(); %�����Ի���

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

% ��ȡ����
[headerlinesIn, chaninfo, ncol] = readhead(pf); %��ȡ������Ϣ
dataStruct =importdata(pf, '\t', headerlinesIn); %��ȡdata��
dataMatrix = dataStruct.data;
nchan = length(chaninfo.channames);
[nsample, ncol2] = size(dataMatrix);
ntrial = (ncol-1)/nchan;

% У������
assert(nchan>=1, 'ͨ����Ϊ0��,����');
assert(nsample>2, '����̫�� (����̫��)');
assert(ncol == ncol2, '�����ļ���');
assert(ceil(ntrial) == ntrial, 'Sweep�����������');

% ����ת����ʽ
time_s = dataMatrix(:,1);
assert(time_s(1) == 0);
Fs = 1 / (time_s(2) - time_s(1));
dat3D = zeros(nsample, nchan, ntrial);
for i=1:nchan
    ind = (1+i):nchan:ncol;
    dat3D(:,i,:) = permute(dataMatrix(:, ind), [1, 3, 2]);
end

% �����ļ�
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

% ��ʼ��ȡ
% ʶ��:   [ATF	1.0]
fline=fgetl(fid); lineNum = lineNum + 1;
assert(fun_match(fline, '^ATF\t.+'), '�ļ���ʽ����');

% ʶ��:   [8	7] | [7 2]
fline=fgetl(fid); lineNum = lineNum + 1;
assert(fun_match(fline, '^(8|7)\t(\d+)'), '�ļ���ʽ����');
ncol = str2double(regexprep(fline, '^(8|7)\t(\d+)', '$2'));
assert(~isnan(ncol));

% ʶ��:   ["AcquisitionMode=Episodic Stimulation"]
fline=fgetl(fid); lineNum = lineNum + 1;
assert(fun_match(fline, '^"AcquisitionMode=(Episodic Stimulation|Gap Free)"$'), '�ļ���ʽ����');

% ʶ��:   ["SignalsExported=AI0,AI1"]
while ~fun_match(fline, '^"SignalsExported=(.+)"$')
    fline=fgetl(fid); lineNum = lineNum + 1;
    assert(fun_notEOF(fline));
end
str = regexprep(fline, '^"SignalsExported=(.+)"$', '$1');
channames = strsplit(str,',');
nchan = length(channames);
ntrial = (ncol-1) / nchan;
assert(nchan>=1 && ceil(ntrial)==ntrial);

% ʶ��:   ["Signals="	"AI0"	"AI1"	"AI0"	"AI1"	"AI0"	"AI1"]
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

% ʶ��:   ["Time (s)"	"Trace #1 (mV)"	"Trace #1 (V)"	"Trace #2 (mV)"	"Trace #2 (V)"	"Trace #3 (mV)"	"Trace #3 (V)"]
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

% �����Ϣ
fclose(fid);
headerlinesIn = lineNum;
chaninfo = struct();
chaninfo.channames = channames;
chaninfo.chanunits = chanunits;

fprintf('�ļ���Ϣ: %d sweep \n', ntrial);
for i=1:nchan
     fprintf('[%.0f]:\t%s (%s)\n', i, channames{i}, chanunits{i});
end