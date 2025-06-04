function [E_inter, P_inter] = interpoling(E, P, polling)


%Удаление дубликатов
[E, idx] = unique(E);
P = P(idx);

%Создание сетки для интерполяции
if polling == 1
    E_inter = linspace(E(1),E(end),30000);

elseif polling == -1
    E_inter = linspace(E(end),E(1),30000);
end
    
% Интерполяция
P_inter = interp1(E, P, E_inter, 'linear');
end