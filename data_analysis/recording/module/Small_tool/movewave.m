function wavepick = movewave(wave, Fs, timemv)
% 匹配时钟时，把波形移动一段时间
% function wavepick = movewave(wave, Fs, timemv)
%  ---------------------------Input---------------------------
%   wave    :    采样数据
%   Fs      :    采样率
%   timemv  :    时间移动, +值 向右(NaN补足), -值 向左(裁剪)
%  
%   ---------------------------Output--------------------------
%   wavepick:    截取的wave，不足的用NaN补足  多余的裁剪
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
