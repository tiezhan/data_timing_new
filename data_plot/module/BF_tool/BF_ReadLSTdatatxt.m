function varargout=BF_ReadLSTdatatxt(txtpatch,varargin)
%function varargout=ReadLSTdatatxt(txtpatch,varargin)
%
%[lstlick,lstlight,lstpump,lstair,lsttone]=ReadLSTdatatxt('c:\5.txt','INPUT3','OUTPUT1','OUTPUT2','OUTPUT3','OUTPUT4');
%输入的参数一个也不能省，与LabState的输出 严格保持一致。
%输出的参数，与输入的参数严格一一对应。
%
%错误输入：“INPUT3    ” ，包含空格
%文件拷贝自 LabState或Excel，保存到txt中。如果读取出错txt另存为ansi格式。
%2015-8-22 陈昕枫 BaseFrame


	fidin=fopen(txtpatch);                               % 打开LabState数据.txt文件             

    for i=1:length(varargin)
		tline=fgetl(fidin);
		varargout{i}=strWhTit2num(tline, varargin{i});	
	end


fclose(fidin);

end %end function

function [dataline]=strWhTit2num(strline,strtitle)
	a=strfind(strline,strtitle);
	if	~isempty(a)%如果找到了该字符串 a应该=1
		b=length(strtitle); 
		strline([a:b])=[];
		dataline=str2num(strline);
	else	
		dataline=[];
    end
	
end