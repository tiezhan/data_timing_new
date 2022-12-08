function YNow=line_scale(XR,YR,XNow)
%2016-1-21 ��꿷�
	%XR 2num, 'X range'
	%YR 2num, 'Y range'
	%XNow Matrix
	%YNow same Matrix size
	if numel(XR)~=2 || numel(YR)~=2 ;error('''XR'',''YR''Ӧ�ø�Ϊ2num');end
	if range(XR)==0; error('''XR''��2ֵ���');end
	k= (YR(2)-YR(1)) / (XR(2)-XR(1));
	b= (XR(1)*YR(2)-XR(2)*YR(1)) / (XR(1)-XR(2));
	fun1 = @(x)k*x+b;
	YNow = arrayfun(fun1,XNow);
end