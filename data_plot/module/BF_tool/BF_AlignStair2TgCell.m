function Alg_cell = BF_AlignStair2TgCell(Lick_and_dur, Trigger, wds_L, wds_R)
%对齐触发周围的持续性事件，警告：不检查左右窗口越界
%function Alg_cell = BF_AlignStair2TgCell(Lick_and_dur, Trigger, wds_L, wds_R)
%  ----Input 参数---------
%   Lick_and_dur: 周围事件的timestamp, 2y nums, [开始时间, 持续时间]
%   Trgger      : 触发事件的timestamp，1v
%   wds_L       ：窗口左侧，如 [-2]
%   wds_R       : 窗口右侧，如 [2]
%  
%  ----Output 参数---------
%   Alg_cell    : 周围时间沿触发的对齐，1x cell of 2y nums, [开始时间, 持续时间]
    %% 检验
    ld = Lick_and_dur;
    assert(size(ld, 2)==2);
    assert(isvector(Trigger) && isscalar(wds_L) && isscalar(wds_R));
    ntrial = length(Trigger);
    Alg_cell = cell(1, ntrial); %1x;
    
    %% 对齐
    ld_bgend =  [ld(:,1), ld(:,1)+ld(:,2)];
    for i=1:ntrial
        trg_now = Trigger(i);
        ld_now = ld_bgend - trg_now;
        ld_now = constrainNumber(ld_now, wds_L, wds_R );
        ld_now(ld_now(:,1) == ld_now(:,2), :) = [];
        ld_bgdur = [ld_now(:,1), ld_now(:,2)-ld_now(:,1)];
        Alg_cell{i} = ld_bgdur;
    end
end
