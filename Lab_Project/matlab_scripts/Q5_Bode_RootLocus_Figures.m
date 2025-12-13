%% Q5: Bode Plot and Root Locus (Uncompensated System)

clc;
fprintf('===========================================\n');
fprintf('  Q5: Bode Plot and Root Locus Figures\n');
fprintf('===========================================\n\n');

%% Load workspace if needed
if ~exist('G2', 'var')
    if exist('Q4_to_Q8_Workspace.mat', 'file')
        load('Q4_to_Q8_Workspace.mat');
        fprintf('Loaded workspace from Q4_to_Q8_Workspace.mat\n\n');
    else
        error('Run sys_params.m first or ensure Q4_to_Q8_Workspace.mat exists!');
    end
end

%% Configuration
output_folder = 'Figures';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
    fprintf('Created output folder: %s\n\n', output_folder);
end

% Design specifications (from sys_params.m)
zeta_desired = 0.69;
wn_desired = 3.33;

%% Get system characteristics
[poles_sys, zeros_sys] = pzmap(G2);
[Gm, Pm, Wcg, Wcp] = margin(G2);

fprintf('System Analysis:\n');
fprintf('  Gain Margin: %.2f dB at %.2f rad/s\n', 20*log10(Gm), Wcg);
fprintf('  Phase Margin: %.2f deg at %.2f rad/s\n', Pm, Wcp);
fprintf('  Open-Loop Poles:\n');
for i = 1:length(poles_sys)
    if abs(imag(poles_sys(i))) < 1e-6
        fprintf('    p%d = %.4f (real)\n', i, real(poles_sys(i)));
    else
        fprintf('    p%d = %.4f %+.4fj\n', i, real(poles_sys(i)), imag(poles_sys(i)));
    end
end
if ~isempty(zeros_sys)
    fprintf('  Open-Loop Zeros:\n');
    for i = 1:length(zeros_sys)
        if abs(imag(zeros_sys(i))) < 1e-6
            fprintf('    z%d = %.4f (real)\n', i, real(zeros_sys(i)));
        else
            fprintf('    z%d = %.4f %+.4fj\n', i, real(zeros_sys(i)), imag(zeros_sys(i)));
        end
    end
end
fprintf('\n');

%% Figure Q5.1: Bode Plot (Uncompensated System)
fig1 = figure('Color', 'w', 'Position', [100, 100, 900, 600]);

% Generate Bode data
[mag, phase, w] = bode(G2);
mag = squeeze(mag);
phase = squeeze(phase);

% Magnitude plot
subplot(2,1,1);
semilogx(w, 20*log10(mag), 'b-', 'LineWidth', 2);
hold on;
grid on; box on;

