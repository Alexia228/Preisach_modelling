%В аргументах функции выбирается инфа, которая нужна для вывода
function [Loops, Loop_temp, periods] = load_loops_files(data)
    addpath('include\include_for_2023_data\') 
    
    if strcmp(data, 'Results_2023_03_14_PMN_20PT') || strcmp(data, 'Results_2023_03_20_PMN_20PT')
    
        names = find_files(data);
              
        time = [];
        temp = [];
        heater = [];
        res = [];
        % set_point = [];
        periods = {};
        Loops = {};
        Loop_temp = [];
        
        for file_n = 1:numel(names)
            disp(['Loading file ' num2str(file_n) '/' num2str(numel(names))]);
        
            matObj = matfile(names(file_n));
        
            periods{file_n} = 1./matObj.freq_list;
            Loops{file_n} = matObj.Loops;
            
        %     temp_setpoint = matObj.temp_actual;
        
            % append temp graph
            temp_graph = matObj.temp_graph;
            time = [time temp_graph.time];
            temp = [temp temp_graph.temp];
            heater = [heater temp_graph.heater];
            res = [res temp_graph.res];
        %     set_point = [set_point repmat(temp_setpoint, size(temp_graph.time))];
            
            temp_by_res = PT1000(res, 'R2K');
            Loop_temp(file_n) = temp_by_res(end);
        end
        
        clearvars file_n temp_setpoint temp_graph matObj
        clearvars names folder_name

    elseif strcmp(data, 'Results_2023_10_11_PMN_33PT') || strcmp(data, 'Results_2023_10_17_PZT_19')
        names = find_files(data);

        for file_n = 1:numel(names)
            disp(['Loading file ' num2str(file_n) '/' num2str(numel(names))]);
            matObj = matfile(names(file_n));
            Loops{file_n} = matObj.Loops;
        end

    end
       
end