%ʹ�� Notepad++ ��open; ֻ֧��ƽ̨Windows
function nppopen(file)
%%notepadplusplus
%   Notepad++.exe ȫ·�� ('D:\L_Notepad++\notepad++.exe')
%%pfname
%   file ȫ·��,��������·���¡�
%%How to use
%   >>nppopen('plot')               %������Ŀ¼��
%   >>nppopen('E:\test\Mcode.m')    %��������Ŀ¼��
%   >>nppopen                       %�����ļ�������Npp
%%Careful
%	���������ļ�û�к�׺��

%2016-2-17 ��꿷�
%2016-3-4 ����·�������пո��bug
%2016-3-7 cmd�������"&"���ţ�ʹ�ó����ں�̨

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
    %%   Notepad++.exe
    try 
        % ����ע���
        npp_path=winqueryreg( 'HKEY_LOCAL_MACHINE','SOFTWARE\Wow6432Node\Notepad++');
        notepadplusplus=fullfile(npp_path,'notepad++.exe');
    catch
        error('�ü����û��װNotepad++����������( https://notepad-plus-plus.org/ ). ');
    end
    %%  cmd����
    command=['"',notepadplusplus,'" "',pfname,'" &'];%·�����ܻ��пո�������""�Ű�·��������
    system(command);
end
