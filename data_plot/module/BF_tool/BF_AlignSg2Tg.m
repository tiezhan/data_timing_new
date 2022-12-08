function [Alg_msXn]=BF_AlignSg2Tg(LickorGC, Trgger, wds_L,wds_R,Mode)
% GCAlg2Tone = BF_AlignSg2Tg ( GCamp_data, MdfLST_tone, -4000, 4999, 'line');--Mode1
% LickAlg2Tone = BF_AlignSg2Tg ( LST_Lick, LST_tone, -4000, 4999, 'dot');--Mode2
% Alg_msXn: ÿ1y ����һ�μ�¼
%	------Mode1-----
%	������� GCamp_data��1ά�����������100s 100*Ƶ�ʸ���     ��'line'��
%	������� GCAlg2Tone������ֵ��ȫ������GCamp_data��ÿһy����һ��trail
%
%	------Mode2-----
%	������� LST_Lick��1ά�����������100s ����������lick����   ��'dot'��
%	������� LickAlg2Tone: ����=0 1��1��ʾ������Lick��
%	2015-8-21 ��꿷� BaseFrame
	


	Sg1=[];Fl=[];Sg=[];
	Sg1 = reshape(  LickorGC,1,length(LickorGC)  );
	Fl = reshape(  Trgger,1,length(Trgger)  );
	switch Mode
		case 'line'
			Sg = Sg1;
		case 'dot'
			Sg = zeros(1,max(Fl)+wds_R);%sg1 Ϊdot ʱ���
			Sg(Sg1)=1;	%sg Ϊline������ʱ���ᣬ1Ϊ�¼�������0Ϊδ������			
		otherwise
			error('��������쳣');
			return;
	end
	clear Sg1;
	
	x=Fl;%������
	y=(wds_L:wds_R)';%������
    
%     %����1
% 	X=ones(length(y),1)* x;
% 	Y=y*ones(1,length(x));
% 	Z=X+Y; 		%����ΪTrgger�Ĵ���n������Ϊwds�����-4000~4999ms��9000*n �ľ���
 
    %����2
    Z=BF_ArrXmodelArrY(x,y,'+');
    
    %ͬ
	clear x y X Y;
	
	Alg_msXn=Sg(int64(Z));  %����Ϊtone������������Ϊ-4~+5s ��

	%%��Algֻ��1�����������Ϊ1x����Ϊ1y
	[a,~]=size(Alg_msXn);
	if a==1 %��Ϊ1x��������Ϊ1y
		Alg_msXn=Alg_msXn';
	end
	
end %end function