% Mark gain crossover frequency
if Wcp > 0 && isfinite(Wcp)
    xline(Wcp, 'r--', 'LineWidth', 1.5);
    plot(Wcp, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
end

% Mark phase crossover frequency
if Wcg > 0 && isfinite(Wcg)
    mag_at_wcg = interp1(w, 20*log10(mag), Wcg);
    xline(Wcg, 'm--', 'LineWidth', 1.5);
    plot(Wcg, mag_at_wcg, 'ms', 'MarkerSize', 10, 'MarkerFaceColor', 'm');
end

ylabel('Magnitude (dB)', 'FontSize', 12, 'FontWeight', 'bold');
title({'Uncompensated System G_2(s) = \theta_2/u'; '\fontsize{11}\it{Bode Diagram}'}, ...
    'FontSize', 14, 'Interpreter', 'tex');
set(gca, 'FontSize', 11, 'FontWeight', 'bold');
xlim([min(w) max(w)]);

% Add legend for markers
if Wcp > 0 && isfinite(Wcp) && Wcg > 0 && isfinite(Wcg)
    legend({'|G_2(j\omega)|', sprintf('\\omega_{gc} = %.2f rad/s', Wcp), '', ...
            sprintf('\\omega_{pc} = %.2f rad/s', Wcg)}, ...
            'Location', 'southwest', 'Interpreter', 'tex', 'FontSize', 10);
end
hold off;

% Phase plot
subplot(2,1,2);
semilogx(w, phase, 'b-', 'LineWidth', 2);
hold on;
grid on; box on;

% Mark gain crossover frequency
if Wcp > 0 && isfinite(Wcp)
    phase_at_wcp = interp1(w, phase, Wcp);
    xline(Wcp, 'r--', 'LineWidth', 1.5);
    plot(Wcp, phase_at_wcp, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    % Draw phase margin arc
    yline(-180, 'k:', 'LineWidth', 1);
    plot([Wcp Wcp], [-180 phase_at_wcp], 'r-', 'LineWidth', 2);
end

% Mark phase crossover frequency
if Wcg > 0 && isfinite(Wcg)
    xline(Wcg, 'm--', 'LineWidth', 1.5);
    plot(Wcg, -180, 'ms', 'MarkerSize', 10, 'MarkerFaceColor', 'm');
end

xlabel('Frequency (rad/s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Phase (deg)', 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'FontSize', 11, 'FontWeight', 'bold');
xlim([min(w) max(w)]);

% Add annotations
if Pm > 0 && isfinite(Pm)
    text_str = sprintf('PM = %.1f°', Pm);
    text(Wcp*1.5, phase_at_wcp-20, text_str, 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'r');
end
if Gm > 0 && isfinite(Gm)
    text_str = sprintf('GM = %.1f dB', 20*log10(Gm));
    text(Wcg*1.5, -160, text_str, 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'm');
end
hold off;

saveas(fig1, fullfile(output_folder, 'Q5_1_Bode_Uncompensated.png'));
fprintf('  [1/3] Q5_1_Bode_Uncompensated.png\n');

%% Figure Q5.2: Root Locus (Open-Loop System)
fig2 = figure('Color', 'w', 'Position', [100, 100, 900, 700]);

% Build pole subtitle
pole_sub = '';
for i = 1:length(poles_sys)
    if abs(imag(poles_sys(i))) < 1e-6
        pole_sub = [pole_sub sprintf('p_%d=%.2f  ', i, real(poles_sys(i)))];
    else
        pole_sub = [pole_sub sprintf('p_%d=%.2f%+.2fj  ', i, real(poles_sys(i)), imag(poles_sys(i)))];
    end
end

% Generate and plot root locus
[r, k] = rlocus(G2);
colors = [0 0.4 0.8; 0.8 0.4 0; 0.2 0.7 0.3; 0.6 0.2 0.8]; % Custom colors

hold on;
h_branches = gobjects(size(r,1), 1);
for i = 1:size(r,1)
    h_branches(i) = plot(real(r(i,:)), imag(r(i,:)), '-', 'Color', colors(i,:), 'LineWidth', 2);
end

% Poles and zeros
h_poles = plot(real(poles_sys), imag(poles_sys), 'rx', 'MarkerSize', 16, 'LineWidth', 4);
if ~isempty(zeros_sys)
    h_zeros = plot(real(zeros_sys), imag(zeros_sys), 'go', 'MarkerSize', 14, 'LineWidth', 3, 'MarkerFaceColor', 'g');
end

% Sgrid (add after other plots)
sgrid(zeta_desired, wn_desired);

% Axis limits
max_imag = max(abs(imag(poles_sys))) * 1.5;
if max_imag < 1, max_imag = 20; end
xlim([-5, 2]); ylim([-max_imag, max_imag]);

grid on; box on;
xlabel('Real Axis (s^{-1})', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Imaginary Axis (s^{-1})', 'FontSize', 12, 'FontWeight', 'bold');
title({'Root Locus: G_2(s) = \theta_2/u'; ['\fontsize{9}\color[rgb]{0.4,0.4,0.4}' pole_sub]}, ...
    'FontSize', 14, 'Interpreter', 'tex');

% Build legend dynamically
if ~isempty(zeros_sys)
    legend([h_branches; h_poles; h_zeros], [arrayfun(@(x) sprintf('Branch %d', x), 1:size(r,1), 'UniformOutput', false), 'Poles', 'Zeros'], ...
        'Location', 'best', 'FontSize', 9);
else
    legend([h_branches; h_poles], [arrayfun(@(x) sprintf('Branch %d', x), 1:size(r,1), 'UniformOutput', false), 'Poles'], ...
        'Location', 'best', 'FontSize', 9);
end
hold off;

saveas(fig2, fullfile(output_folder, 'Q5_2_RootLocus_Uncompensated.png'));
fprintf('  [2/3] Q5_2_RootLocus_Uncompensated.png\n');

%% Figure Q5.3: Pole-Zero Map (Manual plot for full control)
fig3 = figure('Color', 'w', 'Position', [100, 100, 800, 600]);
hold on; grid on; box on;

% Plot poles (big blue X) and zeros (big red O)
h1 = plot(real(poles_sys), imag(poles_sys), 'bx', 'MarkerSize', 20, 'LineWidth', 5);
if ~isempty(zeros_sys)
    h2 = plot(real(zeros_sys), imag(zeros_sys), 'ro', 'MarkerSize', 18, 'LineWidth', 4);
end

% Stability boundary (imaginary axis)
xline(0, 'r--', 'LineWidth', 2);

% Annotations for each pole
for i = 1:length(poles_sys)
    if abs(imag(poles_sys(i))) < 1e-6
        txt = sprintf('p_%d = %.3f', i, real(poles_sys(i)));
    else
        txt = sprintf('p_%d = %.2f%+.2fj', i, real(poles_sys(i)), imag(poles_sys(i)));
    end
    text(real(poles_sys(i))+0.1, imag(poles_sys(i))+0.8, txt, 'FontSize', 9, 'FontWeight', 'bold');
end

xlabel('Real Axis (s^{-1})', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Imaginary Axis (s^{-1})', 'FontSize', 12, 'FontWeight', 'bold');
title(sprintf('Pole-Zero Map: G_2(s) | %d Poles, %d Zeros', length(poles_sys), length(zeros_sys)), ...
    'FontSize', 14, 'FontWeight', 'bold');

if ~isempty(zeros_sys)
    legend([h1, h2], {'Poles', 'Zeros'}, 'Location', 'best', 'FontSize', 11);
else
    legend(h1, {'Poles'}, 'Location', 'best', 'FontSize', 11);
end
hold off;

saveas(fig3, fullfile(output_folder, 'Q5_3_PoleZero_Map.png'));
fprintf('  [3/3] Q5_3_PoleZero_Map.png\n');

%% Print Summary
fprintf('\n===========================================\n');
fprintf('  Q5 Complete! Figures saved to: %s\n', output_folder);
fprintf('===========================================\n');
fprintf('\nSystem Summary for Report:\n');
fprintf('  Transfer Function: G_2(s) = theta_2/u\n');
fprintf('  Gain Margin: %.2f dB (at %.2f rad/s)\n', 20*log10(Gm), Wcg);
fprintf('  Phase Margin: %.2f deg (at %.2f rad/s)\n', Pm, Wcp);


