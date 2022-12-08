function [ToneforPump_1x,TonenoPump_1x]=BF_ToneSPbyPump(Tone_1x,Pump_1x,Left_num,Right_num)
%function [ToneforPump_1x_dot,TonenoPump_1x_dot] ...
%		= ToneSPbyPump(Tone_1x_dot,Pump_1x_dot,Left_num,Right_num)
%[T4P,TnoP]=ToneSPbyPump(lsttone,lstpump,500,2500)
% pump - tone=(500~2500)��tone����0.5s ��Ӧ����2s
%����hit��tone��miss��tone��lightͬ��
%2015-8-22 ��꿷� BaseFrame
%2015-9-16 �Ż���ʹ�ò�ͬ����

	%�������У�Tone���ͣ��У�Pump���������
	caMin=Left_num; caMax=Right_num;
    
%   %����һ
%   x=Tone_1x;y=Pump_1x;
%     X = reshape(x,1,length(x));%�������������� Tone
%  	Y = reshape(y,length(y),1);%������������ Pump
%     Xfull = ones(length(Y),1) * X;
%     Yfull = Y * ones(1,length(X)); 
%     ZZ = Yfull - Xfull;
% 	clear x y X Y Xfull Yfull;
% 
% 	%���Ҿ���Χ�ڣ���С��500~2500��ֵ������Ҫ��ƥ���
%     [Pump_index,Tone_index]=find((ZZ>caMin).* (ZZ<caMax));

 %����2 2015-9-16
    x=Pump_1x;  y=Tone_1x;
    ZZ = BF_ArrXmodelArrY(x,y,'-');
    Zlogic = (ZZ>caMin).* (ZZ<caMax);
    [Tone_index,Pump_index]=find(Zlogic );
 
%  %����3 2015-9-16
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
    %��ͬ
    ToneforPump_1x=Tone_1x(Tone_index);
    TonenoPump_1x=Tone_1x;
    TonenoPump_1x(Tone_index)=[];
	
    if length(Pump_index) ~=length(Pump_1x)
        disp('�����޷���һ��ϸ�֣�');
    end

end