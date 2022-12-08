function [wk] = splitbyweek(data)
wk1 = mean(data(:,1:5),2,'omitnan');
wk2 = mean(data(:,14:18),2,'omitnan');
wk4 = mean(data(:,28:32),2,'omitnan');
wk = horzcat(wk1,wk2,wk4);