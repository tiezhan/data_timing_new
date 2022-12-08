function [data_eachBin,data_mean,data_errorbar,PSTH]=BF_nDatLine2Bins(data_in, bin_siz)
%[~,data_mean:=18*40,~,psth] = BF_nDatLine2Bins (data_in:=9000*40, bin_siz:=500)
%		data_in: ÿ1y����1trail
%		data_eachBin: ÿ1y����1trail
%		data_mean: 1y
%		data_errorbar: 1y
%		psth:1y, data_mean���ۻ�
%
%�Զ��޽�data_in�ĳ���,����ĩβ���� 2016-7-28
%2015-8-21
%��꿷� BaseFrame

	[n9000,n40]=size(data_in);
    n9000 = max(0:bin_siz:n9000);
    data_in = data_in(1:n9000,:);%�Զ��޽�data_in�ĳ���
	x=reshape(data_in,bin_siz,n9000*n40/bin_siz); %500����* ����9000*40/500
	if bin_siz==1 %#ok<ALIGN>
        x2=x;               %��1��bin��������
    else
        x2=mean(x);			%1����* ����9000*40/500
    end
    data_eachBin=reshape(x2,n9000 / bin_siz,n40);

	data_mean=mean(data_eachBin,2);
	data_errorbar=(std(data_eachBin')/sqrt(n40))';%��data_dfF���������ʺ�ӡ����ó������У����ټӡ�
	PSTH = data_mean*bin_siz*size(data_in,2);
end
