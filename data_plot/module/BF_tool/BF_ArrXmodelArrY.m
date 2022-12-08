function [Z_Matix] = BF_ArrXmodelArrY(X_1v,Y_1v,model) %1v��ʾ 1x or 1y
%function [Matix_Z] = BF_ArrXsubArrY(X_1v,Y_1vm,model)
%Z=BF_ArrXsubArrY(lstpump,lsttone,'-');
%model= '+' '-' '*' '/'
%2015-9-16 ��꿷�?BaseFrame
	X_1x = reshape(X_1v,1,length(X_1v)); %1x
	Y_1y = reshape(Y_1v,length(Y_1v),1); %1y
	switch model
		case '+'
		f1 = @ (x) (x+Y_1y); %xΪnum,Y_1yΪ����
		
		case '-'
		f1 = @ (x) (x-Y_1y);
		
		case '*'
		f1 = @ (x) (x.*Y_1y); %��Ҫ��
		
		case '/'
		f1 = @ (x) (x./Y_1y);
		
		otherwise
			error(' �������model����');
			return
	end
	
	cell1 = arrayfun(f1,X_1x,'UniformOutput',false);
	Z_Matix = cell2mat(cell1);