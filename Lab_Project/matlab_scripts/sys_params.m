%% ELEC 481 - Q4-Q8 Parameter Setup for Simulink
clear; clc; close all;

%% Hardware Gain
kc = 10/32768;
kaktkp = 0.70;
ke = 16000/(2*pi);
ka = 32;
khw = kc * kaktkp * ke * ka;

%% Plant #2 Parameters
J1 = 0.0108;
J2 = 0.0103;
c1 = 0.007;
c2 = 0.001;
k1 = 1.37;

%% State-Space Matrices (x = [theta1; omega1; theta2; omega2])
A = [0,        1,         0,        0;
     -k1/J1,   -c1/J1,    k1/J1,    0;
     0,        0,         0,        1;
     k1/J2,    0,         -k1/J2,   -c2/J2];

B = [0; khw/J1; 0; 0];

C = [1, 0, 0, 0;    % theta1
     0, 0, 1, 0];   % theta2

D = [0; 0];

%% Transfer Functions
sys_ss = ss(A, B, C, D);
[num_tf, den_tf] = ss2tf(A, B, C, D);
G2 = tf(num_tf(2,:), den_tf);  % theta2/u for control design

%% Open-Loop Analysis
poles_ol = pole(G2);
fprintf('Open-Loop Poles:\n');
for i = 1:length(poles_ol)
    if abs(imag(poles_ol(i))) < 1e-6
        fprintf('  p%d = %.4f (real)\n', i, real(poles_ol(i)));
    else
        fprintf('  p%d = %.4f %+.4fj\n', i, real(poles_ol(i)), imag(poles_ol(i)));
    end
end

% System characteristics
wn_sys = sqrt(k1*(J1+J2)/(J1*J2));
zeta_sys = (c1*J2 + c2*J1)/(2*sqrt(k1*J1*J2*(J1+J2)));

%% Design Specs (match teammate)
PO = 5;
Ts = 2;
zeta_desired = 0.69;
sigma_desired = 2.3;
wn_desired = 3.33;
wd_desired = 2.4;

%% Root Locus Plots for MANUAL PID Tuning
figure;
rlocus(G2);
sgrid(zeta_desired, wn_desired);
title('Open-Loop Root Locus - G2(s)');

% Try PD compensator with zero at -3
C_pd = tf([1/3, 1], 1);
figure;
rlocus(C_pd * G2);
sgrid(zeta_desired, wn_desired);
title('Compensated Root Locus - (s/3 + 1)*G2(s)');

% Calculate gain automatically for desired poles
s_desired = -sigma_desired + 1i*wd_desired;
Kp = 1 / abs(evalfr(C_pd * G2, s_desired));
fprintf('\nCalculated Kp from root locus: %.2f\n', Kp);

%% Initial Conditions
X0_zero = [0; 0; 0; 0];
X0_nonzero = [0.1; 0; 0; 0];


% Kp = 0.005125;
% Ki = 0.000100;
% Kd = 0.000100;

Kp = 0.00028;
Ki = 0.000003;
Kd = 0.0001;

save('Q4_to_Q8_Workspace.mat');