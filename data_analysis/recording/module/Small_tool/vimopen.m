%使用 Gvim 来open;只支持平台Windows;用法完全等效于nppopen
function vimopen(file)
%%notepadplusplus
%   Gvim.exe 全路径 ('D:\L_Vim\vim\vim74\gvim.exe')
%%pfname
%   file 全路径,或在搜索路径下。
%%How to use
%   >>vimopen('plot')               %在搜索目录下
%   >>vimopen('E:\test\Mcode.m')    %不在搜索目录下
%   >>vimopen                       %不打开文件，运行Gvim
%%Careful
%	错误：物理文件没有后缀名

%2016-3-1 陈昕枫,类似nppopen.m
    %%   file    
    if nargin==1
        if ~exist(file,'file');error(['未找到文件 ''',file,'''。']);end
        if exist(file,'var') %当存在'file.m'文件,且输入参数为'file'时,which失效
            pfname = which('file.m');
        else
            pfname = which(file);
			if isempty(pfname);warning(['物理文件需要后缀名 ''',file,'''。']);end
        end
    else
        pfname ='';
    end
    %%   Gvim.exe
    try 
        % 利用注册表
        npp_path=winqueryreg( 'HKEY_LOCAL_MACHINE','SOFTWARE\Vim\Gvim','path');
        notepadplusplus=npp_path;
    catch
        notepadplusplus='D:\L_Vim\vim\vim74\gvim.exe';
%         error('该计算机没安装Gvim，请先下载( http://www.vim.org/download.php#pc). ');
    end
    %%  cmd命令
    command=['"',notepadplusplus,'" --remote-tab-silent "',pfname,'" &'];%以多标签模式打开
    system(command);
end