function [dataout_1x,dur_1x] = BF_blinkdot2dot (datain_1v,width_num)
%function dataout_1x = blinkdot2dot(datain_1v,width_num)
%
%risedge_tone_dot= blinkline2dot(biu_tone_dot)
%����������ϵͳ11��tone(dataout),1���������2s,��¼��tone����435(datain)��
%�����涨��datain Ϊ1�У� dataout Ϊ1��
%2015-8-22 ��꿷� BaseFrame
%
%����������setrow.m

%��λ���
    datain_1v=setrow(datain_1v);%datain_1v��1x;
	a1=datain_1v;    
	a2=[-inf,a1];
	a2(end)=[];
	dataindex = find( (a1-a2)>width_num );
	dataout_1x = datain_1v(dataindex);
%ÿ��ʱ�䳤
    dataindex2 = [dataindex, length(datain_1v)];
    dur_ind1x = diff(dataindex2);   
    dur_1x = datain_1v(dataindex+dur_ind1x-1)- datain_1v(dataindex)+1;
end