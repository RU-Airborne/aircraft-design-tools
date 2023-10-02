function draw_rectangular_packing(L, W, C_max, R_max, X_lines, Y_lines, X_shift, Y_shift, R_pax, Npax_max)

f = figure;
rectangle('Position',[0 0 L W], EdgeColor='red', LineWidth=2)
hold on
axis equal

for i=1:1:C_max
    for j=1:1:R_max
        if mod(i, 2) == 1
            if mod(j, 2) == 1
                [X, Y] = get_circle(X_lines(i) + X_shift, Y_lines(j) + Y_shift, R_pax);
                plot(X, Y)
            end
        end
    end
end

efficiency = ((Npax_max*pi*R_pax^2*100)/(L*W));
title("M3 Cabin Rectangular Packing(" + efficiency + "\% Efficient)", Interpreter="latex")