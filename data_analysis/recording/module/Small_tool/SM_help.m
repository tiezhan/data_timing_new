function SM_help
% =================命令=================
% function npp(varargin);
% 参照`nppopen`。
% 
% function nppopen(file);
% 使用`NotePad++`来打开file。
% 
% function vim(varargin);
% 参照`vimopen`。
% 
% function vimopen(file);
% 使用`GVIM`来打开file。
% 
% function pname = cdwhich(filename)
% cd到which下的目录
% 
% function ccclc
% 清除工作区、图形、命令行
% 
% function gitbash
% 打开gitbash，执行GIT控制
% 
% function updatelilab
% 更新LILAB文件夹
%
% function mklink
% 创建"文件/文件夹"的替身（高级快捷方式）
% 
% function addgenpathBut(varargin)
% 添加pwd(包含子文件夹)到搜索路径中，但排除某些子文件夹
% 
% function addLilabPath(varargin)
% 临时添加lilab下的某个路径到文件中
%
% function mydoc(topic)
% 代替 doc() 函数，用来显示自定义帮助文档
%
% function mypublish(topic)
% 代替 publish() 函数，用来制作自定义的帮助文档
%
% function checkFileContent(pfname, var_cell)
% 核对MAT文件是否包含了必要的变量
% =================函数=================
% function data1_x=setrow(data_1v)
% 让向量变成1x
% 
% function data1_x=set1x(data_1v)
% 让向量变成1x
% 
% function data1_x=set1y(data_1v)
% 让向量变成1y
% 
% function data1_x=ploHz(XHz, Y, varargin)
% 简单plot出 数据Y 在采样率XHz下的图形.
%
% function YNow=line_scale(XR,YR,XNow)
% 数据做简单的线性转化
% 
% function pfname=uigetfilemult(varargin)
% 对话框，一次载入多个file
% 
% function dataOut=butterBand(dataIn,bandFs,sampleFs)
% 2阶IIR-butter(无限冲激滤波器-butter), 带通, 单向滤波。不推荐
%
% function dataOut=firBand(dataIn, bandFs, sampleFs)
% 100阶FIR(有限冲激滤波器)，带通，零相滤波，比butterBand更推荐
%
% function outdata = spikeFilter(data, Fs, datareffilted)
% Wideband数据滤波&减去基线
% 
% function [outmat, iTime_clean, iTime_artifact] = spikeDetect...
%           (data, Fs, rawpfname, spike_width, stdmin, stdmax)
% 基于阈值法的spike筛选
% 
% function [timktick, wavepick] = cutwave(wave, Fs, timerg)
% 读取采样率下，截取某段时间的wave, 不足的用NaN补足
% 
% function wavepick = movewave(wave, Fs, timemv)
% 读取采样率下，把wave移动一段时间, 不足的用NaN补足
%
% function [newdata_v, rate] = sampleShrink(data_v, nearto)
% 减少缩率图中plot的采样点
% 
% function hline = barline(x, HL, varargin)
% 替代bar()函数，做time-stamp的Raster. 
%
% function hlines = barline_old(x, HL, varargin)
% 同 上述的 barline(). 所有的线条独立
%
% function [tRise_1y, tDur_1y] = detectTTL(data_1v)
% 过滤出TTL通道的数字信号，用上升沿和持续时间表述。逆过程 'revertTTL2bin.m'
%
% function data = revertTTL2bin(tRise, tDur, Fs, tlen)
% detectTTL的逆过程。从上升沿和持续时间建立连续的bool数据
%
% function [phy2logic, logic2phy] = assignChanName(data_ny, Fs, names_cell)
% 利用GUI确定采样的通道的映射关系（硬件通道1：n映射到逻辑通道 X ）
%
% function h = cloudPlot(X,Y)
% 二维散点的热图查看
%
% function data_1y = binmean(data_1v, binsize)
% 对一段数据以binsize逐段取平均
%
% function [freqs, powers] = ezPower(varargin)
% 简单的画出 数据的power分布
%
% function [comp , amp, theta, freqs] = waveletcomplexExractMultBand(data, Fs)
% 利用 小波卷积，对波形进行频率谱解析
%
% function delta = autoMatchStampTTL1TTL2(TTL1, TTL2)
% 自动匹配邮戳
%
% function range_val = constrainNumber(val, range_min, range_max)
% 强制val在约束的范围内
%
% function hpatchs = squareCross(num1, num2, num_merge)
% 用两个正方形的重叠图，表示两个有重叠的计数
%
% function mark = sigmark(pval, defalut_ns)
% 将PVAL计算成 'n.s.','*', '**', '***'
%
% function [A_m, A_std, A_sem] = mean_std_sem(A, dim)
% mean & std & sem value of array
%
% =================包=================
% [h, p] = Stat.__static_func__(mu, sigma, mean1, std1, v1,..., alpha, tail)
% 利用统计量做显著检验, 列出各个函数: Stat.help();
%
% =================三方===============
% function [ varargout ] = cloudPlot( varargin)
%          [h, N_2d] = cloudPlot(X,Y,axisLimits)
% 做云图
help(mfilename)