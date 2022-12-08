function [phy2logic, logic2phy] = assignChanName(data_ny, Fs, names_cell)
%利用GUI确定采样的通道的映射关系（硬件通道1：n映射到逻辑通道 X ）
%function [phy2logic, logic2phy] = assignChanName(data_ny, Fs, names_cell)
%----Input 参数---------
% data_ny       : 要排列通道的数据，1y=1channel
% Fs            : 采样率，缺省则=1
% names_cell    : 逻辑通道的名字, 1v cells of string, 可缺省
%
%----Output 参数---------
% phy2logic     : 物理通道1:n -> 逻辑通道X
% logic2phy     : 逻辑通道1:n -> 物理通道X, 映射错误则取Nan

    %% arg check and pad
    nChan = size(data_ny,2);
    assert( nChan>=1 );
    if ~exist('Fs', 'var');Fs = 1;end
    if ~exist('names_cell', 'var')
        names_cell = cellfun(@(chani)sprintf('逻辑通道%d', chani),...
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