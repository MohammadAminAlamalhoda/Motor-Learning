clc
clear
close all

addpath '../Utils/'

num_trials = 100;
a = 1;
sigma = 1;
beta = 0.001;
N = 10;
e_pref = linspace(-5, 5, N);
w0 = zeros(num_trials, N);
w0(1,:) = 0.05;
u = ones(1, num_trials);
%% Paradigms for different values of z
clc
close all

z = 0.9;
x = paradigm_maker(z, num_trials);
[x_hat, w, e, g] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
figure('Renderer', 'painters', 'Position', [10 10 1800 300])
hold on
plot(x, 'k', 'LineWidth', 2)
plot(x_hat, 'Color', [1, 1, 1]*0.7, 'LineWidth', 3)
ylim([-0.1, 1.1])


z = 0.5;
x = paradigm_maker(z, num_trials);
[x_hat, w, e, g] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
figure('Renderer', 'painters', 'Position', [10 10 1800 300])
hold on
plot(x, 'k', 'LineWidth', 2)
plot(x_hat, 'Color', [1, 1, 1]*0.7, 'LineWidth', 3)
ylim([-0.1, 1.1])

z = 0.1;
x = paradigm_maker(z, num_trials);
[x_hat, w, e, g] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
figure('Renderer', 'painters', 'Position', [10 10 1800 300])
hold on
plot(x, 'k', 'LineWidth', 2)
plot(x_hat, 'Color', [1, 1, 1]*0.7, 'LineWidth', 3)
ylim([-0.1, 1.1])

figure(1)
xlabel('Trial Number')
ylabel('Perturbation (a.u.)')
legend('Paradigm', 'Estimation')
title('Z=0.1')
save_figure('../../Report/figures/figure4/z0_1')

figure(2)
xlabel('Trial Number')
ylabel('Perturbation (a.u.)')
legend('Paradigm', 'Estimation')
title('Z=0.5')
save_figure('../../Report/figures/figure4/z0_5')

figure(3)
xlabel('Trial Number')
ylabel('Perturbation (a.u.)')
legend('Paradigm', 'Estimation')
title('Z=0.9')
save_figure('../../Report/figures/figure4/z0_9')
%% Error Sensivity for different values of z
clc
close all

zs = 0.1:0.005:0.9;
ethas = zeros(length(zs), num_trials);
z_counter = 0;
for z = zs
    z_counter = z_counter+1;
    x = paradigm_maker(z, num_trials);
    [~, w, ~, g] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
    for trial_no = 1:num_trials
        ethas(z_counter, trial_no) = w(trial_no, :) * g(trial_no, :)';
    end
end
Colors = copper(size(ethas, 1));
Colors = flip(Colors);

figure('Renderer', 'painters', 'Position', [10 10 1800 300])
hold on
for i = 1:size(ethas, 1)
    plot(ethas(i, :), 'Color', Colors(i, :), 'LineWidth', 2)
end
xlim([2, num_trials-2])

colormap(Colors)
c = colorbar('Ticks', [zs(1), zs(ceil(end/2)), zs(end)], 'TickLabels', ...
        {num2str(zs(1)), num2str(zs(ceil(end/2))), num2str(zs(end))});
c.Label.String = 'z value';
caxis([zs(1), zs(end)])

figure(1)
xlabel('Trial Number')
ylabel('Error-Sensitivity')
save_figure('../../Report/figures/figure4/erros_sensivity')