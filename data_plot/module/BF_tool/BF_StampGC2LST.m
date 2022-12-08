function [Stamp_strut] = BF_StampGC2LST(GCstp_1vline, LSTstp_1vdot,GCstpW_num,GCstpH_num,thx_num)
%[Stamp_strut] = BF_StampGC2LST(GCstp_1vline, LSTstp_1vdot,GCstpW_num=1000,GCstpH_num=4,thr_num=5)
%Stp = BF_StampGC2LST(data(:,numGCStampCh), lsttone);
%Mdf_lsttone = lsttone + Stp.stdStep_GCsys_LSTsys;
%
%2015-9-17 ��꿷� BaseFrame
	if ~exist('GCstpW_num','var') 
		GCstpW_num = 1000;% ���ڳ���1000��==1s
	end
	if	~exist('GCstpH_num','var') 
		GCstpH_num = 4;% ��ѹ����4V
	end
	if	~exist('thx_num','var') 
		thx_num = 5; %��ƥ���ϡ����ʴ���֮�����Ӧ���ڴ˷�Χ
	end

	GCstp_1xline = reshape(GCstp_1vline,1,length(GCstp_1vline));
	GCstp_1xdot = BF_blinkline2dot( GCstp_1xline,GCstpW_num,GCstpH_num ); %��ѹ������
	Stamp_strut = Hxxx( GCstp_1xdot,LSTstp_1vdot,thx_num );
	
end	%end function


function[Z] = Hxxx(matlab_time,labstate_time,thx_num)
%�Ӻ������鿴/�Ƚ� tone�¼��ֱ��� LabStateϵͳ��GcamPϵͳ��ӡ��(stamp )��
%
    ZZ = BF_ArrXmodelArrY(matlab_time,labstate_time,'-');%����ݣ�matlab-labstate
    ca = ZZ(1,1);	%�������
	[LSTsys_sqc,GCsys_sqc] = find(abs(ZZ-ca)<thx_num);%ע��˳��
    
	%���������
	%
    Z = [];
	Z.GCsys_dot = matlab_time;		%found origin stamp from GCsys
	Z.GCsys_LSTsys(:,1) = matlab_time(GCsys_sqc);
	Z.GCsys_LSTsys(:,2) = labstate_time(LSTsys_sqc);
	Z.GCsys_LSTsys(:,3) = Z.GCsys_LSTsys(:,1)-Z.GCsys_LSTsys(:,2);
	Z.meanStep_GCsys_LSTsys = round(mean(Z.GCsys_LSTsys(:,3)));
	Z.stdStep_GCsys_LSTsys = round(std(Z.GCsys_LSTsys(:,3)));

	%�����û�
	%
    length1=length( Z.GCsys_LSTsys(:,3) );
    disp('-----------------------stamp����-------------------------------');
    disp( ['stamp��GCamp������',num2str( length(matlab_time) )] );
    disp( ['stamp��Labstate������',num2str( length(labstate_time))] );
    disp( ['stampƥ���ϵĸ���Ϊ��',num2str(length1)] );
    disp( ['stampƥ��ķ���(����̶�)Ϊ��',num2str(Z.stdStep_GCsys_LSTsys)] );
    if length1 < 2 || Z.stdStep_GCsys_LSTsys > 10
        warning('stamp���ܴ��ڲ�����������ƥ��ĸ����ٻ�ƥ����������ϸ�˶����ݣ�');
    end
    disp('--------------------------------------------------------------')
end	%end function

