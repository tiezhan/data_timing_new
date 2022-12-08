function [Alg_msXn]=BF_AlignSg2Tg(LickorGC, Trgger, wds_L,wds_R,Mode)
% GCAlg2Tone = BF_AlignSg2Tg ( GCamp_data, MdfLST_tone, -4000, 4999, 'line');--Mode1
% LickAlg2Tone = BF_AlignSg2Tg ( LST_Lick, LST_tone, -4000, 4999, 'dot');--Mode2
% Alg_msXn: 每1y 代表一次记录
%	------Mode1-----
%	输入参数 GCamp_data：1维横或竖向量，100s 100*频率个点     故'line'。
%	输出参数 GCAlg2Tone：数据值完全来自于GCamp_data。每一y代表一次trail
%
%	------Mode2-----
%	输入参数 LST_Lick：1维横或竖向量，100s 但点数等于lick次数   故'dot'。
%	输出参数 LickAlg2Tone: 数据=0 1，1表示发生过Lick。
%	2015-8-21 陈昕枫 BaseFrame
	


	Sg1=[];Fl=[];Sg=[];
	Sg1 = reshape(  LickorGC,1,length(LickorGC)  );
	Fl = reshape(  Trgger,1,length(Trgger)  );
	switch Mode
		case 'line'
			Sg = Sg1;
		case 'dot'
			Sg = zeros(1,max(Fl)+wds_R);%sg1 为dot 时间点
			Sg(Sg1)=1;	%sg 为line的完整时间轴，1为事件发生，0为未发生。			
		otherwise
			error('输出参数异常');
			return;
	end
	clear Sg1;
	
	x=Fl;%横向量
	y=(wds_L:wds_R)';%竖向量
    
%     %方法1
% 	X=ones(length(y),1)* x;
% 	Y=y*ones(1,length(x));
% 	Z=X+Y; 		%横向为Trgger的次数n，纵向为wds定义的-4000~4999ms，9000*n 的矩阵
 
    %方法2
    Z=BF_ArrXmodelArrY(x,y,'+');
    
    %同
	clear x y X Y;
	
	Alg_msXn=Sg(int64(Z));  %横向为tone的轮数，纵向为-4~+5s 。

	%%若Alg只有1向量，会输出为1x，改为1y
	[a,~]=size(Alg_msXn);
	if a==1 %若为1x向量，改为1y
		Alg_msXn=Alg_msXn';
	end
	
end %end function
