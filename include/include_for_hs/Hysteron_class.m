classdef Hysteron_class < handle

    methods (Access = public)
        
        function obj = Hysteron_class(Enp, Epn, Ps)
            obj.Enp = Enp;
            obj.Epn = Epn;
            obj.Ps = Ps;
            %Текущее состояние поляризации
            obj.P = -Ps;
        end
        
        %Выдаёт текущее значение поляризации
        function state = get_state(obj, E)
                if E > obj.Enp
                    obj.P = obj.Ps;
                end
                if E < obj.Epn
                    obj.P = -obj.Ps;
                end
                state = obj.P;
        end
    end

properties
    Enp;
    Epn;
    Ps;
    P;
end

end






















