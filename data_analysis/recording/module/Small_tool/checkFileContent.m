function checkFileContent(pfname, var_cell)
% 核对MAT文件是否包含了必要的变量
% function checkFileContent(pfname, var_cell)
%----Input 参数---------
% pfname         :  MAT文件
% var_cell       :  必须包含的变量, cell of string
%
%----Output 参数---------
% 无

    vars1 = who('-file', pfname);
    [~,f,ext] = fileparts(pfname);
    fname = [f, ext];
    
    assert( all(ismember(var_cell, vars1)), ...
            sprintf('核对文件错误: %s\n', fname));
end