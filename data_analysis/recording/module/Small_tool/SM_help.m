function SM_help
% =================����=================
% function npp(varargin);
% ����`nppopen`��
% 
% function nppopen(file);
% ʹ��`NotePad++`����file��
% 
% function vim(varargin);
% ����`vimopen`��
% 
% function vimopen(file);
% ʹ��`GVIM`����file��
% 
% function pname = cdwhich(filename)
% cd��which�µ�Ŀ¼
% 
% function ccclc
% �����������ͼ�Ρ�������
% 
% function gitbash
% ��gitbash��ִ��GIT����
% 
% function updatelilab
% ����LILAB�ļ���
%
% function mklink
% ����"�ļ�/�ļ���"�������߼���ݷ�ʽ��
% 
% function addgenpathBut(varargin)
% ���pwd(�������ļ���)������·���У����ų�ĳЩ���ļ���
% 
% function addLilabPath(varargin)
% ��ʱ���lilab�µ�ĳ��·�����ļ���
%
% function mydoc(topic)
% ���� doc() ������������ʾ�Զ�������ĵ�
%
% function mypublish(topic)
% ���� publish() ���������������Զ���İ����ĵ�
%
% function checkFileContent(pfname, var_cell)
% �˶�MAT�ļ��Ƿ�����˱�Ҫ�ı���
% =================����=================
% function data1_x=setrow(data_1v)
% ���������1x
% 
% function data1_x=set1x(data_1v)
% ���������1x
% 
% function data1_x=set1y(data_1v)
% ���������1y
% 
% function data1_x=ploHz(XHz, Y, varargin)
% ��plot�� ����Y �ڲ�����XHz�µ�ͼ��.
%
% function YNow=line_scale(XR,YR,XNow)
% �������򵥵�����ת��
% 
% function pfname=uigetfilemult(varargin)
% �Ի���һ��������file
% 
% function dataOut=butterBand(dataIn,bandFs,sampleFs)
% 2��IIR-butter(���޳弤�˲���-butter), ��ͨ, �����˲������Ƽ�
%
% function dataOut=firBand(dataIn, bandFs, sampleFs)
% 100��FIR(���޳弤�˲���)����ͨ�������˲�����butterBand���Ƽ�
%
% function outdata = spikeFilter(data, Fs, datareffilted)
% Wideband�����˲�&��ȥ����
% 
% function [outmat, iTime_clean, iTime_artifact] = spikeDetect...
%           (data, Fs, rawpfname, spike_width, stdmin, stdmax)
% ������ֵ����spikeɸѡ
% 
% function [timktick, wavepick] = cutwave(wave, Fs, timerg)
% ��ȡ�������£���ȡĳ��ʱ���wave, �������NaN����
% 
% function wavepick = movewave(wave, Fs, timemv)
% ��ȡ�������£���wave�ƶ�һ��ʱ��, �������NaN����
%
% function [newdata_v, rate] = sampleShrink(data_v, nearto)
% ��������ͼ��plot�Ĳ�����
% 
% function hline = barline(x, HL, varargin)
% ���bar()��������time-stamp��Raster. 
%
% function hlines = barline_old(x, HL, varargin)
% ͬ ������ barline(). ���е���������
%
% function [tRise_1y, tDur_1y] = detectTTL(data_1v)
% ���˳�TTLͨ���������źţ��������غͳ���ʱ������������ 'revertTTL2bin.m'
%
% function data = revertTTL2bin(tRise, tDur, Fs, tlen)
% detectTTL������̡��������غͳ���ʱ�佨��������bool����
%
% function [phy2logic, logic2phy] = assignChanName(data_ny, Fs, names_cell)
% ����GUIȷ��������ͨ����ӳ���ϵ��Ӳ��ͨ��1��nӳ�䵽�߼�ͨ�� X ��
%
% function h = cloudPlot(X,Y)
% ��άɢ�����ͼ�鿴
%
% function data_1y = binmean(data_1v, binsize)
% ��һ��������binsize���ȡƽ��
%
% function [freqs, powers] = ezPower(varargin)
% �򵥵Ļ��� ���ݵ�power�ֲ�
%
% function [comp , amp, theta, freqs] = waveletcomplexExractMultBand(data, Fs)
% ���� С��������Բ��ν���Ƶ���׽���
%
% function delta = autoMatchStampTTL1TTL2(TTL1, TTL2)
% �Զ�ƥ���ʴ�
%
% function range_val = constrainNumber(val, range_min, range_max)
% ǿ��val��Լ���ķ�Χ��
%
% function hpatchs = squareCross(num1, num2, num_merge)
% �����������ε��ص�ͼ����ʾ�������ص��ļ���
%
% function mark = sigmark(pval, defalut_ns)
% ��PVAL����� 'n.s.','*', '**', '***'
%
% function [A_m, A_std, A_sem] = mean_std_sem(A, dim)
% mean & std & sem value of array
%
% =================��=================
% [h, p] = Stat.__static_func__(mu, sigma, mean1, std1, v1,..., alpha, tail)
% ����ͳ��������������, �г���������: Stat.help();
%
% =================����===============
% function [ varargout ] = cloudPlot( varargin)
%          [h, N_2d] = cloudPlot(X,Y,axisLimits)
% ����ͼ
help(mfilename)