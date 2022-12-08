function [phy2logic, logic2phy] = assignChanName(data_ny, Fs, names_cell)
%����GUIȷ��������ͨ����ӳ���ϵ��Ӳ��ͨ��1��nӳ�䵽�߼�ͨ�� X ��
%function [phy2logic, logic2phy] = assignChanName(data_ny, Fs, names_cell)
%----Input ����---------
% data_ny       : Ҫ����ͨ�������ݣ�1y=1channel
% Fs            : �����ʣ�ȱʡ��=1
% names_cell    : �߼�ͨ��������, 1v cells of string, ��ȱʡ
%
%----Output ����---------
% phy2logic     : ����ͨ��1:n -> �߼�ͨ��X
% logic2phy     : �߼�ͨ��1:n -> ����ͨ��X, ӳ�������ȡNan

    %% arg check and pad
    nChan = size(data_ny,2);
    assert( nChan>=1 );
    if ~exist('Fs', 'var');Fs = 1;end
    if ~exist('names_cell', 'var')
        names_cell = cellfun(@(chani)sprintf('�߼�ͨ��%d', chani),...
                        num2cell(1:nChan), 'UniformOutput', false);
    end
    assert(length(names_cell) == nChan);

    
    %% draw
    hfig = figure;
    hold on;
    hlines = matlab.graphics.chart.primitive.Line.empty(0,0);
    for i=1:nChan
        hlines(i)=plotHz(Fs, data_ny(:,i), 'UserData', i); %assign to ind
    end
    % set self
    self.hlines = hlines;
    self.names_cell = names_cell;
    self.hax = gca;
    self.saver = timer('UserData',[]);
    % set right-click menu
    hcmenu = uicontextmenu;
    set(hlines, 'uicontextmenu', hcmenu);
    for i=1:nChan
        uimenu( hcmenu, 'Label', names_cell{i},...
                          'Callback', @(o,e)ui_menuChose(self, i));
    end
    xlabel('Time (sec)');
    ylabel('Amp');
    title('Assign Channels (save when close)')
    refreshLegend(self)

    %% wait for close
    while isvalid(hfig)
        pause(0.5);
    end
    
    %% Mapping
    phy2logic = set1y(self.saver.UserData);
    logic2phy = nan(nChan, 1);
    for i=1:nChan
        ind = find(phy2logic==i);
        if ~isscalar(ind); continue; end
        logic2phy(i) = ind;
    end
    delete(self.saver);
end

function ui_menuChose(self, i)
    set(gco(),'UserData',i);
    refreshLegend(self);
end

function refreshLegend(self)
    nChan = length(self.hlines);
    funa = @(i1, i2)sprintf('%d | %s', i1, self.names_cell{i2});
    legend(self.hax, arrayfun(funa, 1:nChan, [self.hlines.UserData], 'UniformOutput', false));
    self.saver.UserData = [self.hlines.UserData]; %save re-assignd index
end