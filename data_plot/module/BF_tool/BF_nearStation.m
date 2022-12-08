function [ind_activestation_1y, distance_people_1y] = BF_nearStation(station_1v, people_1v,style)
%测量2个timestamp向量之间的匹配。('人们'总是去最近的'车站'坐车)
%
%function [ind_activestation_1y, distance_people_1y] = BF_nearStation(station_1v, people_1v,style)
% -----Input 参数--------
% station_1v     : 车站, 1_vector (n1)
% people_1v      : 移动的人们, 1_vector (n2)
% style          : {'near'默认, 'people - station >0', 'people - station <0', 'near+'}之间
%
% -----Output 参数--------
% ind_activestation_1y  : 哪些车站有人，1_vector (n1, bool)
% distance_people_1y    : 每个人移动的距离, 1_vector (n2, double)

    if ~exist('style','var'); style='near'; end
    assert( ismember(style,{'near','near+'}), 'Style应该为 ''near'',或''near+''!' )
    ind_activestation_1y = false(length(station_1v),1);
    distance_people_1y = nan(length(people_1v),1);
    switch style
    case 'near' %'pos_now' is arround than always
        for i=1:length(people_1v)
            pos_now = people_1v(i);
            [~,idx] = min(abs(pos_now - station_1v ));
            df = pos_now - station_1v(idx);
            ind_activestation_1y(idx)=true;
            distance_people_1y(i)=df;
        end
    case {'near+', 'people - station >0'} %'pos_now' is bigger than always
        for i=1:length(people_1v)
            pos_now = people_1v(i);
            d = pos_now - station_1v;
            d(d<0) = inf;
            [~,idx] = min(d);
            df  = pos_now - station_1v(idx);
            ind_activestation_1y(idx)=true;
            distance_people_1y(i)=df;
        end
    case {'near-', 'people - station <0'}
        for i=1:length(people_1v)
            pos_now = people_1v(i);
            d = station_1v - pos_now;
            d(d<0) = inf;
            [~,idx] = min(d);
            df  = pos_now - station_1v(idx);
            ind_activestation_1y(idx)=true;
            distance_people_1y(i)=df;
        end
    end
    
end