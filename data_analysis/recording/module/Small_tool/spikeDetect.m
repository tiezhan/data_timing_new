function [outmat, iTime_clean, iTime_artifact] = spikeDetect...
         (data, Fs, rawpfname, spike_width, stdmin, stdmax)
% 摘抄整理自 Spike_Sorting_HH.m ; 修订时间2016-6-20，陈昕枫
% 导出的waveform与导入的data是同一个量级(不同于 Spike_Sorting_HH.m), @2016-6-30
%
%function [outmat, iTime_clean, iTime_artifact] = spikeDetect...
%         (data, Fs, rawpfname, spike_width, stdmin, stdmax)
% -----Input 参数--------
% data           : a bundle, points_by_chans, 1y = 1chan; unit V
% Fs             : sampling rate
% rawpfname      : orginal file name
% spike_width    : spike takes points
% stdmin, stdmax : white_noise < stdmin < real_spike < stdmax < artifact_spike
%
% -----Output 参数--------
% outmat         : output mat file name
% iTime_clean    : real spike, unit s
% iTime_artifact : artifact spike, unit s
%
%------outmat 内容------
% iTime          : real spike, 1y, unit s
% waveform       : spike waveform from 'data', unit V;
%
%------figure 内容------
% spike timeline : real spike v.s. artifact spike every second
% chan wave      : raw waveform from 'data', unit V
% spike wave     : spike waveform from 'data', unit V
	%% 创建接口
	[path,name,~]=fileparts(rawpfname);
	outmat = [path filesep char(name) '_Bundle.mat'];
	waveform_data = data'; %每1x = 1通道
    [numwires, numpoints] = size(waveform_data);
 	fprintf('%每捆有：\t%d电极\n',numwires);
	if numwires>4;error('请只载入1捆电极!');end   
	%% spike参数设置
	if ~exist('stdmin','var'); stdmin = 4; end
    if ~exist('stdmax','var'); stdmax = 20; end
    if ~exist('spike_width','var'); spike_width = 50; end
	w_pre = floor(0.4 * spike_width);
	w_post = spike_width - w_pre;
	%% 滤波
	%% 减基线
	%% 取得超过阈值线的点; 索引
	threshold_window = floor(Fs); %one second sample number
	num_windows = floor((numpoints - w_post) / threshold_window);
	xaux = []; %index of cross stdmin threshold
    temp_tetrode = waveform_data;
	for iwire = 1:numwires
		temp_wire = temp_tetrode(iwire,:);
		for i = 1:num_windows
			temp_ind = w_pre+(i-1)*threshold_window:w_pre-1+i*threshold_window;
			temp_val = abs(temp_wire(temp_ind));
            temp_val_neg = -temp_wire(temp_ind);
			thr = stdmin * median(temp_val) / 0.6745;
			xaux_temp = find(temp_val_neg > thr) + w_pre +(i-1)*threshold_window;
			xaux=[xaux xaux_temp];
		end
	end
	xaux = sort(xaux);

	%% 取得spike峰值的位置; 索引
	nspk = 0; %n spikes
	xaux0 = 0; %absolute, last spike peak index
	index_temp = []; %index of all peak; dirty
	for i = 1:length(xaux)
		if xaux(i) < xaux0 + spike_width -1; continue;end
		peakwin = xaux(i):xaux(i) + spike_width - 1; %window to find peak of spike
		[~, peak_chan] = max(max(-(temp_tetrode(:, peakwin)),[],2),[],1); %chan of max peak
		[~, peak_ind]=max(-(temp_tetrode(peak_chan, peakwin)));%relative index to find peak in a channal
		xaux0 = xaux(i) + peak_ind;
		nspk = nspk + 1;
		index_temp(nspk) = xaux0;
    end

	%% 除去artifacts; 索引
    index = index_temp;
	thr_up = stdmax * median(abs(temp_tetrode(:))) / 0.6745;
	ind_artifact = max(-(temp_tetrode(:, index_temp)),[],1) > thr_up;
	index(ind_artifact) = [];%index of all peak; clean
    index_artifact = index_temp(ind_artifact); %index of all artifacts;
    nspk = length(index);

	%% 得到spike_wave
	spikes = zeros(nspk, numwires, spike_width);    
    for n2=1:numwires
        for n3=1:spike_width
            spikes(:,n2,n3)=temp_tetrode(n2, index + n3-w_pre);
        end
    end

	%% 保存到文件
	waveform = spikes; 
	iTime = reshape(index / Fs, [], 1); %second
	save(outmat, 'waveform', 'iTime');
	disp('Finished spikeDetect of one bundle');
    
    %% 信息汇总输出
    if nargout <= 1; return; end
    iTime_clean = index / Fs; %unit s, stdmin < spike < stdmax
    iTime_artifact = index_artifact / Fs; %unit s, spike > stdmax
    visualise(waveform_data, Fs, waveform, iTime_clean, iTime_artifact)
end

function visualise(waveform_data, Fs, waveform, iTime_clean, iTime_artifact)
    %% figure : whole time wave & clean v.s. artifact
    figure();
    [numwires, numpoints] = size(waveform_data);
    time_len = floor(numpoints / Fs);
    [N_iTime_clean, ~] = histcounts(iTime_clean, 0:time_len);
    [N_iTime_artifact, edges] = histcounts(iTime_artifact, 0:time_len);
    ax(1) = subplot(1+numwires, 1, 1); hold on;
    plot(edges(1:end-1), N_iTime_clean);
    plot(edges(1:end-1), N_iTime_artifact);
    legend(sprintf('real : n=%d', length(iTime_clean)),...
           sprintf('artifact : n=%d', length(iTime_artifact)) );
    ylabel('count / s')
    for i = 1:1:numwires
        ax(end+1) = subplot(1+numwires, 1, i+1);
        ydata = waveform_data(i,:);
        xdata = (1:numpoints) / Fs;
        try
            [ydata, rate] = sample_shrink(ydata, 1e5);%shrink points to plot
            xdata = (1:length(ydata)) / Fs * rate;
        end
        plot(xdata, ydata);
        legend(sprintf('Chan[%d]',i));
    end
    xlabel('Time(s)');
    linkaxes(ax,'x');
    linkaxes(ax(2:end),'y');
    
    %% figure : spike waves quick view
    figure();
    nspk = size(waveform, 1);
    if nspk<1000
        fspk = nspk;
        strspk = sprintf('first %d / %d',fspk,fspk);
    else
        fspk = 1000;
        strspk = sprintf('first %d / %d',fspk,nspk);
    end
    for i = 1:numwires
        subplot(numwires, 1, i); hold on;
        if i==1; title(strspk); end
        plot( reshape(waveform(1:fspk, i, :), fspk, [])' );
        legend(sprintf('Chan[%d]',i));
    end
     xlabel('Time(s)');
end
