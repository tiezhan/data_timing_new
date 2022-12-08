function [dataout_1x,dur_1x] = BF_blinkdot2dot (datain_1v,width_num)
%function dataout_1x = blinkdot2dot(datain_1v,width_num)
%
%risedge_tone_dot= blinkline2dot(biu_tone_dot)
%如条件抑制系统11次tone(dataout),1次声音宽度2s,记录到tone触发435(datain)。
%参数规定：datain 为1行， dataout 为1行
%2015-8-22 陈昕枫 BaseFrame
%
%函数依赖，setrow.m

%错位相减
    datain_1v=setrow(datain_1v);%datain_1v→1x;
	a1=datain_1v;    
	a2=[-inf,a1];
	a2(end)=[];
	dataindex = find( (a1-a2)>width_num );
	dataout_1x = datain_1v(dataindex);
%每次时间长
    dataindex2 = [dataindex, length(datain_1v)];
    dur_ind1x = diff(dataindex2);   
    dur_1x = datain_1v(dataindex+dur_ind1x-1)- datain_1v(dataindex)+1;
end