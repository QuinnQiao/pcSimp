clear;

pcname = 'bunny.ply';
simpname = 'bunny-simp.ply';
alpha = 0.1;
lambda = 0.1;
sigma = 2;
k = 15;

% load and split the point cloud into grids
[grid, forinit, GRID_NUM, GRID_DELTA] = divide(pcname, alpha);

% simplify each grid
n = prod(GRID_NUM);
% simp_grid = repmat(...
%     struct('X',zeros(ceil(forinit(1)*alpha),forinit(2))), 1,n);
m = 0;
X = zeros(forinit);
for i = 1:n
   tmp = simplify(alpha, lambda, sigma, k, grid(i).X);
   % remove overlapped edges
   range = grid(i).range;
   range(:,1) = range(:,1)-GRID_DELTA;
   range(:,2) = range(:,2)+GRID_DELTA;
   tmp = tmp(tmp(:,1)>range(1,1) & tmp(:,1)<range(1,2));
   tmp = tmp(tmp(:,2)>range(2,1) & tmp(:,2)<range(2,2));
   tmp = tmp(tmp(:,3)>range(3,1) & tmp(:,1)<range(3,2));
   t = size(tmp,1);
   X(m+1:m+t,:) = tmp;
   m = m + t;
end

% save the simplified point cloud
if forinit(2) == 3
    pc = pointCloud(X(1:m,:));
else % == 6
    pc = pointCloud(X(1:m,1:3),'Color',X(1:m,4:6));
end
pcwrite(pc,simpname,'PLYFormat','binary');
