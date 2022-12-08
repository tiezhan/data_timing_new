classdef BF_plotRasterFill < handle
%hobj = BF_plotRasterFill(data:ÿ1y=1trail ,Ĭxtick:2num,Ĭcolor:cell)
%       data: AlgScore��ÿ1y����1trail. ���Ƿ�������
%       xtick: ��[-10 20],��դ��״���[���ĵ�]��
%       color��������ĳ�ʼ��ɫ��cell of 3num
%
%--�Դ�����[colorbar ��ɫӳ�� & ��ǩӳ��]�Ĳ˵����ߣ�
    properties %value	       
		dat	%��դ���ݣ�����һ����ÿ1y����1trail. 
		names %��դ�µ���������cell��, �ַ���
        ntype %��դ�µ���������num
		colors %��դ����ɫ��cell�壬1*3num
    end
    properties  % UI obj      
		hfig %������figure
		haxes %������axes
		hmenu %���˵�����
		hmenu_C %���color�˵�����
		hCImg %(color image) imagesc����
		hCBar %(color bar)  colorbar����
	end
	events
		evt_rename %�˵���ť����'����'
		evt_Cchange %�˵���ť����'ɫ��'
    end
    
    methods
		function hobj=BF_plotRasterFill(dat_6000y10x, xtick_2num,color_3arr)
        %��gca�Ļ����ϴ���Raster��
			hobj.hfig=gcf;
			hobj.haxes=gca;
            hold on;
            if ~exist('xtick_2num','var');
                xtick_2num=[1,size(dat_6000y10x,1)];
            elseif isempty(xtick_2num)
                xtick_2num=[1,size(dat_6000y10x,1)];
            end
            
            %��һ��dat
            hobj.remap(dat_6000y10x);
            
			%����color
			if ~exist('color_3arr','var')
				color_3arr=num2cell(get(gca,'colororder'),2);
			end
			if isempty(color_3arr)
				color_3arr=num2cell(get(gca,'colororder'),2);
			end			
			hobj.colors = repmat(color_3arr,...
					ceil(hobj.ntype/length(color_3arr)),1);
			hobj.colors(hobj.ntype+1:end)=[]; %ȥβ
			
			%�����˵� ������
			hobj.createMenu();

			%������ͼ
			hobj.createColormap();
            
            %������ͼx��
            set(hobj.hCImg,'xData',xtick_2num);
            axis(hobj.haxes,'tight');
            
			%��������ʼ��
			addlistener(hobj,'evt_rename',@hobj.when_rename);
			addlistener(hobj,'evt_Cchange',@hobj.when_Cchange);
			notify(hobj,'evt_rename');
			notify(hobj,'evt_Cchange');
		end

		function remap(hobj,orgdat)
			orgtypes = unique(orgdat);
			hobj.ntype = length(orgtypes);

			%��һ��
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
		%-|������ͼ|
		%--|���ı�ǩ��|
		%--------------
		%--|��ǩ( 3 )|
		%--|��ǩ( 2 )|
		%--|��ǩ( 1 )|
			hobj.hmenu = uimenu('Parent',hobj.hfig,'label','������ͼ');
			uimenu('parent',hobj.hmenu,'label','���ı�ǩ��',...
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
		%--|����( 3 )|
		%--|����( 2 )|
		%--|����( 1 )|
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
				set(hobj.hmenu_C(i),'label',['��:',hobj.names{i}]);
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
