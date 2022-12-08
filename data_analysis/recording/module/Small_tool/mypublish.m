function mypublish(mfile)
% ���� publish() �������������������ĵ���
% './a_help.m' �ĵ������'../html/a.html'��
%
% function mypublish(mfile)
%  ---------------------------Input---------------------------
% mfile    : Ҫת����m�ļ���ȱʡ���öԻ���ѡ��
if nargin==0
    [fn ,pn] = uigetfile('*.m', 'File Selector');
    if fn==0; return;end
    mfile = [pn, fn];
end
mfile = which(mfile);
[pn, fn, etc] = fileparts(mfile);
assert(strcmpi(etc,'.m'), 'Should be M-File!');
outputDir = fullfile(pn, '..', 'html'); % ../html
option = struct('outputDir',outputDir, ...
                'catchError',true,...
                'imageFormat','jpeg',...
                'createThumbnail',false,...
                'maxHeight',800,...
                'maxWidth', 500);
publish(mfile, option);
fn2 = regexprep(fn, '_help$', ''); %�������� '_help'
namepre  = fullfile(outputDir, [fn,'.html']);
namepost = fullfile(outputDir, [fn2,'.html']);
movefile(namepre, namepost);
web(fullfile(outputDir, [fn2,'.html']));
     