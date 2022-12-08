%function mklink(op='/j', old, new)
%����windowsƽ̨������"�ļ�/�ļ���"�������߼���ݷ�ʽ��
%
%mklink                 %/j ��ʽ���ļ�������
%mklink /h              %/h ��ʽ���ļ�����
%mklink /d ./data_old   %/d ��ʽ���ļ�������
%mklink /d ./data_old  ./data_new
%
%/j /d �� ����ļ��У��Ƽ�'/j'
%/h    :  ����ļ�������ͬһ���̷�
%
%
%2017-3-8����꿷�
function mklink(op, old, new)
    %%��ȡ3������
    switch nargin
        case 0
            op =adjust_op('/j'); %�ļ��У�matlab֧�ֵĸ�ʽ
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
    %% �ڵ�ǰĿ¼�´���link �򴴽�ָ��link
    if exist('new', 'var') %����ָ��link
        root_new = [new,filesep,'..'];
        if isempty(dir(root_new));%�ݹ鴴������Ŀ¼
            mkdir([new,filesep,'..']); 
        end
        dir_new = dir(new);
        if ~isempty(dir_new) %��ɾ��
            if any([dir_new.isdir])
                rmdir(new)
            else
                delete(new)
            end
        end
    else %�ڵ�ǰĿ¼�´���link
        [~, fOld, extOld] = fileparts(old);
        fNew = [fOld, '_link'];
        new = fullfile(pwd, [fNew, extOld]);
        i = 0;
        while exist(new, 'file')
            i=i+1; assert(i<10, 'ERR');
            new = fullfile(pwd, [fNew, '(',num2str(i),')',extOld]);
        end
    end
    
    %% ִ��cmd���windows-only
    command = sprintf('mklink %s "%s" "%s"',op,new,old);
    system(command);    
end

%ui �����ļ�(/��)�Ի���
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

%���������� /j /d /h
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
