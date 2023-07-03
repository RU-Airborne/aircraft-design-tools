clc; clear; close all;


V_stall_arr = [34.1, 42.5, 37.7]; %ft/s for M1, M2, M3
T1_arr = [11.63255472, 11.01628313, 11.40404905]; %Thrust at the lft off speed for M1, M2, M3
D_avg_arr = [1.316966838, 2.024390566, 1.666926909]; %Average drag during take off for M1, M2, M3


for i = 1:3
%% Initial Input Parameters
%Constants
rho = 2.21442113019121e-003; % Air density at the altitude of flight location in unit slug/ft^3
g = 32.2; %Gravity constant in america units ft/s^2

%Known aircraft parameters
W = 16; %Weight of the plane in lbs
S = 4.95; %The wing's area in unit ft^2
C_Lmax = 1.35; %C_Lmax for the airfoil chosen for the wing
C_lslope = 0.11;
%V_stall = sqrt((2*W)/(rho*S*C_Lmax));
V_stall = V_stall_arr(i);
AR = 7.27; %Aspect ratio
alpha_L0 = -3.74; %The alpha at which C_l = 0 or lift = 0 in degrees
AoA = 2.508524919; %Angle of attack during take off roll in degrees
e = 0.95;

%Known runway parameters
mu_r = 0.02; %This is the coefficient of friction of the runway surface. Ranges from 0.02 for dry concrete runway to 0.3 for very soft ground

%Known thrust parameter
T0 = 12.181; %Thrust in lbs at 0 ft/s
T1 = T1_arr(i); %Thrust in lbs at V_LOF ft/s
T_avg = 0.5*(T0 + T1);

%% Step 1 - Calculating the lift off speed and average speed
V_LOF = 1.1*V_stall; %To ensure a safe take off, the speed to rotate the aircraft will be 1.1 times the stall speed

V_avg = V_LOF/sqrt(2); %Since this is the average acceleration method to estimate take off distance, we need to find the average speed during takeoff. 

%Known drag behavior from OpenVSP
D_avg = D_avg_arr(i); %This is the drag from the drag polar of the aircraft at average speed

%Known lift behavior from XFLR5 or any other airfoil analyzing tools
C_Lslope = C_lslope/(1+(57.3*C_lslope)/(pi*e*AR));
C_L = C_Lslope*(AoA - alpha_L0);
L_avg = C_L*0.5*rho*V_avg^2*S;



%% Step 3 - Calculating average acceleration
a_avg = (g/W)*(T_avg - D_avg - mu_r*(W - L_avg)); %This calculates the average acceleration

Ground_Roll = V_LOF^2/(2*a_avg); %Ground roll distance in ft

fprintf("The ground roll distance is " + num2str(Ground_Roll) + "ft for M" + num2str(i) + "\n")

end


