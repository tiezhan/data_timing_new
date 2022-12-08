function dataOut = butterBand(dataIn, bandFs, sampleFs)
%2阶IIR-butter(无限冲激滤波器-butter), 带通, 单向滤波。不推荐
%function dataOut=butterBand(dataIn, bandFs, sampleFs)
%---------------------------Input---------------------------
%dataIn    :  原始数据, 1v
%bandFs    :  感兴趣的频率段, 2nums
%sampleFs  :  dataIn的采样率
%
%---------------------------Output--------------------------
%dataOut   :  滤波后的数据

	Wn  = 2 * bandFs ./ sampleFs; %2个数
	[b,a] = butter(2,Wn,'bandpass');
	dataOut = filtfilt(b,a,dataIn);
