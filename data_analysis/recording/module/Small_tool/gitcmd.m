function gitcmd
%命令, 在“命令行”中进入git-cmd。
%需要windows平台，并指定git-bash目录为'D:\L_git\git-cmd.exe'
    gitbash_path = 'D:\L_git\git-cmd.exe';
    command = ['"',gitbash_path, '"'];
    system(command);
end