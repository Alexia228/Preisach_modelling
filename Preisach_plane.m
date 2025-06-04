
clc

% plot3(X, Y, Ps, '.')


X_range = linspace(min(X), max(X), 100);
Y_range = linspace(min(Y), max(Y), 100);

[X_grid, Y_grid] = meshgrid(Y_range, X_range);

Ps_grid = zeros(size(X_grid));
for i = 1:numel(X_range)-1
    for j = 1:numel(Y_range)-1

        range1 = X >= X_range(i) & X < X_range(i+1);
        range2 = Y >= Y_range(j) & Y < Y_range(j+1);
        range = range1 & range2;
        Ps_grid(i, j) = sum(Ps(range));

    end
end

figure
% imagesc(X_range, Y_range, log10(Ps_gridfd))
Ps_grid_log = log10(Ps_grid);
Ps_grid_log(Ps_grid_log < -2) = -5;
% hold on
% surf(X_grid, Y_grid, Ps_grid_log)
imagesc (Y_range, X_range, Ps_grid_log)
grid on;        % Включает сетку (но может не отображаться корректно)
set(gca, 'GridLineStyle', '-', 'LineWidth', 0.5, 'GridColor', 'w');
set(gca, 'FontSize', 20)
set(gca, 'YDir', 'normal')
xlabel('\bf\beta')
ylabel('\bf\alpha')
xlim([-30 0])
ylim([0 30])
% colormap hot
grid on
