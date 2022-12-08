function [dataout_1x,dur_1x] = BF_blinkline2dot(datain_1v,width_num,high_num)
%function [dataout_1x,dur_1x]  = blinkline2dot(datain_1v,width_num,high_num)
%
%[risedge_light_dot,dur]= blinkline2dot(Gcamp_light_line',500,4)
%如Gcamp系统系统的light,持续0.5s 500个点 4v
%参数规定：datain 为1行， dataout 为1行
%2015-8-22 陈昕枫 BaseFrame
%2016-1-8 陈昕枫 增加每blink 的持续时间，:=(0，width_num] 1x

%datain_1v 是数字信号(处于明显的两极端), 且blink是规则的，聚合的。
	a1 = datain_1v > high_num;%逻辑值，line
	a2 = find(a1 == 1);	%dot刻度，dot
    [dataout_1x,dur_1x] = BF_blinkdot2dot(a2,width_num);

end