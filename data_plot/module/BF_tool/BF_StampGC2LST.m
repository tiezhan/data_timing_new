function [Stamp_strut] = BF_StampGC2LST(GCstp_1vline, LSTstp_1vdot,GCstpW_num,GCstpH_num,thx_num)
%[Stamp_strut] = BF_StampGC2LST(GCstp_1vline, LSTstp_1vdot,GCstpW_num=1000,GCstpH_num=4,thr_num=5)
%Stp = BF_StampGC2LST(data(:,numGCStampCh), lsttone);
%Mdf_lsttone = lsttone + Stp.stdStep_GCsys_LSTsys;
%
%2015-9-17 陈昕枫 BaseFrame
	if ~exist('GCstpW_num','var') 
		GCstpW_num = 1000;% 周期超过1000个==1s
	end
	if	~exist('GCstpH_num','var') 
		GCstpH_num = 4;% 电压超过4V
	end
	if	~exist('thx_num','var') 
		thx_num = 5; %“匹配上”的邮戳，之间差异应该在此范围
	end

	GCstp_1xline = reshape(GCstp_1vline,1,length(GCstp_1vline));
	GCstp_1xdot = BF_blinkline2dot( GCstp_1xline,GCstpW_num,GCstpH_num ); %电压，周期
	Stamp_strut = Hxxx( GCstp_1xdot,LSTstp_1vdot,thx_num );
	
end	%end function


function[Z] = Hxxx(matlab_time,labstate_time,thx_num)
%子函数，查看/比较 tone事件分别在 LabState系统和GcamP系统的印记(stamp )。
%
    ZZ = BF_ArrXmodelArrY(matlab_time,labstate_time,'-');%横减纵，matlab-labstate
    ca = ZZ(1,1);	%定义起点
	[LSTsys_sqc,GCsys_sqc] = find(abs(ZZ-ca)<thx_num);%注意顺序
    
	%输出的数据
	%
    Z = [];
	Z.GCsys_dot = matlab_time;		%found origin stamp from GCsys
	Z.GCsys_LSTsys(:,1) = matlab_time(GCsys_sqc);
	Z.GCsys_LSTsys(:,2) = labstate_time(LSTsys_sqc);
	Z.GCsys_LSTsys(:,3) = Z.GCsys_LSTsys(:,1)-Z.GCsys_LSTsys(:,2);
	Z.meanStep_GCsys_LSTsys = round(mean(Z.GCsys_LSTsys(:,3)));
	Z.stdStep_GCsys_LSTsys = round(std(Z.GCsys_LSTsys(:,3)));

	%提醒用户
	%
    length1=length( Z.GCsys_LSTsys(:,3) );
    disp('-----------------------stamp检验-------------------------------');
    disp( ['stamp在GCamp个数：',num2str( length(matlab_time) )] );
    disp( ['stamp在Labstate个数：',num2str( length(labstate_time))] );
    disp( ['stamp匹配上的个数为：',num2str(length1)] );
    disp( ['stamp匹配的方差(差异程度)为：',num2str(Z.stdStep_GCsys_LSTsys)] );
    if length1 < 2 || Z.stdStep_GCsys_LSTsys > 10
        warning('stamp可能存在操作，导致其匹配的个数少或匹配差异大，请仔细核对数据！');
    end
    disp('--------------------------------------------------------------')
end	%end function

