function call_Sound(~,~,handles)
 T=str2double(get(handles.wait_time, 'String'));
 if T<=11
 tf=(ceil(T)+1)*500+1000;
 else
 tf=8000;
 end
 tt=0.1;
        Sound_Y=ones(2*tf*tt,1);
        Sound_Y(2:2:end)=-1;        
        sound(Sound_Y,tf*2,8);
end