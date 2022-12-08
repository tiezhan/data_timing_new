function sctbarplot(xxxx)
[r,c]= size(xxxx)
xdata =repmat(1:c,r,1)
scatter(xdata(:),xxxx(:),'MarkerFaceColor','k','MarkerEdgeColor','w','MarkerEdgeAlpha',0.5','jitter','on','jitterAmount',0.05)
 hold on 
 x = [1:c]
 y = mean(xxxx,'omitnan')
 sd= std(xxxx,'omitnan')
 sem = sd/sqrt(length(xxxx))
 e = errorbar(x,y,sem)
 e.CapSize = 40
 e.LineWidth = 2.0
 e.LineStyle = 'none'
 e.Color = 'k'
 xlim([0.5 c+0.5])
 xticks([1:c])

