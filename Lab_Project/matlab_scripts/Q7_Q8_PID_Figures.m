%% Q7 & Q8: PID Controller Figure Generation
% Q7: Step, Square Wave, and Sinusoidal Responses
% Q8: Robustness Analysis with Measurement Noise

clc;
fprintf('===========================================\n');
fprintf('  Q7 & Q8: PID Controller Figures\n');
fprintf('===========================================\n\n');

%% Configuration
output_folder = 'Figures';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
    fprintf('Created output folder: %s\n\n', output_folder);
end

%% Load PID gains from workspace (set in sys_params.m)
if ~exist('Kp', 'var') || ~exist('Ki', 'var') || ~exist('Kd', 'var')
    warning('PID gains (Kp, Ki, Kd) not found in workspace. Loading from saved workspace...');
    if exist('Q4_to_Q8_Workspace.mat', 'file')
        load('Q4_to_Q8_Workspace.mat', 'Kp', 'Ki', 'Kd');
    else
        error('Run sys_params.m first to define Kp, Ki, Kd!');
    end
end

% Create PID gains string for figure annotations
pid_gains_str = sprintf('K_p = %.2e, K_i = %.2e, K_d = %.2e', Kp, Ki, Kd);
fprintf('PID Gains: Kp = %.6f, Ki = %.6f, Kd = %.6f\n\n', Kp, Ki, Kd);

%% ========================================================================
%  Q7: PID Controller Responses
%  ========================================================================
fprintf('--- Q7: PID Controller Responses ---\n');

%% Figure Q7.1: PID Step Response
if ~exist('out', 'var') || ~isprop(out, 'pid_step_response')
    error('Variable "out.pid_step_response" not found!');
end

t = out.pid_step_response.Time;
y = out.pid_step_response.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'PID Controller - Step Response'; ['\fontsize{10}' pid_gains_str]}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'Southeast', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q7_1_PID_Step_Response.png'));
fprintf('  [1/6] Q7_1_PID_Step_Response.png\n');

%% Figure Q7.2: PID Square Wave Response
if ~exist('out', 'var') || ~isprop(out, 'pid_square_response')
    error('Variable "out.pid_square_response" not found!');
end

t = out.pid_square_response.Time;
y = out.pid_square_response.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'PID Controller - Square Wave Input'; ['\fontsize{10}' pid_gains_str]}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'Southeast', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q7_2_PID_Square_Response.png'));
fprintf('  [2/6] Q7_2_PID_Square_Response.png\n');

%% Figure Q7.3: PID Sinusoidal Response
if ~exist('out', 'var') || ~isprop(out, 'pid_sine_response')
    error('Variable "out.pid_sine_response" not found!');
end

t = out.pid_sine_response.Time;
y = out.pid_sine_response.Data;

