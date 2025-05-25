function [X, Y, Psat] = Data_for_hysterons (feloop)
    X = [];
    Y = [];
    Psat = [];

    E = feloop.E;
    P = feloop.P;

    E_cut_n = E.n(1:length(E.n)/2);
    E_cut_p = E.p(1:length(E.p)/2);
    P_cut_n = P.n(1:length(P.n)/2);
    P_cut_p = P.p(1:length(P.p)/2);
    

    d_P_p = diff(P_cut_p);
    d_P_n = diff(P_cut_n);
    d_E_n = E_cut_n(1:length(d_P_n));
    d_E_p = E_cut_p(1:length(d_P_p));


    m = round(length(E.p)/120)+1;
    m;

    d_P_n = movmean(d_P_n, m);
    d_P_p = movmean(d_P_p, m);
    % lim = 0;
    % 
    % range_p = d_P_p > lim;
    % range_n = d_P_n < -lim;
    % 
    % d_P_p = d_P_p (range_p);
    % d_P_n = d_P_n (range_n);
    % d_E_p = d_E_p (range_p);
    % d_E_n = d_E_n (range_n);
    % figure
    % hold on
    % plot(d_E_n, d_P_n);
    % plot(d_E_p, d_P_p);
    % grid on
    %--------------------------------------
    d_P_n = -d_P_n;
    stop = false;
    while ~stop

        if rand() > 0.5
            [Max_P_p, Max_ind_p] = max(d_P_p);
        
            [~, res_ind_n] = min(abs(Max_P_p - d_P_n));
            res_P_n = d_P_n(res_ind_n);

            %Почему две верхние строчки нельзя заменить на:
            % res_P_n = max(d_P_n);
    
            if Max_P_p > res_P_n
                Final_P = res_P_n;
            else
                Final_P = Max_P_p;
            end
    
            d_P_p(Max_ind_p) = d_P_p(Max_ind_p) - Final_P;
            d_P_n(res_ind_n) = d_P_n(res_ind_n) - Final_P;

        else
            [Max_P_n, res_ind_n] = max(d_P_n);
        
            [~, Max_ind_p] = min(abs(Max_P_n - d_P_p));
            res_P_p = d_P_p(Max_ind_p);
        
            if Max_P_n > res_P_p
                Final_P = res_P_p;
            else
                Final_P = Max_P_n;
            end
        
            d_P_p(Max_ind_p) = d_P_p(Max_ind_p) - Final_P;
            d_P_n(res_ind_n) = d_P_n(res_ind_n) - Final_P;

end

X = [X d_E_p(Max_ind_p)];
Y = [Y d_E_n(res_ind_n)];
Psat = [Psat Final_P];

if Final_P == 0
    stop = true;
end

% cla
% plot(d_E_n, d_P_n)
% plot(d_E_p, d_P_p)

drawnow
end

disp('final')

end