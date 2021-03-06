clc
clear
close all

addpath '../Paradigms_Functions/'
addpath '../Utils/'

% %%%%%%%%%%%%%%%%%%%%%% Configs
num_trials = 900;
err_clamp_bool = 0;
length_initial_zeros = 20;
length_error_clamp = 100;
% Single-State and Gain-Specific Models
A = 0.99;
B = 0.013;

% Multi-Rate Model
Af = 0.92;
As = 0.996;
Bf = 0.03;
Bs = 0.004;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% No re-learning
% Single-State Model
clc
close all

deadaptation_trials = 401:432;
washout_trials = deadaptation_trials(end):num_trials;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                       
x = zeros(1, num_trials);

for trial_no = 2:num_trials
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        num_trials num_trials];
patch(box,boxy,'g','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'error clamp trials',...
    'Disturbance', 'Net Adaptation' ,'Location', 'southeast')

xlabel('Trial Number')
ylabel('Adaptation')

save_figure('../../Report/figures/figure3/single_state_ec')
%% Gain Specific Model
clc
close all

deadaptation_trials = 401:418;
washout_trials = deadaptation_trials(end):num_trials;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                       
x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    [x1(trial_no), x2(trial_no), x(trial_no)] = gain_specific(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        num_trials num_trials];
patch(box,boxy,'g','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'error clamp trials',...
    'Disturbance', 'Net Adaptation', 'Down State', 'Up State', 'Location', 'southeast')

xlabel('Trial Number')
ylabel('Adaptation')

save_figure('../../Report/figures/figure3/gain_specific_ec')
%% Multi-Rate Model
clc
close all

deadaptation_trials = 401:420;
washout_trials = deadaptation_trials(end):num_trials;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        num_trials num_trials];
patch(box,boxy,'g','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'error clamp trials',...
    'Disturbance','Net Adaptation', 'Slow State', 'Fast State', 'Location', 'southeast')

xlabel('Trial Number')
ylabel('Adaptation')

save_figure('../../Report/figures/figure3/multi_rate_ec')
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% re-learning
% Single-State Model
clc
close all

deadaptation_trials = 401:432;
washout_trials = deadaptation_trials(end):deadaptation_trials(end)+length_error_clamp;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                       
x = zeros(1, num_trials);

for trial_no = 2:num_trials
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        washout_trials(end)-1 washout_trials(end)-1];
patch(box,boxy,'g','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [num_trials num_trials ...
        washout_trials(end) washout_trials(end)];
patch(box,boxy,'m','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'error clamp trials',...
    'readaptation trials', 'Disturbance', 'Net Adaptation' ,'Location', 'southeast')

xlabel('Trial Number')
ylabel('Adaptation')

save_figure('../../Report/figures/figure3/single_state_ec_rl')
%% Gain Specific Model
clc
close all

deadaptation_trials = 401:418;
washout_trials = deadaptation_trials(end):deadaptation_trials(end)+length_error_clamp;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                       
x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    [x1(trial_no), x2(trial_no), x(trial_no)] = gain_specific(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        deadaptation_trials(end)+length_error_clamp ...
        deadaptation_trials(end)+length_error_clamp];
patch(box,boxy,'g','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+length_error_clamp ...
        deadaptation_trials(end)+length_error_clamp ...
        num_trials num_trials];
patch(box,boxy,'m','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'error clamp trials',...
    'readaptation trials', 'Disturbance', 'Net Adaptation', 'Down State', 'Up State', 'Location', 'southeast')

xlabel('Trial Number')
ylabel('Adaptation')

save_figure('../../Report/figures/figure3/gain_specific_ec_rl')
%% Multi-Rate Model
clc
close all

deadaptation_trials = 401:420;
washout_trials = deadaptation_trials(end):deadaptation_trials(end)+length_error_clamp;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        deadaptation_trials(end)+length_error_clamp ...
        deadaptation_trials(end)+length_error_clamp];
patch(box,boxy,'g','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+length_error_clamp ...
        deadaptation_trials(end)+length_error_clamp ...
        num_trials num_trials];
patch(box,boxy,'m','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'error clamp trials',...
    'readaptation trials', 'Disturbance','Net Adaptation', 'Slow State', 'Fast State', 'Location', 'southeast')

xlabel('Trial Number')
ylabel('Adaptation')

save_figure('../../Report/figures/figure3/multi_rate_ec_rl')