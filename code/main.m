% the main process
% simplify the point cloud with name of pcname
% Author: Junkun Qi
% 2018/5/13
clear;
time_start = clock;

dirname = 'nocolor';
pcname = fullfile(dirname,'bunny.ply');
simpname =  fullfile(dirname,'bunny-simp-2.ply');
alpha = 0.1;
scale = 1.1;
lambda = 0.1;
eta = 0.05;
K = 15;
p_thres_min = 3000;
p_thres_max = 8000;

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
GRID_NUM = ceil(n/p_thres_min);
VOLUMN = prod(range(:,2)-range(:,1));
GRID_LEN = nthroot(VOLUMN/GRID_NUM,3);
GRID_DELTA = GRID_LEN*0.1;
GRID_NUM = ceil((range(:,2)-range(:,1))/GRID_LEN);
GRID_LEN = (range(:,2)-range(:,1))./GRID_NUM;
sigma = nthroot(VOLUMN/n,3)^2;

% make sure the edge to be saved
range(:,1) = range(:,1)-GRID_DELTA/10;

simpX = zeros(ceil(n*alpha),size(X,2));
m = 0;
% split the point cloud into grids and simplify each grid
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
            disp(['simplifying ',num2str(i),',',num2str(j),',',num2str(k)]);
            z_min = range(3,1)+GRID_LEN(3)*(k-1);
            z_max = range(3,1)+GRID_LEN(3)*k;
            % overlapping
            tmpk = tmpj(tmpj(:,3)>z_min-GRID_DELTA & tmpj(:,3)<z_max+GRID_DELTA,:);
            
            
            %%%%%%%
            
            
            % simplify this grid
            tmp = simplify(alpha*scale, lambda, sigma, eta, K, tmpk);
            if isempty(tmp)
                continue;
            end
            
            % merge the grid to the simpX
            tmp = tmp(tmp(:,1)>x_min & tmp(:,1)<x_max,:);
            tmp = tmp(tmp(:,2)>y_min & tmp(:,2)<y_max,:);
            tmp = tmp(tmp(:,3)>z_min & tmp(:,3)<z_max,:);
            t = size(tmp,1);
            simpX(m+1:m+t,:) = tmp;
            m = m + t;
        end
    end
end
disp(['m: ',num2str(m)]);
clear X;

% save the simplified point cloud
if size(simpX,2) == 3
    pc = pointCloud(simpX(1:m,:));
else % == 6
    pc = pointCloud(simpX(1:m,1:3),'Color',simpX(1:m,4:6));
end
pcwrite(pc,simpname,'PLYFormat','binary');

time_end = clock;
disp(['Runtime: ',num2str(etime(time_end,time_start))]);
