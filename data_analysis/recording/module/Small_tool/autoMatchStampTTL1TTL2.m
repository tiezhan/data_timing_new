function delta = autoMatchStampTTL1TTL2(TTL1, TTL2)
% 自动匹配邮戳
% function delta = autoMatchStampTTL1TTL2(TTL1, TTL2)
% ---------------INPUT 参数--------------
% TTL1, TTL2     : timestamp, 1v
%
% ---------------OUTPUT 参数-------------
% delta          : TTL2_new = TTL1 + delta;
%

    TTL1a = TTL1 - TTL1(1);
    TTL2a = TTL2 - TTL2(1);

    TTL1a = sort(TTL1a);
    TTL2a = sort(TTL2a);
    t1 = range(TTL1a);
    t2 = range(TTL2a);
    t_max = max([t1, t2]);
    TTL1b = TTL1a / t_max;
    TTL2b = TTL2a / t_max;

    %% 固定TTL1，改变TTL2
    tRange = [-t2, t1]/t_max;
    n = 1000;
    dts = linspace(tRange(1), tRange(2), n);
    scores = zeros(n, 1);
    for i=1:n
        scores(i) = every_dt_assess(TTL1b, TTL2b, dts(i));
    end
    ind = find(scores == min(scores), 1, 'first');
    if ind==1
        inds = [0 1];
    elseif ind == 100
        inds = [-1 0]+n;
    else
        inds =  [-1 1] + ind;
    end

    %% 二次迭代
    dts2 = linspace(dts(inds(1)), dts(inds(2)), n);
    scores2 = zeros(n, 1);
    for i=1:n
        scores2(i) = every_dt_assess(TTL1b, TTL2b, dts2(i));
    end
    ind2 = find(scores2 == min(scores2), 1, 'first');
    dt = dts2(ind2);

    %% 逆变换成原来
    fun_t = @(t)t*t_max - TTL2(1) + TTL1(1);
    delta = fun_t(dt);

    if nargout==1; return; end
    figure; 
    subplot(2,1,1);hold on;
    plot(fun_t(dts), scores);
    plot(fun_t(dt), min(scores2), 'ro');
    subplot(2,1,2)
    hold on;
    barline(TTL1,[0, 1],'k');
    barline(TTL2,[0.5, 1.5],'r:');
    barline(TTL2 + fun_t(dt),[0.5, 1.5],'r');
    legend('TTL1', 'TTL2', 'TTL2 new');
    title(sprintf('TTL2(new) = TTL2 - delta\ndelta=%.2f', delta));
end

function score = every_dt_assess(TTL1, TTL2, dt)
    %score = 0(好) ~ 1(不好)
    TTL2 = TTL2 + dt;

    diff_t = bsxfun(@minus, set1x(TTL1), set1y(TTL2));
    score1 = min(abs(diff_t));
    score2 = min(abs(diff_t), [], 2);
    k = 1000;
    fun_penalty = @(x)(1-exp(-k *x)); % range [0-1]
    % fun_penalty = @(x)x;
    score = min([mean(fun_penalty(score1)), mean(fun_penalty(score2))]);
end