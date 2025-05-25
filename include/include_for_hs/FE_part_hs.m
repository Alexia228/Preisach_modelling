classdef FE_part_hs < handle
    %--------------------------------PUBLIC--------------------------------
    methods (Access = public)

        % FIXME: Sample.atoms - bad name
        function obj = FE_part_hs(Sample)
            obj.Thickness = Sample.thickness; % m
            obj.Area = Sample.area; % m^2
            obj.diel_p = rand(1) * 0.3 + 0.3; % FIXME
            obj.Res = rand(1)*10e9 + 20e9; % Ohm
            obj.negative_effects = Sample.negative_effects;

            obj.Number_of_hysterons = length(Sample.Psat);

            %Для генерации произвольных гистеронов
            % obj.Enp = [7, 15];
            % obj.Epn = [-15, -7];
            %FIXME: magic constant 40
            % obj.Ps = Rand_range([0, 25/obj.Number_of_hysterons], obj.Number_of_hysterons);
            % Enp_arr = Rand_range(obj.Enp, obj.Number_of_hysterons);
            % Epn_arr = Rand_range(obj.Epn, obj.Number_of_hysterons);

            obj.Ps = Sample.Psat;
            Enp_arr = Sample.Ep;
            Epn_arr = Sample.En;


            for i = 1 : obj.Number_of_hysterons
                Hysteron_array(i) = Hysteron_class(Enp_arr(i), Epn_arr(i), obj.Ps(i));
            end
            obj.Hysteron_array = Hysteron_array;


        end

        function I = get_p (obj, voltage, time_step)
            Field = (voltage*0.001)/(obj.Thickness*100); % kV/cm
            if obj.negative_effects
                P_diel = obj.diel_p * Field;
            else 
                P_diel = 0;
            end

            P_fe = obj.calc_fe_P(Field);
            
            P = P_fe + P_diel;
           

            if isnan(obj.P_old)
                delta_P = 0;
            else
                delta_P = P - obj.P_old;
            end
            obj.P_old = P;

            delta_P = (delta_P/1e6)*100*100; % C/m^2

            Q = delta_P*obj.Area; % C
            I_fe = Q/time_step; % A = C/s
            
            if obj.negative_effects
                I_leak = voltage/obj.Res;
            else 
                I_leak = 0;
            end
            
            I = I_fe + I_leak;
            
          
            if obj.negative_effects
                I_const = 0.1e-11;
                noise = 2*(rand(1)-0.5) * 10e-11;
            else 
                I_const = 0;
                noise = 0;
            end
            I = I + noise + I_const;
          
        end

        function sw = get_Switching_zone(obj)
            warning('function dont work')
            sw = [];
        end
    end


    %-------------------------------PRIVATE--------------------------------
    properties (Access = private)
        Thickness;
        
        Area;
        P_total;
        Res;
        diel_p;
        Ps;
        Enp;
        Epn;
        Hysteron_array;
        Number_of_hysterons;
        negative_effects;

        Psat;
        En;
        Ep;

        P_old = NaN;
    end

    methods (Access = private)

        function Pout = calc_fe_P(obj, Field)
            for i = 1:numel(obj.Hysteron_array)
                P(i) = obj.Hysteron_array(i).get_state(Field);
            end
            Pout = sum(P);
        end
    end
end
% ------------------------------------------------------------