function h=BF_plotStairRasterCell(dat_cell,color_3arr)
%用cell格式储存光栅数据，
%function h=BF_plotStairRasterCell(dat_cell,color_3arr)
%hpatch=BF_plotRasterCell(SweepTicks)
%----Input 参数---------
% dat_cell    : 光栅数据，cell_1v of 数值2y
% color_3arr  : 光栅颜色，可选
%
%----Output 参数---------
% h           : 光栅的line句柄
%% 处理输入参数
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
