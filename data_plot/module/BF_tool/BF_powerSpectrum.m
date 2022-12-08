function [eegSeg,alongTime,freqEnd] = BF_powerSpectrum(EEGrow,Fs,Twin,Bands)
%function [eegSeg,alongTime,freqEnd] = BF_powerSpectrum(EEGrow,Fs,Twin,Bands)
%[eegSeg,alongTime,freqEnd] = BF_powerSpectrum(EEGrow,250,4,0:30);
%
%EEGrow:= 1v ,EEG row vector
%Fs :=1num, simple rate
%Twin:=1num, time window for each FFT apart
%Bands:=1v, calculate during each pair band; Bands:=[0 1 2 5]=mean(0 1]、mean(1 2]、mean(2 5]
%Bands:= n_by_2,同理。1行有2个，2个做配对。
%eegSeg:=nBand_by_nTimewindows, eeg-fft-power along the time and segment by Bands.
%alongTime:= 1x, each second of "eegSeg-time window" begin
%freqEnd: = 1x, each F as "eegSeg-band". 	Recommand to redim it in fun's outside.
%
%函数依赖 setrow
%2016-1-8 陈昕枫 BF
	eegN = Twin*Fs; %每个FFT的窗口采样长度
	length1= 0:eegN:length(EEGrow);
	EEGrow = EEGrow(1 : length1(end)); %截去尾巴
	n=length(EEGrow)/eegN; %n windows
	data.eeg=reshape(EEGrow,eegN,n);
	data.eeg_f=Fs;
	eegP = [];%epoch length points
	for i=1:n
		[~, eegF, ~, eegP(:,end+1)] = spectrogram(...
			data.eeg(:,i), eegN, 0.0, 2 ^ nextpow2(eegN), data.eeg_f);
	end
	if ~exist('Bands','var'); Bands= [0 : floor(max(eegF))];end;
	
    %% 修改Bands 成为n_by_2
    
    if isvector(Bands)
       Bands2 = Bands(1:end-1);
       Bands2 = setrow(Bands2)';%1y
       Bands2(:,2)=Bands(2:end); %n_by_2
    else %n_by_2
        Bands2=Bands;
    end
    freqEnd = Bands2(:,2);
	eegSeg = [];%eeg FFTpower of each Band segment 
	for i=1:size(Bands2,1)
		BandNow=Bands2(i,:); %:=2nums
		ind = find( eegF>BandNow(1) & eegF<BandNow(2) );
		eegSeg(end+1,:) = mean(eegP(ind,:),1); %renew 1x as records in each Band
	end
	alongTime = (0:n-1)*Twin ; %time 刻度从0 开始，单位s。size of each eegSeg
