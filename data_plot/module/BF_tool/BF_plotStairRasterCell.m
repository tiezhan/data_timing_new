function h=BF_plotStairRasterCell(dat_cell,color_3arr)
%��cell��ʽ�����դ���ݣ�
%function h=BF_plotStairRasterCell(dat_cell,color_3arr)
%hpatch=BF_plotRasterCell(SweepTicks)
%----Input ����---------
% dat_cell    : ��դ���ݣ�cell_1v of ��ֵ2y
% color_3arr  : ��դ��ɫ����ѡ
%
%----Output ����---------
% h           : ��դ��line���
%% �����������
	if ~exist( 'color_3arr','var')
        color_3arr =[0.5 0.5 0.5];
    end

%% plot
    hold on;
	h=matlab.graphics.primitive.Patch.empty(1,0);
	for i=1:length(dat_cell)
        dat_temp = dat_cell{i};
        for j=1:size(dat_temp, 1)
            dat_now = dat_temp(j, :); %[begin, duration]
            xdata = dat_now(1)+[0, dat_now(2), dat_now(2), 0];
            ydata = i - 1 + [0 0 1 1];
            h(end+1) = patch('XData',xdata,'YData',ydata,'FaceAlpha',0.5,...
                    'LineStyle','none','FaceColor',color_3arr);
        end
	end
