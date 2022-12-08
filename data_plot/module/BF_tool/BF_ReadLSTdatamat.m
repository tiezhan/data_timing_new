function varargout=BF_ReadLSTdatamat(matfilename,varargin)
%function varargout=ReadLSTdatamat(matfilename,varargin)
%[lsttone,C1S3]=ReadLSTdatamat( BF_textfilter('5.zdata.txt'),'IN3','C1S3')
%依赖于BF_textfilter
%
%2015-9-11 陈昕枫?BaseFrame
%2015-9-20 只输出第一列

	MAT = load(matfilename); 
    varargout = cell(size(varargin));
    for i=1:length(varargin)
        if ~isfield(MAT, varargin{i});
            varargout{i} =[];
        else
            varargout{i} = MAT.(varargin{i});
        end
        if ~isempty(varargout{i})
            varargout{i} = varargout{i}(:,1);
        end
    end

end %end function

