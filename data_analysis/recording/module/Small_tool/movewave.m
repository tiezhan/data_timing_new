function wavepick = movewave(wave, Fs, timemv)
% ƥ��ʱ��ʱ���Ѳ����ƶ�һ��ʱ��
% function wavepick = movewave(wave, Fs, timemv)
%  ---------------------------Input---------------------------
%   wave    :    ��������
%   Fs      :    ������
%   timemv  :    ʱ���ƶ�, +ֵ ����(NaN����), -ֵ ����(�ü�)
%  
%   ---------------------------Output--------------------------
%   wavepick:    ��ȡ��wave���������NaN����  ����Ĳü�
wave = set1y(wave);
if timemv==0
    wavepick = wave;
elseif timemv > 0;
    nancount = ceil(Fs*timemv);
    wavepick = [nan(nancount,1); wave];
else
    wastecount = -ceil(Fs*timemv);
    wavepick = wave(wastecount+1:end);
end
wavepick = set1y(wavepick);
