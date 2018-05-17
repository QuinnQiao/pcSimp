function grid = deepDivide(X, p_thres)
	% to split the VERY LARGE grid to smaller grid
	n,c = size(X);
	num = ceil(n/p_thres);
	range_min = min(X(:,1:3));
	range_max = max(X(:,1:3));
	delta = nthroot(prod(range_max-range_min)/n,3)*0.1;
	grid = repmat(struct('X',zeros(p_thres,c),...
            'range',zeros(3,2)), 1,num);
	for 
end