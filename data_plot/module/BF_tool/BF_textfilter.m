function matfilename = BF_textfilter( filename,countC,countS)
%function matfilename_str = textfilter( filename_str,countC=4,countS=11)
%BF_textfilter('150910202537.zdat.txt')
%
%2015-9-11 陈肖 BaseFrame
%@:chenxiaouestc@163.com
%2015-9-15 陈昕枫 全面优化
%2016-4-14 陈昕枫 （正则表达式）极大幅优化性能，并向下兼容；
%           增加IN，OUT名字显示;。
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
    %% 查找硬件别名
    Info = Gxxx(filename);
    
    %% [IN?] [OUT?] [C?S?]
    Hxxx(filename); %assignin 自动生成变量
    %补足
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
    
    %% 保存
    matfilename=[regexprep(filename,'\.txt',''),'.mat'];    
	clear countC countS i j str1 str2 cout cell1 temp filename instr   
    disp('读取文件成功，并成功转化为mat文件');
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
            fgetl(fid);%之间有一行省去。
            data=[];
            while (~feof(fid) )
                fline=fgetl(fid);
                if ~strcmp(fline,'-1,0')
                    str2 =fline;
                    str2(strfind(fline,','))='	';%把逗号换做‘   ’，非常重要
                    data=[data;str2num(str2)];
                else
                    assignin('caller',instr,data);
                    break;
                end
            end
        end%end if
    end%next [IN?] [OUT?] [C?S?]
    
        
end