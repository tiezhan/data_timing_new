function matfilename = BF_textfilter( filename,countC,countS)
%function matfilename_str = textfilter( filename_str,countC=4,countS=11)
%BF_textfilter('150910202537.zdat.txt')
%
%2015-9-11 ��Ф BaseFrame
%@:chenxiaouestc@163.com
%2015-9-15 ��꿷� ȫ���Ż�
%2016-4-14 ��꿷� ��������ʽ��������Ż����ܣ������¼��ݣ�
%           ����IN��OUT������ʾ;��
    if ~exist('filename', 'var')
        [f, p] = uigetfile('*.zdat.txt');
        if f==0; return; end;
        filename = [p, f];
        clear p f
    end
    if ~exist('countC','var')
        countC=4;
    end
	if ~exist('countS','var')
        countS=11;
    end
    %% ����Ӳ������
    Info = Gxxx(filename);
    
    %% [IN?] [OUT?] [C?S?]
    Hxxx(filename); %assignin �Զ����ɱ���
    %����
    for i=1:8
        instr=['IN',num2str(i)];
        if ~exist(instr,'var')
            eval([instr,'=[];']);
        end
        instr=['OUT',num2str(i)];
        if ~exist(instr,'var')
            eval([instr,'=[];']);
        end
    end
    for i=1:countC
        for j=1:countS
            instr=['C',num2str(i),'S',num2str(j)];
            if ~exist(instr,'var')
                eval([instr,'=[];']);
            end
        end
    end
    
    %% ����
    matfilename=[regexprep(filename,'\.txt',''),'.mat'];    
	clear countC countS i j str1 str2 cout cell1 temp filename instr   
    disp('��ȡ�ļ��ɹ������ɹ�ת��Ϊmat�ļ�');
	save(matfilename);
end

function Cont = Gxxx(filename)
    fid=fopen(filename);
    Cont=[];
    fline=[];
    Cont.InDevice=cell(8,1);
    Cont.OutDevice = cell(8,1);
    expression = '^(In|Out)(\d+)=(\w+).*';
    while ~feof(fid) && ~strcmp(fline,'[KeyInput]')
        fline=fgetl(fid);
        str=fline;
        if regexp(str,expression,'once')
            Style = regexprep(str,expression,'$1');
            Num = regexprep(str,expression,'$2');
            Label = regexprep(str,expression,'$3');
            switch Style
                case 'In'
                    Cont.InDevice(str2double(Num))={Label};
                case 'Out'
                    Cont.OutDevice(str2double(Num))={Label};
            end
        end
    end 
    fclose all;
end
function Hxxx(filename)
    fid=fopen(filename);
    
    %% [IN?] [OUT?] [C?S?]
    expression='^\[(IN\d+|OUT\d+|C\d+S\d+)\]$';
    while ~feof(fid)  %[C1]
        fline=fgetl(fid);
        str=fline;
        if regexp(str,expression,'once')
            instr=regexprep(str,expression,'$1');
            fgetl(fid);%֮����һ��ʡȥ��
            data=[];
            while (~feof(fid) )
                fline=fgetl(fid);
                if ~strcmp(fline,'-1,0')
                    str2 =fline;
                    str2(strfind(fline,','))='	';%�Ѷ��Ż�����   �����ǳ���Ҫ
                    data=[data;str2num(str2)];
                else
                    assignin('caller',instr,data);
                    break;
                end
            end
        end%end if
    end%next [IN?] [OUT?] [C?S?]
    
        
end