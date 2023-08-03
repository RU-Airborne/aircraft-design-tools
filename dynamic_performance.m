%%
clear; close all;clc

% plot thrust vs. velocity
% plot drag vs. velocity
% thrust available (come from prop data)
% T_available(rpm, V)
% D = q * S * (CD0 + K * CL^2)
% where K = 1 / (pi * e * AR)

% load in thrust
load("prop_database\data_9x5.mat");

% define velocities (ft/s)
N_points = 100;
V = linspace(0, 80, N_points);
rho = 0.002377; % slugs / ft^3
q = 1/2 .* rho .* V.^2;

CD0 = 0.03361;
S = 2.44; % ft^2
b = 44 / 12; % ft

AR = b^2 / S;
oswald_eff = 0.8;
CL_max = 1.5245;
K = 1 / (pi * oswald_eff * AR);

% calculate drag
D = q .* S .* (CD0 + K .* CL_max .^2);
P_req = D .* V;


V_8000 = table2array(data_9X5_8000(:,"V_prop"));
T_8000 = table2array(data_9X5_8000(:,"T_LBF"));
P_8000 = T_8000 .* V_8000;

V_9000 = table2array(data_9X5_9000(:,"V_prop"));
T_9000 = table2array(data_9X5_9000(:,"T_LBF"));
P_9000 = T_9000 .* V_9000;

V_10000 = table2array(data_9X5_10000(:,"V_prop"));
T_10000 = table2array(data_9X5_10000(:,"T_LBF"));
P_10000 = T_10000 .* V_10000;

V_11000 = table2array(data_9X5_11000(:,"V_prop"));
T_11000 = table2array(data_9X5_11000(:,"T_LBF"));
P_11000 = T_11000 .* V_11000;

V_12000 = table2array(data_9X5_12000(:,"V_prop"));
T_12000 = table2array(data_9X5_12000(:,"T_LBF"));
P_12000 = T_12000 .* V_12000;

f = figure("Name","Thrust");

plot(V, D, "DisplayName", "Drag")
hold on
plot(V_8000, T_8000,   "--", "DisplayName","Thrust, RPM = 8000")
plot(V_9000, T_9000,   "--",    "DisplayName","Thrust, RPM = 9000")
plot(V_10000, T_10000,   "--",  "DisplayName","Thrust, RPM = 10000")
plot(V_11000, T_11000,   "--",  "DisplayName","Thrust, RPM = 11000")
plot(V_12000, T_12000,   "--",  "DisplayName","Thrust, RPM = 12000")

legend
xlabel("Velocity (ft/s)");
ylabel("Thrust or Drag (lbf)");
title("APC 9$\times$5 Prop")
latex_graph(f);


%%
% bonus:
% power required vs. velocity
% power available vs. velocity
f = figure("Name","Power");

plot(V, P_req, "DisplayName", "Power Required")
hold on
plot(V_8000, P_8000,   "--", "DisplayName","Power, RPM = 8000")
plot(V_9000, P_9000,   "--",    "DisplayName","Power, RPM = 9000")
plot(V_10000, P_10000,   "--",  "DisplayName","Power, RPM = 10000")
plot(V_11000, P_11000,   "--",  "DisplayName","Power, RPM = 11000")
plot(V_12000, P_12000,   "--",  "DisplayName","Power, RPM = 12000")

legend
xlabel("Velocity (ft/s)");
ylabel("Power (lbf ft / s)");
title("APC 9$\times$5 Prop")
axis([0, 80, 0, 200])
latex_graph(f);

