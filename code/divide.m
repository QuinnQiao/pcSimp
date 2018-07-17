function [grid, len] = divide(X, p_thres)
    % grid parameter
    n = size(X, 1);
    p_min = min(X(:, 1:3));
    p_max = max(X(:, 1:3));
    range = [p_min' p_max'];
    GRID_NUM = round(n/p_thres);
    VOLUMN = prod(range(:,2)-range(:,1));
    GRID_LEN = nthroot(VOLUMN/GRID_NUM,3);
    GRID_NUM = ceil((range(:,2)-range(:,1))/GRID_LEN);
    GRID_LEN = (range(:,2)-range(:,1))./GRID_NUM;

    % construct grid with overlapping
    forinit = [ceil(p_thres*1.5), size(X,2)];
    len = prod(GRID_NUM);
    grid = repmat(struct('X',zeros(forinit),...
            'range',zeros(3,2), 'edge',zeros(3,2)), 1, len);
    for i = 1:GRID_NUM(1)
        x_min = range(1,1)+GRID_LEN(1)*(i-1);
        x_max = range(1,1)+GRID_LEN(1)*i;
        GRID_DELTA = GRID_LEN(1)*0.1;
        % overlapping
        tmpi = X(X(:,1)>x_min-GRID_DELTA & X(:,1)<x_max+GRID_DELTA,:);
        xst = 0;
        xed = 0;
        if i == 1
            xst = 1;
        end
        if i == GRID_NUM(1)
            xed = 1;
        end
        for j = 1:GRID_NUM(2)
            y_min = range(2,1)+GRID_LEN(2)*(j-1);
            y_max = range(2,1)+GRID_LEN(2)*j;
            GRID_DELTA = GRID_LEN(2)*0.1;
            % overlapping
            tmpj = tmpi(tmpi(:,2)>y_min-GRID_DELTA & tmpi(:,2)<y_max+GRID_DELTA, :);
            yst = 0;
            yed = 0;
            % for floating point comparing (==)
            if j == 1
                yst = 1;
            end
            if j == GRID_NUM(2)
                yed = 1;
            end
            for k = 1:GRID_NUM(3)
                z_min = range(3,1)+GRID_LEN(3)*(k-1);
                z_max = range(3,1)+GRID_LEN(3)*k;
                GRID_DELTA = GRID_LEN(3)*0.1;
                % overlapping
                tmpk = tmpj(tmpj(:,3)>z_min-GRID_DELTA & tmpj(:,3)<z_max+GRID_DELTA, :);
                zst = 0;
                zed = 0;
                % for floating point comparing (==)
                if k == 1
                    zst = 1;
                end
                if k == GRID_NUM(3)
                    zed = 1;
                end
                p = (i-1)*GRID_NUM(2)*GRID_NUM(3)+(j-1)*GRID_NUM(3)+k;
                grid(p).X = tmpk;
                grid(p).range = [x_min, x_max; y_min, y_max; z_min, z_max];
                grid(p).edge = [xst, xed; yst, yed; zst, zed];
            end
        end
    end
end