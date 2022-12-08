function varargout=BF_ReadLSTdatatxt(txtpatch,varargin)
%function varargout=ReadLSTdatatxt(txtpatch,varargin)
%
%[lstlick,lstlight,lstpump,lstair,lsttone]=ReadLSTdatatxt('c:\5.txt','INPUT3','OUTPUT1','OUTPUT2','OUTPUT3','OUTPUT4');
%����Ĳ���һ��Ҳ����ʡ����LabState����� �ϸ񱣳�һ�¡�
%����Ĳ�����������Ĳ����ϸ�һһ��Ӧ��
%
%�������룺��INPUT3    �� �������ո�
%�ļ������� LabState��Excel�����浽txt�С������ȡ����txt���Ϊansi��ʽ��
%2015-8-22 ��꿷� BaseFrame


	fidin=fopen(txtpatch);                               % ��LabState����.txt�ļ�             

    for i=1:length(varargin)
		tline=fgetl(fidin);
		varargout{i}=strWhTit2num(tline, varargin{i});	
	end


fclose(fidin);

end %end function

function [dataline]=strWhTit2num(strline,strtitle)
	a=strfind(strline,strtitle);
	if	~isempty(a)%����ҵ��˸��ַ��� aӦ��=1
		b=length(strtitle); 
		strline([a:b])=[];
		dataline=str2num(strline);
	else	
		dataline=[];
    end
	
end