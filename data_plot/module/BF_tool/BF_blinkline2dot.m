function [dataout_1x,dur_1x] = BF_blinkline2dot(datain_1v,width_num,high_num)
%function [dataout_1x,dur_1x]  = blinkline2dot(datain_1v,width_num,high_num)
%
%[risedge_light_dot,dur]= blinkline2dot(Gcamp_light_line',500,4)
%��Gcampϵͳϵͳ��light,����0.5s 500���� 4v
%�����涨��datain Ϊ1�У� dataout Ϊ1��
%2015-8-22 ��꿷� BaseFrame
%2016-1-8 ��꿷� ����ÿblink �ĳ���ʱ�䣬:=(0��width_num] 1x

%datain_1v �������ź�(�������Ե�������), ��blink�ǹ���ģ��ۺϵġ�
	a1 = datain_1v > high_num;%�߼�ֵ��line
	a2 = find(a1 == 1);	%dot�̶ȣ�dot
    [dataout_1x,dur_1x] = BF_blinkdot2dot(a2,width_num);

end