function [ToneforPump_1x,TonenoPump_1x]=BF_ToneSPbyPump(Tone_1x,Pump_1x,Left_num,Right_num)
%function [ToneforPump_1x_dot,TonenoPump_1x_dot] ...
%		= ToneSPbyPump(Tone_1x_dot,Pump_1x_dot,Left_num,Right_num)
%[T4P,TnoP]=ToneSPbyPump(lsttone,lstpump,500,2500)
% pump - tone=(500~2500)。tone持续0.5s 响应窗口2s
%区分hit的tone，miss的tone；light同理
%2015-8-22 陈昕枫 BaseFrame
%2015-9-16 优化，使用不同方法

	%构建（行：Tone）和（列：Pump）矩阵相减
	caMin=Left_num; caMax=Right_num;
    
%   %方法一
%   x=Tone_1x;y=Pump_1x;
%     X = reshape(x,1,length(x));%横向量，被减数 Tone
%  	Y = reshape(y,length(y),1);%纵向量，减数 Pump
%     Xfull = ones(length(Y),1) * X;
%     Yfull = Y * ones(1,length(X)); 
%     ZZ = Yfull - Xfull;
% 	clear x y X Y Xfull Yfull;
% 
% 	%查找矩阵范围内，大小在500~2500的值，就是要的匹配点
%     [Pump_index,Tone_index]=find((ZZ>caMin).* (ZZ<caMax));

 %方法2 2015-9-16
    x=Pump_1x;  y=Tone_1x;
    ZZ = BF_ArrXmodelArrY(x,y,'-');
    Zlogic = (ZZ>caMin).* (ZZ<caMax);
    [Tone_index,Pump_index]=find(Zlogic );
 
%  %方法3 2015-9-16
%     Tone_index=[];  Pump_index=[];
%     for pumpi=1:length(Pump_1x)
%         for tonei=1:length(Tone_1x)
%             ca = Pump_1x(pumpi)-Tone_1x(tonei);
%             if ca>caMin && ca<caMax
%                 Tone_index(end+1)=tonei;
%                 Pump_index(end+1)=pumpi;
%             end
%         end
%      end
    %相同
    ToneforPump_1x=Tone_1x(Tone_index);
    TonenoPump_1x=Tone_1x;
    TonenoPump_1x(Tone_index)=[];
	
    if length(Pump_index) ~=length(Pump_1x)
        disp('错误：无法进一步细分！');
    end

end