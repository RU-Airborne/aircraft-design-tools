function [X, Y] = get_circle(X_center, Y_center, r)
theta = linspace(0, 2*pi, 100);
X = (r .* cos(theta)) + X_center;
Y = (r .* sin(theta)) + Y_center;
end