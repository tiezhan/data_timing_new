function [wait0s,wait2s,wait3s] = setcondition(tRise_wait,tDur_wait)
wait0s=[];
dur0s=[];
lea0s=[];
for i = 1: size(tRise_wait,1)
     if (tDur_wait(i)>0 && tDur_wait(i)<1.2)
         wait0s(end+1)= tRise_wait(i);
          dur0s(end + 1) = tDur_wait(i);
          lea0s(end +1) = tRise_wait(i)+tDur_wait(i);
     end
end

wait0s = vertcat(wait0s, lea0s,lea0s+1,dur0s);

wait2s=[];
dur2s=[];
lea2s=[];
for i = 1: size(tRise_wait,1)
     if (tDur_wait(i)>1.9 && tDur_wait(i)<2.9)
         wait2s(end+1)= tRise_wait(i);
         dur2s(end + 1) = tDur_wait(i);
         lea2s(end +1) = tRise_wait(i)+tDur_wait(i);
     end
end
wait2s = vertcat(wait2s, lea2s,lea2s+1,dur2s);

wait3s=[];
dur3s=[];
lea3s=[];
for i = 1: size(tRise_wait,1)
     if (tDur_wait(i)>2.9 && tDur_wait(i)<3.9)
         wait3s(end+1)= tRise_wait(i);
         dur3s(end + 1) = tDur_wait(i);
         lea3s(end +1) = tRise_wait(i)+tDur_wait(i);
     end
end

wait3s = vertcat(wait3s, lea3s, lea3s+1,dur3s);