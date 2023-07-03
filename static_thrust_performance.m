%%
clear;close all;clc
files = dir("./prop_database/*.mat");

for i = 1:length(files)
    load(fullfile(files(i).folder, files(i).name))
end
clear files i

%% User inputs
% Max takeoff weight (Refer to Table of Dimensions / BoM)
max_takeoff_weight = 1.5; % lbf
% Designed Thrust-to-Weight Ratio
TW_ratio = 2; 
% Nominal cell voltage (do not change)
cell_voltage_nominal = 3.7; % V
% Battery information (refer to BoM)
n_cells = 3; 
capacity_mah = 2200; % mAh
% Motor shaft efficiency (0.8 is a good guess)
shaft_eff = 0.8; 

thrust_search_range = 1; % lbf 
R_motor = 0.15; % ohm
tip_mach = 0.5; % 0.5 is usually acceptable for 

% 
total_voltage_nominal = n_cells * cell_voltage_nominal; % V
total_energy = capacity_mah / 1000 * total_voltage_nominal; % Wh
desired_thrust = TW_ratio * max_takeoff_weight; % lbf


%% Filter props to thrust range
mach_filter = table2array(prop_static_database(:,"max_mach")) == tip_mach;
prop_static_database = prop_static_database(mach_filter, :);
thrust = table2array(prop_static_database(:,"max_thrust_LBF_filtered"));
thrust_filter = (thrust > desired_thrust) & (thrust < desired_thrust + thrust_search_range);
prop_database_filtered = prop_static_database(thrust_filter, :);

%%
diameter = table2array(prop_database_filtered(:,"diameter"));
pitch = table2array(prop_database_filtered(:,"pitch"));
thrust = table2array(prop_database_filtered(:,"max_thrust_LBF_filtered"));
power_prop = table2array(prop_database_filtered(:,"max_pwr_W_filtered"));
rpm = table2array(prop_database_filtered(:,"rpm"));
current = power_prop ./ total_voltage_nominal;
KV = rpm ./ total_voltage_nominal;
power_loss = R_motor .* current.^2;
power_total = power_loss + power_prop;

%% filter out current limitations
current_max = 70;


%%
f = figure();
tiledlayout(2,2)
nexttile
p(1) = plot3(diameter, pitch, thrust, "o", "DisplayName","Thrust (lbf)");
hold on
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("Thrust (lbf)")
grid on

nexttile
p(2) = plot3(diameter, pitch, current, "o", "DisplayName","Current (A)");
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("Current (A)")
grid on

nexttile
p(3) = plot3(diameter, pitch, rpm, "o", "DisplayName","RPM");
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("RPM")
grid on

nexttile
p(4) = plot3(diameter, pitch, KV, "o", "DisplayName","RPM");
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("$K_V$")

%
f.Color = 'white';
for i = 1:length(p)
    set(findall(p(i), 'Type', 'Line'),'LineWidth',1)
%     set(p(i),"Fontsize",8);
end
sgtitle(sprintf("Filtered by Tip Mach: $M=%1.3f$", tip_mach), "interpreter", "latex")
set(findall(f, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(f, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
grid on

