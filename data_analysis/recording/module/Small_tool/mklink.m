%function mklink(op='/j', old, new)
%运用windows平台，创建"文件/文件夹"的替身（高级快捷方式）
%
%mklink                 %/j 方式，文件夹替身
%mklink /h              %/h 方式，文件替身
%mklink /d ./data_old   %/d 方式，文件夹替身
%mklink /d ./data_old  ./data_new
%
%/j /d ： 针对文件夹，推荐'/j'
%/h    :  针对文件，必须同一磁盘符
%
%
%2017-3-8，陈昕枫
function mklink(op, old, new)
    %%提取3个参数
    switch nargin
        case 0
            op =adjust_op('/j'); %文件夹，matlab支持的格式
            old= uigetpf(op,'old');
            if old==0;return;end       
        case 1
            op = adjust_op(op);
            old= uigetpf(op,'old');
            if old==0;return;end
        case 2    
            op = adjust_op(op);
        case 3
            op = adjust_op(op);
    end
    %% 在当前目录下创建link 或创建指定link
    if exist('new', 'var') %创建指定link
        root_new = [new,filesep,'..'];
        if isempty(dir(root_new));%递归创建顶层目录
            mkdir([new,filesep,'..']); 
        end
        dir_new = dir(new);
        if ~isempty(dir_new) %则删除
            if any([dir_new.isdir])
                rmdir(new)
            else
                delete(new)
            end
        end
    else %在当前目录下创建link
        [~, fOld, extOld] = fileparts(old);
        fNew = [fOld, '_link'];
        new = fullfile(pwd, [fNew, extOld]);
        i = 0;
        while exist(new, 'file')
            i=i+1; assert(i<10, 'ERR');
            new = fullfile(pwd, [fNew, '(',num2str(i),')',extOld]);
        end
    end
    
    %% 执行cmd命令，windows-only
    command = sprintf('mklink %s "%s" "%s"',op,new,old);
    system(command);    
end

%ui 载入文件(/夹)对话框
function  pfname = uigetpf(op,model)
    switch op
        case '/h'
            if strcmp(model,'old')
                [f,p]=uigetfile('*.*','site Old File');
                if f==0;pfname=0;return;end
            else
                [f,p]=uiputfile('*.*','generate New File');
                if f==0;pfname=0;return;end
            end
            pfname=[p,f];
        case {'/j','/d'}
            if strcmp(model,'old')
                pfname=uigetdir('.','site Old Folder');
            else
                pfname=uigetdir('.','generate New Folder');
                if pfname==0;return;end
                if length(dir(pfname))>2;error('New Folder must be empty');end
            end            
    end
end

%纠正操作符 /j /d /h
function op_new = adjust_op(op)
    op2 = lower(op);
    switch op2
        case {'j','\j','/j'}
            op_new='/j';
        case {'d','\d','/d'}
            op_new='/d';
        case {'h','\h','/h'}
            op_new='/h';
        otherwise
            error('Operator should be ''j'',''d'',''h''!')
    end
end
