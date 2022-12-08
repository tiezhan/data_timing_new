function [h]=BF_plotPETH( dat_6000y10x, binsize_num, mode_char, errbar_char,xtick_2x )
%function [h]=BF_plotPETH( dat_6000y10x, binsize_num, mode_char, errbar_char,xtick_2x )
%
%h1=BF_plotPETH( Alg2tone, 500, 'SUM', [-20,40]);
%mode_char 'SUM' 'MEAN'
%errbar_char 'errorbar' 'noerrorbar' 
%2015-8-23 陈昕枫 BaseFrame
	[y6000,x10] = size(dat_6000y10x);
	[~, bindat_mean ,bindat_err] =  BF_nDatLine2Bins(dat_6000y10x, binsize_num);
	y1200 = length(bindat_mean); %等效y1200=y6000/binsize_num;

    %% 判断xtick_2x是否存在，若无 则补齐
    if ~exist('xtick_2x','var')
        xtick_2x=[0 y6000];
    end
        
	%% 严格要求xtick_2x [-20,40]。[-20,39.99]错误 [-20:x:40]错误
	xtick1 = xtick_2x;
	xtick1(2)=xtick1(2) - ( xtick1(2)-xtick1(1) )/y1200;
	xtick1 = linspace(xtick1(1),xtick1(2), y1200);
	
	%% 按model修正值幅度
    switch upper(mode_char)
        case 'SUM'
            y1 = bindat_mean * x10 * binsize_num;
            y1err=bindat_err * x10 * binsize_num;
        case  'MEAN'
            y1 = bindat_mean * binsize_num;
            y1err=bindat_err * binsize_num;
        otherwise
	end
	 % 	sum(y1) * 500*10
	%% 按errorbar决定是否打印误差区
	switch upper(errbar_char)
        case  'ERRORBAR'
            h=BF_plotwSEM(xtick1,y1,y1err);
        case  'NOERRORBAR'
            h=plot(xtick1,y1);
        otherwise
    end
   
end%end function