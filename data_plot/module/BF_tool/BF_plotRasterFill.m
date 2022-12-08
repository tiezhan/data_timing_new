classdef BF_plotRasterFill < handle
%hobj = BF_plotRasterFill(data:每1y=1trail ,默xtick:2num,默color:cell)
%       data: AlgScore，每1y代表1trail. 且是分类数据
%       xtick: 如[-10 20],光栅条状物的[中心点]！
%       color：各子类的初始颜色。cell of 3num
%
%--自带调整[colorbar 颜色映射 & 标签映射]的菜单工具！
    properties %value	       
		dat	%光栅数据；被归一化，每1y代表1trail. 
		names %光栅下的种类名；cell体, 字符串
        ntype %光栅下的种类数；num
		colors %光栅的颜色；cell体，1*3num
    end
    properties  % UI obj      
		hfig %依赖的figure
		haxes %依赖的axes
		hmenu %根菜单对象
		hmenu_C %多个color菜单对象
		hCImg %(color image) imagesc对象
		hCBar %(color bar)  colorbar对象
	end
	events
		evt_rename %菜单按钮更改'名称'
		evt_Cchange %菜单按钮更改'色彩'
    end
    
    methods
		function hobj=BF_plotRasterFill(dat_6000y10x, xtick_2num,color_3arr)
        %在gca的基础上创建Raster！
			hobj.hfig=gcf;
			hobj.haxes=gca;
            hold on;
            if ~exist('xtick_2num','var');
                xtick_2num=[1,size(dat_6000y10x,1)];
            elseif isempty(xtick_2num)
                xtick_2num=[1,size(dat_6000y10x,1)];
            end
            
            %归一化dat
            hobj.remap(dat_6000y10x);
            
			%整合color
			if ~exist('color_3arr','var')
				color_3arr=num2cell(get(gca,'colororder'),2);
			end
			if isempty(color_3arr)
				color_3arr=num2cell(get(gca,'colororder'),2);
			end			
			hobj.colors = repmat(color_3arr,...
					ceil(hobj.ntype/length(color_3arr)),1);
			hobj.colors(hobj.ntype+1:end)=[]; %去尾
			
			%制作菜单 控制器
			hobj.createMenu();

			%制作热图
			hobj.createColormap();
            
            %修饰热图x轴
            set(hobj.hCImg,'xData',xtick_2num);
            axis(hobj.haxes,'tight');
            
			%监听并初始化
			addlistener(hobj,'evt_rename',@hobj.when_rename);
			addlistener(hobj,'evt_Cchange',@hobj.when_Cchange);
			notify(hobj,'evt_rename');
			notify(hobj,'evt_Cchange');
		end

		function remap(hobj,orgdat)
			orgtypes = unique(orgdat);
			hobj.ntype = length(orgtypes);

			%归一化
			normdat = ones(size(orgdat));
			for i=1:length(orgtypes)
				ind=orgdat==orgtypes(i);
				normdat(ind)=i;
			end
			hobj.dat = normdat;
			temp = num2cell(orgtypes);
			hobj.names = cellfun(@num2str,temp,'UniformOutput', false);
		end

		function createMenu(hobj)
		%-|修正热图|
		%--|更改标签名|
		%--------------
		%--|标签( 3 )|
		%--|标签( 2 )|
		%--|标签( 1 )|
			hobj.hmenu = uimenu('Parent',hobj.hfig,'label','修整热图');
			uimenu('parent',hobj.hmenu,'label','更改标签名',...
					'callback',@hobj.ui_barrename);
			for i=1:hobj.ntype
				ind = hobj.ntype+1-i;
				tempm(i)=uimenu('Parent',hobj.hmenu,'label','NULL',...
						'callback',@(o,e)hobj.ui_menuc(o,e,ind));
			end
			set(tempm(1),'Separator','on');
			hobj.hmenu_C=tempm(end:-1:1);
		end

		function createColormap(hobj)
            axes(hobj.haxes);
			hobj.hCImg=imagesc(hobj.dat');
			set(hobj.haxes,'TickDir','out');
			range=[0.5,hobj.ntype+0.5];
			caxis(range);
			hobj.hCBar=colorbar;
			set(hobj.hCBar,'ticks',1:hobj.ntype,'limits',range,...
                    'TickDirection','out','TickLength',0);
        end

		function ui_menuc(hobj,~,~,i)
			c=uisetcolor(hobj.colors{i},'Select a color');
			hobj.colors{i}=c;
                        
            %notify
            notify(hobj,'evt_Cchange');
		end

		function ui_barrename(hobj,~,~)
		%-|Input|
		%--|名字( 3 )|
		%--|名字( 2 )|
		%--|名字( 1 )|
			promp=repmat({''},1,hobj.ntype);
			promp{1}='Write a new name:';
			def=flip(hobj.names);
			answer = inputdlg(promp,'Input',1,def);
			if isempty(answer);return;end
			hobj.names = flip(answer);
            
            %notify
            notify(hobj,'evt_rename');
		end
		
		function when_rename(hobj,~,~)
			for i=1:hobj.ntype
				set(hobj.hmenu_C(i),'label',['彩:',hobj.names{i}]);
			end
			set(hobj.hCBar,'ticklabels',hobj.names);
		end

		function when_Cchange(hobj,~,~)
			for i=1:hobj.ntype
				set(hobj.hmenu_C(i),'ForegroundColor',hobj.colors{i});
			end
			mycolor = cell2mat(reshape(hobj.colors,length(hobj.colors),1));
			colormap(hobj.haxes,mycolor);
		end

	end

end
