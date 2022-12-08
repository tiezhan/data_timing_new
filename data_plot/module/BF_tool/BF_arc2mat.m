function pfmats = BF_arc2mat(pfnames)
% ת�� ArControl .txt �ļ�Ϊ .mat�� ��ͬʱת�������
%function BF_arc2mat(pfnames)
%----Input ����---------
% pfnames    : daq�ļ�·��, ��ʡ��
%
%----Output ����---------
% pfmats     : mat�ļ�·����cell����
%
%----Example-------------
%BF_arc2mat(); %�����Ի���

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.txt');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames);
    pfmats{i} = trans(pfnames{i});
end

%%
function pfnew = trans(pf)
[~, f, ~] = fileparts(pf);
pfnew = regexprep(pf, '\.txt$', '_arc.mat');
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '.mat');
    return;
end
MAT = struct();
fid = fopen(pf);
frewind(fid); %to the begin of file;
expression = '^(IN\d+|OUT\d+|C\d+S\d+):(\w.*)$';
while ~feof(fid)
    str=fgetl(fid);
    if isequal(str, -1); return; end;
    if regexp(str,expression,'once')
        Style = regexprep(str,expression,'$1');
        Nums = regexprep(str,expression,'$2');
        if ~isfield(MAT,Style); MAT.(Style)=[]; end
        MAT.(Style) = [MAT.(Style);str2num(Nums)]; %#ok<ST2NM>
     end
end
fclose(fid);
save(pfnew, '-struct', 'MAT');