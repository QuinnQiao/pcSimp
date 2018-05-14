function [grid, forinit, num, sigma] = ...
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
    disp(['n: ',num2str(n)]);
    range = [pc.XLimits; pc.YLimits; pc.ZLimits];
    clear pc;

    % compute grid parameter
    GRID_NUM = ceil(n/p_thres);
    VOLUMN = prod(range(:,2)-range(:,1));
    GRID_LEN = nthroot(VOLUMN/GRID_NUM,3);
    GRID_DELTA = GRID_LEN*0.1;
    GRID_NUM = round((range(:,2)-range(:,1))/GRID_LEN);
    GRID_LEN = (range(:,2)-range(:,1))./GRID_NUM;

    % make sure the edge to be saved
    range(:,1) = range(:,1)-GRID_DELTA/10;

    % construct grid with overlapping
    forinit = [ceil(p_thres*1.5), size(X,2)];
    grid = repmat(struct('X',zeros(forinit),...
            'range',zeros(3,2)), 1,prod(GRID_NUM));
    for i = 1:GRID_NUM(1)
        x_min = range(1,1)+GRID_LEN(1)*(i-1);
        x_max = range(1,1)+GRID_LEN(1)*i;
        % overlapping
        tmpi = X(X(:,1)>x_min-GRID_DELTA & X(:,1)<x_max+GRID_DELTA,:);
        for j = 1:GRID_NUM(2)
            y_min = range(2,1)+GRID_LEN(2)*(j-1);
            y_max = range(2,1)+GRID_LEN(2)*j;
            % overlapping
            tmpj = tmpi(tmpi(:,2)>y_min-GRID_DELTA & tmpi(:,2)<y_max+GRID_DELTA,:);
            for k = 1:GRID_NUM(3)
                z_min = range(3,1)+GRID_LEN(3)*(k-1);
                z_max = range(3,1)+GRID_LEN(3)*k;
                % overlapping
                tmpk = tmpj(tmpj(:,3)>z_min-GRID_DELTA & tmpj(:,3)<z_max+GRID_DELTA,:);
                % compute index
                p = (i-1)*GRID_NUM(2)*GRID_NUM(3)+(j-1)*GRID_NUM(3)+k;
                grid(p).X = tmpk;
                grid(p).range = [x_min, x_max; y_min, y_max; z_min, z_max];
            end
        end
    end
    
    % return value
    forinit(1)= ceil(n*alpha);
    num = prod(GRID_NUM);
    sigma = nthroot(VOLUMN/n,3)^2;
end
