function addLilabPath(varargin)
% function addLilabPath(varargin)
% 添加lilab下某个文件夹到搜索目录 (临时)
% ---------------EXAMPLE---------------
% addLilabPath('CuiTY', 'PLXrecoder', 'Plx_Cite');
% addLilabPath('CuiTY/PLXrecoder/Plx_Cite');

%lilabpath ../../
if nargin == 1; return; end
this_path  = mfilename('fullpath');
lilab_path = fileparts(fileparts(fileparts(this_path))); %cd ../../
target_path = fullfile(lilab_path, varargin{:});
addpath(target_path);