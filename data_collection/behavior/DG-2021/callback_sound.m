function callback_sound(~,~,handles)
% global tf;
% global tt;
 tf=str2double(get(handles.edit_tone_frequency, 'String'));
 tt=str2double(get(handles.edit_tone_time, 'String'))/1000;
        Sound_Y=ones(2*tf*tt,1);
        Sound_Y(2:2:end)=-1;        
        sound(Sound_Y,tf*2,8);
end