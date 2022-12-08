function mypublish(mfile)
% 代替 publish() 函数，用来制作帮助文档。
% './a_help.m' 文档存放于'../html/a.html'。
%
% function mypublish(mfile)
%  ---------------------------Input---------------------------
% mfile    : 要转化的m文件，缺省则用对话框选择
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
fn2 = regexprep(fn, '_help$', ''); %丢弃最后的 '_help'
namepre  = fullfile(outputDir, [fn,'.html']);
namepost = fullfile(outputDir, [fn2,'.html']);
movefile(namepre, namepost);
web(fullfile(outputDir, [fn2,'.html']));
     