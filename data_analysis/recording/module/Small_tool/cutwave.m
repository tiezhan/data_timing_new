function [timepick, wavepick] = cutwave(wave, Fs, timerg)
%读取采样率下，截取某段时间的wave, 不足的用NaN补足
%function [timktick, wavepick] = cutwave(wave, Fs, timerg)
% ---------------------------Input---------------------------
% wave    :    采样数据
% Fs      :    采样率
% timerg  :    时间范围
%
% ---------------------------Output--------------------------
% timepick:    时间刻度
% wavepick:    截取的wave，不足的用NaN补足

switch length(timerg)
	case 1	
		tickrg =[1 timerg * Fs];
	case 2
		tickrg =timerg * Fs;
	otherwise
		error('输入参数错误');
end
tickrg = floor(tickrg);
tickall = tickrg(1):1:tickrg(2);
timepick = reshape(tickall / Fs, [], 1);
tickmax = length(wave);
wavepick= NaN * ones(length(tickall), 1);

%ind_bg ind_end ; 游标
ind_bg = find(tickall>=1, 1, 'first');
ind_end = find(tickall<=tickmax, 1, 'last');
wavepick(ind_bg:ind_end) = wave( tickall(ind_bg):tickall(ind_end) );

%自动修整个数
a = floor(Fs*range(timerg));
wavepick = wavepick(1:a);
timepick = timepick(1:a);