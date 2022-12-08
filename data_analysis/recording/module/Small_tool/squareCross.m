function hpatchs = squareCross(num1, num2, num_merge)
%用两个正方形的重叠图，表示两个有重叠的计数
%function hpatchs = squareCross(num1, num2, num_merge)
%----Input 参数---------
% num1, num2  : num, 各自的
% num_merge   : num, 重叠的
%
%----Output 参数---------
% hpatchs     : 1x3; 正方形patch; 1-num1, 2-num2, 3-merge
%
%----Example-------------
%squareCross(100, 64, 16)

    % 参数
    color1 = [0 0.447 0.741];
    color2 = [0.930 0.690 0.130];
    color_merge = [0.85 0.325 0.098];
    facealpha = 1;
    linewidth = 1;
    
    % 输入参数校验
    assert(isscalar(num1) && isscalar(num2) && isscalar(num_merge));
    assert(num1>0 && num2>0 && num_merge>0);
    assert(num_merge < min([num1, num2]));
    
    % 计算
    len1 = sqrt(num1);
    len2 = sqrt(num2);
    len_merge = sqrt(num_merge);
    xpoint1 = [0 len1 len1 0];
    ypoint1 = [0 0 len1 len1];
    xpoint2 = len1 - len_merge + [0 len2 len2 0];
    ypoint2 = len_merge - len2 + [0 0 len2 len2];
    xpoint_merge = len1 - len_merge + [0 len_merge len_merge 0];
    ypoint_merge = [0 0 len_merge len_merge];
    
    % 画图
    hold on;
    axis equal
    funpatch = @(X,Y,C)patch(X,Y,C,'facealpha',facealpha,'LineWidth',linewidth);
    hpatchs(1) = funpatch(xpoint1, ypoint1, color1);
    hpatchs(2) = funpatch(xpoint2, ypoint2, color2);
    hpatchs(3) = funpatch(xpoint_merge, ypoint_merge, color_merge);
    if nargout ==0; clear hpatchs; end
end