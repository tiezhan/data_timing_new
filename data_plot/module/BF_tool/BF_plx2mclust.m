function BF_plx2mclust(pfnames)
%转化plx文件中spike数据到可直接导入MClust的MAT文件。 可同时转化多个。
%BF_plx2mclust(pfnames)
%----Input 参数---------
% pfnames    : plx文件路径, 可省略
%
%----Output 参数---------
% none
%
%----Output 文件---------
% waveform  : 3D nspike_by_nchan_by_nsample, spike wave (unit??)
% iTime     : nspike_by_1, spike time (sec)
% Fs        : simple rate
%
%----Example-------------
%BF_plx2mclust(); %弹出对话框

%% add path
% OR PLEASE ADD THE TOOL BOX OF "PLEXON LNC MATLAB OFFILINE FILES SDK"
path1 = which('BF_help.m');
ind = find(path1==filesep, 3, 'last');
path_LILAB = path1(1:ind);
addpath(fullfile(path_LILAB, 'CuiYT', 'PLXrecoder', 'Plx_Cite'));

%% load file
if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.plx');
end
for i=1:length(pfnames)
    trans(pfnames{i});
end


function trans(pf)
%% information & check
[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreThresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(pf);
assert( Version > 102 );
if ( Trodalness < 2 )
    disp('Data type : Single Electrode');
elseif ( Trodalness == 2 )
    disp('Data type : Stereotrode');
elseif ( Trodalness == 4 )
    disp('Data type : Tetrode');
else
    error('Data type: unkown');
end
disp(['Opened File Name: ' OpenedFileName]);
disp(['Version: ' num2str(Version)]);
disp(['Frequency : ' num2str(Freq)]);
disp(['Comment : ' Comment]);
disp(['Date/Time : ' DateTime]);
disp(['Duration : ' num2str(Duration)]);
disp(['Num Pts Per Wave : ' num2str(NPW)]);
disp(['Num Pts Pre-Threshold : ' num2str(PreThresh)]);

[tscounts, wfcounts, evcounts, contcounts] = plx_info(OpenedFileName, 1);
numspc = size(tscounts, 2)-1;

%% read file
sortuint=0;
allspk.spc = cell(numspc, sortuint+1); %waveform: nspike x nsample, cell
allspk.num = zeros(numspc, sortuint+1); %npikes.
allspk.ts = cell(numspc, sortuint+1);  %iTime:  nspike x 1
allspk.npw = zeros(numspc, sortuint+1);
fprintf('Read channals: ');
for inumspc = 1:numspc   % starting with unit 0 (unsorted) 
    for isortuint = 0:sortuint
          [allspk.num(inumspc,isortuint+1), allspk.npw(inumspc,isortuint+1), allspk.ts{inumspc,isortuint+1}, allspk.spc{inumspc,isortuint+1}] = plx_waves(OpenedFileName, inumspc, isortuint);
          if(length(allspk.spc{inumspc,isortuint+1}) ~= 1)
             allspk.spc{inumspc,isortuint+1}=allspk.spc{inumspc,isortuint+1}/32768*10;
          end
    end
    fprintf(' >%d',  inumspc);
end
fprintf('\nFinish Read.\n');

%% check & print
nTrodalness = numspc / Trodalness;
indEmptySpikeChan = cellfun(@(x)size(x, 2), allspk.spc) == 1;
assert(nTrodalness == floor(nTrodalness));
assert(isequal(NPW, unique(cellfun(@(x)size(x, 2), allspk.spc(~indEmptySpikeChan)))));
chanmap = reshape(1:numspc, Trodalness, [])'; %nTrodalness x subTrodalness(1/2/4)
for iTrodalness = 1:nTrodalness
    chans = chanmap(iTrodalness, :);
    if any(indEmptySpikeChan(chans)); continue; end
    nspk = unique(allspk.num(chans));
    nspk2 = unique(cellfun(@length, allspk.ts(chans)));
    nspk3 = unique(cellfun(@(x)size(x, 1), allspk.spc(chans)));
    assert(isscalar(nspk) && isscalar(nspk2) && isscalar(nspk3));
    assert(nspk == nspk2 && nspk == nspk3);
end

%% write file
[p,f,~] = fileparts(OpenedFileName);
pfnew = @(str, num)fullfile(p, sprintf([f, '_plx_%s%d.mat'], str, num));
if ( Trodalness < 2 )
    tag = 'Sin';
elseif ( Trodalness == 2 )
    tag = 'Ste';
elseif ( Trodalness == 4 )
    tag = 'Tet';
end

for iTrodalness = 1:nTrodalness
    % data
    MAT = struct();
    chans = chanmap(iTrodalness, :);
    if any(indEmptySpikeChan(chans))
        fprintf('第%d捆为空\n', iTrodalness);
        continue;
    end
    MAT.iTime = allspk.ts{chans(1)};
    MAT.waveform = permute(cat(3, allspk.spc{chans}), [1, 3, 2]);
    MAT.Fs = Freq;
    
    % file
    matfile = pfnew(tag, iTrodalness);
    save(matfile, '-struct', 'MAT');
end