function pfmats = BF_arc2mat(pfnames)
% 转化 ArControl .txt 文件为 .mat。 可同时转化多个。
%function BF_arc2mat(pfnames)
%----Input 参数---------
% pfnames    : daq文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Example-------------
%BF_arc2mat(); %弹出对话框

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