function pfmat = BF_hekaAsc2mat(pfnames)
%ת�� .asc(Haka File) Ϊ .mat�� ��ͬʱת�������
%function BF_hekaAsc2mat(pfnames)
%----Input ����---------
% pfnames    : asc�ļ�·��, ��ʡ��
%
%----Output ����---------
% pfmats     : mat�ļ�·����cell����
%
%----Output �ļ�---------
% data  : 1D nsample, UNCHECKED
%       : 2D nsample_by_nchan, UNCHECKED
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string
%         : chanunits, cell of string
%
%----Example-------------
%BF_hekaAsc2mat(); %�����Ի���

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

% ��ʼ��ȡ
% ��֤��ͷ
fline=fgetl(fid);
assert(fun_match(fline, '^Series_.+'), '�ļ���ʽ����');
fline=fgetl(fid);
assert(fun_match(fline, '^Sweep_.+'), '�ļ���ʽ����');
fline=fgetl(fid);
assert(fun_match(fline, '^"Index".+'), '�ļ���ʽ����');

% ʶ��ͨ����Ϣ
sp = fline(8);
sp_str = ['%f',sp];
str1 = regexprep(fline, '[ |\t|,]', '');
str2 = regexprep(str1, '""', '|');
str3 = regexprep(str2, '"', '');
items = strsplit(str3, '|');
assert(strcmp(items{1}, 'Index'), '�ļ���ʽ����');
assert(strcmp(items{2}, 'Time[s]'), '�ļ���ʽ����');
nchan = (length(items)-1)/2;
chaninfo = struct();
chaninfo.channames = cell(1, nchan);
chaninfo.chanunits = cell(1, nchan);
for i=1:nchan
    item = items{1+2*i};
    info = strsplit(item(1:end-1), '[');
    assert(length(info)==2 && ~isempty(info{1}), 'ͨ����������');
    assert(strcmp(info{2}, 'V')||strcmp(info{2}, 'A'), 'ͨ����λ����');
    chaninfo.channames{i} = info{1};
    chaninfo.chanunits{i} = info{2};
end

% ʶ�������
fline=fgetl(fid);
v1 = sscanf(fline, sp_str);
fline=fgetl(fid);
v2 = sscanf(fline, sp_str);
Fs = 1/(v2(2)-v1(2));

% ʶ��ÿ�β�������
nsample = 2;
while ~isempty(fgetl(fid))
    nsample = nsample+1;
end

% ʶ��sweep��
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
    assert(fun_match(fgetl(fid), '^"Index".+'), '�ļ���ʽ����');
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