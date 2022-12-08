function Alg_sXtrail = BF_AlignWave2Tg(Wave, Trigger, wds_L, wds_R, ifshow)
% �������ź� ���� ĳʱ�����
% Alg_sXtrail = BF_AlignWave2Tg(Wave, Trigger, wds_L, wds_R, ifshow)
% 
% --------------Input ����-----------
% Wave           :  �����ź�, 1v
% Trigger        :  ��Ҫ����ġ������¼���, 1v
% wds_L, wds_R   :  ʱ�䴰�ڣ���λ������
% ifshow         :  �Ƿ񻭳�ͼ����ʡ��(Ĭ�ϲ���)
%
% --------------Output ����-----------
% Alg_sXtrail    :  �������ź�, ���ڲ����� x �������¼�������
% ͼ��չʾ        :  ��� ifshow==true, չʾ��ͼ�;�ֵͼ
%

    %% check & adjust paras
    assert(isvector(Wave));
    assert(isvector(Trigger));
    assert(isscalar(wds_L));
    assert(isscalar(wds_R));
    assert(wds_R > wds_L);
    
    Wave = reshape( Wave, [], 1);        %1y
    Trigger = reshape( Trigger, [], 1);  %1y
    Trigger = floor(Trigger);
    wds_L   = floor(wds_L);
    wds_R   = floor(wds_R);
    
    if ~exist('ifshow', 'var'); ifshow = false; end
    
    %% clean out "Trigger" invalid head and tail
    len = length(Wave);
    ind_dirty = (Trigger + wds_L <=0)| (Trigger +wds_R >len);
    if any(ind_dirty)
        warn( sprintf('flag ��������/�ܺ� = %.0f/%.0f, �Զ�����', ...
              sum(ind_dirty), length(Trigger)) );
        Trigger(ind_dirty) = [];
    end
    ind_dirty = isnan(Wave(Trigger + wds_L)) | isnan(Wave(Trigger + wds_R));
    if any(ind_dirty)
        warn( sprintf('��nan����/�ܺ� = %.0f/%.0f���Զ�����', ...
                sum(ind_dirty), length(Tigger)) );
        Trigger(ind_dirty) = [];
    end
    ntrial = length(Trigger);
    assert(ntrial>=1, 'flag ����̫��');
    %% calculate
    Alg_sXtrail = zeros(wds_R - wds_L + 1, ntrial);
    for i=1:ntrial
        trigger_now = Trigger(i);
        ind_choose = trigger_now + (wds_L : wds_R);
        Alg_sXtrail(:, i) = Wave(ind_choose);
    end
    
    %% ifshow
    if ifshow
        Alg_mean = mean(Alg_sXtrail, 2);
        
        figure;
        subplot(3, 1, 1); hold on;
        xtick = wds_L : wds_R;
        ytick = 1:ntrial;
        imagesc(xtick, ytick, Alg_sXtrail');
        xlabel('sample tick');
        ylabel('trial (#)');
        axis tight
        subplot(3, 1, 2); hold on;
        plot(xtick, Alg_sXtrail', 'color', 0.2*[1 1 1]);
        plot(xtick, Alg_mean, 'color', [1 0 0], 'linewidth', 2);
        xlabel('sample tick');
        ylabel('Amp');
        
        subplot(3, 1, 3); hold on;
        if ntrial<=1; return; end;
        Alg_sem = std(Alg_sXtrail, 0, 2) / sqrt(ntrial);
        h_mean = BF_plotwSEM(xtick, Alg_mean, Alg_sem);
        set(h_mean, 'color', [1 0 0], 'linewidth', 2);
        ylabel('Amp');
    end