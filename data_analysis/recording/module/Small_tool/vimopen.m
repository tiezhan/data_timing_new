%ʹ�� Gvim ��open;ֻ֧��ƽ̨Windows;�÷���ȫ��Ч��nppopen
function vimopen(file)
%%notepadplusplus
%   Gvim.exe ȫ·�� ('D:\L_Vim\vim\vim74\gvim.exe')
%%pfname
%   file ȫ·��,��������·���¡�
%%How to use
%   >>vimopen('plot')               %������Ŀ¼��
%   >>vimopen('E:\test\Mcode.m')    %��������Ŀ¼��
%   >>vimopen                       %�����ļ�������Gvim
%%Careful
%	���������ļ�û�к�׺��

%2016-3-1 ��꿷�,����nppopen.m
    %%   file    
    if nargin==1
        if ~exist(file,'file');error(['δ�ҵ��ļ� ''',file,'''��']);end
        if exist(file,'var') %������'file.m'�ļ�,���������Ϊ'file'ʱ,whichʧЧ
            pfname = which('file.m');
        else
            pfname = which(file);
			if isempty(pfname);warning(['�����ļ���Ҫ��׺�� ''',file,'''��']);end
        end
    else
        pfname ='';
    end
    %%   Gvim.exe
    try 
        % ����ע���
        npp_path=winqueryreg( 'HKEY_LOCAL_MACHINE','SOFTWARE\Vim\Gvim','path');
        notepadplusplus=npp_path;
    catch
        notepadplusplus='D:\L_Vim\vim\vim74\gvim.exe';
%         error('�ü����û��װGvim����������( http://www.vim.org/download.php#pc). ');
    end
    %%  cmd����
    command=['"',notepadplusplus,'" --remote-tab-silent "',pfname,'" &'];%�Զ��ǩģʽ��
    system(command);
end