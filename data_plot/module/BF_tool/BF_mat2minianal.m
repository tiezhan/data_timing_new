function BF_mat2minianal(pfnames)
%转化电生理 mat 文件为多个 MiniAnalysis .txt。 可同时转化多个。
%function BF_mat2minianal(pfnames)
%----Input 参数---------
% pfnames    : mat文件路径, 可省略
%
%----Output 参数---------
% 无
%
%----Input  文件---------
% data  : 1D nsample
%       : 2D nsample_by_nchan
%       : 3D nsample_by_nchan_by_ntrial
% Fs    : simple rate
% chaninfo: channames, cell of string
%         : chanunits, cell of string
%
%----Example-------------
%BF_abfmat2minianal(); %弹出对话框

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.mat');
end
for i=1:length(pfnames)
    checkFileContent(pfnames{i}, {'data', 'Fs', 'chaninfo'});
    trans(pfnames{i});
end

%% translate each file
function trans(pf)
MAT = load(pf, '-mat', 'data', 'Fs', 'chaninfo');
dat3D = MAT.data;
Fs = MAT.Fs;
chaninfo = MAT.chaninfo;
dims = size(dat3D);
switch length(dims)
    case 2
        dat = dat3D;
        if dims(1) == 1; dat = dat'; end
    case 3
        dat = dat3D;
    otherwise
        error('MAT文件中的 data 数据尺度错误！');
end
[nsample, nchan, ntrial] = size(dat);
assert(nchan>=1 && nchan <= 100);
assert(nsample>100);
assert(ntrial>=1 && ntrial <= 100);

 %% 打印信息
fprintf('--------文件信息--------\n');
fprintf('通道\t:\t%.0f\n', nchan);
fprintf('时长\t:\t%.2f (sec)\n', nsample / Fs);
fprintf('Trial\t:\t%.0f\n', ntrial);
[p,f,~] = fileparts(pf);
p_f = fullfile(p, f);
for ichan = 1:nchan
    for itrial = 1:ntrial
        str = sprintf('_Ch%d_%d.txt', ichan, itrial);
        file_new = [p_f, str];
        dat_temp  = set1y(squeeze(dat(:, ichan, itrial)));
        chanunit = chaninfo.chanunits{ichan};
        channame = chaninfo.channames{ichan};
        writefile(file_new, Fs, dat_temp, chanunit, channame)
    end
end
disp('导出文件成功');

function writefile(file_new, Fs, dat, chanunit, channame)
 fid = fopen(file_new, 'w');
fprintf(fid, 'ABFUtilityASCII: Convert Any ASCII to ABF\r\n');
fprintf(fid, 'Column number to convert            = %.0f\r\n', 1);
fprintf(fid, 'Number of lines to skip for header  = %.0f\r\n', 10);
fprintf(fid, 'Sampling Interval (in micro second) = %.0f\r\n', 1e6/Fs);
fprintf(fid, 'ADC Voltage Range (Volts)           = %.0f\r\n', 10);
fprintf(fid, 'ADC Resolution (12 bit=2048)        = %.0f\r\n', 32768);
fprintf(fid, 'Unit (pA or mV)                     = %s\r\n', chanunit);
fprintf(fid, 'Scaling Factor (Volts/Unit)         = %.0f\r\n', 1);
fprintf(fid, 'Multiplication Factor               = %.0f\r\n', 1);
fprintf(fid, 'Amplication-%s\r\n', channame);
fprintf(fid, '%.7g\r\n', dat);
fclose(fid); 
