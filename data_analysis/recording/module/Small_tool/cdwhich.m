function pname = cdwhich(filename)
%cd��which�µ�Ŀ¼
%function pname = cdwhich(filename)
%-----------------Input------------------
% filename :   �ļ�����cd����Ŀ¼��.
% (��ȱ��)  :  ִ��undo, ����cdwhich.
%
%-----------------Output-----------------
% pname     :  cd֮��ġ���ǰĿ¼��
%
%@��꿷㣬2016-7-14
    persistent perpath;
    if isempty(perpath);perpath = cd;end
    if ~exist('filename','var') 
        %����[], ����֮ǰ��
        lastpath = cd;
        cd(perpath);
        perpath = lastpath;
    else
        %�л���filename��·��
        pfname = which(filename);
        if isempty(pfname)
            fprintf('''%s'' not found.\n', filename);
        else
            pname = fileparts(pfname);
            perpath = cd;
            cd(pname);
        end
    end
    pname = pwd;
    if nargout==0
        clear pname
    end
end