function [grid, len] = divide(X, p_thres, range)
    % Divide X with range, points in each grid >= p_thres
    delta = 1e-10; % Just for avoiding >= and <= in float numbers
    range(:,1) = range(:,1)-delta; 
    range(:,2) = range(:,2)+delta;
    
    p = X(:,1)>range(1,1) & X(:,1)<range(1,2) & X(:,2)>range(2,1)...
        & X(:,2)<range(2,2) & X(:,3)>range(3,1) & X(:,3)<range(3,2);
    Y = X(p,:);
    n = size(Y, 1);
    
    % Naive strategy, the same as that in main.m
    GRID_NUM = round(n / p_thres);
    VOLUMN = prod(range(:,2) - range(:,1));
    GRID_LEN = nthroot(VOLUMN / GRID_NUM,3);
    GRID_NUM = ceil((range(:,2)-range(:,1)) / GRID_LEN);
    GRID_LEN = (range(:,2)-range(:,1)) ./ GRID_NUM;

    % Grid with overlap
    forinit = [round(p_thres*1.4), 3];
    len = prod(GRID_NUM);
    grid = repmat(struct('X',zeros(forinit),...
            'range',zeros(3,2)), 1, len);
    
    for i = 1:GRID_NUM(1)
        x_min = range(1,1) + GRID_LEN(1)*(i-1);
        x_max = range(1,1) + GRID_LEN(1)*i;
        GRID_DELTA = GRID_LEN(1)*0.1;
        % overlap
        tmpi = X(X(:,1)>(x_min-GRID_DELTA) & X(:,1)<(x_max+GRID_DELTA),:);
        
        for j = 1:GRID_NUM(2)
            y_min = range(2,1) + GRID_LEN(2)*(j-1);
            y_max = range(2,1) + GRID_LEN(2)*j;
            GRID_DELTA = GRID_LEN(2)*0.1;
            % overlap
            tmpj = tmpi(tmpi(:,2)>(y_min-GRID_DELTA) & tmpi(:,2)<(y_max+GRID_DELTA), :);
            
            for k = 1:GRID_NUM(3)
                z_min = range(3,1) + GRID_LEN(3)*(k-1);
                z_max = range(3,1) + GRID_LEN(3)*k;
                GRID_DELTA = GRID_LEN(3)*0.1;
                % overlap
                tmpk = tmpj(tmpj(:,3)>(z_min-GRID_DELTA) & tmpj(:,3)<(z_max+GRID_DELTA), :);         
                
                p = (i-1)*GRID_NUM(2)*GRID_NUM(3) + (j-1)*GRID_NUM(3) + k;
                grid(p).X = tmpk;
                grid(p).range = [x_min, x_max; y_min, y_max; z_min, z_max];
            end
        end
    end
end