figure('Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;
plot(t, y(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Cmd Position ($r$)');
plot(t, y(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Disk 1 ($\theta_1$)');
plot(t, y(:,3), 'r-.', 'LineWidth', 2, 'DisplayName', 'Disk 2 ($\theta_2$)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 12, 'FontWeight', 'bold');
title({'PID Controller - Sinusoidal Input (1 rad/s)'; ['\fontsize{10}' pid_gains_str]}, 'FontSize', 14, 'Interpreter', 'tex');
legend('show', 'Location', 'Southeast', 'Interpreter', 'latex', 'FontSize', 11);
hold off;

saveas(gcf, fullfile(output_folder, 'Q7_3_PID_Sine_Response.png'));
fprintf('  [3/6] Q7_3_PID_Sine_Response.png\n');

%% ========================================================================
%  Q8: Robustness Analysis - Measurement Noise
%  ========================================================================
fprintf('\n--- Q8: Robustness with Measurement Noise ---\n');

% Validate required variables
if ~exist('out', 'var')
    error('Variable "out" not found! Run Simulink first.');
end

%% Figure Q8.1: Small Noise - Combined (A) Feedback + (B) Response
% Noise Power: 5e-7
figure('Color', 'w', 'Position', [100, 100, 700, 700]);

% Get response data
t_resp = out.pid_small_noise_response.Time;
y_resp = out.pid_small_noise_response.Data;

% Get feedback data
t_fb = out.pid_small_noise_feedback.Time;
y_fb = out.pid_small_noise_feedback.Data;

% (A) Top subplot: Noisy Measurement Input (Sensor Feedback)
subplot(2,1,1);
hold on;
plot(t_resp, y_resp(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
if size(y_fb, 2) >= 2
    plot(t_fb, y_fb(:,2), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
else
    plot(t_fb, y_fb(:,1), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
end
grid on; box on; axis tight;
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(A) Noisy Measurement Input (Sensor Feedback)', 'FontSize', 12, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 10);
hold off;

% (B) Bottom subplot: Actual System Response
subplot(2,1,2);
hold on;
plot(t_resp, y_resp(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
plot(t_resp, y_resp(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Actual Plant Output (Clean)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(B) Actual System Response', 'FontSize', 12, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 10);
hold off;

sgtitle({'Robustness Test: PID Controller - Small Noise'; '\fontsize{10}(Power = 5\times10^{-7})'}, ...
    'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'tex');

saveas(gcf, fullfile(output_folder, 'Q8_1_PID_SmallNoise_Combined.png'));
fprintf('  [4/6] Q8_1_PID_SmallNoise_Combined.png\n');

%% Figure Q8.2: Large Noise - Combined (A) Feedback + (B) Response
% Noise Power: 0.001
figure('Color', 'w', 'Position', [100, 100, 700, 700]);

% Get response data
t_resp = out.pid_big_noise_response.Time;
y_resp = out.pid_big_noise_response.Data;

% Get feedback data
t_fb = out.pid_big_noise_feedback.Time;
y_fb = out.pid_big_noise_feedback.Data;

% (A) Top subplot: Noisy Measurement Input (Sensor Feedback)
subplot(2,1,1);
hold on;
plot(t_resp, y_resp(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
if size(y_fb, 2) >= 2
    plot(t_fb, y_fb(:,2), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
else
    plot(t_fb, y_fb(:,1), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
end
grid on; box on; axis tight;
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(A) Noisy Measurement Input (Sensor Feedback)', 'FontSize', 12, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 10);
hold off;

% (B) Bottom subplot: Actual System Response
subplot(2,1,2);
hold on;
plot(t_resp, y_resp(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
plot(t_resp, y_resp(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Actual Plant Output (Clean)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(B) Actual System Response', 'FontSize', 12, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 10);
hold off;

sgtitle({'Robustness Test: PID Controller - Large Noise'; '\fontsize{10}(Power = 0.001)'}, ...
    'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'tex');

saveas(gcf, fullfile(output_folder, 'Q8_2_PID_LargeNoise_Combined.png'));
fprintf('  [5/6] Q8_2_PID_LargeNoise_Combined.png\n');

%% Figure Q8.3: Side-by-Side Comparison (Small vs Large Noise)
figure('Color', 'w', 'Position', [50, 50, 1400, 700]);

% === LEFT COLUMN: Small Noise ===
% Get small noise data
t_small = out.pid_small_noise_response.Time;
y_small = out.pid_small_noise_response.Data;
t_fb_small = out.pid_small_noise_feedback.Time;
y_fb_small = out.pid_small_noise_feedback.Data;

% (A) Small Noise - Feedback
subplot(2,2,1);
hold on;
plot(t_small, y_small(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
if size(y_fb_small, 2) >= 2
    plot(t_fb_small, y_fb_small(:,2), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
else
    plot(t_fb_small, y_fb_small(:,1), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
end
grid on; box on; axis tight;
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(A) Noisy Measurement Input (Sensor Feedback)', 'FontSize', 11, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 9);
hold off;

% (B) Small Noise - Response
subplot(2,2,3);
hold on;
plot(t_small, y_small(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
plot(t_small, y_small(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Actual Plant Output (Clean)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(B) Actual System Response', 'FontSize', 11, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 9);
hold off;

% === RIGHT COLUMN: Large Noise ===
% Get large noise data
t_big = out.pid_big_noise_response.Time;
y_big = out.pid_big_noise_response.Data;
t_fb_big = out.pid_big_noise_feedback.Time;
y_fb_big = out.pid_big_noise_feedback.Data;

% (A) Large Noise - Feedback
subplot(2,2,2);
hold on;
plot(t_big, y_big(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
if size(y_fb_big, 2) >= 2
    plot(t_fb_big, y_fb_big(:,2), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
else
    plot(t_fb_big, y_fb_big(:,1), '-', 'Color', [0.6 0.2 0.8], 'LineWidth', 1.2, 'DisplayName', 'Measured Signal (With Noise)');
end
grid on; box on; axis tight;
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(A) Noisy Measurement Input (Sensor Feedback)', 'FontSize', 11, 'FontWeight', 'bold');
legend('show', 'Location', 'Northeast', 'FontSize', 9);
hold off;

% (B) Large Noise - Response
subplot(2,2,4);
hold on;
plot(t_big, y_big(:,1), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
plot(t_big, y_big(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Actual Plant Output (Clean)');
grid on; box on; axis tight;
xlabel('Time (s)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Position (rad)', 'FontSize', 11, 'FontWeight', 'bold');
title('(B) Actual System Response', 'FontSize', 11, 'FontWeight', 'bold');
legend('show', 'Location', 'Southeast', 'FontSize', 9);
hold off;

% Add column titles using annotation
annotation('textbox', [0.13, 0.92, 0.35, 0.05], 'String', 'Small Noise (Power = 5\times10^{-7})', ...
    'FontSize', 13, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'Interpreter', 'tex');
annotation('textbox', [0.55, 0.92, 0.35, 0.05], 'String', 'Large Noise (Power = 0.001)', ...
    'FontSize', 13, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'Interpreter', 'tex');

sgtitle('Q8: Robustness Test - PID Controller with Measurement Noise', ...
    'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, fullfile(output_folder, 'Q8_3_PID_Noise_Comparison.png'));
fprintf('  [6/6] Q8_3_PID_Noise_Comparison.png\n');

%% Done
fprintf('\n===========================================\n');
fprintf('  Q7 & Q8 Complete! Figures saved to: %s\n', output_folder);
fprintf('===========================================\n');

