function [out] = paringseq(Time_Lick,Time_Tone)
A = Time_Lick
B = Time_Tone
m_start = 1
out = []
for i = 1:length(A) -1
    low = A(i) - (A(i+1)-A(i))/2
    high = A(i) + (A(i+1)-A(i))/2
    for j = m_start :length(B)
        if B(j) <= high && B(j) >= low
            out(i) = B(j)
        else
            continue     
        end
        m_start = j     
    end
       
end
 for j = m_start :length(B)
     high=A(end)+(A(end) - A(end-1))/2
     low = A(end)-(A(end) - A(end-1))/2
    if B(j) <= high && B(j) >= low
            out(i+1) = B(j)
    end
 end