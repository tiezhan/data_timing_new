function [timepick, wavepick] = cutwave(wave, Fs, timerg)
%��ȡ�������£���ȡĳ��ʱ���wave, �������NaN����
%function [timktick, wavepick] = cutwave(wave, Fs, timerg)
% ---------------------------Input---------------------------
% wave    :    ��������
% Fs      :    ������
% timerg  :    ʱ�䷶Χ
%
% ---------------------------Output--------------------------
% timepick:    ʱ��̶�
% wavepick:    ��ȡ��wave���������NaN����

switch length(timerg)
	case 1	
		tickrg =[1 timerg * Fs];
	case 2
		tickrg =timerg * Fs;
	otherwise
		error('�����������');
end
tickrg = floor(tickrg);
tickall = tickrg(1):1:tickrg(2);
timepick = reshape(tickall / Fs, [], 1);
tickmax = length(wave);
wavepick= NaN * ones(length(tickall), 1);

%ind_bg ind_end ; �α�
ind_bg = find(tickall>=1, 1, 'first');
ind_end = find(tickall<=tickmax, 1, 'last');
wavepick(ind_bg:ind_end) = wave( tickall(ind_bg):tickall(ind_end) );

%�Զ���������
a = floor(Fs*range(timerg));
wavepick = wavepick(1:a);
timepick = timepick(1:a);