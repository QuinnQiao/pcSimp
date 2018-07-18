clear;
time_start = clock;
% hyper-parameters
filename = 'nocolor/armadillo';
pcname = [filename, '.ply'];
alpha = 0.1;
lambda = 1e-7;
K = 15;
p_thres_min = 3000;
p_thres_max = 8000;

% load the point cloud
pc = pcread(pcname);
X = double(pc.Location);
n = pc.Count;
range = [pc.XLimits; pc.YLimits; pc.ZLimits];
clear pc;
disp(['n: ',num2str(n)]);

% divide the point cloud into grids
GRID_NUM = round(n/p_thres_min);
VOLUMN = prod(range(:,2)-range(:,1));
GRID_LEN = nthroot(VOLUMN/GRID_NUM,3);
GRID_NUM = ceil((range(:,2)-range(:,1))/GRID_LEN);
GRID_LEN = (range(:,2)-range(:,1))./GRID_NUM;
simpname = [filename, '-sr', num2str(alpha),...
			'-cp', num2str(lambda), '.ply'];

% simplify while dividing
m = 0;
simpX = zeros(round(alpha*n), 3);
for i = 1:GRID_NUM(1)
    x_min = range(1,1)+GRID_LEN(1)*(i-1);
    x_max = range(1,1)+GRID_LEN(1)*i;
    GRID_DELTA = GRID_LEN(1)*0.1;
    % overlapping
    tmpi = X(X(:,1)>x_min-GRID_DELTA & X(:,1)<x_max+GRID_DELTA, :);
    
    for j = 1:GRID_NUM(2)
        y_min = range(2,1)+GRID_LEN(2)*(j-1);
        y_max = range(2,1)+GRID_LEN(2)*j;
        GRID_DELTA = GRID_LEN(2)*0.1;
        % overlapping
        tmpj = tmpi(tmpi(:,2)>y_min-GRID_DELTA & tmpi(:,2)<y_max+GRID_DELTA, :);
        
        for k = 1:GRID_NUM(3)
            z_min = range(3,1)+GRID_LEN(3)*(k-1);
            z_max = range(3,1)+GRID_LEN(3)*k;
            GRID_DELTA = GRID_LEN(3)*0.1;
            % overlapping
            tmpk = tmpj(tmpj(:,3)>z_min-GRID_DELTA & tmpj(:,3)<z_max+GRID_DELTA, :);
            tmprange = [x_min, x_max; y_min, y_max; z_min, z_max];
            
            % simplify
            disp([' simplifying in ', num2str(i), num2str(j), num2str(k)]);
            if size(tmpk, 1) > p_thres_max
            	% divide again
            	disp('    deep dividing...')
            	[deep_grid, deep_grid_num] = divide(tmpk, p_thres_min, tmprange);
            	for p = 1:deep_grid_num
            		tmp = simplify(alpha, lambda, K, deep_grid(p).X, deep_grid(p).range);
		        	t = size(tmp,1);
                    if t > 0
					    simpX(m+1:m+t, :) = tmp;
					    m = m + t;
                    end
            	end
            	clear deep_grid;
            else
            	tmp = simplify(alpha, lambda, K, tmpk, tmprange);
                t = size(tmp,1);
                if t > 0
				    simpX(m+1:m+t, :) = tmp;
				    m = m + t;
                end
            end	            
        end
    end
end

% save the simplifxed point cloud
disp(['m: ',num2str(m)]);
pc = pointCloud(simpX(1:m,:));
pcwrite(pc,simpname,'PLYFormat','binary');

time_end = clock;
disp(['Runtime: ', num2str(etime(time_end,time_start))]);