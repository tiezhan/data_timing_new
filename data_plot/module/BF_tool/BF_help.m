function BF_help
% =================函数=================
% function Alg_sXtrail = BF_AlignWave2Tg(Wave, Trigger, wds_L, wds_R, ifshow)
% 对齐连续信号(Wave) to 触发(Trigger)
%
% function [Alg_60x9000y]=BF_AlignSg2Tg(LickorGC_1x_dotline, Trgger_1x_dot, wdsL,wdsR,Mode_char)
% 对齐信号(sigal) to 触发(Trigger)		60次触发，9000的观测窗口
% 
% function Alg_cell = BF_AlignSg2TgCell(Lick, Trgger, wds_L,wds_R)
% 对齐信号(sigal) to 触发(Trigger)        返回 '1x cell of 1y nums'
%
% function Alg_cell = BF_AlignStair2TgCell(Lick_and_dur, Trigger, wds_L, wds_R)
% 对齐信号(sigal, 有持续时间) to 触发(Trigger)  返回 '1x cell of 2y nums'
%
% function dataout_1x_dot = BF_blinkdot2dot(datain_1x_dot,width_num)
% LabState设置成1st<biu biu biu>  2nd<biu biu biu>，清除间隔果断的biu数据
% 
% function [dataout_1x,dur_1x]  = BF_blinkline2dot(datain_1x,width_num,high_num)
% Gcamp系统，Light信号持续0.5s，转化成只有大于某值的上升沿的数据。
% 
% function [data_eachBin_180y60x,data_mean,data_errorbar]=BF_nDatLine2Bins(data_in_9000y60x, bin_siz)
% 累积直方图 or 平滑曲线
% 
% function [h,h_patch]=BF_plotwSEM(x,y_1xy,yerr_1xy)
% 打印plot线和 误差面积
% 
% function varargout=BF_ReadLSTdatatxt(txtpatch,varargin)
% 严格按照顺序提取， 且txt要转化为ansi编码
% 
% function [ToneforPump_1x_dot,TonenoPump_1x_dot] ...
% 		= BF_ToneSPbyPump(Tone_1x_dot,Pump_1x_dot,Left_num,Right_num)
%细化发生了Pump的Tone，发生Air的Light
%
%function delay_1v = BF_firstLickDelay(Tone_1v, lick_1v, noperiod_num=0)
%获取离Tone邮戳最近的lick发生的时间差
%
%function [ind_activestation_1y, distance_people_1y] = BF_nearStation(...
%           station_1v, people_1v,style)
%匹配邮戳('人们总是去最近的车站坐车)
%
%function idx_1y = BF_FndArrinArr(dat_1xory, seek_1y)
%在向量dat中，查找seek向量存在的位置s
%
%function [h]=BF_plotRaster(dat_6000y10x, xtick_6000xor2x,...
%        可选color，可选linebg,可选linehigh)
%画出光栅图
%
%function [h]=BF_plotRasterCell(dat_cell,可选color，...
%        可选linebottom=0,可选linehigh)	
%画出光栅图
%
%function h=BF_plotStairRasterCell(dat_cell,color_3arr)
%画出时间持续的patch光栅图
%
%function varargout=BF_ReadLSTdatamat(matfilename,varargin)
%提取BF_textfilter中特定字符名称的变量
%
%function Matix_Z = BF_ArrXmodelArrY(X_1v,Y_1v，model)
%两个向量元素逐个相减(+-*/)，生成矩阵
%
%function Stp_strut = BF_StampGC2LST(GCstp_1vline, LSTstp_1vdot, ...
%       GCstpW_num,GCstpH_num,thx_num)
%计算邮戳差值，并且建议其可靠程度。
%
%function [Xsort_v,Ymean_v]=BF_YmeaninX(X_v,Y_v,model); 
%X向量相同的情况下对应Y向量重新排布。
%
%function [eegSeg,alongTime,freqEnd] = BF_powerSpectrum(EEGrow,Fs,Twin,Bands)
%给eeg信号做“功率谱密度”计算。计算的是Bands之间的power的均值。
%
%function BF_fileDateCmp(file1, file2)
%比较两个文件的修改时间先后
%
% =================文件格式转化=================
%function outmatname =BF_textfilter(filename,countC,countS)
%提取LabState→StateData→“change to TXT file”数据，by陈肖
%
%function BF_daq2mat(filenames)
%同时转化多个 daq 文件为 mat文件
%
%function BF_arc2mat(filenames)
%同时转化多个 ArControl .txt 文件为 mat文件
%
%function BF_abf2mat(filenames)
%同时转化多个.abf(Axon Binary File) 文件为 mat文件
%
%function BF_abf2mat(filenames)
%同时转化多个.abf(Axon Binary File) 文件为 mat文件
%
%function BF_mat2atf(pfnames)
%转化 mat 文件为 .atf。 可同时转化多个。
%
%function BF_h5_to_mat(pfnames)
%转化 h5 文件(wavesurfer)为 .atf。 可同时转化多个。
%
%function BF_atf2mat(pfnames)
%转化 atf 文件为 .mat。 可同时转化多个。
%
%function BF_hekaAsc2mat(pfnames)
%转化 .asc(Haka File) 文件为 .mat。 可同时转化多个。--推荐
%
%function BF_hekaMat2mat(pfnames)
%转化 .mat(Haka File) 文件为 .mat。 可同时转化多个。--不推荐
%
%function BF_plx2mclust(pfnames)
%转化 plx文件中spike数据到可直接导入MClust的MAT文件
%
%function BF_plx2mat(pfnames)
%转化 plx文件为 .mat。 可同时转化多个。
%
%function BF_edf2EXGmat(pfnames)
%转化 Sirenia 睡眠系统导出的 *.EDF 文件为 GUI_menuScored的 MAT文件
help(mfilename)
