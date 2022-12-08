function dataOut = firBand(dataIn, bandFs, sampleFs)
%100阶FIR(有限冲激滤波器)，带通，零相滤波，比butterBand更推荐
%function dataOut=firBand(dataIn, bandFs, sampleFs)
%---------------------------Input---------------------------
%dataIn    :  原始数据, 1v
%bandFs    :  感兴趣的频率段, 2nums
%sampleFs  :  dataIn的采样率
%
%---------------------------Output--------------------------
%dataOut   :  滤波后的数据

	Wn = 2 * bandFs ./ sampleFs; %2个数
	b  = fir1(100,Wn,'bandpass');  %101个
    a  = 1;
	dataOut = filtfilt(b,a,dataIn);
