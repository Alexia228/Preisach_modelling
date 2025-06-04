P_int_cut_p = P_int_1(1:length(P_int_1)/2);
P_int_cut_n = -P_int_3(1:length(P_int_3)/2);
E_cut_n = Field_3(1:length(Field_3)/2);
E_cut_p = Field_1(1:length(Field_1)/2);

[E_inter_p, P_inter_p] = interpoling(E_cut_p,P_int_cut_p, 1);
[E_inter_n, P_inter_n] = interpoling(E_cut_n,P_int_cut_n, -1);


P_inter_p = P_inter_p - P_inter_p(end)/2;
P_inter_n = -P_inter_n + P_inter_n(end)/2;

hold on
grid on
plot(E_inter_p, P_inter_p, 'r')
plot(E_inter_n, P_inter_n, 'b')

P.n_cut = P.n(1:end/2);
P.p_cut = P.p(1:end/2);
E.p_cut = E.p(1:end/2);
E.n_cut = E.n(1:end/2);

plot(E.p_cut,P.p_cut)
plot(E.n_cut,P.n_cut)

err_n = abs(P.n_cut'-P_inter_n)./P.n_cut';
err_p = abs(P.p_cut'-P_inter_p)./P.p_cut';

plot(E_inter_n, err_n)
plot(E_inter_p, err_p)

err_n_cut = err_n(1:end/2);
err_p_cut = err_p(end/2:end);

error_n = -sum(err_n_cut)/length(err_n_cut)*100;
error_p = sum(err_p_cut)/length(err_p_cut)*100;









