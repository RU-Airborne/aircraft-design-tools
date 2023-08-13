%%
clear;close all;clc

%% nominal case
b_nom = 44 / 12;
b_std = 2 / 12;

S_nom = 2.44;
S_std = 0.2;

h_nom = 10/12;
h_std = 2/12;

W_nom = 1.5;
W_std = 0.35;

CD0_nom = 0.03361;
CD0_std = 0.01;

CL_nom = 1.1;
CL_std = 0.2;

oswald_eff_nom = 0.8;
oswald_eff_std = 0.05;

Ta_nom = 12.5/16;
Ta_std = 8 / 16;

mu_r_nom = 0.05;
mu_r_std = 0.05;

rho_nom = 0.002344;
rho_std = 0.0001;

dt = 0.01;
t_end = 30;

% [s_a, V_LO] = takeoff_distance(b_nom, S_nom, h_nom, W_nom, CD0_nom, CL_nom, ...
%     oswald_eff_nom, Ta_nom, mu_r_nom, rho_nom, dt, t_end);

%% monte carlo time
N = 1000;
s_a = zeros(1, N);
V_LO = zeros(1, N);

for i = 1:N
    b = abs(normrnd(b_nom, b_std));
    S = abs(normrnd(S_nom, S_std));
    h = abs(normrnd(h_nom, h_std));
    W = abs(normrnd(W_nom, W_std));
    CD0 = abs(normrnd(CD0_nom, CD0_std));
    CL = abs(normrnd(CL_nom, CL_std));
    oswald_eff = abs(normrnd(oswald_eff_nom, oswald_eff_std));
    Ta = abs(normrnd(Ta_nom, Ta_std));
    mu_r = abs(normrnd(mu_r_nom, mu_r_std));
    rho = abs(normrnd(rho_nom, rho_std));
    
    [s_a(i), V_LO(i)] = takeoff_distance(b, S, h, W, CD0, CL, ...
        oswald_eff, Ta, mu_r, rho, dt, t_end);
    disp(i);
end


idx = (s_a > 0) & (V_LO > 0) & (s_a < 100);
s_a = s_a(idx);
V_LO = V_LO(idx);


[s_a_min, s_a_max, s_a_mean, s_a_med, s_a_mode, s_a_std, s_a_var] = one_var_stats(s_a, true);
%%
f = figure(1);
histogram(s_a, 40, "Normalization","probability")
xlabel("Takeoff Distance (ft)");
ylabel("Probability")
title(sprintf("N: %1.1f, Mean: %1.3f ft, Std: %1.3f ft", sum(idx), s_a_mean, s_a_std));
latex_graph(f);

f = figure(2);
scatter(s_a, V_LO)
xlabel("Takeoff Distance (ft)");
ylabel("Takeoff Velocity (ft/s)");
latex_graph(f);
