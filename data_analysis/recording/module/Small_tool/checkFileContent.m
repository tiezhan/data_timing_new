function checkFileContent(pfname, var_cell)
% �˶�MAT�ļ��Ƿ�����˱�Ҫ�ı���
% function checkFileContent(pfname, var_cell)
%----Input ����---------
% pfname         :  MAT�ļ�
% var_cell       :  ��������ı���, cell of string
%
%----Output ����---------
% ��

    vars1 = who('-file', pfname);
    [~,f,ext] = fileparts(pfname);
    fname = [f, ext];
    
    assert( all(ismember(var_cell, vars1)), ...
            sprintf('�˶��ļ�����: %s\n', fname));
end