function addgenpathBut(varargin)
%添加pwd(包含子文件夹)到搜索路径中，但排除某些子文件夹
%function addgenpathBut(varargin)
%
%----------------------Input-----------------------------
% varargin  :  Root folders to ignore with its' subfolders
%              Case sensitivity.
%              Wildcard character unsupported.
%
%EXAMPLE :
% %% default: ignore '.git' and '.svn' in any folder;
% addgenpathBut; 
%
% %% besides, ignore './dataSample'
% addgenpathBut('dataSample'); 
%
% %% besides, ignore './dataSample' & './test'
% addgenpathBut('dataSample', 'test');
    
    %% defauts: '.git', '.svn'
    pwd_str = pwd;
    gen_str = genpath(pwd_str);
    pwd_regstr = regexptranslate('escape', pwd_str);
    filesep_regstr = regexptranslate('escape', filesep);
    ignore_regstr = [pwd_regstr, filesep_regstr, '[^;]*\.(git|svn)[^;]*;'];
    gen_newstr = regexprep(gen_str, ignore_regstr, '');
    
    %% extra : varargin
    for item = varargin
        folder = item{1};
        folder_full = regexptranslate('escape',[pwd_str,filesep,folder]);
        ignore_regstr = [folder_full, '(?=;|\\|/)[^;]*;']; %ignored deeply
        gen_newstr = regexprep(gen_newstr, ignore_regstr, '');
    end
    
    %% addpath
    addpath(gen_newstr);