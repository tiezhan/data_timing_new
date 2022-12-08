function dataOut = butterBand(dataIn, bandFs, sampleFs)
%2��IIR-butter(���޳弤�˲���-butter), ��ͨ, �����˲������Ƽ�
%function dataOut=butterBand(dataIn, bandFs, sampleFs)
%---------------------------Input---------------------------
%dataIn    :  ԭʼ����, 1v
%bandFs    :  ����Ȥ��Ƶ�ʶ�, 2nums
%sampleFs  :  dataIn�Ĳ�����
%
%---------------------------Output--------------------------
%dataOut   :  �˲��������

	Wn  = 2 * bandFs ./ sampleFs; %2����
	[b,a] = butter(2,Wn,'bandpass');
	dataOut = filtfilt(b,a,dataIn);
