function [prop_database_filtered] = static_performance_search(tip_mach, desired_thrust, thrust_search_range, KV_lower, KV_upper, current_lower, current_upper, total_voltage_nominal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load("./prop_database/static_thrust_database.mat", "prop_static_database");

mach_filter = table2array(prop_static_database(:,"max_mach")) == tip_mach;
thrust = table2array(prop_static_database(:,"max_thrust_LBF_filtered"));
thrust_filter = (thrust > desired_thrust) & (thrust < desired_thrust + thrust_search_range);
filter_1 = mach_filter & thrust_filter;

prop_database_filtered = prop_static_database(filter_1, :);

power_prop = table2array(prop_database_filtered(:,"max_pwr_W_filtered"));
rpm = table2array(prop_database_filtered(:,"rpm"));
current = power_prop ./ total_voltage_nominal;
KV = rpm ./ total_voltage_nominal;

KV_filter = (KV > KV_lower) & (KV < KV_upper);
current_filter = (current > current_lower) & (current < current_upper);
filter_2 = KV_filter & current_filter;
prop_database_filtered = prop_database_filtered(filter_2, :);
% prop_database_filtered = prop_database_filtered(current_filter, :);

diameter = table2array(prop_database_filtered(:,"diameter"));
pitch = table2array(prop_database_filtered(:,"pitch"));
thrust = table2array(prop_database_filtered(:,"max_thrust_LBF_filtered"));
power_prop = table2array(prop_database_filtered(:,"max_pwr_W_filtered"));
rpm = table2array(prop_database_filtered(:,"rpm"));
current = power_prop ./ total_voltage_nominal;
KV = rpm ./ total_voltage_nominal;
% power_loss = R_motor .* current.^2;
% power_total = power_loss + power_prop;

f = figure();
f.Units = "inches";
f.Position = [0.25, 0.25, 6, 7];
tiledlayout(2,2)
nexttile
% p(1) = plot3(diameter, pitch, thrust, "o", "DisplayName","Thrust (lbf)");
p = plot3(diameter, pitch, thrust, "o", "DisplayName","Thrust (lbf)");
set(findall(p, 'Type', 'Line'),'LineWidth',1)
hold on
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("Thrust (lbf)")
grid on

nexttile
p = plot3(diameter, pitch, current, "o", "DisplayName","Current (A)");
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("Current (A)")
grid on
set(findall(p, 'Type', 'Line'),'LineWidth',1)

nexttile
p = plot3(diameter, pitch, rpm, "o", "DisplayName","RPM");
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("RPM")
grid on
set(findall(p, 'Type', 'Line'),'LineWidth',1)

nexttile
p = plot3(diameter, pitch, KV, "o", "DisplayName","RPM");
xlabel("Diameter (in)")
ylabel("Pitch (in)")
zlabel("$K_V$")
set(findall(p, 'Type', 'Line'),'LineWidth',1)

%
f.Color = 'white';
% for i = 1:length(p)
%     set(findall(p(i), 'Type', 'Line'),'LineWidth',1)
%     set(p(i),"Fontsize",8);
% end
sgtitle(sprintf("Filtered by Tip Mach: $M=%1.3f$ \n $ %1.3f < K_V < %1.3f$ \n $%1.3f < I < %1.3f$", tip_mach, KV_lower, KV_upper, current_lower, current_upper), "interpreter", "latex")
set(findall(f, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(f, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
grid on

end

