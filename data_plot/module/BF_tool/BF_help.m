function BF_help
% =================����=================
% function Alg_sXtrail = BF_AlignWave2Tg(Wave, Trigger, wds_L, wds_R, ifshow)
% ���������ź�(Wave) to ����(Trigger)
%
% function [Alg_60x9000y]=BF_AlignSg2Tg(LickorGC_1x_dotline, Trgger_1x_dot, wdsL,wdsR,Mode_char)
% �����ź�(sigal) to ����(Trigger)		60�δ�����9000�Ĺ۲ⴰ��
% 
% function Alg_cell = BF_AlignSg2TgCell(Lick, Trgger, wds_L,wds_R)
% �����ź�(sigal) to ����(Trigger)        ���� '1x cell of 1y nums'
%
% function Alg_cell = BF_AlignStair2TgCell(Lick_and_dur, Trigger, wds_L, wds_R)
% �����ź�(sigal, �г���ʱ��) to ����(Trigger)  ���� '1x cell of 2y nums'
%
% function dataout_1x_dot = BF_blinkdot2dot(datain_1x_dot,width_num)
% LabState���ó�1st<biu biu biu>  2nd<biu biu biu>�����������ϵ�biu����
% 
% function [dataout_1x,dur_1x]  = BF_blinkline2dot(datain_1x,width_num,high_num)
% Gcampϵͳ��Light�źų���0.5s��ת����ֻ�д���ĳֵ�������ص����ݡ�
% 
% function [data_eachBin_180y60x,data_mean,data_errorbar]=BF_nDatLine2Bins(data_in_9000y60x, bin_siz)
% �ۻ�ֱ��ͼ or ƽ������
% 
% function [h,h_patch]=BF_plotwSEM(x,y_1xy,yerr_1xy)
% ��ӡplot�ߺ� ������
% 
% function varargout=BF_ReadLSTdatatxt(txtpatch,varargin)
% �ϸ���˳����ȡ�� ��txtҪת��Ϊansi����
% 
% function [ToneforPump_1x_dot,TonenoPump_1x_dot] ...
% 		= BF_ToneSPbyPump(Tone_1x_dot,Pump_1x_dot,Left_num,Right_num)
%ϸ��������Pump��Tone������Air��Light
%
%function delay_1v = BF_firstLickDelay(Tone_1v, lick_1v, noperiod_num=0)
%��ȡ��Tone�ʴ������lick������ʱ���
%
%function [ind_activestation_1y, distance_people_1y] = BF_nearStation(...
%           station_1v, people_1v,style)
%ƥ���ʴ�('��������ȥ����ĳ�վ����)
%
%function idx_1y = BF_FndArrinArr(dat_1xory, seek_1y)
%������dat�У�����seek�������ڵ�λ��s
%
%function [h]=BF_plotRaster(dat_6000y10x, xtick_6000xor2x,...
%        ��ѡcolor����ѡlinebg,��ѡlinehigh)
%������դͼ
%
%function [h]=BF_plotRasterCell(dat_cell,��ѡcolor��...
%        ��ѡlinebottom=0,��ѡlinehigh)	
%������դͼ
%
%function h=BF_plotStairRasterCell(dat_cell,color_3arr)
%����ʱ�������patch��դͼ
%
%function varargout=BF_ReadLSTdatamat(matfilename,varargin)
%��ȡBF_textfilter���ض��ַ����Ƶı���
%
%function Matix_Z = BF_ArrXmodelArrY(X_1v,Y_1v��model)
%��������Ԫ��������(+-*/)�����ɾ���
%
%function Stp_strut = BF_StampGC2LST(GCstp_1vline, LSTstp_1vdot, ...
%       GCstpW_num,GCstpH_num,thx_num)
%�����ʴ���ֵ�����ҽ�����ɿ��̶ȡ�
%
%function [Xsort_v,Ymean_v]=BF_YmeaninX(X_v,Y_v,model); 
%X������ͬ������¶�ӦY���������Ų���
%
%function [eegSeg,alongTime,freqEnd] = BF_powerSpectrum(EEGrow,Fs,Twin,Bands)
%��eeg�ź������������ܶȡ����㡣�������Bands֮���power�ľ�ֵ��
%
%function BF_fileDateCmp(file1, file2)
%�Ƚ������ļ����޸�ʱ���Ⱥ�
%
% =================�ļ���ʽת��=================
%function outmatname =BF_textfilter(filename,countC,countS)
%��ȡLabState��StateData����change to TXT file�����ݣ�by��Ф
%
%function BF_daq2mat(filenames)
%ͬʱת����� daq �ļ�Ϊ mat�ļ�
%
%function BF_arc2mat(filenames)
%ͬʱת����� ArControl .txt �ļ�Ϊ mat�ļ�
%
%function BF_abf2mat(filenames)
%ͬʱת�����.abf(Axon Binary File) �ļ�Ϊ mat�ļ�
%
%function BF_abf2mat(filenames)
%ͬʱת�����.abf(Axon Binary File) �ļ�Ϊ mat�ļ�
%
%function BF_mat2atf(pfnames)
%ת�� mat �ļ�Ϊ .atf�� ��ͬʱת�������
%
%function BF_h5_to_mat(pfnames)
%ת�� h5 �ļ�(wavesurfer)Ϊ .atf�� ��ͬʱת�������
%
%function BF_atf2mat(pfnames)
%ת�� atf �ļ�Ϊ .mat�� ��ͬʱת�������
%
%function BF_hekaAsc2mat(pfnames)
%ת�� .asc(Haka File) �ļ�Ϊ .mat�� ��ͬʱת�������--�Ƽ�
%
%function BF_hekaMat2mat(pfnames)
%ת�� .mat(Haka File) �ļ�Ϊ .mat�� ��ͬʱת�������--���Ƽ�
%
%function BF_plx2mclust(pfnames)
%ת�� plx�ļ���spike���ݵ���ֱ�ӵ���MClust��MAT�ļ�
%
%function BF_plx2mat(pfnames)
%ת�� plx�ļ�Ϊ .mat�� ��ͬʱת�������
%
%function BF_edf2EXGmat(pfnames)
%ת�� Sirenia ˯��ϵͳ������ *.EDF �ļ�Ϊ GUI_menuScored�� MAT�ļ�
help(mfilename)
