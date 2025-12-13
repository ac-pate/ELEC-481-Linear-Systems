%% Q4: Open-Loop System Figure Generation
% Impulse and Step Responses with Zero and Non-Zero Initial Conditions

clc;
fprintf('===========================================\n');
fprintf('  Q4: Open-Loop System Figures\n');
fprintf('===========================================\n\n');

%% Configuration
output_folder = 'Figures';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
    fprintf('Created output folder: %s\n\n', output_folder);
end

%% Figure Q4.1: Impulse Response (Zero IC)
if ~exist('out', 'var') || ~isprop(out, 'impulse_response_zero_ic')
    error('Variable "out.impulse_response_zero_ic" not found!');
end

t = out.impulse_response_zero_ic.Time;
y = out.impulse_response_zero_ic.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'Open-Loop System'; '\fontsize{11}\it{Impulse Response (Zero IC)}'}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'best', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q4_1_Impulse_Zero_IC.png'));
fprintf('  [1/4] Q4_1_Impulse_Zero_IC.png\n');

%% Figure Q4.2: Impulse Response (Non-Zero IC)
if ~exist('out', 'var') || ~isprop(out, 'impulse_response_nz_ic')
    error('Variable "out.impulse_response_nz_ic" not found!');
end

t = out.impulse_response_nz_ic.Time;
y = out.impulse_response_nz_ic.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'Open-Loop System'; '\fontsize{11}\it{Impulse Response (Non-Zero IC)}'}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'best', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q4_2_Impulse_NonZero_IC.png'));
fprintf('  [2/4] Q4_2_Impulse_NonZero_IC.png\n');

%% Figure Q4.3: Step Response (Zero IC)
if ~exist('out', 'var') || ~isprop(out, 'step_response_zero_ic')
    error('Variable "out.step_response_zero_ic" not found!');
end

t = out.step_response_zero_ic.Time;
y = out.step_response_zero_ic.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'Open-Loop System'; '\fontsize{11}\it{Step Response (Zero IC)}'}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'Southeast', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q4_3_Step_Zero_IC.png'));
fprintf('  [3/4] Q4_3_Step_Zero_IC.png\n');

%% Figure Q4.4: Step Response (Non-Zero IC)
if ~exist('out', 'var') || ~isprop(out, 'step_response_nz_ic')
    error('Variable "out.step_response_nz_ic" not found!');
end

t = out.step_response_nz_ic.Time;
y = out.step_response_nz_ic.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'Open-Loop System'; '\fontsize{11}\it{Step Response (Non-Zero IC)}'}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'Southeast', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q4_4_Step_NonZero_IC.png'));
fprintf('  [4/4] Q4_4_Step_NonZero_IC.png\n');

%% Done
fprintf('\n===========================================\n');
fprintf('  Q4 Complete! Figures saved to: %s\n', output_folder);
fprintf('===========================================\n');

