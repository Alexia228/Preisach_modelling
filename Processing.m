%Загружает в Workspace данные и строит петли в зависимости от выбранных 
%данных.
addpath('include\include_for_2022_data')
addpath('include\include_for_2023_data')

data = 'Results_2022_PMN20PT_PZT4_1/';
% data = 'Results_2023_03_14_PMN_20PT';
% data = 'Results_2023_03_20_PMN_20PT';
% data = 'Results_2023_10_11_PMN_33PT';
% data = 'Results_2023_10_17_PZT_19';

%-------------------------------------------------------------------------%
if strcmp(data, 'Results_2022_PMN20PT_PZT4_1/')
    %Хорошо бы разделить данные для PZT и PMN в разные папки
    
    % PMN-20PT
    % Sample.H = 85e-6; %m
    % Sample.S = 0.29/1000^2; %m^2
    % Sample.Gain = 20;
    % PZT
    Sample.H = 35e-6; %m
    Sample.S = 450e-6 * 280e-6; %m^2
    Sample.Gain = 20;
    
    for file_number = 418
        feloop = open_dwm_fe_loop(Sample, data, file_number, 'align');
        E = feloop.E;
        P = feloop.P;
    
        %Для того, чтобы петли были одного цвета
        % E_union = [E.p;E.n]; 
        % P_union = [P.p;P.n];
        % plot(E_union, P_union,'linewidth', 1);
    
        hold on
        grid on
        plot(E.p, P.p, 'linewidth', 1)
        plot(E.n, P.n, 'linewidth', 1)
        ylabel('P, uC/cm^2', 'FontSize', 16)
        xlabel('E, kV/cm', 'FontSize', 16)
        set(gca, 'FontSize', 20)
        title([' T = ' num2str(feloop.temp) ' ⁰C'], 'FontSize', 18)
        drawnow
    end
%-------------------------------------------------------------------------%
elseif strcmp(data, 'Results_2023_03_14_PMN_20PT')
    fig = figure('position', [443 80 620 685]);

    %После первого запуска строка ниже комментируется, т.к. петли уже 
    % загружены
    [Loops, Loop_temp, periods] = load_loops_files(data);
    %Счётчик по температуре
    Temp_range = 30;
    %Счётчик по частоте
    for freq_N = 1
        j = 0;
        for i = Temp_range
            j = j + 1;
        
            Loops_loc = Loops{i};
            
            loop = Loops_loc(freq_N); 
          
            loop = feloop_swap_p_n(loop);
            feloop = feloop_processing(loop,false, fig);
            E = feloop.E;
            P = feloop.P;
        
            Temp_out(freq_N, j) = Loop_temp(i);
            Period(freq_N) = numel(loop.init.E.n)/1000; 
        
            hold on
            cla
            set(gca, 'fontsize', 11)
            plot(E.p, P.p, 'r', 'linewidth', 2)
            plot(E.n, P.n, 'b', 'linewidth', 2)
            xlabel('E, kV/cm', 'fontsize', 12)
            ylabel('P, uC/cm^2', 'fontsize', 12)
            grid on
            drawnow
            pause(0.5)
            
            title(num2str(Loop_temp(i)))    
        end
    end
%-------------------------------------------------------------------------%
elseif strcmp(data, 'Results_2023_03_20_PMN_20PT')
    fig = figure('position', [443 80 620 685]);
    %После первого запуска строка ниже комментируется, т.к. петли уже 
    % загружены
    [Loops, Loop_temp, periods] = load_loops_files(data);
    %Счётчик по температуре
    Temp_range = 10;
    %Счётчик по частоте
     for freq_N = 1
     j = 0;
        for i = Temp_range
            j = j + 1;
        
            Loops_loc = Loops{i};
            
            loop = Loops_loc(freq_N); 
          
            loop = feloop_swap_p_n_new(loop);
            feloop = feloop_processing_new(loop,false, fig);
            E = feloop.E;
            P = feloop.P;
        
            Temp_out(freq_N, j) = Loop_temp(i);
            Period(freq_N) = numel(loop.feloop.init.E.n)/1000; 
        
            hold on
            cla
            set(gca, 'fontsize', 11)
            plot(E.p, P.p, 'r', 'linewidth', 2)
            plot(E.n, P.n, 'b', 'linewidth', 2)
            xlabel('E, kV/cm', 'fontsize', 12)
            ylabel('P, uC/cm^2', 'fontsize', 12)
            grid on
            drawnow
            
            title(num2str(Loop_temp(i)))    
        end
     end
%-------------------------------------------------------------------------%
elseif strcmp(data, 'Results_2023_10_11_PMN_33PT')
    %После первого запуска строка ниже комментируется, т.к. петли уже 
    % загружены
    [Loops] = load_loops_files(data);
    fig = figure('position', [466 129 759 846]);
    for i = 5
        Loops_loc = Loops{i};
        loop = Loops_loc(1);
        
        loop = feloop_swap_p_n_new(loop);
        feloop = feloop_processing_new(loop, true, fig);       
        
        drawnow
    end
%-------------------------------------------------------------------------%
elseif strcmp(data, 'Results_2023_10_17_PZT_19')
    %После первого запуска строка ниже комментируется, т.к. петли уже 
    % загружены
    % [Loops] = load_loops_files(data);
    %Калечная петля : 130
    % Норм петли: 1:86
    % ZOV-петля - 58
    % Bad петли: 86, 90, 94, 95, 96, 98, 100, 102, 103, 106, 110, 113, 114,
    % 115-119...
    fig = figure('position', [466 129 759 846]);
    for i = 6
        Loops_loc = Loops{i};
        loop = Loops_loc(1);
        
        loop = feloop_swap_p_n_new(loop);
        feloop = feloop_processing_new(loop, true, fig);       
        
        drawnow
    end
end
%-------------------------------------------------------------------------%