function pfname=uigetfilemult(varargin)
%function pfname=uigetfilemult(varargin)
%pfname=uigetfilemult('*.mat;*.txt','load file');
%if isempty(pfname);return;end; %û�����κ��ļ�
%for i=1:length(pfname)
%   disp(pfname{i});
%end
%
%   varargin: uigetfile������,�����趨'MultiSelect'
%   pfname: ϸ����,1x����
%
%
%2016-3-15 ��꿷㣬����
	[fname,pname]=uigetfile(varargin{:},'MultiSelect','on');
	switch class(fname)
		case 'double'%û�������ļ�
			pfname={};
			return
		case 'char' %����һ���ļ�
			pfname={[pname,fname]};
		case 'cell' %�������ļ�
			pfname=cell(size(fname));
			for i=1:length(fname)
				pfname(i)={[pname,fname{i}]};
			end

	end

end
