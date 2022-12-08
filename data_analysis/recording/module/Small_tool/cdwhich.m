function pname = cdwhich(filename)
%cd到which下的目录
%function pname = cdwhich(filename)
%-----------------Input------------------
% filename :   文件名，cd到该目录下.
% (若缺损)  :  执行undo, 撤销cdwhich.
%
%-----------------Output-----------------
% pname     :  cd之后的“当前目录”
%
%@陈昕枫，2016-7-14
    persistent perpath;
    if isempty(perpath);perpath = cd;end
    if ~exist('filename','var') 
        %参数[], 返回之前的
        lastpath = cd;
        cd(perpath);
        perpath = lastpath;
    else
        %切换到filename的路径
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