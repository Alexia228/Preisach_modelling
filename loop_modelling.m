
addpath('include\include_for_hs\')

%Пороги переключения и поляризация для гистеронов
[X,Y,Ps] = Data_for_hysterons(feloop);

%Задание геометрии образца
Sample.area = 8.27e-7; %m^2
Sample.thickness = 1e-4; %m

Sample.Psat = Ps*5;
Sample.En = Y;
Sample.Ep = X;
Sample.negative_effects = false;

%Задание параметры треугольного сигнала
Amp = 600;
T_period = 4; % s


FE = FE_part_hs(Sample);

waveform_up = voltage_triangle(Amp, T_period, 1);
waveform_down = voltage_triangle(Amp,T_period, -1);

[Field_1, P_int_1] = Experiment(Sample, FE, waveform_up);
% [Field_2, P_int_2] = Experiment(Sample, FE, waveform_up);
[Field_3, P_int_3] = Experiment(Sample, FE, waveform_down);
% [Field_4, P_int_4] = Experiment(Sample, FE, waveform_down);

%Вычитание по DWM
% P_int_p = P_int_1 - P_int_2;
% P_int_n = P_int_3 - P_int_4;

%Сопоставление отрицательной и положительной ветки
correction_p = (P_int_1(end)-P_int_1(1))/2;
correction_n = (P_int_3(end)-P_int_3(1))/2;

% correction_p_DWM = (P_int_p(end)-P_int_p(1))/2;
% correction_n_DWM = (P_int_n(end)-P_int_n(1))/2;

%Построение обычной петли
hold on
grid on
plot(Field_1, P_int_1-correction_p,':', 'LineWidth', 3, 'Color', 'red');
plot(Field_3, P_int_3-correction_n,':', 'LineWidth', 3, 'Color', 'red')

legend('Experiment','Model','AutoUpdate', 'off','Location','northwest')
xline(0)
yline(0)
set(gca, 'fontsize', 20)
xlabel('E, kV/cm')
ylabel('P, uC/cm^2')

% Построение петли DWM
% figure('position', [536 123 600 500])
% grid on
% hold on
% plot(Field_1, P_int_p-correction_p_DWM,'color', 'red', 'linewidth', 2)
% plot(Field_3, P_int_n-correction_n_DWM,'color', 'blue', 'linewidth', 2)
% xline(0)
% yline(0)
% set(gca, 'fontsize', 20)
% xlabel('E, kV/cm')
% ylabel('P, uC/cm^2')



%Токовые петли
% P_int_cut_p = P_int_1(1:length(P_int_1)/2);
% P_int_cut_n = -P_int_3(1:length(P_int_3)/2);
% E_cut_n = Field_3(1:length(Field_3)/2);
% E_cut_p = Field_1(1:length(Field_1)/2);
% 
% d_P_p = diff(P_int_cut_p);
% d_P_n = diff(P_int_cut_n);
% d_E_p = E_cut_p(1:length(d_P_p));
% d_E_n = E_cut_n(1:length(d_P_n));
% 
% 
% hold on
% plot(d_E_n, d_P_n, 'b');
% plot(d_E_p, d_P_p, 'r');
% grid on


function [Field, P_int] = Experiment(Sample, FEset, waveform)
Area = Sample.area;
Thickness = Sample.thickness;

voltage = [waveform.voltage];
time = [waveform.time];

time_step = time(2) - time(1);

Current = [];
for  i = 1:numel(voltage)
    cur = 0;
    for k = 1 : numel(FEset)
        cur = cur + FEset(k).get_p(voltage(i), time_step);
    end
    Current(i) = cur/numel(FEset);
    
end

Q_int = cumsum(Current)*time_step;
P_int = (Q_int*1e6)/(Area*100*100);
Field = (voltage*1e-3)/(Thickness*100);

end