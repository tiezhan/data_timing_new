path = 'D:\lutiezhan\data_number\fiber_recording\DAT-cre-vta\2ds'; %%����·�������º������Զ���ȡ��·�������е��ļ��У�����һ��ȡ�����ļ���
c = dir(path);
dff0 = [];
dff2 = [];
dff3 = [];
for i = 1:length(c)
    if(isequal(c(i).name,'.')||... %% ������Ŀ¼
       isequal(c(i).name,'..')||...
       ~c(i).isdir)
   continue;
    end
    secondpath = fullfile(path, c(i).name); %% ��ȡÿ���ļ����µ����ļ���
    [a1,a2,a3]= Call_find_dff_signal(secondpath,1); %% call function timewait���������ļ�����.mat����,condition1= ����wait�� 2=�����뿪��3=�����ˮ
    if ~isempty(a1)
    dff0 = vertcat(dff0,a1);%% ��ÿ�η��ص�a1,a2,a3ֵ�ϲ���TimeWait,TimeRun��TimeRound������������
    end
    if ~isempty(a2)
    dff2 = vertcat(dff2,a2);
    end
    if ~isempty(a3)
    dff3 = vertcat(dff3,a3);
    end
end

        
       