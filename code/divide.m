function [grid, forinit, num, delta, sigma] = ...
            divide(pcname, alpha, p_thres)
    % divide the point cloud into overlapped grids
    % Author: Junkun Qi
    % 2018/5/13

    % load point cloud
    pc = pcread(pcname);
    X = double(pc.Location);
    if ~isempty(pc.Color)
        X = [X, double(pc.Color)];
    end
    n = pc.Count;
    range = [pc.XLimits; pc.YLimits; pc.ZLimits];
    clear pc;

    % compute grid parameter
    GRID_NUM = ceil(n/p_thres);
    VOLUMN = prod(range(:,2)-range(:,1));
    GRID_LEN = nthroot(VOLUMN/GRID_NUM,3);
    GRID_DELTA = GRID_LEN*0.05;
    GRID_NUM = round((range(:,2)-range(:,1))/GRID_LEN);
    GRID_LEN = (range(:,2)-range(:,1))./GRID_NUM;

    % construct grid with overlapping
    forinit = [ceil(p_thres*1.5), size(X,2)];
    grid = repmat(struct('X',zeros(forinit),...
            'range',zeros(3,2)), 1,prod(GRID_NUM));
    for i = 1:GRID_NUM(1)
        x_min = range(1,1)+GRID_LEN(1)*(i-1)-GRID_DELTA;
        x_max = range(1,1)+GRID_LEN(1)*i+GRID_DELTA;
        tmp = X(X(:,1)>x_min & X(:,1)<x_max);
        for j = 1:GRID_NUM(2)
            y_min = range(2,1)+GRID_LEN(2)*(j-1)-GRID_DELTA;
            y_max = range(2,1)+GRID_LEN(2)*j+GRID_DELTA;
            tmp = tmp(tmp(:,2)>y_min & tmp(:,2)<y_max);
            for k = 1:GRID_NUM(3)
                z_min = range(3,1)+GRID_LEN(3)*(k-1)-GRID_DELTA;
                z_max = range(3,1)+GRID_LEN(3)*k+GRID_DELTA;
                tmp = tmp(tmp(:,3)>z_min & tmp(:,3)<z_max);
                p = (i-1)*GRID_NUM(2)*GRID_NUM(3)+(j-1)*GRID_NUM(3)+k;
                if size(tmp,1)<(1/alpha)
                    grid(p).X = [];
                    grid(p).range = [];
                else
                    grid(p).X = tmp;
                    grid(p).range = ...
                        [x_min+GRID_DELTA, x_max-GRID_DELTA; 
                         y_min+GRID_DELTA, y_max-GRID_DELTA; 
                         z_min+GRID_DELTA, z_max-GRID_DELTA];
                end
            end
        end
    end
    
    % return value
    forinit(1)= ceil(n*alpha);
    num = prod(GRID_NUM);
    delta = GRID_DELTA/10;
    sigma = nthroot(VOLUMN/n,3)^2;
end
