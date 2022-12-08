function [Xsort_v,Ymean_v]=BF_YmeaninX(X_v,Y_v,model)
%function [Xsort_v,Ymean_v]=BF_YmeaninX(X_v,Y_v); %Yÿ���� mean
%function [Xsort_v,Yrand_v]=BF_YmeaninX(X_v,Y_v,'rand'); %Yÿ���� rand
%2015-11-9 ��꿷�
%����ͬX��Y�ľ�ֵ��Ȼ�����Yֵ
%������������� ������ġ�����X_v Y_vҪ�ϸ��Ӧ��

%X_v=[1 1 2 2  2 3 4 4 4 5 5 6];Y_v=[1 2 3 4 5 6 7 8 9 10 11 7];
%��Ysortmean_v =1.5 1.5 4 4 4 6 8 8 8 10.5 10.5 7],Xsort_v==X_v;
	
	%%��һ��ģʽ ��mean
	if ~isvector(X_v)||~isvector(Y_v);error('�������Ҫ��Ϊ����');end;
	[X,ix]= sort(X_v); 
	Y = Y_v(ix);
	
	[~,in_str,~] = unique(X);
	temp1 = in_str;temp1(end+1)=length(X)+1;
	in_count = diff([temp1]);
	in_end = in_str + in_count -1;
    for i=1:length(in_str)
        Y2(in_str(i):in_end(i)) = mean( Y(in_str(i):in_end(i)) );
    end
	Xsort_v = X;
	Ymean_v = reshape(Y2,size(Y_v));
	
	%%�ڶ���ģʽ ��random
	if ~exist('model','var'); return;end;
	if ~strcmp(model,'rand');return;end;
	% else ����������������
	for i=1:length(in_str)
		temp2 = Y(in_str(i):in_end(i));
		temp2ind = randperm(length(temp2));
		temp2 = temp2(temp2ind);
		Y2(in_str(i):in_end(i)) = temp2;
    end
    Xsort_v = X;
	Ymean_v = reshape(Y2,size(Y_v));