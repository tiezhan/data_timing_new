function gitbash
%命令, 打开gitbash。
%需要windows平台，并指定git-bash目录为'D:\L_git\git-bash.exe'
    gitbash_path = 'D:\L_git\git-bash.exe';
    command = ['"',gitbash_path, '" &'];
    system(command);
end