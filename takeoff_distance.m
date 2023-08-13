function [s_a, V_LO] = takeoff_distance(b, S, h, W, CD0, CL, oswald_eff, Ta, mu_r, rho, dt, t_end)

C_D = CD0;
C_L = CL; %maximum lift coefficient during takeoff
e = oswald_eff; %oswald efficiency factor
m = W/32.2; %mass of aircraft (slugs)
phi = ((16*h/b)^2)/(1+(16*h/b)^2); %ground effect factor
AR = (b^2)/S; %aspect ratio

L = @(V) (1/2)*(rho)*(V.^2)*(S)*(C_L); %lift force
D = @(V) (1/2)*(rho)*(V.^2)*(S)*(C_D + (phi)*(C_L^2)/(pi*e*AR)); %drag force

t = [0:dt:t_end]; %time interval
V0=0; %initial condition - initial velocity is zero

[t,V_a] = ode23(@(t,V) (Ta-D(V)-mu_r*(W-L(V)))/m, t, V0); %integrate takeoff equation with max thrust

R_a = (L(V_a)-W);%Lift-Weight difference for max thrust (kilopounds)

n_a = R_a<0; %return true if R < 0 (true = before lift-off)
R_a = R_a(n_a); %only keep values of R < 0 (before lift-off)

t_a = t(n_a); %only keep times before lift-off
s_a = trapz(V_a(n_a),t_a); %integrate V-t graph to get distance traveled
% x_a = linspace(0,s_a,length(R_a)); %generate vector for distance traveled, same # of data points as R

% figure(1);
% plot(x_a,R_a); %plot values of R with respect to x for all three situations
% hold on; grid on; 
% xlabel('Distance traveled (ft)'); ylabel('L - W (lbs)');
% ylim([-W-10,0]);
% title('Takeoff Analysis of Aircraft at Sea Level'); 
% 
% 
% figure(2);
% plot(x_a,V_a(1:length(x_a)));

% disp('Takeoff Distance (ft):'); 
% disp(s_a);
% 
% disp('Takeoff Speed (ft/s):');
V_LO = max(V_a(n_a));
% disp(V_LO);
end

