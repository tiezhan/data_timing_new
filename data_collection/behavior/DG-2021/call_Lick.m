function call_Lick(obj,~,handles)
global Lick_M
Lick_M=str2double(fgetl(obj));
set(handles.edit_lick11,'String',num2str(Lick_M));
end