function dataOut = firBand(dataIn, bandFs, sampleFs)
%100��FIR(���޳弤�˲���)����ͨ�������˲�����butterBand���Ƽ�
%function dataOut=firBand(dataIn, bandFs, sampleFs)
%---------------------------Input---------------------------
%dataIn    :  ԭʼ����, 1v
%bandFs    :  ����Ȥ��Ƶ�ʶ�, 2nums
%sampleFs  :  dataIn�Ĳ�����
%
%---------------------------Output--------------------------
%dataOut   :  �˲��������

	Wn = 2 * bandFs ./ sampleFs; %2����
	b  = fir1(100,Wn,'bandpass');  %101��
    a  = 1;
	dataOut = filtfilt(b,a,dataIn);
