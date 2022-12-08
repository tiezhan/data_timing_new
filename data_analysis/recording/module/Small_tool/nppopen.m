%使用 Notepad++ 来open; 只支持平台Windows
function nppopen(file)
%%notepadplusplus
%   Notepad++.exe 全路径 ('D:\L_Notepad++\notepad++.exe')
%%pfname
%   file 全路径,或在搜索路径下。
%%How to use
%   >>nppopen('plot')               %在搜索目录下
%   >>nppopen('E:\test\Mcode.m')    %不在搜索目录下
%   >>nppopen                       %不打开文件，运行Npp
%%Careful
%	错误：物理文件没有后缀名

%2016-2-17 陈昕枫
%2016-3-4 修正路径不能有空格的bug
%2016-3-7 cmd命令加上"&"符号，使得程序在后台

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
    %%   Notepad++.exe
    try 
        % 利用注册表
        npp_path=winqueryreg( 'HKEY_LOCAL_MACHINE','SOFTWARE\Wow6432Node\Notepad++');
        notepadplusplus=fullfile(npp_path,'notepad++.exe');
    catch
        error('该计算机没安装Notepad++，请先下载( https://notepad-plus-plus.org/ ). ');
    end
    %%  cmd命令
    command=['"',notepadplusplus,'" "',pfname,'" &'];%路径可能会有空格，所以用""号把路径括起来
    system(command);
end
