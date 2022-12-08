function [sucrate] = calsucrate(data,order)
if order == 1 %% seperate data by DAY
new = splitDAY(data)
 sucrate = []
for i= 1:size(new,2)
    day1 = new(:,i)
    dd1 = day1(isfinite(day1))
   
    m = 0
    for j =1:length(dd1)
        if dd1(j) >1.9 && dd1(j) <3.1
            m = m + 1
        end
    end
    rate_wait = m/length(dd1);
sucrate = [sucrate rate_wait];    
end
end

if order == 2 %% seperate data by week
new = splitbyweek(data)
 sucrate = []
for i= 1:size(new,2)
    day1 = new(:,i)
    dd1 = day1(isfinite(day1))
   
    m = 0
    for j =1:length(dd1)
        if dd1(j) >1.9 && dd1(j) <3.1
            m = m + 1
        end
    end
    rate_wait = m/length(dd1);
sucrate = [sucrate rate_wait];    
end
end

if order == 3 %% seperate data by naive and trained
new = testmice(data)
 sucrate = []
for i= 1:size(new,2)
    day1 = new(:,i)
    dd1 = day1(isfinite(day1))
   
    m = 0
    for j =1:length(dd1)
        if dd1(j) >1.9 && dd1(j) <3.1
            m = m + 1
        end
    end
    rate_wait = m/length(dd1);
sucrate = [sucrate rate_wait];    
end
end


