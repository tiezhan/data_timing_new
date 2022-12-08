function pfname=uigetfilemult(varargin)
%function pfname=uigetfilemult(varargin)
%pfname=uigetfilemult('*.mat;*.txt','load file');
%if isempty(pfname);return;end; %没载入任何文件
%for i=1:length(pfname)
%   disp(pfname{i});
%end
%
%   varargin: uigetfile的输入,不用设定'MultiSelect'
%   pfname: 细胞体,1x向量
%
%
%2016-3-15 陈昕枫，创建
	[fname,pname]=uigetfile(varargin{:},'MultiSelect','on');
	switch class(fname)
		case 'double'%没有载入文件
			pfname={};
			return
		case 'char' %载入一个文件
			pfname={[pname,fname]};
		case 'cell' %载入多个文件
			pfname=cell(size(fname));
			for i=1:length(fname)
				pfname(i)={[pname,fname{i}]};
			end

	end

end
