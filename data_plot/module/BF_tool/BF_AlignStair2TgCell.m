function Alg_cell = BF_AlignStair2TgCell(Lick_and_dur, Trigger, wds_L, wds_R)
%���봥����Χ�ĳ������¼������棺��������Ҵ���Խ��
%function Alg_cell = BF_AlignStair2TgCell(Lick_and_dur, Trigger, wds_L, wds_R)
%  ----Input ����---------
%   Lick_and_dur: ��Χ�¼���timestamp, 2y nums, [��ʼʱ��, ����ʱ��]
%   Trgger      : �����¼���timestamp��1v
%   wds_L       ��������࣬�� [-2]
%   wds_R       : �����Ҳ࣬�� [2]
%  
%  ----Output ����---------
%   Alg_cell    : ��Χʱ���ش����Ķ��룬1x cell of 2y nums, [��ʼʱ��, ����ʱ��]
    %% ����
    ld = Lick_and_dur;
    assert(size(ld, 2)==2);
    assert(isvector(Trigger) && isscalar(wds_L) && isscalar(wds_R));
    ntrial = length(Trigger);
    Alg_cell = cell(1, ntrial); %1x;
    
    %% ����
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
