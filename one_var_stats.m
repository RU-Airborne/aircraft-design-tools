function [X_min, X_max, X_mean, X_med, X_mode, X_std, X_var] = one_var_stats(X, is_print)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X_min = min(X);
X_max = max(X);
X_mean = mean(X);
X_med = median(X);
X_mode = mode(X);
X_std = std(X);
X_var = var(X);

if is_print
    fprintf("Mean: %1.3f \n", X_mean)
    fprintf("Std: %1.3f \n", X_std)
    fprintf("Min: %1.3f \n", X_min)
    fprintf("Max: %1.3f \n", X_max)
    fprintf("Median: %1.3f \n", X_med)
    fprintf("Mode: %1.3f \n", X_mode)
    fprintf("Var: %1.3f \n", X_var)
end

end

