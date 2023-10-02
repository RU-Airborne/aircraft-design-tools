clc; clear; close all;

%% Passenger and Cabin Data
% Cabin Dims
L = 12; %in
W = 6; %in

% Passenger Dims
D_pax = 1.5; %in
R_pax = D_pax / 2; % in
FoS = .10; % Factor of safety + no touching margin
D = D_pax * (1+FoS); % in
R = D/2; % in

%% Rectangular Packing
% Calculate Max Rows, Cols, and Pax Possible
R_max_r = floor((W - R)/ R);
C_max_r = floor((L - R)/ R);

Npax_max_r = floor(W/D)*floor(L/D);
% Get Center of All Circles
X_lines_r = zeros(1, C_max_r);
Y_lines_r = zeros(1, R_max_r);
X_lines_r(1) = R;
Y_lines_r(1) = R;

for i=2:1:C_max_r
    X_lines_r(i) = X_lines_r(i-1) + R;
end

for i=2:1:R_max_r
    Y_lines_r(i) = Y_lines_r(i-1) + R;
end

% Get Appropriate Shifting to Center Payload
if mod(R_max_r, 2) == 1
    Y_shift_r = W/2 - (Y_lines_r(ceil(R_max_r/2)));
else
    Y_shift_r = W/2 - ((Y_lines_r(R_max_r/2)+Y_lines_r(1+R_max_r/2))/2);
end

if mod(C_max_r, 2) == 1
    X_shift_r = L/2 - (X_lines_r(ceil(C_max_r/2)));
else
    X_shift_r = L/2 - ((X_lines_r(C_max_r/2)+X_lines_r(1+C_max_r/2))/2);
end % Something in here is not working properly - Mithun

%% Triangular Packing
% Calculate Max Rows, Cols, and Pax Possible
R_max_t = floor((W - R)/ R);
C_max_t = floor((L - R) / (sqrt(3)*R));

Npax_max_t = ceil(R_max_t * C_max_t/2);
% Get Center of All Circles
X_lines_t = zeros(1, C_max_t);
Y_lines_t = zeros(1, R_max_t);
X_lines_t(1) = R;
Y_lines_t(1) = R;

for i=2:1:C_max_t
    X_lines_t(i) = X_lines_t(i-1) + sqrt(3)*R;
end

for i=2:1:R_max_t
    Y_lines_t(i) = Y_lines_t(i-1) + R;
end

% Get Appropriate Shifting to Center Payload
if mod(R_max_t, 2) == 1
    Y_shift_t = W/2 - (Y_lines_t(ceil(R_max_t/2)));
else
    Y_shift_t = W/2 - ((Y_lines_t(R_max_t/2)+Y_lines_t(1+R_max_t/2))/2);
end

if mod(C_max_t, 2) == 1
    X_shift_t = L/2 - (X_lines_t(ceil(C_max_t/2)));
else
    X_shift_t = L/2 - ((X_lines_t(C_max_t/2)+X_lines_t(1+C_max_t/2))/2);
end



%% Visualize Results
draw_rectangular_packing(L, W, C_max_r, R_max_r, X_lines_r, Y_lines_r, X_shift_r, Y_shift_r, R_pax, Npax_max_r)
draw_triangular_packing(L, W, C_max_t, R_max_t, X_lines_t, Y_lines_t, X_shift_t, Y_shift_t, R_pax, Npax_max_t)
